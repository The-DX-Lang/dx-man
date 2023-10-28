module command_line

pub interface CliCommand {
	get_name() string
	get_description() string
	get_aliases() []string
	get_subcommands() []CliCommand
	get_arguments() []CliArgument
	get_options() []CliOption
	get_flags() []CliFlag
	// Gets called when the command was determined to execute
	execute(commandExecutionContext CommandExecutionContext) ?
}

pub fn find_command_by_name_or_alias(commands []CliCommand, name_or_alias string) ?CliCommand {
	for command in commands {
		if command.get_name() != name_or_alias && name_or_alias !in command.get_aliases() {
			continue
		}

		return command
	}

	return none
}
