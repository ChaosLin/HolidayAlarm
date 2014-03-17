//
//  HACalendarObject.h
//  Holiday&Alarm
//
//  Created by Chaos Lin on 12/16/13.
//  Copyright (c) 2013 Chaos Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HASaveAndLoadClass.h"

@class HASituation;

@interface HACalendarManager : HASaveAndLoadClass

+ (id)sharedInstance;
- (void)scheduleDateID:(NSInteger)dateID withSituation:(NSInteger)situationID;

- (void)scheduleNextTenDays;
@end
