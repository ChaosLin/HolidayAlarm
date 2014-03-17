//
//  HACommonMacros.h
//  Holiday&Alarm
//
//  Created by Chaos Lin on 12/17/13.
//  Copyright (c) 2013 Chaos Lin. All rights reserved.
//

#ifndef Holiday_Alarm_HACommonMacros_h
#define Holiday_Alarm_HACommonMacros_h



#endif

#ifdef DEBUG
#define DLog(format, ...) NSLog(format,## __VA_ARGS__)
#else
#define DLog(format, ...)
#endif