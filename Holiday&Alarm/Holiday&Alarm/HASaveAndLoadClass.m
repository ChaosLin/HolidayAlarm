//
//  HASaveAndLoadClass.m
//  Holiday&Alarm
//
//  Created by Chaos Lin on 12/16/13.
//  Copyright (c) 2013 Chaos Lin. All rights reserved.
//

#import "HASaveAndLoadClass.h"

@implementation HASaveAndLoadClass

//- (BOOL)archieveToFileWithData:(id)data
//{
//    BOOL result = NO;
//    if (!self.str_filePath || ![self.str_filePath isKindOfClass:[NSString class]])
//    {
//        result = NO;
//    }
//    else
//    {
//        NSString* str_fullPath = [NSTemporaryDirectory() stringByAppendingPathComponent:self.str_filePath];
//        result = [NSKeyedArchiver archiveRootObject:data toFile:str_fullPath];
//    }
//    if (!result)
//    {
//        DLog(@"%@ %@ %d",  NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
//    }
//    return result;
//}
//
//- (BOOL)unarchieveFromFileToData:(id*)data
//{
//    BOOL result = NO;
//    if (!self.str_filePath || ![self.str_filePath isKindOfClass:[NSString class]])
//    {
//        result = NO;
//    }
//    else
//    {
//        NSString* str_fullPath = [NSTemporaryDirectory() stringByAppendingPathComponent:self.str_filePath];
//        if ([[NSFileManager defaultManager] fileExistsAtPath:str_fullPath])
//        {
//            id data_result = [NSKeyedUnarchiver unarchiveObjectWithFile:str_fullPath];
//            if (data_result)
//            {
//                *data = data_result;
//                result = YES;
//            }
//        }
//    }
//    if (!result)
//    {
//        DLog(@"%@ %@ %d",  NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
//    }
//    return result;
//}

#pragma mark - 由子类去实现的方法
- (BOOL)save
{
    return YES;
}

- (BOOL)load
{
    return NO;
}
@end
