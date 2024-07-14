//:____________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
//:____________________________________________________
//! @fileoverview Core Type Aliases
//__________________________________|
// @deps std
const std = @import("std");


//______________________________________
// @section Array Aliases
//____________________________
/// @descr CharLiteral String. Compatible with C (Zero terminated)
pub const zstr      = [:0]const u8;
/// @descr CharLiteral String
pub const cstr      = []const u8;
/// @descr List of CharLiteral Strings
pub const cstr_List = []const cstr;


//______________________________________
// @section GArray Aliases
//____________________________
/// @descr Generic Growable Sequence/Array. Maps to `std.ArrayList(T)`
pub const seq = std.ArrayList;
/// @descr Growable Sequence of Bytes (aka string)
pub const ByteBuffer = seq(u8);
/// @descr Growable Sequence of Bytes (aka string). Alias for {@link ByteBuffer}
pub const str = ByteBuffer;

//______________________________________
// @section MultiArray List Aliases
//____________________________
/// @descr MultiArray List (SoA)
pub const List = std.MultiArrayList;


//______________________________________
// @section Map Aliases
//____________________________
/// @descr Static Table (aka StaticStringMap)
pub const Map = std.StaticStringMap;


//______________________________________
// @section Set Aliases
//____________________________
/// @descr Describes a set[T]. Doesn't maintain insertion order.
/// @todo Support for containing strings by conditionally returning an std.BufSet
/// @todo Rename to UnorderedSet and implement set as OrderedSet by default
pub fn UnorderedSet (comptime T :type) type {
// pub fn set (comptime T :type) type {
  return struct {
    data  :Data,
    const Data = std.AutoHashMap(T, void);
    pub const Iter = Data.KeyIterator;
    pub fn create  (A :std.mem.Allocator) @This() { return @This(){.data= std.AutoHashMap(T, void).init(A)}; }
    pub fn destroy (S :*@This()) void { S.data.deinit(); }
    pub fn incl    (S :*@This(), val :T) !void { _ = try S.data.getOrPut(val); }
    pub fn excl    (S :*@This(), val :T)  void { _ = S.data.remove(val) ; }
    pub fn iter    (S :*const @This()) @This().Iter { return S.data.keyIterator(); }
  };
}
//____________________________
/// @descr Describes a set[T]
/// @todo Support for containing strings by conditionally returning an std.StringArrayHashMap
pub fn set (comptime T :type) type {
  return struct {
    data  :Data,
    const Data = if (T == cstr) std.StringArrayHashMap(void) else std.AutoArrayHashMap(T, void);
    pub fn create  (A :std.mem.Allocator) @This() { return @This(){.data= Data.init(A)}; }
    pub fn destroy (S :*@This()) void { S.data.deinit(); }
    pub fn incl    (S :*@This(), val :T) !void { _ = try S.data.getOrPut(val); }
    pub fn excl    (S :*@This(), val :T)  void { _ = S.data.orderedRemove(val) ; }
    pub fn items   (S :*const @This()) []const T { return S.data.keys(); }
  };
}



//______________________________________
// @section Marker Types
//____________________________
/// @descr Dummy type. Marks that a field is not used yet
pub const todo = ?u8;


//______________________________________
// @section Name
//____________________________
/// @descr Describes a General Purpose Name.
pub const Name = struct {
  /// @descr Short version of the name. Mandatory.
  short  :cstr,
  /// @descr Long version of the name. Will use {@link Name.short} when not specified.
  long   :?cstr= null,
  /// @descr Human-readable version of the name. Will use {@link Name.long} when not specified.
  human  :?cstr= null,
};


//______________________________________
// @section Other Aliases
//____________________________
pub const Version = std.SemanticVersion;
/// @descr Returns a new Version object, described with the Semantic Versioning 2.0.0 specification.
pub fn version (M :usize, m :usize, p :usize) Version { return version2(M,m,p, .{}); }
pub fn version2 (M :usize, m :usize, p :usize, args :struct {
    pre   : ?cstr= null,
    build : ?cstr= null,
  }) Version {
  return Version{.major= M, .minor= m, .patch= p, .pre= args.pre, .build= args.build };

}

