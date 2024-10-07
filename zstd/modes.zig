// @deps std
const std     = @import("std");
const builtin = @import("builtin");


//______________________________________
// @section Operating System Aliases
//____________________________
pub const linux = builtin.os.tag == .linux;
pub const win   = builtin.os.tag == .windows;
pub const macos = builtin.os.tag.isDarwin();


//______________________________________
// @section Compile Mode Aliases
//____________________________
pub const debug = builtin.mode == std.builtin.OptimizeMode.Debug;
pub const safe  = std.debug.runtime_safety;

