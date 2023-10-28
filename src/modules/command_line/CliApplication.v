module command_line

import math { min }
import log

pub struct CliApplication {
pub:
	name                string       [required]
	version             string       [required]
	registered_commands []CliCommand
	global_options      []CliOption
	global_flags        []CliFlag
}

pub fn (this CliApplication) execute(command_line_arguments []string) {
	log.debug('Command line arguments: ${command_line_arguments}')

	initial_execution_context := ExtendedCommandExecutionContext{
		available_commands: this.registered_commands
		registered_commands: this.registered_commands
		available_options: this.global_options
		available_flags: this.global_flags
		should_parse_commands: true
	}

	found_extended_execution_context := determine_execution_context(command_line_arguments,
		initial_execution_context)

	command_execution_context := convert_from_extended_command_execution_context(found_extended_execution_context)

	if command_execution_context.command_hierarchy.len == 0 {
		log.info('TODO: Print usage since no command was found')

		return
	}

	command_to_execute := command_execution_context.command_hierarchy[command_execution_context.command_hierarchy.len - 1]

	command_to_execute.execute(command_execution_context)
}

pub fn determine_execution_context(command_line_arguments []string, parent_execution_context ExtendedCommandExecutionContext) ExtendedCommandExecutionContext {
	mut new_execution_context := ExtendedCommandExecutionContext{
		...parent_execution_context
	}

	if command_line_arguments.len == 0 {
		log.debug('Returning current command execution context since no command line arguments are left')

		mut new_flags := parent_execution_context.flags.clone()

		for flag in parent_execution_context.available_flags {
			if flag.name in parent_execution_context.flags {
				continue
			}

			new_flags[flag.name] = flag.to_parsed_flag(false)
		}

		new_execution_context = ExtendedCommandExecutionContext{
			...parent_execution_context
			flags: new_flags
		}

		return new_execution_context
	}

	first_command_line_argument := command_line_arguments[0]
	next_arguments := command_line_arguments[1..]

	if first_command_line_argument.starts_with('--') {
		trimmed_name := first_command_line_argument.substr(2, first_command_line_argument.len)

		log.debug('Trying to find option by name: ${trimmed_name}')

		found_option := find_option_by_name(parent_execution_context.available_options,
			trimmed_name)

		if found_option != none {
			type_asserted_option := found_option or { panic('') }

			log.debug('Found cli option: ${type_asserted_option.name}')

			mut new_options := parent_execution_context.options.clone()
			new_options[type_asserted_option.name] = type_asserted_option.parse(next_arguments[0])

			new_execution_context = ExtendedCommandExecutionContext{
				...parent_execution_context
				options: new_options
			}

			return determine_execution_context(next_arguments[1..], new_execution_context)
		}

		log.debug('Trying to find flag by name: ${trimmed_name}')

		found_flag := find_flag_by_name(parent_execution_context.available_flags, trimmed_name)

		if found_flag != none {
			type_asserted_flag := found_flag or { panic('') }

			log.debug('Found cli flag: ${type_asserted_flag.name}')

			mut new_flags := parent_execution_context.flags.clone()
			new_flags[type_asserted_flag.name] = type_asserted_flag.to_parsed_flag(true)

			new_execution_context = ExtendedCommandExecutionContext{
				...parent_execution_context
				flags: new_flags
			}

			return determine_execution_context(next_arguments, new_execution_context)
		}

		log.warn('Could not find an option or flag for "${first_command_line_argument}"')

		return determine_execution_context(next_arguments, new_execution_context)
	} else if first_command_line_argument.starts_with('-') {
		trimmed_alias := first_command_line_argument.substr(1, first_command_line_argument.len)
		log.debug('Trying to find option by alias: ${trimmed_alias}')

		found_option := find_option_by_alias(parent_execution_context.available_options,
			trimmed_alias)

		if found_option != none {
			type_asserted_option := found_option or { panic('') }

			log.debug('Found cli option: ${type_asserted_option.name}')

			mut new_options := parent_execution_context.options.clone()
			new_options[type_asserted_option.name] = type_asserted_option.parse(next_arguments[0])

			new_execution_context = ExtendedCommandExecutionContext{
				...parent_execution_context
				options: new_options
			}

			return determine_execution_context(next_arguments[1..], new_execution_context)
		}

		log.debug('Trying to find flag by alias: ${trimmed_alias}')

		found_flag := find_flag_by_alias(parent_execution_context.available_flags, trimmed_alias)

		if found_flag != none {
			type_asserted_flag := found_flag or { panic('') }

			log.debug('Found cli flag: ${type_asserted_flag.name}')

			mut new_flags := parent_execution_context.flags.clone()
			new_flags[type_asserted_flag.name] = type_asserted_flag.to_parsed_flag(true)

			new_execution_context = ExtendedCommandExecutionContext{
				...parent_execution_context
				flags: new_flags
			}

			return determine_execution_context(next_arguments, new_execution_context)
		}

		log.warn('Could not find an option or flag for "${first_command_line_argument}"')

		return determine_execution_context(next_arguments, new_execution_context)
	}

	log.debug('Trying to find the command with name or alias: ${first_command_line_argument}')

	found_command := find_command_by_name_or_alias(parent_execution_context.available_commands,
		first_command_line_argument)

	if parent_execution_context.should_parse_commands && found_command != none {
		type_asserted_command := found_command or { panic('') }

		log.debug('Found command: "${found_command}"')

		mut new_command_hierarchy := parent_execution_context.command_hierarchy.clone()
		new_command_hierarchy << found_command

		mut new_available_options := parent_execution_context.available_options.clone()
		new_available_options << type_asserted_command.get_options()

		mut new_available_flags := parent_execution_context.available_flags.clone()
		new_available_flags << type_asserted_command.get_flags()

		new_execution_context = ExtendedCommandExecutionContext{
			...parent_execution_context
			command_hierarchy: new_command_hierarchy
			available_commands: type_asserted_command.get_subcommands()
			available_arguments: type_asserted_command.get_arguments()
			available_options: new_available_options
			available_flags: new_available_flags
		}

		return determine_execution_context(next_arguments, new_execution_context)
	}

	log.debug('Trying to parse "${first_command_line_argument}" as argument for the current command')

	if parent_execution_context.available_arguments.len == 0 {
		log.warn('Could not parse "${first_command_line_argument}" since the command does not accept arguments')

		return parent_execution_context
	}

	current_argument := parent_execution_context.available_arguments[min(parent_execution_context.argument_index,
		parent_execution_context.available_arguments.len - 1)]

	if current_argument.is_variadic == false
		&& parent_execution_context.argument_index >= parent_execution_context.available_arguments.len {
		log.warn('Could not parse "${first_command_line_argument}" as argument since the last argument (${current_argument.name}) is not variadic')

		return parent_execution_context
	}

	mut new_value := []string{}

	if current_argument.name in parent_execution_context.arguments {
		new_value = parent_execution_context.arguments[current_argument.name].value.clone()
	}

	new_value << [first_command_line_argument]

	mut new_arguments := parent_execution_context.arguments.clone()
	new_arguments[current_argument.name] = ParsedCliArgument{
		...new_arguments[current_argument.name]
		name: current_argument.name
		parser: current_argument.parser
		value: new_value
	}

	new_execution_context = ExtendedCommandExecutionContext{
		...parent_execution_context
		should_parse_commands: false
		arguments: new_arguments
		argument_index: parent_execution_context.argument_index + 1
	}

	return determine_execution_context(next_arguments, new_execution_context)
}
