//:_______________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0 :
//:_______________________________________________________
// @deps std
const std = @import("std");


test {
  std.testing.refAllDecls(@This());
  // Custom Types
  _ = @import("./zstd/type/sequence.test.zig"); // seq[T]
  // _ = @import("./zstd/type/set.test.zig"); // set[T]
}

