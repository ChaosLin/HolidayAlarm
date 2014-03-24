//
//  HADBQuerayResult.m
//  Holiday&Alarm
//
//  Created by Chaos Lin on 3/24/14.
//  Copyright (c) 2014 Chaos Lin. All rights reserved.
//

#import "HADBQueryResult.h"

@implementation HADBQueryResult

- (instancetype)initWithQueryState:(BOOL)isQuerySucc
{
    if (self = [super init])
    {
        _isQuerySucc = isQuerySucc;
    }
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@ isQuerySucc:%d arr:%@", NSStringFromClass(self.class), self.isQuerySucc, self.dataArray];
}
@end
