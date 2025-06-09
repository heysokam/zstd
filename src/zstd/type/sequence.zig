//:____________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
//! @fileoverview Describes the seq[T] type and its related tools and aliases.
//_____________________________________________________________________________|
pub const sequence = @This();
const std = @import("std");
const cstring = @import("./alias.zig").cstring;

//______________________________________
// @section Aliases
//____________________________
/// @descr Growable Sequence of Bytes (aka string). Alias for {@link seq(u8)}
pub const string     = seq(u8);
/// @descr Growable Sequence of Bytes
pub const ByteBuffer = seq(u8);


//______________________________________
// @section Type Definition
//____________________________
/// @descr Generic Growable Sequence/Array
pub fn seq (comptime T :type) type { return struct {
  const Buffer = std.ArrayListUnmanaged(T);

  A       :std.mem.Allocator,
  buffer  :@This().Buffer,
  pub fn data (str :*const @This()) []T { return str.buffer.items; }

  //______________________________________
  /// @description Creates a completely empty sequence
  pub fn create_empty (allocator :std.mem.Allocator) @This() {
    return @This(){
      .A      = allocator,
      .buffer = @This().Buffer{},
    };
  }

  //______________________________________
  /// @description Creates an empty sequence with the given pre-allocated capacity
  pub fn create_capacity (cap :usize, allocator :std.mem.Allocator) !@This() {
    var result = @This(){
      .A      = allocator,
      .buffer = @This().Buffer{},
    };
    try result.buffer.ensureTotalCapacity(result.A, cap);
    return result;
  }

  //______________________________________
  /// @description Creates a sequence with the given list of items
  pub fn create (items :[]const T, allocator :std.mem.Allocator) !@This() {
    var result = try @This().create_capacity(items.len, allocator);
    result.buffer.appendSliceAssumeCapacity(items);
    return result;
  }

  //______________________________________
  /// @description Creates a sequence with the given list of items
  pub fn destroy (S :*@This()) void { S.buffer.deinit(S.A); }
  //______________________________________
  /// @description Adds the given list of items to the sequence
  pub fn add (S :*@This(), items :[]const T) !void { try S.buffer.appendSlice(S.A, items); }

  // TODO: Make it generic for slice and single item
  pub fn contains (S :*@This(), item :T) bool { return std.mem.indexOfScalar(T, S.buffer.items, item) != null; }
  pub fn has (S :*@This(), item :T) bool { return S.contains(item); }

};}


//______________________________________
// @section string
//____________________________
/// @descr Collection of tools for dealing with Growable Sequence of Bytes (aka string).
pub const Str = struct {
  const @"type" = ByteBuffer;
  /// @descr Allocates a Growable Sequence of Bytes (aka string) from the given {@arg S} string.
  pub fn from (S :cstring, A :std.mem.Allocator) !@This() {
    var result = try @This().create_capacity(A, S.len);
    try result.add(S);
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

