module commands

import command_line { CliArgument, CliCommand, CliFlag, CliOption, CommandExecutionContext }
import log
import string_parser { identity_parser }

pub struct HelpCommand {
}

pub fn (_ HelpCommand) get_name() string {
	return 'help'
}

pub fn (_ HelpCommand) get_description() string {
	return ''
}

pub fn (_ HelpCommand) get_aliases() []string {
	return []
}

pub fn (_ HelpCommand) get_subcommands() []CliCommand {
	return []
}

pub fn (_ HelpCommand) get_arguments() []CliArgument {
	return [
		CliArgument{
			name: 'path'
			parser: identity_parser
			is_variadic: true
		},
	]
}

pub fn (_ HelpCommand) get_options() []CliOption {
	return []
}

pub fn (_ HelpCommand) get_flags() []CliFlag {
	return []
}

pub fn (_ HelpCommand) execute(executionContext CommandExecutionContext) ? {
	log.info('Executing the help command with context: ${executionContext}')
}
