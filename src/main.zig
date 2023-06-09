const std = @import("std");

const EnvPair = @import("env-pair.zig").EnvPair;
const next = @import("env-reader.zig").next;

const testing = std.testing;








test "open test file simple key" {
    const file =
        try std.fs.cwd().openFile("test-files/sample.env", . {});
    defer file.close() ;

    var key =  [_]u8{0} ** 32768;
      var value =  [_]u8{0} ** 32768; //still learning. want to create a big buffer for max size

        var pair = EnvPair {
            .key=key,
            .value = value
        };

    nextKey(file.reader(),&pair) catch |x| {
        return x;
    };
           std.debug.print("Output:  {s}={s} \n", .{pair.key,pair.value});
               try std.testing.expect(std.mem.eql(u8,pair.key[0..5] , "alpha"));
}