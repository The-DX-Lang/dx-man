module command_line

import string_parser { Parser }

pub struct CliArgument {
pub:
	name        string                  [required]
	description string
	is_required bool
	is_variadic bool
	parser      Parser[string, !string] [required]
}

pub struct ParsedCliArgument {
	CliArgument
	value []string
}
