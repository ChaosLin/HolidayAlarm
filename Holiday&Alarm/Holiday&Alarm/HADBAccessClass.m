//
//  HADBAccessClass.m
//  Holiday&Alarm
//
//  Created by Renton Lin on 2/27/14.
//  Copyright (c) 2014 Chaos Lin. All rights reserved.
//

#import "HADBAccessClass.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "HADBQueryResult.h"

@interface HADBAccessClass()
@property (nonatomic, strong) FMDatabaseQueue* queue;
@end

@implementation HADBAccessClass

static HADBAccessClass* global_DBO = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        global_DBO = self.new;
    });
    return global_DBO;
}

+ (void)destroy
{
    global_DBO = nil;
}

- (void)dealloc
{
    if (self.queue)
    {
        [self.queue close];
    }
}

- (BOOL)setDataBaseFullPath:(NSString*)path
{
    self.queue = [FMDatabaseQueue databaseQueueWithPath:path];
    return self.queue?YES:NO;
}

- (HADBQueryResult*)queryMessage:(NSString*)message,...
{
    __block HADBQueryResult* result;
    NSAssert(self.queue, @"You should provide a valid dataBasePath");
    NSMutableArray* arr_result = [NSMutableArray arrayWithCapacity:100];
    va_list args;
    va_start(args, message);
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet* set_result = [db executeQuery:message withVAList:args];
#ifdef DEBUG
        if (!set_result)
        {
            NSLog(@"%@ failed\nerror: %@", message, [db lastErrorMessage]);
        }
#endif
        BOOL flag_succ = set_result?YES:NO;
        result = [[HADBQueryResult alloc]initWithQueryState:flag_succ];
        
        while ([set_result next]) {
            NSDictionary* dic_row = [set_result resultDictionary];
            if (dic_row)
            {
                [arr_result addObject:dic_row];
            }
        }
    }];
    va_end(args);
    result.dataArray = arr_result;
    return result;
}

- (BOOL)updateMessage:(NSString*)message,...
{
    NSAssert(self.queue, @"You should provide a valid dataBasePath");
    __block BOOL result = NO;
    va_list args;
    va_start(args, message);
    [self.queue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:message withVAList:args];
#ifdef DEBUG
        if (!result)
        {
            NSLog(@"%@ failed\nerror: %@", message, [db lastErrorMessage]);
        }
#endif
    }];
    va_end(args);
    return result;
}

@end
