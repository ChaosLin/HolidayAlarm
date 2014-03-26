//
//  HASituationManager.m
//  Holiday&Alarm
//
//  Created by Chaos Lin on 12/16/13.
//  Copyright (c) 2013 Chaos Lin. All rights reserved.
//

#import "HASituationManager.h"
#import "HASituation.h"
#import "HAAlarm.h"
#import "HAAlarmScheduler.h"
#import "HADBQueryResult.h"
#import "HADBAccessClassHelper.h"
#define fileName_situationManager @"SituationManager.plist"

@interface HASituationManager()
@property (nonatomic, strong) NSMutableArray* arr_situations;
@end
@implementation HASituationManager

+ (id)sharedInstance
{
    static HASituationManager* situationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        situationManager = [[HASituationManager alloc]init];
        situationManager.str_filePath = fileName_situationManager;
        BOOL result = [situationManager load];
        NSAssert(result, nil);
    });
    return situationManager;
}

- (id)init
{
    if (self = [super init])
    {
        self.arr_situations = [NSMutableArray array];
    }
    return self;
}

- (HASituation*)getWeekDaySituation
{
    return [self getSituationWithID:SITUATION_WEEKDAY];
}

- (HASituation*)getCommonHolidaySituation
{
    return [self getSituationWithID:SITUATION_HOLIDAY];
}

- (HASituation*)getSituationWithID:(NSInteger)situationID
{
    HASituation* situation = nil;
    for (HASituation* situation_iter in self.arr_situations)
    {
        if (situation_iter.id_situation == situationID)
        {
            situation = situation_iter;
            break;
        }
    }
    return situation;
}

- (BOOL)updateSituationWithSituation:(HASituation*)situation toSituationId:(NSInteger)situationID
{
    BOOL result = YES;
    if (situationID != situation.id_situation)
    {
        NSAssert(0, nil);
        result = NO;
    }
    else
    {
        if ([situation isKindOfClass:[HASituation class]])
        {
            //必须存在才能更新
            HASituation* situation_temp = [self getSituationWithID:situationID];
            if (situation_temp)
            {
                [self.arr_situations removeObject:situation_temp];
                [self addSituation:situation];
            }
            else
            {
                result = NO;
                NSAssert(0, nil);
            }
        }
    }
    if (result)
    {
        [[HAAlarmScheduler sharedInstance] changeAlarmsForSituationID:situationID];
    }
    return result;
}

- (BOOL)addSituation:(HASituation*)situation
{
    BOOL result = YES;
    if ([situation isKindOfClass:[HASituation class]])
    {
        //id不能重复
#warning 直接找一个没有用的id去做为id就行
        HASituation* situation_temp = [self getSituationWithID:situation.id_situation];
        if (!situation_temp)
        {
            [self.arr_situations addObject:situation];
        }
        else
        {
            result = NO;
            DLog(@"Add situation error: the situation id is already used");
        }
    }
    return result;
}

- (BOOL)setSituationWithID:(NSInteger)situationId withAlarams:(NSArray*)alarms
{
    BOOL result = YES;
    
    HASituation* situation = [self getSituationWithID:situationId];
    if (!situation)
    {
        result = NO;
    }
    else
    {
        //检验alarms
        result = [situation updateWithAlarms:alarms];
    }
    return result;
}

