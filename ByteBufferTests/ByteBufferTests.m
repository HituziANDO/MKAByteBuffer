//
//  ByteBufferTests.m
//  ByteBufferTests
//
//  Created by Masaki Ando on 2019/01/05.
//  Copyright © 2019年 Hituzi Ando. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ByteBuffer.h"

@interface ByteBufferTests : XCTestCase

@property (nonatomic) BYTByteBuffer *byteBuffer;

@end

@implementation ByteBufferTests

static const NSUInteger kDefaultCapacity = 256;

- (void)setUp {
    [super setUp];

    self.byteBuffer = [BYTByteBuffer allocateWithCapacity:kDefaultCapacity];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

// Can't use `init` initializer.
- (void)testInit {
    XCTAssertThrows([[BYTByteBuffer alloc] init]);
}

- (void)testCapacity {
    XCTAssertEqual(kDefaultCapacity, self.byteBuffer.capacity);
}

- (void)testPosition {
    [[[self.byteBuffer putData:[@"a" dataUsingEncoding:NSASCIIStringEncoding]]
                       putData:[@"b" dataUsingEncoding:NSASCIIStringEncoding]]
                       putData:[@"c" dataUsingEncoding:NSASCIIStringEncoding]];

    XCTAssertEqual(self.byteBuffer.position, 3);
}

- (void)testRemaining {
    [[self.byteBuffer putData:[@"a" dataUsingEncoding:NSASCIIStringEncoding]]
                      putData:[@"b" dataUsingEncoding:NSASCIIStringEncoding]];

    XCTAssertEqual(kDefaultCapacity - 2, self.byteBuffer.remaining);
}

- (void)testHasRemaining {
    XCTAssertTrue(self.byteBuffer.hasRemaining);

    NSData *a = [@"a" dataUsingEncoding:NSASCIIStringEncoding];

    for (NSInteger i = 0; i < kDefaultCapacity; i++) {
        [self.byteBuffer putData:a];
    }

    XCTAssertFalse(self.byteBuffer.hasRemaining);
}

- (void)testPutUTF8String {
    [[self.byteBuffer putUTF8String:@"abc"]
                      putUTF8String:@"def"];

    XCTAssertEqual(6, self.byteBuffer.position);
    NSString *str = [[NSString alloc] initWithData:self.byteBuffer.buffer encoding:NSUTF8StringEncoding];
    XCTAssertTrue([str hasPrefix:@"abcdef"]);
}

- (void)testPutData {
    NSData *a = [@"a" dataUsingEncoding:NSASCIIStringEncoding];

    for (NSInteger i = 0; i < kDefaultCapacity; i++) {
        [self.byteBuffer putData:a];
    }

    // Overflow exception
    XCTAssertThrows([self.byteBuffer putData:a]);
}

- (void)testGetInteger {
    [[[self.byteBuffer putInteger:2019]
                       putInteger:-300]
                       putInteger:12345];

    [self.byteBuffer flip];

    XCTAssertEqual(2019, [self.byteBuffer getInteger]);
    XCTAssertEqual(-300, [self.byteBuffer getInteger]);
    XCTAssertEqual(12345, [self.byteBuffer getInteger]);
}

- (void)testGetUInteger {
    [[[self.byteBuffer putUInteger:2019]
                       putUInteger:300]
                       putUInteger:12345];

    [self.byteBuffer flip];

    XCTAssertEqual(2019, [self.byteBuffer getUInteger]);
    XCTAssertEqual(300, [self.byteBuffer getUInteger]);
    XCTAssertEqual(12345, [self.byteBuffer getUInteger]);
}

- (void)testGetShort {
    [[[self.byteBuffer putShort:5]
                       putShort:-3]
                       putShort:1];

    [self.byteBuffer flip];

    XCTAssertEqual(5, [self.byteBuffer getShort]);
    XCTAssertEqual(-3, [self.byteBuffer getShort]);
    XCTAssertEqual(1, [self.byteBuffer getShort]);
}

- (void)testGetInt8 {
    [[[self.byteBuffer putInt8:55]
                       putInt8:-3]
                       putInt8:1];

    [self.byteBuffer flip];

    XCTAssertEqual(55, [self.byteBuffer getInt8]);
    XCTAssertEqual(-3, [self.byteBuffer getInt8]);
    XCTAssertEqual(1, [self.byteBuffer getInt8]);
}

- (void)testGetUInt8 {
    [[[self.byteBuffer putUInt8:5]
                       putUInt8:33]
                       putUInt8:1];

    [self.byteBuffer flip];

    XCTAssertEqual(5, [self.byteBuffer getUInt8]);
    XCTAssertEqual(33, [self.byteBuffer getUInt8]);
    XCTAssertEqual(1, [self.byteBuffer getUInt8]);
}

- (void)testGetInt16 {
    [[[self.byteBuffer putInt16:32000]
                       putInt16:-32000]
                       putInt16:1];

    [self.byteBuffer flip];

    XCTAssertEqual(32000, [self.byteBuffer getInt16]);
    XCTAssertEqual(-32000, [self.byteBuffer getInt16]);
    XCTAssertEqual(1, [self.byteBuffer getInt16]);
}

- (void)testGetUInt16 {
    [[[self.byteBuffer putUInt16:32000]
                       putUInt16:64000]
                       putUInt16:1];

    [self.byteBuffer flip];

    XCTAssertEqual(32000, [self.byteBuffer getUInt16]);
    XCTAssertEqual(64000, [self.byteBuffer getUInt16]);
    XCTAssertEqual(1, [self.byteBuffer getUInt16]);
}

- (void)testGetInt32 {
    [[[self.byteBuffer putInt32:2100000000]
                       putInt32:-2100000000]
                       putInt32:1];

    [self.byteBuffer flip];

    XCTAssertEqual(2100000000, [self.byteBuffer getInt32]);
    XCTAssertEqual(-2100000000, [self.byteBuffer getInt32]);
    XCTAssertEqual(1, [self.byteBuffer getInt32]);
}

- (void)testGetUInt32 {
    [[[self.byteBuffer putUInt32:2100000000]
                       putUInt32:4200000000]
                       putUInt32:1];

    [self.byteBuffer flip];

    XCTAssertEqual(2100000000, [self.byteBuffer getUInt32]);
    XCTAssertEqual(4200000000, [self.byteBuffer getUInt32]);
    XCTAssertEqual(1, [self.byteBuffer getUInt32]);
}

- (void)testGetInt64 {
    [[[self.byteBuffer putInt64:9000000000000000000]
                       putInt64:-9000000000000000000]
                       putInt64:1];

    [self.byteBuffer flip];

    XCTAssertEqual(9000000000000000000, [self.byteBuffer getInt64]);
    XCTAssertEqual(-9000000000000000000, [self.byteBuffer getInt64]);
    XCTAssertEqual(1, [self.byteBuffer getInt64]);
}

- (void)testGetUInt64 {
    [[[self.byteBuffer putUInt64:9000000000000000000]
                       putUInt64:18000000000000000000]
                       putUInt64:1];

    [self.byteBuffer flip];

    XCTAssertEqual(9000000000000000000, [self.byteBuffer getUInt64]);
    XCTAssertEqual(18000000000000000000, [self.byteBuffer getUInt64]);
    XCTAssertEqual(1, [self.byteBuffer getUInt64]);
}

- (void)testGetInt {
    [[[self.byteBuffer putInt:2019]
                       putInt:-300]
                       putInt:12345];

    [self.byteBuffer flip];

    XCTAssertEqual(2019, [self.byteBuffer getInt]);
    XCTAssertEqual(-300, [self.byteBuffer getInt]);
    XCTAssertEqual(12345, [self.byteBuffer getInt]);
}

- (void)testGetUInt {
    [[[self.byteBuffer putUInt:2019]
                       putUInt:300]
                       putUInt:12345];

    [self.byteBuffer flip];

    XCTAssertEqual(2019, [self.byteBuffer getUInt]);
    XCTAssertEqual(300, [self.byteBuffer getUInt]);
    XCTAssertEqual(12345, [self.byteBuffer getUInt]);
}

- (void)testGetLong {
    [[[self.byteBuffer putLong:2019L]
                       putLong:300000000L]
                       putLong:12345L];

    [self.byteBuffer flip];

    XCTAssertEqual(2019L, [self.byteBuffer getLong]);
    XCTAssertEqual(300000000L, [self.byteBuffer getLong]);
    XCTAssertEqual(12345L, [self.byteBuffer getLong]);
}

- (void)testGetLongLong {
    [[[self.byteBuffer putLongLong:2019LL]
                       putLongLong:300000000000LL]
                       putLongLong:12345LL];

    [self.byteBuffer flip];

    XCTAssertEqual(2019LL, [self.byteBuffer getLongLong]);
    XCTAssertEqual(300000000000LL, [self.byteBuffer getLongLong]);
    XCTAssertEqual(12345LL, [self.byteBuffer getLongLong]);
}

- (void)testGetFloat {
    [[[self.byteBuffer putFloat:2019.1f]
                       putFloat:-300.123f]
                       putFloat:12345.6789f];

    [self.byteBuffer flip];

    XCTAssertEqual(2019.1f, [self.byteBuffer getFloat]);
    XCTAssertEqual(-300.123f, [self.byteBuffer getFloat]);
    XCTAssertEqual(12345.6789f, [self.byteBuffer getFloat]);
}

- (void)testGetDouble {
    [[[self.byteBuffer putDouble:2019.1]
                       putDouble:-300.123]
                       putDouble:12345.6789];

    [self.byteBuffer flip];

    XCTAssertEqual(2019.1, [self.byteBuffer getDouble]);
    XCTAssertEqual(-300.123, [self.byteBuffer getDouble]);
    XCTAssertEqual(12345.6789, [self.byteBuffer getDouble]);
}

- (void)testGetData {
    [[[self.byteBuffer putData:[@"a" dataUsingEncoding:NSASCIIStringEncoding]]
                       putData:[@"b" dataUsingEncoding:NSASCIIStringEncoding]]
                       putData:[@"c" dataUsingEncoding:NSASCIIStringEncoding]];

    [self.byteBuffer flip];

    NSString *a = [[NSString alloc] initWithData:[self.byteBuffer getData] encoding:NSASCIIStringEncoding];
    XCTAssertEqualObjects(@"a", a);
    XCTAssertEqual(1, self.byteBuffer.position);

    NSString *b = [[NSString alloc] initWithData:[self.byteBuffer getData] encoding:NSASCIIStringEncoding];
    XCTAssertEqualObjects(@"b", b);
    XCTAssertEqual(2, self.byteBuffer.position);

    NSString *c = [[NSString alloc] initWithData:[self.byteBuffer getData] encoding:NSASCIIStringEncoding];
    XCTAssertEqualObjects(@"c", c);
    XCTAssertEqual(3, self.byteBuffer.position);
}

- (void)testFlip {
    [[[self.byteBuffer putData:[@"a" dataUsingEncoding:NSASCIIStringEncoding]]
                       putData:[@"b" dataUsingEncoding:NSASCIIStringEncoding]]
                       putData:[@"c" dataUsingEncoding:NSASCIIStringEncoding]];

    [self.byteBuffer flip];

    XCTAssertEqual(0, self.byteBuffer.position);
    XCTAssertEqual(3, self.byteBuffer.limit);
}

- (void)testRewind {
    [[[self.byteBuffer putData:[@"a" dataUsingEncoding:NSASCIIStringEncoding]]
                       putData:[@"b" dataUsingEncoding:NSASCIIStringEncoding]]
                       putData:[@"c" dataUsingEncoding:NSASCIIStringEncoding]];

    [self.byteBuffer flip];

    [self.byteBuffer getData];  // => a, position = 1
    [self.byteBuffer getData];  // => b, position = 2

    [self.byteBuffer rewind];

    XCTAssertEqual(0, self.byteBuffer.position);
}

- (void)testClear {
    [[[self.byteBuffer putData:[@"a" dataUsingEncoding:NSASCIIStringEncoding]]
                       putData:[@"b" dataUsingEncoding:NSASCIIStringEncoding]]
                       putData:[@"c" dataUsingEncoding:NSASCIIStringEncoding]];

    [self.byteBuffer flip];
    [self.byteBuffer clear];

    XCTAssertEqual(0, self.byteBuffer.position);
    XCTAssertEqual(kDefaultCapacity, self.byteBuffer.limit);
}

- (void)testCompact {
    [[[[[self.byteBuffer putData:[@"a" dataUsingEncoding:NSASCIIStringEncoding]]
                         putData:[@"b" dataUsingEncoding:NSASCIIStringEncoding]]
                         putData:[@"c" dataUsingEncoding:NSASCIIStringEncoding]]
                         putData:[@"d" dataUsingEncoding:NSASCIIStringEncoding]]
                         putData:[@"e" dataUsingEncoding:NSASCIIStringEncoding]];

    [self.byteBuffer flip];

    [self.byteBuffer getData];  // => a
    [self.byteBuffer getData];  // => b

    [self.byteBuffer compact];

    XCTAssertEqual(3, self.byteBuffer.position);
    XCTAssertEqual(kDefaultCapacity, self.byteBuffer.limit);
    NSString *str = [[NSString alloc] initWithData:self.byteBuffer.buffer encoding:NSASCIIStringEncoding];
    XCTAssertTrue([str hasPrefix:@"cde"]);
}

@end
