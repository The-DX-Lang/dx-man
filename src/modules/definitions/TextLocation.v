module definitions

pub struct TextLocation {
pub:
	column      int
	line_number int
}

pub const default_text_location = TextLocation{
	column: 0
	line_number: 1
}

pub fn (this TextLocation) advance(amount int) TextLocation {
	return TextLocation{
		column: this.column + amount
		line_number: this.line_number
	}
}

pub fn (this TextLocation) handle_newline() TextLocation {
	return TextLocation{
		column: 0
		line_number: this.line_number + 1
	}
}
