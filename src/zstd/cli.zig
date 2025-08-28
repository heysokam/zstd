//:_______________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0 :
//:_______________________________________________________
//! @fileoverview Cable connector to all zstd.Core modules
//__________________________________________________________|
pub const CLI = @This();
// @deps std
const std = @import("std");
// @deps zstd
const T       = @import("./types.zig");
const set     = T.set;
const seq     = T.seq;
const cstring = T.cstring;
const string  = T.string;
const Table   = T.StringTable;
const StrList = seq(cstring);


A     :std.mem.Allocator,
arg0  :cstring,
args  :Args,
opts  :Opts,
pub const Opts = struct {
  short  :Short,
  long   :Long,
  const Short = set.Ordered(u8);
  const Long  = Table(StrList);  // (key :string, values[cstring])
};
const Args = StrList;


const parse = struct {
  const Error = error { Short, Long, Name, Value };
  const Context = enum { none, name, value };

  fn long (cli :*CLI, val :cstring) !void {
    if (val[0] != '-' and val[1] != '-') return CLI.parse.Error.Long;
    // Parser State
    var ct     :Context= .none;
    var sep    :?usize=  null;  // Position of the : separator
    var N      :string=  string.create_empty(cli.A);
    var value  :?string= null;
    var escape :bool=    false;
    // Parse the option
    for (val, 0..) | ch, pos | {
      if (pos == 0 or pos == 1) continue;  // Skip the --
      if (pos == 2) ct = .name;            // Always start with the name
      switch (ct) {
        .none  => return CLI.parse.Error.Long,  // Should never happen
        .name  => {
               if (std.ascii.isAlphanumeric(ch)) { try N.add_one(ch); continue; }
          else if (ch == ':')                    { ct = .value; sep = pos; continue; }
          else                                   { return CLI.parse.Error.Name; }
         },
        .value => {
          if (ch == '"') {
                 if (pos == sep.? + 1) { continue; }
            else if (pos == val.len) { break; }
            else if (!escape)        { return CLI.parse.Error.Value; }
            } //:: if (ch == ") ...

          if (escape)           { escape = false; }  // This check has to go before the next. Allows `\\` as legal syntax
          else if (ch == '\\')  { escape = true; continue; }
          if (value == null) value = string.create_empty(cli.A);
          try value.?.add_one(ch);
         },
      }
    }
    // TODO: Move to its own function on the StringTable type
    const entry = try cli.opts.long.getOrPut(N.data());
    if (!entry.found_existing) { entry.value_ptr.* = StrList.create_empty(cli.A); }
    if (value != null) try entry.value_ptr.add_one(try value.?.toOwned());
  }

  // TODO: Allow short options to be more than booleans
  fn short (cli :*CLI, val :cstring) !void {
    for (val) | ch | {
      try switch (ch) {
        '-'       => continue,
        'a'...'z',
        'A'...'Z' => cli.opts.short.incl(ch),
        else => return CLI.parse.Error.Short,
      };
    }
  }

  fn arg (cli :*CLI, val :cstring) !void {
    try cli.args.add_one(val);  // @note Requires args to be initialized before calling this function
  }

};

pub fn init (A :std.mem.Allocator) !CLI {
  var args = try std.process.argsWithAllocator(A);
  defer args.deinit();
  var result = CLI{
    .A       = A,
    .arg0    = try A.dupe(u8, args.next() orelse ""),
    .args    = Args.create_empty(A),
    .opts    = CLI.Opts{
      .short = Opts.Short.create(A),
      .long  = Opts.Long.init(A),
      }, //:: opts
    }; //:: result
  while (args.next()) | arg | {
         if (std.mem.startsWith(u8, arg, "--")) { try CLI.parse.long(&result, arg); }
    else if (!std.mem.startsWith(u8, arg, "-")) { try CLI.parse.arg(&result, arg); }
    else                                        { try CLI.parse.short(&result, arg); }
  }
  return result;
}

pub fn destroy (cli :*CLI) void {
  cli.A.free(cli.arg0);
  cli.args.destroy();
  cli.opts.short.destroy();
  cli.opts.long.deinit();
}

//______________________________________
// @section Check Existence
//____________________________
/// @descr Returns true if the {@arg cli} contains the {@arg arg} argument at position {@arg id}
/// @note cli.args[0] will be arg1. cli.arg0 does not count
pub fn hasArgAt (cli :*const CLI, arg :cstring, id :usize) bool {
  return cli.args.data().len >= id+1 and std.mem.eql(u8, cli.args.data()[id], arg);
}
/// @descr Returns true if the {@arg cli} contains an argument at position {@arg id}
/// @note cli.args[0] will be arg1. cli.arg0 does not count
pub fn hasArg (cli :*const CLI, id :usize) bool { return cli.args.data().len >= id+1; }
/// @descr Returns true if the {@arg cli} contains the {@arg opt} long option
pub fn hasLong (cli :*const CLI, opt :cstring) bool { return cli.opts.long.contains(opt); }
/// @descr Returns true if the {@arg cli} contains the {@arg opt} short option
pub fn hasShort (cli :*const CLI, opt :u8  ) bool { return cli.opts.short.data.contains(opt); }

//______________________________________
// @section Get the values
//____________________________
pub const get = struct {
  const Error = error { LongOptionMissing, ArgumentMissing };
  /// @descr Returns the last value set for the long {@arg opt} in the {@arg cli} list of long options
  pub fn long (cli :*const CLI, opt :cstring) !cstring {
    const values = cli.opts.long.get(opt);
    if (values == null) { return get.Error.LongOptionMissing; }
    return values.?.data()[values.?.data().len-1];
  }
  /// @descr Returns the Argument at position {@arg id}
  /// @note cli.args[0] will be arg1. cli.arg0 does not count
  pub fn arg (cli :*const CLI, id :usize) !cstring {
    if (!cli.hasArg(id)) { return get.Error.ArgumentMissing; }
    return cli.args.data()[id];
  }
};
// Get: Aliases
pub const getLong = CLI.get.long;
pub const getArg  = CLI.get.arg;

