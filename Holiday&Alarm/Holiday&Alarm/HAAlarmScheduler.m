//
//  HAAlarmScheduler.m
//  Holiday&Alarm
//
//  Created by Chaos Lin on 12/16/13.
//  Copyright (c) 2013 Chaos Lin. All rights reserved.
//

#import "HAAlarmScheduler.h"
#import "HASituationManager.h"
#import "HASituation.h"
#import "HAAlarm.h"

#define key_dateId @"key_dateId"
#define key_situationId @"key_situationId"

@interface HAAlarmScheduler()
- (NSArray*)getLocalNotificationsWithDayId:(NSInteger)dayId;
- (NSArray*)getLocalNotificationsWithSituationId:(NSInteger)situationId;
- (BOOL)cancelLocalNotificationsForSituationId:(NSInteger)situationId;
- (NSDictionary*)generateUserInfoWithDateId:(NSInteger)dateId situationId:(NSInteger)situationId;
- (NSArray*)getAllLocalNotifications;
- (BOOL)scheduleAlarm:(HAAlarm*)alarm forDateId:(NSInteger)dateId situationId:(NSInteger)situationId;
@end

@implementation HAAlarmScheduler

+ (instancetype)sharedInstance
{
    static HAAlarmScheduler* alarmScheduler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alarmScheduler = [[HAAlarmScheduler alloc]init];
    });
    return alarmScheduler;
}

- (BOOL)schedulAlarmWithDateID:(NSInteger)dateID situationId:(NSInteger)situationId
{
    BOOL result = YES;
#warning 也许一天能有几种模式
    [self cancelAlarmOnDateID:dateID];
    HASituation* situation = [[HASituationManager sharedInstance] getSituationWithID:situationId];
    if (!situation)
    {
        result = NO;
    }
    else
    {
        NSArray* arr_alarms = situation.arr_alarms;
        for (HAAlarm* alarm in arr_alarms)
        {
            [self scheduleAlarm:alarm forDateId:dateID situationId:situationId];
        }
    }
    return result;
}

- (BOOL)cancelAlarmOnDateID:(NSInteger)dateID
{
    BOOL result = YES;
    NSMutableArray* arr_allNotifications = [NSMutableArray arrayWithArray:[self getAllLocalNotifications]];
    NSArray* arr_notificationForDateId = [self getLocalNotificationsWithDayId:dateID];
    [arr_allNotifications removeObjectsInArray:arr_notificationForDateId];
    //重设localnotification队列
    [UIApplication sharedApplication].scheduledLocalNotifications = arr_allNotifications;
    return result;
}

- (BOOL)cancelAllLocalNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    return YES;
}

- (BOOL)changeAlarmsForSituationID:(NSInteger)situationId
{
    const NSInteger max = 100;
    NSInteger a[max];
    NSInteger index = 0;
    NSArray* arr_notificationForSituationId = [self getLocalNotificationsWithSituationId:situationId];
    BOOL alreadyInArray = NO;
    for (UILocalNotification* notification in arr_notificationForSituationId)
    {
        NSInteger id_date = [[notification.userInfo valueForKey:key_dateId] integerValue];
        alreadyInArray = NO;
        for (NSInteger i = 0; i < index; i++)
        {
            if (a[i] == id_date)
            {
                alreadyInArray = YES;
                break;
            }
        }
        if (!alreadyInArray)
        {
            a[index] = id_date;
            index ++;
        }
    }
#warning 多遍历了一遍
    [self cancelLocalNotificationsForSituationId:situationId];
    for (NSInteger i = 0; i < index; i++)
    {
        NSInteger id_date = a[i];
        [self schedulAlarmWithDateID:id_date situationId:situationId];
    }
    return YES;
}

#pragma mark - private
- (NSArray*)getLocalNotificationsWithDayId:(NSInteger)dayId
{
    NSMutableArray* arr_return = [NSMutableArray array];
    NSArray* arr_allNotifications = [self getAllLocalNotifications];
    for (UILocalNotification* notification in arr_allNotifications)
    {
        if (dayId == [[notification.userInfo valueForKey:key_dateId] integerValue])
        {
            [arr_return addObject:notification];
        }
    }
    return arr_return;
}

- (NSArray*)getLocalNotificationsWithSituationId:(NSInteger)situationId
{
    NSMutableArray* arr_return = [NSMutableArray array];
    NSArray* arr_allNotifications = [self getAllLocalNotifications];
    for (UILocalNotification* notification in arr_allNotifications)
    {
        if (situationId == [[notification.userInfo valueForKey:key_situationId] integerValue])
        {
            [arr_return addObject:notification];
        }
    }
    return arr_return;
}

- (BOOL)cancelLocalNotificationsForSituationId:(NSInteger)situationId
{
    BOOL result = YES;
    NSMutableArray* arr_allNotifications = [NSMutableArray arrayWithArray:[self getAllLocalNotifications]];
    NSArray* arr_notificationForSituationId = [self getLocalNotificationsWithSituationId:situationId];
    [arr_allNotifications removeObjectsInArray:arr_notificationForSituationId];
    [UIApplication sharedApplication].scheduledLocalNotifications = arr_allNotifications;
    return result;
}

- (NSDictionary*)generateUserInfoWithDateId:(NSInteger)dateId situationId:(NSInteger)situationId
{
    return @{key_dateId:@(dateId), key_situationId:@(situationId)};
}

- (NSArray*)getAllLocalNotifications
{
    return [UIApplication sharedApplication].scheduledLocalNotifications;
}

- (BOOL)scheduleAlarm:(HAAlarm*)alarm forDateId:(NSInteger)dateId situationId:(NSInteger)situationId
{
    UILocalNotification* notification = [[UILocalNotification alloc]init];
    notification.timeZone = [NSTimeZone localTimeZone];
    notification.alertBody = alarm.str_alarm;
    NSDateFormatter* formatter = NSDateFormatter.new;
    formatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
//    NSString* str_date = @"2013-12-10-07-49-00";
    NSInteger year = dateId / 10000;
    NSInteger month = dateId % 10000 / 100;
    NSInteger day = dateId % 100;
    NSString* str_date = [NSString stringWithFormat:@"%04ld-%02ld-%02ld-%02ld-%02ld-00", (long)year, (long)month, (long)day, (long)alarm.hour, (long)alarm.minitue];
    NSDate* date_fire = [formatter dateFromString:str_date];
    notification.fireDate = date_fire;
    notification.userInfo = @{key_dateId:@(dateId), key_situationId:@(situationId)};

    notification.soundName = @"三星优美闹钟铃声.caf";
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    return YES;
}
@end
