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
/// @descr Describes a software version, using the Semantic Versioning 2.0.0 specification.
pub const Version = std.SemanticVersion;

