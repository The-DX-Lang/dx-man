module command_line

pub struct CommandExecutionContext {
pub:
	command_hierarchy   []CliCommand
	registered_commands []CliCommand
	arguments           map[string]ParsedCliArgument
	options             map[string]ParsedCliOption
	flags               map[string]ParsedCliFlag
}

pub struct ExtendedCommandExecutionContext {
	CommandExecutionContext
pub:
	available_commands    []CliCommand
	available_arguments   []CliArgument
	available_options     []CliOption
	available_flags       []CliFlag
	should_parse_commands bool
	argument_index        int
}

pub fn convert_from_extended_command_execution_context(extendedCommandExecutionContext ExtendedCommandExecutionContext) CommandExecutionContext {
	return CommandExecutionContext{
		command_hierarchy: extendedCommandExecutionContext.command_hierarchy
		registered_commands: extendedCommandExecutionContext.registered_commands
		arguments: extendedCommandExecutionContext.arguments
		options: extendedCommandExecutionContext.options
		flags: extendedCommandExecutionContext.flags
	}
}
