module definitions

pub struct TextRange {
pub:
	start_location TextLocation
	end_location   TextLocation
}

pub fn TextRange.calculate(start_location TextLocation, text_length int) TextRange {
	return TextRange{
		start_location: start_location
		end_location: start_location.advance(text_length)
	}
}
