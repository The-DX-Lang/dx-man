module command_line

import string_parser { StringParser }

pub struct CliOption {
pub:
	name        string                       [required]
	description string
	aliases     []string
	parser      StringParser[string, string] [required]
}

pub fn (this CliOption) parse(input string) ParsedCliOption {
	return ParsedCliOption{
		name: this.name
		description: this.description
		aliases: this.aliases
		parser: this.parser
		value: this.parser(input)
	}
}

pub struct ParsedCliOption {
	CliOption
pub:
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
