//
//  DateUtils.h
//  Holiday&Alarm
//
//  Created by Chaos Lin on 2/25/14.
//  Copyright (c) 2014 Chaos Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject

//Calculate with year, month and day;
+ (NSInteger)numberOfDaysInYear:(NSInteger)year month:(NSInteger)month;

+ (BOOL)isLeapYearForYear:(NSInteger)year;

//Calculate with NSDate object;
//
+ (NSInteger)getDayIdWithDate:(NSDate*)date;
+ (NSDate*)getDateWithDayId:(NSInteger)dayId;
+ (NSInteger)getDayIdWithDays:(NSInteger)days afterDayId:(NSInteger)dateId_origin;
@end
