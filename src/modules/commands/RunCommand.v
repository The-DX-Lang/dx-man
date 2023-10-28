module commands

import command_line { CliArgument, CliCommand, CliFlag, CliOption, CommandExecutionContext }
import log
import string_parser { valid_file_parser }

pub struct RunCommand {
}

pub fn (_ RunCommand) get_name() string {
	return 'run'
}

pub fn (_ RunCommand) get_description() string {
	return 'Runs the given source file'
}

pub fn (_ RunCommand) get_aliases() []string {
	return []
}

pub fn (_ RunCommand) get_subcommands() []CliCommand {
	return []
}

pub fn (_ RunCommand) get_arguments() []CliArgument {
	return [
		CliArgument{
			name: 'file'
			description: 'The file which should be executed'
			is_required: true
			parser: valid_file_parser
		},
	]
}

pub fn (_ RunCommand) get_options() []CliOption {
	return []
}

pub fn (_ RunCommand) get_flags() []CliFlag {
	return []
}

pub fn (_ RunCommand) execute(commandExecutionContext CommandExecutionContext) ? {
	file_argument := commandExecutionContext.arguments['file'] or {
		log.error('No file to run specified!')

		return
	}

	file_to_run := file_argument.value[0]

	log.info('Running file: ${file_to_run}')
}
