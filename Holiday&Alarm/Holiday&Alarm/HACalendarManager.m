//
//  HACalendarObject.m
//  Holiday&Alarm
//
//  Created by Chaos Lin on 12/16/13.
//  Copyright (c) 2013 Chaos Lin. All rights reserved.
//

#import "HACalendarManager.h"
#import "HASituationManager.h"
#import "HAAlarmScheduler.h"
#import "HADayObject.h"
#import "DateUtils.h"
#import "HADBAccessClassHelper.h"
#import "HADBQueryResult.h"

#define fileName_calendarManager @"Calendar.plist"

@interface HACalendarManager()
@property (nonatomic, strong) NSMutableDictionary* dic_dayId2situationId;
@end

@implementation HACalendarManager
+ (instancetype)sharedInstance
{
    static HACalendarManager* calendarManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendarManager = [[HACalendarManager alloc]init];
        calendarManager.str_filePath = fileName_calendarManager;
        [calendarManager load];
    });
    return calendarManager;
}

- (id)init
{
    if (self = [super init])
    {
        self.dic_dayId2situationId = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)scheduleDateID:(NSInteger)dateID withSituation:(NSInteger)situationID
{
    HAAlarmScheduler* alarmScheduler = [HAAlarmScheduler sharedInstance];
    if ([alarmScheduler schedulAlarmWithDateID:dateID situationId:situationID])
    {
        [self.dic_dayId2situationId setValue:[NSString stringWithFormat:@"%ld", (long)situationID] forKey:[NSString stringWithFormat:@"%ld", (long)dateID]];
    }
}

- (void)scheduleNextTenDays
{
    NSDate* date_today = [NSDate date];
    NSInteger dateId_today = [DateUtils getDayIdWithDate:date_today];
    [(HAAlarmScheduler*)[HAAlarmScheduler sharedInstance] cancelAllLocalNotifications];
    for (NSInteger i = 0; i <= 10; i++)
    {
        NSInteger dateId_new = [HADayObject getDays:i afterDateId:dateId_today];
        BOOL isWeekend = [DateUtils isWeekendWithDayID:dateId_new];
        NSInteger situationId = [[self.dic_dayId2situationId valueForKey:[NSString stringWithFormat:@"%ld", (long)dateId_new]] integerValue];
        if (situationId)
        {
            [[HAAlarmScheduler sharedInstance] schedulAlarmWithDateID:dateId_new situationId:situationId];
            DLog(@"schedule %ld with situation %ld", (long)dateId_new, (long)situationId);
        }
        else
        {
            if (!isWeekend)
            {
                [[HAAlarmScheduler sharedInstance] schedulAlarmWithDateID:dateId_new situationId:SITUATION_WEEKDAY];
                DLog(@"schedule %ld with situation %d", (long)dateId_new, SITUATION_WEEKDAY);
            }
            else
            {
                [[HAAlarmScheduler sharedInstance] schedulAlarmWithDateID:dateId_new situationId:SITUATION_HOLIDAY];
                DLog(@"schedule %ld with situation %d", (long)dateId_new, SITUATION_HOLIDAY);
            }
        }
    }
}

- (NSInteger)getSituationIDForDayID:(NSInteger)dayID
{
    NSInteger ID_situation = 0;
    id situationId = [self.dic_dayId2situationId valueForKey:[NSString stringWithFormat:@"%d", dayID]];
    if (situationId)
    {
        ID_situation = [situationId integerValue];
    }
    else
    {
        if (![DateUtils isWeekendWithDayID:dayID])
        {
            ID_situation = SITUATION_WEEKDAY;
        }
        else
        {
            ID_situation = SITUATION_HOLIDAY;
        }
    }
    return ID_situation;
}

#pragma mark - SuperClass
- (BOOL)load
{
    BOOL result = YES;
    self.dic_dayId2situationId = [NSMutableDictionary dictionary];
    HADBAccessClassHelper* dbHelper = [HADBAccessClassHelper sharedInstance];
    HADBQueryResult* result_query = [dbHelper queryCalendarDB];
    if (result_query.isQuerySucc)
    {
        for (NSDictionary* dic_info in result_query.dataArray)
        {
            id id_sid = [dic_info valueForKey:@"sid"];
            id id_dayid = [dic_info valueForKey:@"dayid"];
            if (id_sid && id_dayid)
            {
                [self.dic_dayId2situationId setValue:id_sid forKey:[NSString stringWithFormat:@"%@", id_dayid]];
            }
        }
    }
    result = result_query.isQuerySucc;
    return result;
}

- (BOOL)save
{
    return YES;//[self archieveToFileWithData:self.dic_dayId2situationId];
}
@end