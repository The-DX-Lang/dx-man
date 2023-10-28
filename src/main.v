module main

import command_line
import commands { HelpCommand, ReplCommand }
import os
import log

fn main() {
	log.set_level(.debug)

	application := command_line.CliApplication{
		name: 'dx-man'
		version: '0.0.0'
		registered_commands: [HelpCommand{}, ReplCommand{}]
	}

	application.execute(os.args[1..])
}
