//:_______________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0 :
//:_______________________________________________________
//! @fileoverview Aliases for Zig std types
//___________________________________________|
const zstd = @This();
// @deps std
const std = @import("std");


//______________________________________
// @section Base/Primary Type Aliases
//____________________________
pub const todo = ?u8;


//______________________________________
// @section Array Aliases
//____________________________
/// @descr CharLiteral String. Compatible with C (Zero terminated)
pub const zstring      = [:0]const u8;
pub const zstr         = zstring;
/// @descr List of (Zero terminated) CharLiteral Strings
pub const zstring_List = []const zstring;
pub const zstr_List    = zstring_List;
/// @descr CharLiteral String (constant)
pub const cstring      = []const u8;
pub const cstr         = cstring;
/// @descr Modifiable CharLiteral String
pub const mstring     = []u8;
pub const mstr        = mstring;
/// @descr List of CharLiteral Strings
pub const cstring_List = []const cstring;
pub const cstr_List    = cstring_List;


//______________________________________
// @section MultiArray List Aliases
//____________________________
/// @descr MultiArray List (SoA)
pub const List = std.MultiArrayList;


//______________________________________
// @section Map Aliases
//____________________________
/// @descr Static Table (aka StaticStringMap)
pub const Map         = std.StaticStringMap;
pub const StringTable = std.StringHashMap;

