//
//  HADayObject.m
//  Holiday&Alarm
//
//  Created by Chaos Lin on 12/16/13.
//  Copyright (c) 2013 Chaos Lin. All rights reserved.
//

#import "HADayObject.h"
#import "DateUtils.h"

@implementation HADayObject

+ (NSDate*)getDateWithDateId:(NSInteger)dateId
{
    NSDate* result = nil;
    NSInteger year = dateId / 10000;
    NSInteger month = dateId % 10000 / 100;
    NSInteger day = dateId % 100;
    if (2050 < year || 1 > month || 12 < month || 1 > day || 31 < day)
    {
        //报错啥的
    }
    else
    {
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* compnents = [[NSDateComponents alloc]init];
        compnents.year = year;
        compnents.month = month;
        compnents.day = day;
        result = [calendar dateFromComponents:compnents];
    }
    return result;
}

+ (NSInteger)getDateIDWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    if (2050 < year || 1 > month || 12 < month || 1 > day || 31 < day)
    {
        return INAVLIDDATEID;
    }
    return year * 10000 + month * 100 + day;
}

+ (NSInteger)getWeekDayWithDateId:(NSInteger)dateId
{
    NSInteger result = -1;
    NSDate* date = [self getDateWithDateId:dateId];
    if (date)
    {
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitWeekday fromDate:date];
        result = components.weekday;
        result -= 1;
        if (-1 == result)
        {
            result = 7;
        }
    }
    return result;
}

+ (NSInteger)getNextDateIdWithDateId:(NSInteger)dateId
{
    return [self getDays:1 afterDateId:dateId];
}

+ (NSInteger)getDays:(NSInteger)days afterDateId:(NSInteger)dateId
{
    NSInteger result = -1 ;
    NSDate* date_thisDay = [self getDateWithDateId:dateId];
    if (date_thisDay)
    {
        NSDate* date_nextDay = [NSDate dateWithTimeInterval:days * 24 * 60 * 60 sinceDate:date_thisDay];
        result = [DateUtils getDayIdWithDate:date_nextDay];
    }
    return result;
}
@end
