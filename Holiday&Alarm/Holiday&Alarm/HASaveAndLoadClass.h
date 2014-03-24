//
//  HASaveAndLoadClass.h
//  Holiday&Alarm
//
//  Created by Chaos Lin on 12/16/13.
//  Copyright (c) 2013 Chaos Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HASaveAndLoadClass : NSObject

@property (nonatomic, strong) NSString* str_filePath;
//- (BOOL)archieveToFileWithData:(id)data;
//- (BOOL)unarchieveFromFileToData:(id*)data;

- (BOOL)load;
- (BOOL)save;
@end
