//
//  TweaksPresentationTests.m
//  TweaksPresentationTests
//
//  Created by Jarosław Pendowski on 15/08/15.
//  Copyright (c) 2015 Jarosław Pendowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSMutableArray+Queue.h"


@interface NSMutableArrayQueueTests : XCTestCase

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation NSMutableArrayQueueTests

- (void)setUp {
    [super setUp];
    self.array = [NSMutableArray array];
}

- (void)pushPop {
    
    [self.array q_push:@"A"];
    
    XCTAssertEqual(self.array.count, 1);
    XCTAssertEqualObjects([self.array q_pop], @"A");
    XCTAssertEqualObjects([self.array q_pop], nil);
    
    [self.array q_push:@"A"];
    [self.array q_push:@"B"];
    
    XCTAssertEqual(self.array.count, 2);
    XCTAssertEqualObjects([self.array q_pop], @"B");
    XCTAssertEqualObjects([self.array q_pop], @"A");
    XCTAssertEqualObjects([self.array q_pop], nil);
    
    [self.array q_push:@"A"];
    [self.array q_push:@"B"];
    [self.array addObject:@"C"];
    
    XCTAssertEqual(self.array.count, 3);
    XCTAssertEqualObjects([self.array q_pop], @"C");
    XCTAssertEqualObjects([self.array q_pop], @"B");
    XCTAssertEqualObjects([self.array q_pop], @"A");
    XCTAssertEqualObjects([self.array q_pop], nil);
    
    [self.array q_push:@"A"];
    [self.array q_push:@"B"];
    [self.array insertObject:@"C" atIndex:0];
    
    XCTAssertEqual(self.array.count, 3);
    XCTAssertEqualObjects([self.array q_pop], @"B");
    XCTAssertEqualObjects([self.array q_pop], @"A");
    XCTAssertEqualObjects([self.array q_pop], @"C");
    XCTAssertEqualObjects([self.array q_pop], nil);
}

@end
