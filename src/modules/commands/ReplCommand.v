module commands

import command_line { CliArgument, CliCommand, CliFlag, CliOption, CommandExecutionContext }
import log

pub struct ReplCommand {
}

pub fn (_ ReplCommand) get_name() string {
	return 'repl'
}

pub fn (_ ReplCommand) get_description() string {
	return ''
}

pub fn (_ ReplCommand) get_aliases() []string {
	return []
}

pub fn (_ ReplCommand) get_subcommands() []CliCommand {
	return []
}

pub fn (_ ReplCommand) get_arguments() []CliArgument {
	return []
}

pub fn (_ ReplCommand) get_options() []CliOption {
	return []
}

pub fn (_ ReplCommand) get_flags() []CliFlag {
	return []
}

pub fn (_ ReplCommand) execute(commandExecutionContext CommandExecutionContext) ? {
	log.info('Starting REPL')
}
