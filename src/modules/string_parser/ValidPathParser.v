module string_parser

import os

pub fn valid_path_parser(input string) ?string {
	absolute_path := os.abs_path(input)

	return os.existing_path(absolute_path) or { none }
}
