//
//  HADBAccessClassHelper.m
//  Holiday&Alarm
//
//  Created by Renton Lin on 2/28/14.
//  Copyright (c) 2014 Chaos Lin. All rights reserved.
//

#import "HADBAccessClassHelper.h"
#import "HADBAccessClass.h"
#import "HASituation.h"
#import "HAAlarm.h"

#define DataBaseName @"HA.db"
#define DataBaseFullPath [NSTemporaryDirectory() stringByAppendingPathComponent:DataBaseName]

@interface HADBAccessClassHelper()
- (BOOL)initDataBaseTables;
@end

@implementation HADBAccessClassHelper

- (id)init
{
    if (self = [super init])
    {
        [self setDataBaseFullPath:DataBaseFullPath];
        //init Database tables;
        BOOL flag_initDB = [self initDataBaseTables];
        if (!flag_initDB)
        {
            NSAssert(0, @"Init DB failed");
        }
    }
    return self;
}

- (BOOL)initDataBaseTables
{
    BOOL result = YES;
    BOOL result_createSituation = [self updateMessage:@"create table if not exists situation(id integer primary key autoincrement, description text)"];
    BOOL result_createCalendar = [self updateMessage:@"create table if not exists calendar(id integer primary key autoincrement, dayid integer not null, sid integer not null)"];
    BOOL result_alarm = [self updateMessage:@"create table if not exists alarm(id integer primary key autoincrement, description text, title text, message text, sid integer, hour integer, min integer)"];
    result = result_createSituation && result_createCalendar && result_alarm;
    return result;
}

- (NSArray*)querySituationDB
{
    return [self queryMessage:@"select * from situation"];
}

- (BOOL)addSituation:(HASituation*)situation{
    return [self updateMessage:@"insert into situation (id, description) values (?,?)", @(situation.id_situation), situation.str_name];
}

- (BOOL)deleteSituation:(HASituation*)situation
{
    return [self updateMessage:@"delete from situation where id = ?", @(situation.id_situation)];
}

- (BOOL)updateSituation:(HASituation*)situation
{
    return [self updateMessage:@"update situation set description = ? where id = ?", situation.str_name, @(situation.id_situation)];
}

#pragma mark - Alarm;
- (NSArray*)queryAlarmDB
{
    return [self queryMessage:@"select * from alarm"];
}
- (BOOL)addAlarm:(HAAlarm*)alarm
{
    return [self updateMessage:@"insert into alarm (id, description, hour, min, message, title, sid) values (?,?,?,?,?,?,?)", @(alarm.alarmId), alarm.str_name, @(alarm.hour), @(alarm.minitue), alarm.str_alarm, alarm.str_title, @(alarm.situationId)];
}
- (BOOL)deleteAlarm:(HAAlarm*)alarm
{
    return [self updateMessage:@"delete from alarm where id = ?", @(alarm.alarmId)];
}
- (BOOL)updateAlarm:(HAAlarm*)alarm
{
    return [self updateMessage:@"update alarm set description=?, hour=?, min=?, message=?, title=?, sid=? where id=?", alarm.str_name, @(alarm.hour), @(alarm.minitue), alarm.str_alarm, alarm.str_title, @(alarm.situationId), @(alarm.alarmId)];
}

#pragma mark - Calendar
- (NSArray*)queryCalendarDB
{
    return [self queryMessage:@"select * from calendar"];
}

- (BOOL)addSituationID:(NSInteger)sid forDayId:(NSInteger)dayId
{
    return [self updateMessage:@"insert into calendar (dayid, sid) values(?,?)", @(dayId), @(sid)];
}

- (BOOL)deleteDayId:(NSInteger)dayId
{
    return [self updateMessage:@"delete from calendar where dayid = ?", @(dayId)];
}

- (BOOL)updateDayId:(NSInteger)dayId withSituationId:(NSInteger)sid
{
    return [self updateMessage:@"update calendar set sid = ? where dayId = ?", @(sid), @(dayId)];
}
@end
