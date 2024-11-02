//:____________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
//:____________________________________________________
// @deps std
const std = @import("std");
// @deps zstd
const seq = @import("./alias.zig").seq;

//______________________________________
/// @descr Describes a growable list of arbitrary data
pub fn DataList (T :type) type {
  return struct {
    /// @descr Describes a location/position inside the list
    pub const Pos = pos.type;
    const pos = struct {
      const @"type" = usize;
      /// @descr Describes an invalid location/position inside the list
      pub const Invalid :pos.type= std.math.maxInt(pos.type);
    };
    /// @descr Describes a growable list of arbitrary data
    pub const Entries = seq(T);
    entries :?Entries=  null,
    /// @descr Creates a new empty DataList(T) object.
    pub fn create (A :std.mem.Allocator) @This() { return @This(){.entries= Entries.init(A)}; }
    /// @descr Releases all memory used by the DataList(T)
    pub fn destroy (L:*@This()) void { L.entries.?.deinit(); }
    /// @descr Returns true if the Node list has no nodes.
    pub fn empty (L:*const @This()) bool { return L.entries == null or L.entries.?.items.len == 0; }
    /// @descr Adds the given {@arg val} to the {@arg L} DataList(T)
    pub fn add (L :*@This(), val :T) !void { try L.entries.?.append(val); }
    /// @descr Duplicates the data of the {@arg N} so that it is safe to call {@link DataList(T).destroy} without deallocating the duplicate.
    pub fn clone (L :*const @This()) !@This() { return @This(){.entries= try L.entries.?.clone()}; }
    /// @descr Returns the list of items contained in {@arg L}. Returns an empty list otherwise.
    pub fn items (L :*const @This()) []T { return if (!L.empty()) L.entries.?.items else &.{}; }
    /// @descr Returns the length of the list of items contained in {@arg L}.
    pub fn len (L :*const @This()) @This().Pos { return if (!L.empty()) L.entries.?.items.len else @This().pos.Invalid; }
    /// @descr Returns the position/id of the last entry in the list of items contained in {@arg L}.
    pub fn last (L :*const @This()) @This().Pos { return if (!L.empty()) L.entries.?.items.len-1 else @This().pos.Invalid; }
    /// @descr Returns the list of items contained in {@arg L}. Returns an empty list otherwise.
    pub fn at (L :*const @This(), P :@This().Pos) ?T { return if (!L.empty()) L.entries.?.items[P] else null; }
  };
} //:: zstd.DataList

