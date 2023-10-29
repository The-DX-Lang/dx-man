module definitions

pub enum TokenType {
	keyword
	identifier
	string
	char
	number
	special_character
	single_line_comment
	multi_line_comment
}

pub struct Token {
pub:
	@type TokenType
	range TextRange
	value string
}

pub fn Token.new(@type TokenType, start_location TextLocation, value string) Token {
	return Token{
		@type: @type
		range: TextRange.calculate(start_location, value.runes().len)
		value: value
	}
}

pub fn Token.new_keyword(start_location TextLocation, value string) Token {
	return Token.new(.keyword, start_location, value)
}

pub fn Token.new_identifier(start_location TextLocation, value string) Token {
	return Token.new(.identifier, start_location, value)
}

pub fn Token.new_string(start_location TextLocation, value string) Token {
	return Token.new(.string, start_location, value)
}

pub fn Token.new_char(start_location TextLocation, value string) Token {
	return Token.new(.char, start_location, value)
}

pub fn Token.new_number(start_location TextLocation, value string) Token {
	return Token.new(.number, start_location, value)
}

pub fn Token.new_special_character(start_location TextLocation, value string) Token {
	return Token.new(.special_character, start_location, value)
}

pub fn Token.new_single_line_comment(start_location TextLocation, value string) Token {
	return Token.new(.single_line_comment, start_location, value)
}

pub fn Token.new_multi_line_comment(start_location TextLocation, end_location TextLocation, value string) Token {
	return Token{
		@type: .multi_line_comment
		range: TextRange{
			start_location: start_location
			end_location: end_location
		}
		value: value
	}
}
