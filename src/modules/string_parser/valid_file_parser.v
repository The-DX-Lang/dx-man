module string_parser

import os

pub fn valid_file_parser(input string) ?string {
	absolute_path := os.abs_path(input)

	return if os.is_dir(absolute_path) == false {
		absolute_path
	} else {
		none
	}
}