#pragma mark - superClass
- (BOOL)load
{
    HADBQueryResult* result_situation= [[HADBAccessClassHelper sharedInstance] querySituationDB];
    HADBQueryResult* result_alarms = [[HADBAccessClassHelper sharedInstance] queryAlarmDB];
    //
    BOOL result = result_situation.isQuerySucc && result_situation.isQuerySucc;
    if (result)
    {
        //得到alarms
        NSArray* arr_alarms_raw = result_alarms.dataArray;
        NSMutableArray* arr_alarms_parsed = [NSMutableArray arrayWithCapacity:100];
        for (NSDictionary* info in arr_alarms_raw)
        {
            HAAlarm* alarm = [HAAlarm parseFromDictionary:info];
            if (alarm)
            {
                [arr_alarms_parsed addObject:alarm];
            }
            NSAssert(0 != alarm.alarmId, nil);
        }
        
        //得到situations
        NSArray* arr_situations_raw = result_situation.dataArray;
        NSMutableArray* arr_situations_parsed = [NSMutableArray arrayWithCapacity:10];
        for (NSDictionary* info in arr_situations_raw)
        {
            HASituation* situation = [[HASituation alloc]init];
            situation.id_situation = [[info valueForKey:@"id"] integerValue];
            situation.str_name = [info valueForKey:@"description"];
            [arr_situations_parsed addObject:situation];
        }
        
        //根据alarm的sid把alarm放进对应的situation里面
        //分组
        NSMutableDictionary* dic_sid2arr = [NSMutableDictionary dictionaryWithCapacity:10];
        for (HAAlarm* alarm in arr_alarms_parsed)
        {
            NSInteger sid = alarm.situationId;
            NSMutableArray* arr_alarms = [dic_sid2arr valueForKey:[NSString stringWithFormat:@"%d", sid]];
            if (!arr_alarms)
            {
                arr_alarms = [NSMutableArray arrayWithCapacity:10];
                [dic_sid2arr setValue:arr_alarms forKey:[NSString stringWithFormat:@"%d", sid]];
            }
            [arr_alarms addObject:alarm];
        }
        //更新进对应的situation
        NSMutableArray* arr_keys = [NSMutableArray arrayWithArray:[dic_sid2arr allKeys]];
        for (HASituation* situation in arr_situations_parsed)
        {
            NSInteger sid = situation.id_situation;
            NSArray* arr_alarms = [dic_sid2arr valueForKey:[NSString stringWithFormat:@"%d", sid]];
            if (arr_alarms)
            {
                [situation updateWithAlarms:arr_alarms];
            }
            else
            {
                [situation updateWithAlarms:[NSMutableArray array]];
            }
            [arr_keys removeObject:[NSString stringWithFormat:@"%d", sid]];
        }
        if (0 != arr_keys.count)
        {
            NSAssert(0, @"有sid不存在的alarms存在");
        }
        self.arr_situations = arr_situations_parsed;
    }
#warning 这里的初始化感觉有问题
    if (!self.arr_situations || 0 == self.arr_situations.count)
    {
        self.arr_situations = [NSMutableArray array];
        HASituation* newSituation = [[HASituation alloc]init];
        newSituation.id_situation = SITUATION_WEEKDAY;
        newSituation.str_name = @"工作日";
        HAAlarm* alarm = [[HAAlarm alloc]init];
        alarm.str_alarm = @"It's a good day~ :)";
        alarm.str_name = @"起床";
        alarm.hour = 7;
        alarm.minitue = 1;
        alarm.str_title = @"Hy";
        alarm.alarmId = 1;
        [newSituation updateWithAlarms:[NSArray arrayWithObject:alarm]];
        
        HASituation* situation_holiday = [[HASituation alloc]init];
        situation_holiday.id_situation = SITUATION_HOLIDAY;
        situation_holiday.str_name = @"假期";
        HAAlarm* alarm_holiday = [[HAAlarm alloc]init];
        alarm_holiday.str_alarm = @"It's a good day~ :)";
        alarm_holiday.str_name = @"起床";
        alarm_holiday.hour = 8;
        alarm_holiday.minitue = 20;
        alarm_holiday.str_title = @"Hy";
        alarm_holiday.alarmId = 2;
        [situation_holiday updateWithAlarms:[NSArray arrayWithObject:alarm_holiday]];
        
        [self.arr_situations addObject:newSituation];
        [self.arr_situations addObject:situation_holiday];
    }
    return result;
}

- (BOOL)save
{
    return YES;
//    return [self archieveToFileWithData:self.arr_situations];
}
@end
