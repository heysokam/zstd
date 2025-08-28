//:_______________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0 :
//:_______________________________________________________
//! @fileoverview
//!  Describes a Shell Command and the tools to manage it
//!  The command will be run by combining all of its separate parts into a single string
//_______________________________________________________________________________________|
const Cmd = @This();
// @deps std
const std = @import("std");
// @deps zstd
const T         = @import("../types.zig");
const cstring   = T.cstring;
const cstr_List = T.cstring_List;


// TODO: Move to their own file, including the rest at ../shell.zig
const zig = struct {
  /// @descr Runs the given command using {@link std.process.Child.spawnAndWait} in non-capturing (aka shell-like) mode
  fn shell (args :cstr_List, A :std.mem.Allocator) !void {
    var P = std.process.Child.init(args, A);
    _= try std.process.Child.spawnAndWait(&P);
  }
};


//______________________________________
// @section Object Fields
//____________________________
parts   :Parts,
cwd     :?cstring    = null,
result  :?Cmd.Result = null,


//______________________________________
// @section Internal Types
//____________________________
const Parts = T.seq(cstring);
pub const Result = struct {
  stdout  :Data,
  stderr  :Data,
  code    :?u8,
  const MaxBytes = 50*1024;
  const Data = T.seq(u8);
  const Term = std.process.Child.Term;
  fn create (A :std.mem.Allocator) Cmd.Result {
    return Cmd.Result{
      .stdout = Data.create_empty(A),
      .stderr = Data.create_empty(A),
      .code   = null,
    };
  }
  pub fn clone (R :*Cmd.Result) !Cmd.Result { return Cmd.Result{
    .stderr = try R.stderr.clone(),
    .stdout = try R.stdout.clone(),
    .code   = R.code
  };}
  fn destroy (R :*Cmd.Result) void { R.stderr.destroy(); R.stdout.destroy(); R.code = null; }
};


//______________________________________
// @section General tools
//____________________________
/// @descr Frees all resources owned by the object.
pub fn destroy (C :*Cmd) void {
  C.parts.destroy();
  if (C.result != null){ C.result.?.destroy(); C.result = null; }
  if (C.cwd != null) C.cwd = null;
}
/// @descr Creates a new empty Cmd object, and initializes its memory
pub fn create  (A :std.mem.Allocator) Cmd { return Cmd{.parts = Cmd.Parts.create_empty(A)}; }
/// @descr Adds the {@arg part} to the list of parts of the {@arg Cmd}. Allocates more memory as necessary.
pub fn add     (C :*Cmd, part :cstring) !void { try C.parts.add_one(part); }
/// @descr Adds the entire {@arg list} to the list of parts of the {@arg Cmd}. Allocates more memory as necessary.
pub fn addList (C :*Cmd, list :cstr_List) !void { try C.parts.add_many(list); }

//______________________________________
/// @blocking
/// @descr Runs the given Command in non-capturing (aka shell-like) mode
pub fn run (C :*Cmd) !void { try zig.shell(C.parts.data(), C.parts.A); }
//______________________________________
/// @blocking
/// @descr Runs the given {@arg C} Command and stores the output into its {@link Cmd.result} field
pub fn exec (C :*Cmd) !void {
  C.result = Cmd.Result.create(C.parts.A);
  var P = std.process.Child.init(C.parts.data(), C.parts.A);
  P.stdout_behavior = .Pipe;
  P.stderr_behavior = .Pipe;
  try P.spawn();
  var tmp_stdout = C.result.?.stdout.toUnmanaged();
  var tmp_stderr = C.result.?.stderr.toUnmanaged();
  try P.collectOutput(C.parts.A, &tmp_stdout, &tmp_stderr, Cmd.Result.MaxBytes);
  const code = try P.wait();
  C.result.?.stdout = Cmd.Result.Data.fromUnmanaged(tmp_stdout, C.result.?.stdout.A);
  C.result.?.stderr = Cmd.Result.Data.fromUnmanaged(tmp_stderr, C.result.?.stderr.A);
  C.result.?.code   = code.Exited;
}

