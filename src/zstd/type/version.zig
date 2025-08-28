//:_______________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0 :
//:_______________________________________________________
//! @fileoverview Describes a General Purpose Name.
//__________________________________________________|
pub const Version = std.SemanticVersion;
// @deps std
const std = @import("std");
// @deps zstd.types
const alias = @import("./alias.zig");
const cstr  = alias.cstr;


//______________________________________
// @section Version Management
//____________________________
/// @descr Returns a new Version object, described with the Semantic Versioning 2.0.0 specification.
pub fn version  (M :usize, m :usize, p :usize) Version { return version2(M,m,p, .{}); }
pub fn version2 (M :usize, m :usize, p :usize, args :struct {
    pre   : ?cstr= null,
    build : ?cstr= null,
  }) Version {
  return Version{.major= M, .minor= m, .patch= p, .pre= args.pre, .build= args.build };
}
// TODO:
// const Version *{.strdefine.}= "dev." & gorge "git --no-pager log -n 1 --pretty=format:%H"

