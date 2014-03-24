//
//  HADBQuerayResult.h
//  Holiday&Alarm
//
//  Created by Chaos Lin on 3/24/14.
//  Copyright (c) 2014 Chaos Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HADBQueryResult : NSObject

@property (nonatomic, readonly) BOOL isQuerySucc;
@property (nonatomic, strong) NSArray* dataArray;

- (instancetype)initWithQueryState:(BOOL)isQuerySucc;
@end
