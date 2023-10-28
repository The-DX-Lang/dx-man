module main

import command_line { CliApplication, CliFlag }
import commands { HelpCommand, ReplCommand }
import os
import log

fn main() {
	log.set_level(.debug)

	application := CliApplication{
		name: 'dx-man'
		version: '0.0.0'
		registered_commands: [HelpCommand{}, ReplCommand{}]
		global_flags: [
			CliFlag{
				name: 'verbose'
				aliases: ['v']
				description: 'Enables verbose logging'
			},
		]
	}

	application.execute(os.args[1..])
}
