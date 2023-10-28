module string_parser

pub type StringParser[T, U] = fn (T) ?U
