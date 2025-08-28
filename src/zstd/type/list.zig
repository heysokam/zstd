//:_______________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0 :
//:_______________________________________________________
// @deps std
const std = @import("std");
// @deps zstd
const seq = @import("./alias.zig").seq;
const Distinct = @import("./distinct.zig").Distinct;

//______________________________________
/// @descr Describes a growable list of arbitrary data that must be indexed with a Distinct(uint)
pub fn DataList2 (T :type, P :type) type { switch (@typeInfo(P)) {
    .int => |t| if (t.signedness != .unsigned)
            @compileError("The integer type used for the Index/Position of the list MUST be unsigned."),
    else => @compileError("The type used for the Index/Position of the list MUST be an integer.")
  } return struct {
  const Uint = P;
  /// @descr Describes a location/position inside the list
  pub const Pos = Distinct(Uint);
  /// @descr Describes a growable list of arbitrary data
  pub const Entries = std.AutoArrayHashMapUnmanaged(@This().Pos, T);
  A        :std.mem.Allocator,
  entries  :Entries= .{},

  /// @descr Creates a new empty DataList(T) object.
  pub fn create (A :std.mem.Allocator) !@This() { return @This(){.A=A, .entries= try Entries.init(A, &.{}, &.{})}; }
  /// @descr Releases all memory used by the DataList(T)
  pub fn destroy (L :*@This()) void { L.entries.deinit(L.A); }
  /// @descr Duplicates the data of the {@arg N} so that it is safe to call {@link DataList(T).destroy} without deallocating the duplicate.
  pub fn clone (L :*const @This()) !@This() { return @This(){.A=L.A, .entries= try L.entries.clone(L.A)}; }
  /// @descr Adds the given {@arg val} to the {@arg L} DataList(T)
  pub fn add (L :*@This(), val :T) !void { try L.entries.put(L.A, @This().Pos.from(L.entries.entries.len), val); }
  /// @descr Sets the item contained in {@arg L} at position {@arg pos} to the value of {@arg V}
  pub fn set (L :*const @This(), pos :@This().Pos, V :T) void { L.entries.put(L.A, pos, V); }
  /// @descr Returns the list of items contained in {@arg L}. Returns an empty list otherwise.
  pub inline fn items (L :*const @This()) []T { return L.entries.values(); }
  /// @descr Returns the item contained in {@arg L} at position {@arg pos}. Returns null otherwise.
  pub inline fn at (L :*const @This(), pos :@This().Pos) ?T { return L.entries.get(pos); }
  /// @descr Returns true if the Node list has no nodes.
  pub inline fn empty (L :*const @This()) bool { return L.entries.entries.len == 0; }
  /// @descr Returns the length of the list of items contained in {@arg L}.
  pub inline fn len (L :*const @This()) Uint { return L.entries.entries.len; }
  /// @descr Returns the position/id of the last entry in the list of items contained in {@arg L}.
  pub inline fn last (L :*const @This()) @This().Pos { return @This().Pos.from(L.len()-1); }
};} //:: zstd.DataList
pub fn DataList (T :type) type { return DataList2(T, usize); }

