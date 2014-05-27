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

+ (instancetype)sharedInstance;
- (void)scheduleDateID:(NSInteger)dateID withSituation:(NSInteger)situationID;

- (void)scheduleNextTenDays;

//得转成枚举类型比较好吧。
- (NSInteger)getSituationIDForDayID:(NSInteger)dayID;
@end
