//
//  HAAlarmScheduler.h
//  Holiday&Alarm
//
//  Created by Chaos Lin on 12/16/13.
//  Copyright (c) 2013 Chaos Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HAAlarmScheduler : NSObject

+ (instancetype)sharedInstance;
- (BOOL)schedulAlarmWithDateID:(NSInteger)dateID situationId:(NSInteger)situationId;
- (BOOL)cancelAlarmOnDateID:(NSInteger)dateID;
- (BOOL)changeAlarmsForSituationID:(NSInteger)situationId;
- (BOOL)cancelAllLocalNotifications;

@end
