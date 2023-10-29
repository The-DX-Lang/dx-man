module definitions

pub fn test_default_text_location() {
	assert default_text_location.column == 0
	assert default_text_location.line_number == 1
}

pub fn test_advance() {
	current_text_location := default_text_location

	result := current_text_location.advance(1)

	assert result.column == 1
	assert result.line_number == 1
	assert &result != &current_text_location
}

pub fn test_handle_newline() {
	current_text_location := TextLocation{
		column: 12
		line_number: 1
	}

	result := current_text_location.handle_newline()

	assert result.column == 0
	assert result.line_number == 2
	assert &result != &current_text_location
}
