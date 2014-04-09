//
//  HASituationManager.h
//  Holiday&Alarm
//
//  Created by Chaos Lin on 12/16/13.
//  Copyright (c) 2013 Chaos Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HASaveAndLoadClass.h"

@class HASituation;
@class HAAlarm;
#ifndef SITUATION_WEEKDAY
#define SITUATION_WEEKDAY 1
#endif
#ifndef SITUATION_HOLIDAY
#define SITUATION_HOLIDAY 2
#endif

@interface HASituationManager : HASaveAndLoadClass

+ (id)sharedInstance;

- (HASituation*)getWeekDaySituation;
- (HASituation*)getCommonHolidaySituation;
- (HASituation*)getSituationWithID:(NSInteger)situationID;

- (BOOL)addSituation:(HASituation*)situation;
//暂时先不使用这两个方法，这两个方法从设计上并不是很好
//- (BOOL)updateSituationWithSituation:(HASituation*)situation toSituationId:(NSInteger)situationID;
//- (BOOL)setSituationWithID:(NSInteger)situationId withAlarams:(NSArray*)alarms;
- (BOOL)addAlarm:(HAAlarm*)alarm forSituationID:(NSInteger)situationId;
- (BOOL)deleteAlarm:(HAAlarm*)alarm forSituationID:(NSInteger)situationId;
- (BOOL)updateALarm:(HAAlarm*)alarm forSituationID:(NSInteger)situationId;
@end
