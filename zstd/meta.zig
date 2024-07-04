//:____________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
//:____________________________________________________
//! @fileoverview Tools for Zig's Type system and Meta-Programming
//__________________________________________________________________|
pub const meta = @This();
// @deps std
const std = @import("std");

//____________________________________
/// @descr Returns the last part of the typeName for T, without any of its `one.two.Typ` dot prefixes
pub fn typeName(T :type) []const u8 {
  const name = @typeName(T);
  const start = start: {
    const last = std.mem.lastIndexOfScalar(u8, name, '.') orelse 0;
    if (last == 0) { break :start last;   }
    else           { break :start last+1; }
  };
  return name[start..name.len];
}


pub const enums = struct {
  //____________________________________
  /// @descr
  ///  Combines all fields of all enums listed in {@arg list} into a single Enum type.
  ///  Will return an enum with prefixed fields when {@arg prefix} is not omitted and sent as true
  ///  @note Prefixes are created as `T_`
  pub fn join (list :[]const type, args :struct {
      prefix :bool= true,
    }) type {
    var index :usize= 0;
    // Find the total Length of the enum
    var length :usize= 0;
    for (list) |E| { length += @typeInfo(E).Enum.fields.len; }
    // Find the list of enum fields
    var fields :[length]std.builtin.Type.EnumField= undefined;
    for (list) |E| {
      const E_fields = @typeInfo(E).Enum.fields;
      for (0..E_fields.len) | id | {
        defer index += 1;
        fields[index] = .{
          .name  = name: {
            if (args.prefix) { break :name meta.typeName(E) ++ "_" ++ E_fields[id].name; }
            else             { break :name E_fields[id].name; }},
          .value = index,
        };
      }
    }
    // Return the resulting enum
    return @Type(.{.Enum= .{
      .tag_type      = std.math.IntFittingRange(0, fields.len -| 1),
      .fields        = &fields,
      .decls         = &.{},
      .is_exhaustive = true,
      }
    });
  }

  //____________________________________
  /// @descr Combines all fields of {@arg A} and {@arg B} enums into a single Enum type.
  pub fn join2(A :type, B :type) type {
    const A_fields = @typeInfo(A).Enum.fields;
    const B_fields = @typeInfo(B).Enum.fields;
    var new_fields :[A_fields.len + B_fields.len]std.builtin.Type.EnumField= undefined;
    var new_index :usize= 0;

    for (0..A_fields.len) |id| {
      defer new_index += 1;
      new_fields[new_index] = .{
        .name = A_fields[id].name,
        .value = new_index,
      };
    }

    for (0..B_fields.len) |id| {
      defer new_index += 1;
      new_fields[new_index] = .{
        .name = B_fields[id].name,
        .value = new_index,
      };
    }

    return @Type(.{.Enum= .{
      .tag_type = std.math.IntFittingRange(0, new_fields.len -| 1),
      .fields = &new_fields,
      .decls = &.{},
      .is_exhaustive = true,
      }
    });
  }
};

