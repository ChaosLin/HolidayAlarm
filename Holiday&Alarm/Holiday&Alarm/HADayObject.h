//
//  HADayObject.h
//  Holiday&Alarm
//
//  Created by Chaos Lin on 12/16/13.
//  Copyright (c) 2013 Chaos Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef INAVLIDDATEID
#define INAVLIDDATEID -1
#endif
@interface HADayObject : NSObject

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;

+ (NSDate*)getDateWithDateId:(NSInteger)dateId;
+ (NSInteger)getDateIDWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSInteger)getNextDateIdWithDateId:(NSInteger)dateId;
+ (NSInteger)getDays:(NSInteger)days afterDateId:(NSInteger)dateId;
@end
