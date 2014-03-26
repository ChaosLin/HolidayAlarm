//
//  HASituation.m
//  Holiday&Alarm
//
//  Created by Chaos Lin on 12/16/13.
//  Copyright (c) 2013 Chaos Lin. All rights reserved.
//

#import "HASituation.h"
#import "HAAlarm.h"

@interface HASituation()
@property (nonatomic, strong) NSMutableArray* arr_alarms;

@end

@implementation HASituation

//@property (nonatomic, assign) NSInteger id_situation;
//@property (nonatomic, strong) NSString* str_name;
//@property (nonatomic, strong) NSArray* arr_alarms;

#define k_keySituationID @"k_keySituationID"
#define k_keyName   @"k_keyName"
#define k_keyArrAlarms @"k_keyArrAlarms"

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.id_situation = [aDecoder decodeIntegerForKey:k_keySituationID];
        self.str_name = [aDecoder decodeObjectForKey:k_keyName];
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
@end
