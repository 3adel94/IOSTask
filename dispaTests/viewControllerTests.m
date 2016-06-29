//
//  viewControllerTests.m
//  dispa
//
//  Created by Ahmed Adel  on 6/29/16.
//  Copyright © 2016 Ahmed Adel . All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface viewControllerTests : XCTestCase
@property (nonatomic) ViewController *vcToTest;
@end

@implementation viewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.vcToTest = [[ViewController  alloc] init];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testExample {
//    // This is an example of a functional test case.
//    // Use XCTAssert and related functions to verify your tests produce the correct results.
//}
//
//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
