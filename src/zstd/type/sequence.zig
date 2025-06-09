//:____________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
//! @fileoverview Describes the seq[T] type and its related tools and aliases.
//_____________________________________________________________________________|
pub const sequence = @This();
const std = @import("std");
const alias = @import("./alias.zig");
const zstd = struct {
  const cstring = alias.cstring;
  const zstring = alias.zstring;
};

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
  const Buffer        = std.ArrayListUnmanaged(T);
  const Slice         = @This().Buffer.Slice;
  const SentinelSlice = @This().Buffer.SentinelSlice;

  A       :std.mem.Allocator,
  buffer  :@This().Buffer,
  pub fn data (str :*const @This()) @This().Slice { return str.buffer.items; }

  //______________________________________
  /// @descr Creates a sequence with the given list of items
  pub fn destroy (S :*@This()) void { S.buffer.deinit(S.A); }
  //______________________________________
  /// @descr Creates a completely empty sequence
  pub fn create_empty (allocator :std.mem.Allocator) @This() {
    return @This(){
      .A      = allocator,
      .buffer = @This().Buffer{},
    };
  }

  //______________________________________
  /// @descr Creates an empty sequence with the given pre-allocated capacity
  pub fn create_capacity (cap :usize, allocator :std.mem.Allocator) !@This() {
    var result = @This().create_empty(allocator);
    try result.buffer.ensureTotalCapacity(result.A, cap);
    return result;
  }

  //______________________________________
  /// @descr Creates a sequence with the given list of items
  pub fn create (items :@This().Slice, allocator :std.mem.Allocator) !@This() {
    var result = try @This().create_capacity(items.len, allocator);
    result.buffer.appendSliceAssumeCapacity(items);
    return result;
  }
  //______________________________________
  /// @descr Creates a sequence from the given unmanaged seq.Buffer
  pub fn fromUnmanaged (buffer :@This().Buffer, allocator :std.mem.Allocator) @This() {
    var result = @This().create_empty(allocator);
    result.buffer = buffer;
    return result;
  }
  //______________________________________
  /// @descr Returns the unmanaged data of the sequence, and clears the sequence without deallocating any data
  pub fn toUnmanaged (S :*@This()) @This().Buffer {
    const allocator = S.A;
    const result    = S.buffer;
    S.* = @This().create_empty(allocator);
    return result;
  }

  //______________________________________
  pub fn toOwned (S :*@This()) !@This().Slice {
    return try S.buffer.toOwnedSlice(S.A);
  }
  //______________________________________
  pub fn toOwnedSentinel (S :*@This(), comptime sentinel :T) !@This().SentinelSlice(sentinel) {
    return try S.buffer.toOwnedSliceSentinel(S.A, sentinel);
  }
  //______________________________________
  pub fn zstring (S :*@This()) !zstd.zstring { return try S.toOwnedSentinel(0); }

  //______________________________________
  /// @descr
  ///  Clones all of the data of the sequence into the result.
  ///  The resulting sequence will be independent of the original and contain a duplicate of its data.
  ///  Must destroy both sequences separately when done using them.
  pub fn clone (S :*const @This()) !@This() {
    var result = @This().create_empty(S.A);
    result.buffer = try result.buffer.clone(result.A);
    return result;
  }

  //______________________________________
  /// @descr Adds the given item to the sequence
  pub fn add_one (S :*@This(), item :T) !void { try S.buffer.append(S.A, item); }
  //______________________________________
  /// @descr Adds the given list of items to the sequence
  pub fn add_many (S :*@This(), items :[]const T) !void { try S.buffer.appendSlice(S.A, items); }
  //______________________________________
  /// @descr Adds the given list of items to the sequence
  // TODO: Make it generic for slice and single item
  pub fn add (S :*@This(), items :[]const T) !void { try S.buffer.appendSlice(S.A, items); }

  //______________________________________
  // TODO: Make it generic for slice and single item
  pub fn contains (S :*@This(), item :T) bool { return std.mem.indexOfScalar(T, S.buffer.items, item) != null; }
  pub fn has (S :*@This(), item :T) bool { return S.contains(item); }
};} //:: seq[T]


//______________________________________
// @section string
//____________________________
/// @descr Collection of tools for dealing with Growable Sequence of Bytes (aka string).
pub const Str = struct {
  const @"type" = ByteBuffer;
  /// @descr Allocates a Growable Sequence of Bytes (aka string) from the given {@arg S} string.
  pub fn from (S :zstd.cstring, A :std.mem.Allocator) !@This() {
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

