//
//  HAAlarm.h
//  Holiday&Alarm
//
//  Created by Chaos Lin on 12/16/13.
//  Copyright (c) 2013 Chaos Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HAAlarm : NSObject<NSCoding>

@property (nonatomic, assign) NSInteger alarmId;
@property (nonatomic, strong) NSString* str_name;//描述，比如起床闹铃
@property (nonatomic, assign) NSInteger hour;//[0~23]
@property (nonatomic, assign) NSInteger minitue;//[0~59]
@property (nonatomic, strong) NSString* str_alarm;//notification的时候的文字
@property (nonatomic, strong) NSString* str_title;
@property (nonatomic, assign) NSInteger situationId;
@end
