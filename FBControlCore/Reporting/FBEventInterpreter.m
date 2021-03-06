/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBEventInterpreter.h"
#import "FBSubject.h"
#import "FBJSONEnums.h"

@implementation FBBaseEventInterpreter

- (NSArray<NSString *> *)interpret:(FBEventReporterSubject *)eventReporterSubject
{
  NSMutableArray *results = [[NSMutableArray alloc] init];
  for (id item in eventReporterSubject.subSubjects) {
    if ([item isKindOfClass:[NSArray class]]) {
      for (id innerItem in item) {
        NSString *toAdd = [self getStringFromEventReporterSubject:innerItem];
        if (toAdd) {
          [results addObject:toAdd];
        }
      }
    } else {
      NSString *toAdd = [self getStringFromEventReporterSubject:item];
      if (toAdd) {
        [results addObject:toAdd];
      }
    }
  }

  return results;
}

- (nullable NSString *)getStringFromEventReporterSubject:(nonnull FBEventReporterSubject *)subject
{
  NSAssert(NO, @"-[%@ %@] is abstract and should be overridden", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
  return nil;
}

@end


@implementation FBJSONEventInterpreter

- (instancetype)initWithPrettyFormatting:(BOOL)pretty
{
  self = [super init];

  if (!self) {
    return nil;
  }

  _pretty = pretty;

  return self;
}

- (nullable NSString *)getStringFromEventReporterSubject:(nonnull FBEventReporterSubject *)subject
{
  NSDictionary *dict = [subject jsonSerializableRepresentation];

  //Check it has an eventName string
  if (![dict objectForKey:FBJSONKeyEventName]) {
    NSAssert(NO, ([NSString stringWithFormat:@"%@ does not have a %@", subject, FBJSONKeyEventName]));
    return nil;
  }

  //Check it has an eventType string
  if (![dict objectForKey:FBJSONKeyEventType]) {
    NSAssert(NO, ([NSString stringWithFormat:@"%@ does not have a %@", subject, FBJSONKeyEventType]));
    return nil;
  }

  NSJSONWritingOptions writingOptions = self.pretty ? NSJSONWritingPrettyPrinted : 0;
  NSError *error = nil;

  NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:writingOptions error:&error];
  NSString *serialized = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

  if (error) {
    NSAssert(NO, ([NSString stringWithFormat:@"Failed to Serialize %@ to string: %@", dict, error]));
    return nil;
  }

  return serialized;
}

@end


@implementation FBHumanReadableEventInterpreter

- (nullable NSString *)getStringFromEventReporterSubject:(nonnull FBEventReporterSubject *)subject
{
  return subject.description;
}

@end
