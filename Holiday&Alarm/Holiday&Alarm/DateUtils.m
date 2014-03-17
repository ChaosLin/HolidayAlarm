//
//  DateUtils.m
//  Holiday&Alarm
//
//  Created by Chaos Lin on 2/25/14.
//  Copyright (c) 2014 Chaos Lin. All rights reserved.
//

#import "DateUtils.h"
#import <time.h>
@interface DateUtils()

+ (struct tm*)getTimeStructWithDate:(NSDate*)date;
+ (BOOL)isUsingDayLightSavingFlag;
+ (struct tm*)getCurrentTm;
+ (struct tm*)getTempTm;//生成一个今天的0点0分0秒的时间
+ (NSDate*)getDateWithTm:(struct tm*) timeM;
+ (NSInteger)getDayIdWithTm:(struct tm*)timeM;
@end

@implementation DateUtils

#pragma mark - Year,month,day
+ (NSInteger)numberOfDaysInYear:(NSInteger)year month:(NSInteger)month
{
    static NSInteger days[]={31,28,31,30,31,30,31,31,30,31,30,31};
    if (0 > month || 12 < month)
    {
        return -1;
    }
    else
    {
        NSInteger numberOfDay = days[month - 1];
        if (2 == month)
        {
            if ([self isLeapYearForYear:year])
            {
                numberOfDay = 29;
            }
        }
        return numberOfDay;
    }
}

+ (BOOL)isLeapYearForYear:(NSInteger)year
{
    BOOL isLeap = NO;
    if (0 != year % 4)
    {
        isLeap = NO;
    }
    else
    {
        if (0 == year % 400)
        {
            isLeap = YES;
        }
        else
        {
            isLeap = NO;
        }
    }
    return isLeap;
}

#pragma mark - Struct tm
+ (BOOL)isUsingDayLightSavingFlag
{
    struct tm* tm_now = [self getCurrentTm];
    BOOL result = tm_now->tm_isdst?YES:NO;
    return result;
}

+ (struct tm*)getCurrentTm
{
    time_t time_now = time(NULL);
    struct tm* tm_now = localtime(&time_now);
    return tm_now;
}

+ (struct tm*)getTempTm
{
    time_t time_now = time(NULL);
    struct tm* tm_now = localtime(&time_now);
    tm_now->tm_hour = 0;
    tm_now->tm_min = 0;
    tm_now->tm_sec = 0;
    return tm_now;
}

+ (struct tm*)getTimeStructWithDate:(NSDate*)date
{
    long timeInterval = (long)[date timeIntervalSince1970];
    time_t time = timeInterval;
    struct tm* result;
    result = localtime(&time);
    return result;
}

+ (NSDate*)getDateWithTm:(struct tm*) timeM
{
    time_t time = mktime(timeM);
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:(long)time];
    return date;
}

+ (NSInteger)getDayIdWithTm:(struct tm*)timeM
{
    int year = timeM->tm_year + 1900;
    int month = timeM->tm_mon + 1;
    int day = timeM->tm_mday;
    return 10000* year + month * 100 + day;
}
#pragma mark - NSDate
+ (NSInteger)getDayIdWithDate:(NSDate*)date
{
    struct tm* dateStruct = [self getTimeStructWithDate:date];
    NSInteger year = dateStruct->tm_year + 1900;
    NSInteger month = dateStruct->tm_mon + 1;
    NSInteger day = dateStruct->tm_mday;
    
    NSInteger result = year * 10000 + month * 100 + day;
    return result;
}

+ (NSDate*)getDateWithDayId:(NSInteger)dayId
{
    NSInteger year = dayId / 10000 - 1900;
    NSInteger month = dayId % 10000 / 100 - 1;
    NSInteger day = dayId % 100;
    struct tm* time_temp = [self getTempTm];
    time_temp->tm_year = (int)year;
    time_temp->tm_mon = (int)month;
    time_temp->tm_mday = (int)day;
    return [self getDateWithTm:time_temp];
}

+ (NSInteger)getDayIdWithDays:(NSInteger)days afterDayId:(NSInteger)dateId_origin
{
    NSInteger year = dateId_origin / 10000 - 1900;
    NSInteger month = dateId_origin % 10000 / 100 - 1;
    NSInteger day = dateId_origin % 100;
    struct tm* tm_new = [self getTempTm];
    tm_new->tm_year = (int)year;
    tm_new->tm_mon = (int)month;
    tm_new->tm_mday = (int)day + (int)days;
    return [self getDayIdWithTm:tm_new];
}
@end
