//
//  HADBAccessClassHelper.h
//  Holiday&Alarm
//
//  Created by Renton Lin on 2/28/14.
//  Copyright (c) 2014 Chaos Lin. All rights reserved.
//

#import "HADBAccessClass.h"
@class HASituation;
@class HACalendarManager;
@class HAAlarm;
@interface HADBAccessClassHelper : HADBAccessClass

- (NSArray*)querySituationDB;
- (BOOL)addSituation:(HASituation*)situation;
- (BOOL)deleteSituation:(HASituation*)situation;
- (BOOL)updateSituation:(HASituation*)situation;

- (NSArray*)queryAlarmDB;
- (BOOL)addAlarm:(HAAlarm*)alarm;
- (BOOL)deleteAlarm:(HAAlarm*)alarm;
- (BOOL)updateAlarm:(HAAlarm*)alarm;

- (NSArray*)queryCalendarDB;
- (BOOL)addSituationID:(NSInteger)sid forDayId:(NSInteger)dayId;
- (BOOL)deleteDayId:(NSInteger)dayId;
- (BOOL)updateDayId:(NSInteger)dayId withSituationId:(NSInteger)sid;

@end
