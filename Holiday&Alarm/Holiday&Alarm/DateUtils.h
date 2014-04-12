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

#pragma mark - Transform
//Calculate with NSDate object;
+ (NSInteger)getDayIdWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
//NSDate->20140412
+ (NSInteger)getDayIdWithDate:(NSDate*)date;
//20140412->NSDate
+ (NSDate*)getDateWithDayId:(NSInteger)dayId;
//20140412 2 -> 20140414
+ (NSInteger)getDayIdWithDays:(NSInteger)days afterDayId:(NSInteger)dateId_origin;
//20140412 -> 6
//discussion:Return -1 when the dayId is not correct;
+ (NSInteger)getWeekDayWithDayId:(NSInteger)dayId;

#pragma mark - CalendarView
//20140412 -> 2 [0 ~ 5]
+ (NSInteger)getRowWithDayId:(NSInteger)dayId;
//20140412 -> 7 [0 ~ 6]
+ (NSInteger)getVolumeWithDayId:(NSInteger)dayId;
@end
