/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>

#import <FBControlCore/FBControlCore.h>
#import <XCTestBootstrap/XCTestBootstrap.h>

NS_ASSUME_NONNULL_BEGIN

@class FBDevice;

/**
 An implementation of FBXCTestCommands, for Devices.
 */
@interface FBDeviceXCTestCommands : NSObject <FBXCTestCommands, FBiOSTargetCommand>


/**
 A helper method for overwriting xcTestRunProperties.
 Creates a new properties dictionary with values from baseProperties
 overwritten with values from newProperties. It overwrites values only
 for existing keys. It assumes that the dictionary has XCTestRun file
 format and that base has a single test with bundle id StubBundleId.

 @param baseProperties base properties
 @param newProperties base properties will be overwritten with newProperties
 @returns a new xcTestRunProperites with
 */
+ (NSDictionary *)overwriteXCTestRunPropertiesWithBaseProperties:(NSDictionary<NSString *, id> *)baseProperties newProperties:(NSDictionary<NSString *, id> *)newProperties;


@end

NS_ASSUME_NONNULL_END
