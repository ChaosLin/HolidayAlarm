//
//  HAAlarm.m
//  Holiday&Alarm
//
//  Created by Chaos Lin on 12/16/13.
//  Copyright (c) 2013 Chaos Lin. All rights reserved.
//

#import "HAAlarm.h"

@implementation HAAlarm

#define k_keyId @"k_keyId"
#define k_keyName @"k_keyName"
#define k_keyHour @"k_keyHour"
#define k_keyMinute @"k_keyMinute"
#define k_keyAlarm @"k_keyAlarm"

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.alarmId = [aDecoder decodeIntegerForKey:k_keyId];
        self.str_name = [aDecoder decodeObjectForKey:k_keyName];
        self.hour = [aDecoder decodeIntegerForKey:k_keyHour];
        self.minitue = [aDecoder decodeIntegerForKey:k_keyMinute];
        self.str_alarm = [aDecoder decodeObjectForKey:k_keyAlarm];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.alarmId forKey:k_keyId];
    [aCoder encodeObject:self.str_name forKey:k_keyName];
    [aCoder encodeInteger:self.hour forKey:k_keyHour];
    [aCoder encodeInteger:self.minitue forKey:k_keyMinute];
    [aCoder encodeObject:self.str_alarm forKey:k_keyAlarm];
}
@end
