//:____________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
//! @fileoverview Core Type Aliases
//__________________________________|
// @deps std
const std = @import("std");

//______________________________________
// @section Array Aliases
//____________________________
/// @descr CharLiteral String. Compatible with C
pub const cstr      = [:0]const u8;
/// @descr List of CharLiteral Strings
pub const cstr_List = []const cstr;

//______________________________________
// @section GArray Aliases
//____________________________
/// @descr Generic Growable Sequence/Array. Maps to `std.ArrayList(T)`
pub const Seq = std.ArrayList;
/// @descr Growable Sequence of Bytes (aka string)
pub const ByteBuffer = Seq(u8);
/// @descr Growable Sequence of Bytes (aka string). Alias for {@link ByteBuffer}
pub const Str = ByteBuffer;


//______________________________________
// @section Marker Types
//____________________________
/// @descr Dummy type. Marks that a field is not used yet
pub const todo = ?u8;

