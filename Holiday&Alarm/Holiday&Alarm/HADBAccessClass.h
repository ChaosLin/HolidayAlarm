//
//  HADBAccessClass.h
//  Holiday&Alarm
//
//  Created by Renton Lin on 2/27/14.
//  Copyright (c) 2014 Chaos Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HADBQueryResult;
@interface HADBAccessClass : NSObject

+ (instancetype)sharedInstance;
+ (void)destroy;

- (BOOL)setDataBaseFullPath:(NSString*)path;

- (HADBQueryResult*)queryMessage:(NSString*)message,...;

- (BOOL)updateMessage:(NSString*)message,...;

@end
