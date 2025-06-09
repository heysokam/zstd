//:____________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
//! @fileoverview Describes a set[T] type and its related tools.
//_______________________________________________________________|
pub const set = @This();
pub const Set = @This().Ordered;
// @deps std
const std = @import("std");
// @deps zstd.types
const alias = @import("./alias.zig");
const cstr  = alias.cstr;


//______________________________________
// @section Set Aliases
//____________________________
/// @descr Describes a set[T] that doesn't maintain insertion order.
/// @todo Support for containing strings by conditionally returning an std.BufSet
/// @todo Rename to UnorderedSet and implement set as OrderedSet by default
pub fn Unordered (comptime T :type) type {
// pub fn set (comptime T :type) type {
  return struct {
    data  :Data,
    const Data = std.AutoHashMap(T, void);
    pub const Iter = Data.KeyIterator;
    pub fn create   (A :std.mem.Allocator) @This() { return @This(){.data= std.AutoHashMap(T, void).init(A)}; }
    pub fn clone    (S :*const @This()) !@This() { return @This(){.data= try S.data.clone()}; }
    pub fn destroy  (S :*@This()) void { S.data.deinit(); }
    pub fn incl     (S :*@This(), val :T) !void { _ = try S.data.getOrPut(val); }
    pub fn excl     (S :*@This(), val :T)  void { _ = S.data.remove(val) ; }
    pub fn iter     (S :*const @This()) @This().Iter { return S.data.keyIterator(); }
    pub fn contains (S :*const @This(), val :T) bool { return S.data.contains(val); }
    pub fn has      (S :*const @This(), val :T) bool { return S.contains(val); }
  };
}
//____________________________
/// @descr Describes a set[T]
/// @todo Support for containing strings by conditionally returning an std.StringArrayHashMap
pub fn Ordered (comptime T :type) type {
  return struct {
    data  :Data,
    const Data = if (T == cstr) std.StringArrayHashMap(void) else std.AutoArrayHashMap(T, void);
    pub fn create   (A :std.mem.Allocator) @This() { return @This(){.data= Data.init(A)}; }
    pub fn destroy  (S :*@This()) void { S.data.deinit(); }
    pub fn incl     (S :*@This(), val :T) !void { _ = try S.data.getOrPut(val); }
    pub fn excl     (S :*@This(), val :T)  void { _ = S.data.orderedRemove(val) ; }
    pub fn items    (S :*const @This()) []const T { return S.data.keys(); }
    pub fn contains (S :*const @This(), val :T) bool { return S.data.contains(val); }
    pub fn has      (S :*const @This(), val :T) bool { return S.contains(val); }
  };
}

