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

#define fileName_calendarManager @"Calendar.plist"

@interface HACalendarManager()
@property (nonatomic, strong) NSMutableDictionary* dic_dayId2situationId;
@end

@implementation HACalendarManager
+ (id)sharedInstance
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
    for (NSInteger i = 1; i <= 10; i++)
    {
        NSInteger dateId_new = [HADayObject getDays:i afterDateId:dateId_today];
        NSInteger weekday = [HADayObject getWeekDayWithDateId:dateId_new];
        NSInteger situationId = [[self.dic_dayId2situationId valueForKey:[NSString stringWithFormat:@"%ld", (long)dateId_new]] integerValue];
        if (situationId)
        {
            [[HAAlarmScheduler sharedInstance] schedulAlarmWithDateID:dateId_new situationId:situationId];
            NSLog(@"schedule %ld with situation %ld", (long)dateId_new, (long)situationId);
        }
        else
        {
            if (1 <= weekday && weekday <= 5)
            {
                [[HAAlarmScheduler sharedInstance] schedulAlarmWithDateID:dateId_new situationId:SITUATION_WEEKDAY];
                NSLog(@"schedule %ld with situation %d", (long)dateId_new, SITUATION_WEEKDAY);
            }
            else
            {
                [[HAAlarmScheduler sharedInstance] schedulAlarmWithDateID:dateId_new situationId:SITUATION_HOLIDAY];
                NSLog(@"schedule %ld with situation %d", (long)dateId_new, SITUATION_HOLIDAY);
            }
        }
    }
}


#pragma mark - SuperClass
- (BOOL)load
{
    id dataTemp = nil;
    BOOL result = [self unarchieveFromFileToData:&dataTemp];
    if (result && [dataTemp isKindOfClass:[NSDictionary class]])
    {
        self.dic_dayId2situationId = [NSMutableDictionary dictionaryWithDictionary:dataTemp];
    }
    return result;
}

- (BOOL)save
{
    return [self archieveToFileWithData:self.dic_dayId2situationId];
}
@end