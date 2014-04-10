//
//  HASituation.m
//  Holiday&Alarm
//
//  Created by Chaos Lin on 12/16/13.
//  Copyright (c) 2013 Chaos Lin. All rights reserved.
//

#import "HASituation.h"
#import "HAAlarm.h"
#import "HADBAccessClassHelper.h"

@interface HASituation()
@property (nonatomic, strong) NSMutableArray* arr_alarms;

@end

@implementation HASituation

#define k_keySituationID @"k_keySituationID"
#define k_keyName   @"k_keyName"
#define k_keyArrAlarms @"k_keyArrAlarms"

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.id_situation = [aDecoder decodeIntegerForKey:k_keySituationID];
        self.str_name = [aDecoder decodeObjectForKey:k_keyName];
#warning 这种情况下这个数组还会是mutable的么?
        self.arr_alarms = [aDecoder decodeObjectForKey:k_keyArrAlarms];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.id_situation forKey:k_keySituationID];
    [aCoder encodeObject:self.str_name forKey:k_keyName];
    [aCoder encodeObject:self.arr_alarms forKey:k_keyArrAlarms];
}

- (id)init
{
    if (self = [super init])
    {
        self.arr_alarms = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (BOOL)updateWithAlarms:(NSArray*)alarms
{
    BOOL isAlarmsValid = YES;
    if (!alarms || ![alarms isKindOfClass:[NSArray class]])
    {
        isAlarmsValid = NO;
    }
    else
    {
        for (NSInteger i = 0; i < alarms.count; i++)
        {
            HAAlarm* alarm = [alarms objectAtIndex:i];
            if (![alarm isKindOfClass:[HAAlarm class]])
            {
                isAlarmsValid = NO;
                break;
            }
        }
    }
    if (isAlarmsValid)
    {
        self.arr_alarms = [NSMutableArray arrayWithArray:alarms];
    }
    if (!isAlarmsValid)
    {
        DLog(@"%@ %@ %d",  NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
    }
    return isAlarmsValid;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@ id:%d name:%@ alarms:%@", [self class], self.id_situation, self.str_name, self.arr_alarms];
}

#warning 如果同一个alarm添加到两个不同的situation里面会出问题
- (BOOL)addAlarm:(HAAlarm*)alarm
{
    BOOL result = YES;
    BOOL alarmIDExsited = NO;
    for (HAAlarm* alarm_temp in self.arr_alarms)
    {
        if (alarm_temp.alarmId == alarm.alarmId)
        {
            alarmIDExsited = YES;
            break;
        }
    }
    if (alarmIDExsited)
    {
        result = NO;
    }
    else
    {
        alarm.situationId = self.id_situation;
        [(NSMutableArray*)self.arr_alarms addObject:alarm];
        result = [[HADBAccessClassHelper sharedInstance] addAlarm:alarm];
    }
    NSAssert(result, nil);
    return result;
}

- (BOOL)deleteAlarm:(HAAlarm*)alarm
{
    BOOL result = YES;
    BOOL alarmIDExsited = NO;
    HAAlarm* alarm_toRemove = nil;
    for (HAAlarm* alarm_temp in self.arr_alarms)
    {
        if (alarm_temp.alarmId == alarm.alarmId)
        {
            alarmIDExsited = YES;
            alarm_toRemove = alarm_temp;
            break;
        }
    }
    if (!alarmIDExsited)
    {
        result = NO;
    }
    else
    {
        [(NSMutableArray*)self.arr_alarms removeObject:alarm_toRemove];
        result = [[HADBAccessClassHelper sharedInstance] deleteAlarm:alarm_toRemove];
    }
    NSAssert(result, nil);
    return result;
}

- (BOOL)updateAlarm:(HAAlarm*)alarm
{
    BOOL result = YES;
    NSInteger index = -1;
    for (NSInteger i = 0; i < self.arr_alarms.count; i++)
    {
        HAAlarm* alarm_temp = [self.arr_alarms objectAtIndex:i];
        if (alarm_temp.alarmId == alarm.alarmId)
        {
            index = i;
            break;
        }
    }
    if (-1 == index)
    {
        result = NO;
    }
    else
    {
        [(NSMutableArray*)self.arr_alarms replaceObjectAtIndex:index withObject:alarm];
        result = [[HADBAccessClassHelper sharedInstance] updateAlarm:alarm];
    }
    NSAssert(result, nil);
    return result;
}
@end
