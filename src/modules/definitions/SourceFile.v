module definitions

import os

pub struct SourceFile {
pub:
	file_path     string [required]
	file_contents []rune [required]
}

pub fn SourceFile.read_from_file(file_path string) !SourceFile {
	absolute_file_path := os.abs_path(file_path)
	file_contents := os.read_file(absolute_file_path)!

	return SourceFile{
		file_path: absolute_file_path
		file_contents: file_contents.runes()
	}
}
