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
- (BOOL)updateSituationWithSituation:(HASituation*)situation toSituationId:(NSInteger)situationID;

- (BOOL)setSituationWithID:(NSInteger)situationId withAlarams:(NSArray*)alarms;
@end
