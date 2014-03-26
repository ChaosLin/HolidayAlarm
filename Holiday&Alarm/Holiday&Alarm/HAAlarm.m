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
#define k_keyTitle @"k_keyTitle"
#define k_keySid @"k_keySid"

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.alarmId = [aDecoder decodeIntegerForKey:k_keyId];
        self.str_name = [aDecoder decodeObjectForKey:k_keyName];
        self.hour = [aDecoder decodeIntegerForKey:k_keyHour];
        self.minitue = [aDecoder decodeIntegerForKey:k_keyMinute];
        self.str_alarm = [aDecoder decodeObjectForKey:k_keyAlarm];
        self.str_title = [aDecoder decodeObjectForKey:k_keyTitle];
        self.situationId = [aDecoder decodeIntegerForKey:k_keySid];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.alarmId forKey:k_keyId];
    [aCoder encodeObject:self.str_name forKey:k_keyName];
    [aCoder encodeInteger:self.hour forKey:k_keyHour];
    [aCoder encodeInteger:self.minitue forKey:k_keyMinute];
    [aCoder encodeObject:self.str_title forKey:k_keyTitle];
    [aCoder encodeObject:self.str_alarm forKey:k_keyAlarm];
    [aCoder encodeInteger:self.situationId forKey:k_keySid];
}


+ (instancetype)parseFromDictionary:(NSDictionary*)dic_info
{
    if (!dic_info || ![dic_info isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    HAAlarm* alarm = [[HAAlarm alloc]init];
    alarm.alarmId = [[dic_info valueForKey:@"id"] integerValue];
    alarm.str_name = [dic_info valueForKey:@"description"];
    alarm.hour = [[dic_info valueForKey:@"hour"] integerValue];
    alarm.minitue = [[dic_info valueForKey:@"min"] integerValue];
    alarm.str_title = [dic_info valueForKey:@"title"];
    alarm.str_alarm = [dic_info valueForKey:@"message"];
    alarm.situationId = [[dic_info valueForKey:@"sid"] integerValue];
    return alarm;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@ id:%d sid:%d name:%@ message:%@ hour:%d miniute:%d", self.class, self.alarmId, self.situationId, self.str_name, self.str_alarm, self.hour, self.minitue];
}
@end
