import lexer { Lexer }
import definitions { SourceFile, Token }

const source_file = SourceFile.read_from_file('./src/modules/lexer/testdata/Option.dx') or {
	panic('Could not read source file: ${err}')
}

const keywords = definitions.dx_keywords

pub fn test_new_lexer() {
	result := Lexer.new(source_file, keywords)

	assert result.source_file == source_file
	assert result.global_position == 0
	assert result.local_position == definitions.default_text_location
}

pub fn test_advance() {
	mut file_lexer := Lexer.new(source_file, keywords)

	file_lexer.advance(2)

	assert file_lexer.global_position == 2
	assert file_lexer.local_position.column == 2
	assert file_lexer.local_position.line_number == 1
}

pub fn test_handle_newline() {
	mut file_lexer := Lexer.new(source_file, keywords)

	file_lexer.advance(2)
	file_lexer.handle_newline()

	assert file_lexer.global_position == 2
	assert file_lexer.local_position.column == 0
	assert file_lexer.local_position.line_number == 2
}

pub fn test_is_at_eof() {
	mut file_lexer := Lexer.new(source_file, keywords)

	assert file_lexer.is_at_eof() == false

	file_lexer.advance(file_lexer.source_file.file_contents.len)

	assert file_lexer.is_at_eof()
}

pub fn test_append_to_buffer() {
	mut file_lexer := Lexer.new(source_file, keywords)
	file_lexer.append_to_buffer(`c`, `l`, `a`, `s`, `s`)

	assert file_lexer.buffer == 'class'.runes()
	assert file_lexer.global_position == 5
	assert file_lexer.local_position.column == 5
	assert file_lexer.local_position.line_number == 1
}

pub fn test_tokenize_keyword() {
	input_file := SourceFile{
		file_path: 'test://'
		file_contents: 'class'.runes()
	}
	mut file_lexer := Lexer.new(input_file, keywords)

	result := file_lexer.tokenize() or { panic(err) }

	assert result == [
		Token.new_keyword(definitions.default_text_location, 'class'),
	]
}

pub fn test_tokenize_identifier() {
	input_file := SourceFile{
		file_path: 'test://'
		file_contents: 'MyClass'.runes()
	}
	mut file_lexer := Lexer.new(input_file, keywords)

	result := file_lexer.tokenize() or { panic(err) }

	assert result == [
		Token.new_identifier(definitions.default_text_location, 'MyClass'),
	]
}

pub fn test_tokenize_single_line_comment() {
	input_file := SourceFile{
		file_path: 'test://'
		file_contents: '// unit test'.runes()
	}
	mut file_lexer := Lexer.new(input_file, keywords)

	result := file_lexer.tokenize() or { panic(err) }

	assert result == [
		Token.new_single_line_comment(definitions.default_text_location, '// unit test'),
	]
	assert file_lexer.buffer == []
}

pub fn test_tokenize_multi_line_comment() {
	file_contents := '/* unit test */'

	input_file := SourceFile{
		file_path: 'test://'
		file_contents: file_contents.runes()
	}
	mut file_lexer := Lexer.new(input_file, keywords)

	result := file_lexer.tokenize() or { panic(err) }

	assert result == [
		Token.new_multi_line_comment(definitions.default_text_location, definitions.default_text_location.advance(file_contents.len),
			file_contents),
	]
	assert file_lexer.buffer == []
}

pub fn test_tokenize_integer() {
	file_contents := '42'

	input_file := SourceFile{
		file_path: 'test://'
		file_contents: file_contents.runes()
	}
	mut file_lexer := Lexer.new(input_file, keywords)

	result := file_lexer.tokenize() or { panic(err) }

	assert result == [
		Token.new_number(definitions.default_text_location, file_contents),
	]
	assert file_lexer.buffer == []
}

pub fn test_tokenize_float() {
	file_contents := '42.42'

	input_file := SourceFile{
		file_path: 'test://'
		file_contents: file_contents.runes()
	}
	mut file_lexer := Lexer.new(input_file, keywords)

	result := file_lexer.tokenize() or { panic(err) }

	assert result == [
		Token.new_number(definitions.default_text_location, file_contents),
	]
	assert file_lexer.buffer == []
}

pub fn test_tokenize_integer_with_underscores() {
	file_contents := '1_000'

	input_file := SourceFile{
		file_path: 'test://'
		file_contents: file_contents.runes()
	}
	mut file_lexer := Lexer.new(input_file, keywords)

	result := file_lexer.tokenize() or { panic(err) }

	assert result == [
		Token.new_number(definitions.default_text_location, file_contents),
	]
	assert file_lexer.buffer == []
}

pub fn test_tokenize_float_with_underscores() {
	file_contents := '1_000.00'

	input_file := SourceFile{
		file_path: 'test://'
		file_contents: file_contents.runes()
	}
	mut file_lexer := Lexer.new(input_file, keywords)

	result := file_lexer.tokenize() or { panic(err) }

	assert result == [
		Token.new_number(definitions.default_text_location, file_contents),
	]
	assert file_lexer.buffer == []
}

pub fn test_tokenize_float_with_underscores_before_separator() {
	file_contents := '1_000_.00'

	input_file := SourceFile{
		file_path: 'test://'
		file_contents: file_contents.runes()
	}
	mut file_lexer := Lexer.new(input_file, keywords)

	result := file_lexer.tokenize() or { panic(err) }

	assert result == [
		Token.new_number(definitions.default_text_location, file_contents),
	]
	assert file_lexer.buffer == []
}

pub fn test_tokenize_strings() {
	file_contents := '"unit test"'

	input_file := SourceFile{
		file_path: 'test://'
		file_contents: file_contents.runes()
	}
	mut file_lexer := Lexer.new(input_file, keywords)

	result := file_lexer.tokenize() or { panic(err) }

	assert result == [
		Token.new_string(definitions.default_text_location, file_contents),
	]
	assert file_lexer.buffer == []
}

pub fn test_tokenize_char() {
	file_contents := "'0'"

	input_file := SourceFile{
		file_path: 'test://'
		file_contents: file_contents.runes()
	}
	mut file_lexer := Lexer.new(input_file, keywords)

	result := file_lexer.tokenize() or { panic(err) }

	assert result == [
		Token.new_char(definitions.default_text_location, file_contents),
	]
	assert file_lexer.buffer == []
}
