module lexer

import definitions { SourceFile, TextLocation, Token }

pub struct Lexer {
pub:
	source_file SourceFile [required]
	keywords    []string   [required]
	keep_spaces bool
	keep_tabs   bool
pub mut:
	global_position int
	local_position  TextLocation
	found_tokens    []Token
	buffer          []rune
}

pub fn Lexer.new(source_file SourceFile, keywords []string) Lexer {
	return Lexer{
		source_file: source_file
		keywords: keywords
		local_position: definitions.default_text_location
	}
}

pub fn (mut this Lexer) advance(amount int) {
	this.global_position += amount
	this.local_position = this.local_position.advance(amount)
}

pub fn (mut this Lexer) handle_newline() {
	this.local_position = this.local_position.handle_newline()
}

pub fn (mut this Lexer) is_at_eof() bool {
	return this.global_position >= this.source_file.file_contents.len
}

pub fn (mut this Lexer) append_to_buffer(characters ...rune) {
	this.buffer << characters
	this.advance(characters.len)
}

pub fn (mut this Lexer) handle_buffer() {
	buffer_length := this.buffer.len

	if buffer_length == 0 {
		return
	}

	buffer_content := this.buffer.map[string](fn (character rune) string {
		return character.str()
	}).join('')

	this.buffer = []

	if this.keywords.contains(buffer_content) {
		this.append_token(Token.new_keyword(this.local_position.advance(buffer_length * -1),
			buffer_content))

		return
	}

	this.append_token(Token.new_identifier(this.local_position.advance(buffer_length * -1),
		buffer_content))
}

pub fn (mut this Lexer) get_current_character() ?rune {
	if this.is_at_eof() {
		return none
	}

	return this.source_file.file_contents[this.global_position]
}

pub fn (mut this Lexer) peek() ?rune {
	if this.is_at_eof() {
		return none
	}

	if this.global_position + 1 >= this.source_file.file_contents.len {
		return none
	}

	return this.source_file.file_contents[this.global_position + 1]
}

fn (mut this Lexer) append_token(token_to_append Token) {
	this.found_tokens << [token_to_append]
}

pub fn (mut this Lexer) tokenize() ![]Token {
	this.found_tokens = []

	for this.is_at_eof() == false {
		mut current_character := this.source_file.file_contents[this.global_position]

		match current_character {
			` ` {
				this.handle_buffer()

				if this.keep_spaces {
					this.append_token(Token.new_special_character(this.local_position,
						' '))
				} else {
					this.advance(1)
				}
			}
			`\t` {
				this.handle_buffer()

				if this.keep_tabs {
					this.append_token(Token.new_special_character(this.local_position,
						' '))
				} else {
					this.advance(1)
				}
			}
			`\r` {
				this.handle_buffer()
				this.advance(1)
			}
			`\n` {
				this.handle_buffer()
				this.advance(1)
				this.handle_newline()
			}
			`/` {
				next_character := this.peek()

				if next_character == none {
					this.append_token(Token.new_special_character(this.local_position,
						current_character.str()))
					this.advance(1)
				} else {
					typed_next_character := next_character or {
						panic('Could not get next character')
					}

					match typed_next_character {
						`/` {
							this.parse_single_line_comment()
						}
						`*` {
							this.parse_multi_line_comment()!
						}
						else {
							this.append_token(Token.new_special_character(this.local_position,
								current_character.str()))
							this.advance(1)
						}
					}
				}
			}
			`"` {
				this.handle_buffer()
				this.parse_string()!
			}
			`'` {
				this.handle_buffer()
				this.parse_char()!
			}
			`(`, `)`, `[`, `]`, `<`, `>` {
				this.handle_buffer()
				this.advance(1)
				this.append_token(Token.new_special_character(this.local_position, current_character.str()))
			}
			`!`, `?`, `+`, `-`, `*`, `%`, `&`, `|`, `.`, `:`, `;`, `\\` {
				this.handle_buffer()
				this.advance(1)
				this.append_token(Token.new_special_character(this.local_position, current_character.str()))
			}
			`0`...`9` {
				if this.buffer.len == 0 {
					this.parse_number()
				} else {
					this.append_to_buffer(current_character)
				}
			}
			else {
				this.append_to_buffer(current_character)
			}
		}
	}

	this.handle_buffer()

	return this.found_tokens
}

fn (mut this Lexer) parse_single_line_comment() {
	start_location := this.local_position

	for this.is_at_eof() == false {
		current_character := this.source_file.file_contents[this.global_position]

		match current_character {
			`\r` {
				this.advance(1)
			}
			`\n` {
				this.advance(1)
				break
			}
			else {
				this.append_to_buffer(current_character)
			}
		}
	}

	buffer_contents := this.buffer.string()
	this.buffer = []
	this.append_token(Token.new_single_line_comment(start_location, buffer_contents))
}

fn (mut this Lexer) parse_multi_line_comment() ! {
	start_location := this.local_position

	for this.is_at_eof() == false {
		current_character := this.source_file.file_contents[this.global_position]
		next_character := this.source_file.file_contents[this.global_position + 1]

		match current_character {
			`\r` {
				this.advance(1)
			}
			`\n` {
				this.append_to_buffer(current_character)
				this.handle_newline()
			}
			`*` {
				this.append_to_buffer(current_character)

				if next_character == `/` {
					this.append_to_buffer(next_character)
					break
				}
			}
			else {
				this.append_to_buffer(current_character)
			}
		}
	}

	if this.is_at_eof() && this.buffer.last() != `/` {
		return UnexpectedEndOfFileError{
			start_location: start_location
			what_lexing: 'multi line comment'
			closing_character: '*/'
		}
	}

	buffer_contents := this.buffer.string()
	this.buffer = []
	this.append_token(Token.new_multi_line_comment(start_location, this.local_position,
		buffer_contents))
}

fn (mut this Lexer) parse_number() {
	start_location := this.local_position

	for !this.is_at_eof() {
		current_character := this.source_file.file_contents[this.global_position]

		match current_character {
			`0`...`9`, `_`, `.` {
				this.append_to_buffer(current_character)
			}
			else {
				break
			}
		}
	}

	buffer_contents := this.buffer.string()
	this.buffer = []
	this.append_token(Token.new_number(start_location, buffer_contents))
}

fn (mut this Lexer) parse_string() ! {
	start_location := this.local_position

	for !this.is_at_eof() {
		current_character := this.source_file.file_contents[this.global_position]

		this.append_to_buffer(current_character)

		if this.buffer.len > 1 && this.buffer[this.buffer.len - 1] != `\\`
			&& current_character == `"` {
			break
		}
	}

	if this.is_at_eof() && this.buffer.last() != `"` {
		return UnexpectedEndOfFileError{
			start_location: start_location
			what_lexing: 'string'
			closing_character: '"'
		}
	}

	buffer_contents := this.buffer.string()
	this.buffer = []
	this.append_token(Token.new_string(start_location, buffer_contents))
}

fn (mut this Lexer) parse_char() ! {
	start_location := this.local_position

	for !this.is_at_eof() {
		current_character := this.source_file.file_contents[this.global_position]

		this.append_to_buffer(current_character)

		if this.buffer.len > 1 && this.buffer[this.buffer.len - 1] != `\\`
			&& current_character == `'` {
			break
		}
	}

	if this.is_at_eof() && this.buffer.last() != `'` {
		return UnexpectedEndOfFileError{
			start_location: start_location
			what_lexing: 'char'
			closing_character: "'"
		}
	}

	buffer_contents := this.buffer.string()
	this.buffer = []
	this.append_token(Token.new_char(start_location, buffer_contents))
}
