module lexer

import definitions { TextLocation }

struct UnexpectedEndOfFileError {
	Error
	what_lexing       string       [required]
	closing_character string       [required]
	start_location    TextLocation [required]
}

pub fn (mut this UnexpectedEndOfFileError) str() string {
	return 'Unexpected end of file while parsing ${this.what_lexing}. The token starts at ${this.start_location}. You could add the following string to help the lexer: ${this.closing_character}'
}
