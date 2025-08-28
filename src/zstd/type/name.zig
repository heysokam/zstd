//:_______________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0 :
//:_______________________________________________________
//! @fileoverview Describes a General Purpose Name.
//__________________________________________________|
pub const Name = @This();
// @deps std
const std = @import("std");
// @deps zstd.types
const alias = @import("./alias.zig");
const cstr  = alias.cstr;

//______________________________________
// @section Name
//____________________________
/// @descr Short version of the name. Mandatory.
short  :cstr,
/// @descr Long version of the name. Will use {@link Name.short} when not specified.
long   :?cstr= null,
/// @descr Human-readable version of the name. Will use {@link Name.long} when not specified.
human  :?cstr= null,

