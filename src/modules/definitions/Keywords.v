module definitions

// boolean values

pub const keyword_true = 'true'

pub const keyword_false = 'false'

// data types

pub const keyword_void = 'void'

pub const keyword_boolean = 'boolean'

pub const keyword_byte = 'byte'

pub const keyword_int8 = 'int8'

pub const keyword_int16 = 'int16'

pub const keyword_int32 = 'int32'

pub const keyword_int64 = 'int64'

pub const keyword_uint8 = 'uint8'

pub const keyword_uint16 = 'uint16'

pub const keyword_uint32 = 'uint32'

pub const keyword_uint64 = 'uint64'

pub const keyword_float32 = 'float32'

pub const keyword_float64 = 'float64'

pub const keyword_string = 'string'

pub const keyword_char = 'char'

// variables + constants

pub const keyword_var = 'var'

pub const keyword_const = 'const'

// loops

pub const keyword_for = 'for'

pub const keyword_foreach = 'foreach'

pub const keyword_in = 'in'

pub const keyword_while = 'while'

pub const keyword_do = 'do'

pub const keyword_continue = 'continue'

pub const keyword_break = 'break'

// other

pub const keyword_enum = 'enum'

pub const keyword_class = 'class'

pub const keyword_this = 'this'

pub const keyword_super = 'super'

pub const keyword_struct = 'struct'

pub const keyword_match = 'match'

pub const keyword_when = 'when'

pub const keyword_operator = 'operator'

pub const keyword_if = 'if'

pub const keyword_elseif = 'elseif'

pub const keyword_else = 'else'

pub const keyword_return = 'return'

// Visibility

pub const keyword_public = 'public'

pub const keyword_protected = 'protected'

pub const keyword_private = 'private'

// class modifiers

pub const keyword_abstract = 'abstract'

pub const keyword_final = 'final'

// inheritance + traits

pub const keyword_trait = 'trait'

pub const keyword_extends = 'extends'

pub const keyword_implements = 'implements'

// module system

pub const keyword_export = 'export'

pub const keyword_import = 'import'

pub const keyword_from = 'from'

pub const dx_keywords = [
	// boolean values
	keyword_true,
	keyword_false,
	// data types
	keyword_void,
	keyword_boolean,
	keyword_byte,
	keyword_int8,
	keyword_int16,
	keyword_int32,
	keyword_int64,
	keyword_uint8,
	keyword_uint16,
	keyword_uint32,
	keyword_uint64,
	keyword_float32,
	keyword_float64,
	keyword_string,
	keyword_char,
	// variables + constants
	keyword_var,
	keyword_const,
	// loops
	keyword_for,
	keyword_foreach,
	keyword_in,
	keyword_while,
	keyword_do,
	keyword_continue,
	keyword_break,
	// other
	keyword_enum,
	keyword_class,
	keyword_this,
	keyword_super,
	keyword_struct,
	keyword_match,
	keyword_when,
	keyword_operator,
	keyword_if,
	keyword_elseif,
	keyword_else,
	keyword_return,
	// Visibility
	keyword_public,
	keyword_protected,
	keyword_private,
	// class modifiers
	keyword_abstract,
	keyword_final,
	// inheritance + traits
	keyword_trait,
	keyword_extends,
	keyword_implements,
	// module system
	keyword_export,
	keyword_import,
	keyword_from,
]

pub const valid_top_level_keywords = [
	keyword_void,
	keyword_boolean,
	keyword_byte,
	keyword_int8,
	keyword_int16,
	keyword_int32,
	keyword_int64,
	keyword_uint8,
	keyword_uint16,
	keyword_uint32,
	keyword_uint64,
	keyword_float32,
	keyword_float64,
	keyword_string,
	keyword_char,
	//
	keyword_abstract,
	keyword_final,
	//
	keyword_const,
	keyword_enum,
	keyword_struct,
	keyword_class,
	keyword_trait,
	//
	keyword_export,
	keyword_import,
]
