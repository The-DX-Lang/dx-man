module string_parser

pub fn test_identity_parser() {
	input := 'unit test'
	result := identity_parser(input) or { '' }

	assert result == input
}
