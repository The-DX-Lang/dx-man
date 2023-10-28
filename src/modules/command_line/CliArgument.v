module command_line

import string_parser { StringParser }

pub struct CliArgument {
pub:
	name        string                        [required]
	description string
	is_required bool
	is_variadic bool
	parser      StringParser[string, !string] [required]
}

pub struct ParsedCliArgument {
	CliArgument
	value []string
}
