module definitions

pub fn test_calculate() {
	text_length := 'for'.len

	result := TextRange.calculate(default_text_location, text_length)

	assert result.start_location == default_text_location
	assert &result.start_location == &default_text_location
	assert result.end_location.column == 3
	assert result.end_location.line_number == default_text_location.line_number
}
