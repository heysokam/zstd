//:____________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
//:____________________________________________________
//! @fileoverview Aliases for Zig std types
//___________________________________________|
const zstd = @This();
// @deps std
const std = @import("std");

//______________________________________
// @section Array Aliases
//____________________________
/// @descr CharLiteral String. Compatible with C (Zero terminated)
pub const zstr      = [:0]const u8;
/// @descr List of (Zero terminated) CharLiteral Strings
pub const zstr_List = []const zstr;
/// @descr CharLiteral String
pub const cstr      = []const u8;
/// @descr List of CharLiteral Strings
pub const cstr_List = []const cstr;


//______________________________________
// @section GArray Aliases
//____________________________
/// @descr Generic Growable Sequence/Array. Maps to `std.ArrayList(T)`
pub const seq = std.ArrayList;
/// @descr Growable Sequence of Bytes
pub const ByteBuffer = seq(u8);
/// @descr Growable Sequence of Bytes (aka string). Alias for {@link ByteBuffer}
pub const str = zstd.Str.type;
//____________________________
/// @descr Collection of tools for dealing with Growable Sequence of Bytes (aka string). Alias for {@link ByteBuffer}
pub const Str = struct {
  const @"type" = ByteBuffer;
  /// @descr Allocates a Growable Sequence of Bytes (aka string) from the given {@arg S} string.
  pub fn from (S :cstr, A :std.mem.Allocator) !zstd.str {
    var result = try zstd.str.initCapacity(A, S.len);
    try result.appendSlice(S);
    return result;
  } //:: zstd.Str.from
}; //:: zstd.Str
//____________________________
// @reference Filtered remove from ArrayList
// fn filterItems (lst :*std.ArrayList(u64)) void {
//   var to :usize= 0;
//   for (0..lst.items.len) | from | {
//     lst.items[to] = lst.items[from];             // move the item backwards when needed
//     if (shouldStay(lst.items[to])) { to += 1; }  // Increase the target index to not overwrite items that we want to keep
//   }
//   lst.shrinkRetainingCapacity(to);               // Remove everything leftover at the end of the list
// }
//____________________________


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

//______________________________________
// @section Distinct Numbers
//____________________________
pub fn Distinct (T :type) type { return enum(T) {_,}; }
pub const distinct = Distinct;

