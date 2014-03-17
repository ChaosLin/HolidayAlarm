//
//  HASituation.h
//  Holiday&Alarm
//
//  Created by Chaos Lin on 12/16/13.
//  Copyright (c) 2013 Chaos Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef SITUATION_WEEKDAY
#define SITUATION_WEEKDAY 1
#endif
#ifndef SITUATION_HOLIDAY
#define SITUATION_HOLIDAY 2
#endif

@interface HASituation : NSObject<NSCoding>
@property (nonatomic, assign) NSInteger id_situation;
@property (nonatomic, strong) NSString* str_name;
@property (nonatomic, readonly) NSArray* arr_alarms;

- (BOOL)updateWithAlarms:(NSArray*)alarms;
@end