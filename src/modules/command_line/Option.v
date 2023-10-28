module command_line

import string_parser { Parser }

pub struct CliOption {
pub:
	name        string                 [required]
	description string
	aliases     []string
	parser      Parser[string, string] [required]
}

pub struct ParsedCliOption {
	CliOption
	value ?string
}

pub fn find_option_by_name(options []CliOption, name_to_find string) ?CliOption {
	for cli_option in options {
		if cli_option.name != name_to_find {
			continue
		}

		return cli_option
	}

	return none
}

pub fn find_option_by_alias(options []CliOption, alias_to_find string) ?CliOption {
	for cli_option in options {
		if cli_option.aliases.contains(alias_to_find) == false {
			continue
		}

		return cli_option
	}

	return none
}
