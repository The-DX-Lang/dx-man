module string_parser

pub type Parser[T, U] = fn (T) ?U
