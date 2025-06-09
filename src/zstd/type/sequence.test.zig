//:____________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
// @deps std
const std = @import("std");
// @deps tests
const t  = @import("minitest");
const it = t.it;
const A  = std.testing.allocator;
// @deps zstd
const string = @import("./sequence.zig").string;


var  String = t.title("string");
test String { String.begin(); defer String.end();

try it("must initialize/allocate to a seq of characters with the expected values without errors.", struct {fn f()!void {
  const Expected = "SomeString";
  var data = try string.create(Expected, A);
  defer data.destroy();
  const result = data.data();
  try t.eq_str(result, Expected);
}}.f);

try it("must add a list of items to a string without errors.", struct {fn f()!void {
  const Initial  = "SomeString";
  const Input    = "1234";
  const Expected = Initial++Input;
  var data = try string.create(Initial, A);
  defer data.destroy();
  try data.add(Input);
  const result = data.data();
  try t.eq_str(result, Expected);
}}.f);

try it("must return true when calling .contains if the string includes that item", struct {fn f()!void {
  const Expected = true;
  const Initial  = "SomeString";
  const Input    = "1234";
  var data = try string.create(Initial, A);
  defer data.destroy();
  try data.add(Input);
  const result = data.contains('4');
  try t.eq(result, Expected);
}}.f);

try it("must return false when calling .contains if the string does not include that item", struct {fn f()!void {
  const Expected = false;
  const Initial  = "SomeString";
  const Input    = "1234";
  var data = try string.create(Initial, A);
  defer data.destroy();
  try data.add(Input);
  const result = data.contains('5');
  try t.eq(result, Expected);
}}.f);

} //:: string

