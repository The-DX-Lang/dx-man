module command_line

pub struct CliFlag {
pub:
	name        string   [required]
	description string
	aliases     []string
}

pub fn (this CliFlag) to_parsed_flag(value bool) ParsedCliFlag {
	return ParsedCliFlag{
		name: this.name
		description: this.description
		aliases: this.aliases
		value: value
	}
}

pub struct ParsedCliFlag {
	CliFlag
pub:
	value bool
}

pub fn find_flag_by_name(flags []CliFlag, name_to_find string) ?CliFlag {
	for flag in flags {
		if flag.name != name_to_find {
			continue
		}

		return flag
	}

	return none
}

pub fn find_flag_by_alias(flags []CliFlag, alias_to_find string) ?CliFlag {
	for flag in flags {
		if flag.aliases.contains(alias_to_find) == false {
			continue
		}

		return flag
	}

	return none
}
