//:____________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
// @deps std
const std = @import("std");


test {
  std.testing.refAllDecls(@This());
  // Custom Types
  _ = @import("./zstd/type/sequence.test.zig"); // seq[T]
  // _ = @import("./zstd/type/set.test.zig"); // set[T]
}

