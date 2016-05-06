/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <XCTest/XCTest.h>

#import <XCTestBootstrap/XCTestBootstrap.h>

#import <FBSimulatorControl/FBSimulatorControl.h>

#import "CoreSimulatorDoubles.h"
#import "FBSimulatorControlTestCase.h"
#import "FBSimulatorPoolTestCase.h"
#import "FBSimulatorControlFixtures.h"
#import "FBSimulatorControlAssertions.h"

@interface FBSimulatorTestInjection : FBSimulatorControlTestCase <FBTestManagerTestReporter>

@property (nonatomic, strong, readwrite) NSMutableSet *passedMethods;
@property (nonatomic, strong, readwrite) NSMutableSet *failedMethods;

@end

@implementation FBSimulatorTestInjection

#pragma mark Lifecycle

- (void)setUp
{
  [super setUp];
  self.passedMethods = [NSMutableSet set];
  self.failedMethods = [NSMutableSet set];
}

#pragma mark Tests

- (void)testInjectsApplicationTestIntoSampleApp
{
  FBSimulator *simulator = [self obtainBootedSimulator];
  id<FBInteraction> interaction = [[simulator.interact
    installApplication:self.tableSearchApplication]
    startTestRunnerLaunchConfiguration:self.tableSearchAppLaunch testBundlePath:self.applicationTestBundlePath reporter:self];

  [self assertInteractionSuccessful:interaction];
  [self assertPassed:@[@"testIsRunningOnIOS"] failed:@[@"testIsRunningOnMacOSX", @"testIsSafari"]];

}

- (void)testInjectsApplicationTestIntoSafari
{
  FBSimulator *simulator = [self obtainBootedSimulator];
  id<FBInteraction> interaction = [simulator.interact
    startTestRunnerLaunchConfiguration:self.safariAppLaunch testBundlePath:self.applicationTestBundlePath reporter:self];

  [self assertInteractionSuccessful:interaction];
  [self assertPassed:@[@"testIsRunningOnIOS", @"testIsSafari"] failed:@[@"testIsRunningOnMacOSX"]];
}

- (void)assertPassed:(NSArray<NSString *> *)passed failed:(NSArray<NSString *> *)failed
{
  BOOL success = [NSRunLoop.currentRunLoop spinRunLoopWithTimeout:FBControlCoreGlobalConfiguration.regularTimeout untilTrue:^BOOL{
    return [self.passedMethods isEqualToSet:[NSSet setWithArray:passed]];
  }];
  XCTAssertTrue(success);
  success = [NSRunLoop.currentRunLoop spinRunLoopWithTimeout:FBControlCoreGlobalConfiguration.fastTimeout untilTrue:^BOOL{
    return [self.failedMethods isEqualToSet:[NSSet setWithArray:failed]];
  }];
  XCTAssertTrue(success);
}

#pragma mark FBTestManagerTestReporter

- (void)testManagerMediatorDidBeginExecutingTestPlan:(FBTestManagerAPIMediator *)mediator
{

}

- (void)testManagerMediator:(FBTestManagerAPIMediator *)mediator testSuite:(NSString *)testSuite didStartAt:(NSString *)startTime
{

}

- (void)testManagerMediator:(FBTestManagerAPIMediator *)mediator testCaseDidFinishForTestClass:(NSString *)testClass method:(NSString *)method withStatus:(NSString *)status duration:(NSNumber *)duration
{
  if ([status isEqualToString:@"passed"]) {
    [self.passedMethods addObject:method];
  } else if ([status isEqualToString:@"failed"]) {
    [self.failedMethods addObject:method];
  }
}

- (void)testCaseDidFailForTestClass:(NSString *)testClass method:(NSString *)method withMessage:(NSString *)message file:(NSString *)file line:(NSNumber *)line
{

}

- (void)testManagerMediator:(FBTestManagerAPIMediator *)mediator testBundleReadyWithProtocolVersion:(NSNumber *)protocolVersion minimumVersion:(NSNumber *)minimumVersion
{

}

- (void)testManagerMediator:(FBTestManagerAPIMediator *)mediator testCaseDidStartForTestClass:(NSString *)testClass method:(NSString *)method
{
}

- (void)testManagerMediator:(FBTestManagerAPIMediator *)mediator testSuite:(NSString *)testSuite didFinishAt:(NSString *)finishTime runCount:(NSNumber *)runCount withFailures:(NSNumber *)failuresCount unexpected:(NSNumber *)unexpectedFailureCount testDuration:(NSNumber *)testDuration totalDuration:(NSNumber *)totalDuration
{

}

- (void)testManagerMediatorDidFinishExecutingTestPlan:(FBTestManagerAPIMediator *)mediator
{

}

@end