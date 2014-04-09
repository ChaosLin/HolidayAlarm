//
//  HANotificationListViewController.m
//  Holiday&Alarm
//
//  Created by Chaos Lin on 13-12-9.
//  Copyright (c) 2013年 Chaos Lin. All rights reserved.
//

#import "HANotificationListViewController.h"
#import "HASituationManager.h"
#import "HACalendarManager.h"
#import "HASituation.h"
#import "HAAlarm.h"
#import "HADayObject.h"
#import "CXCalendarView.h"
#import "DateUtils.h"
#import "HADBAccessClassHelper.h"
#import "HADBQueryResult.h"

@interface HANotificationListViewController () <CXCalendarViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) UITableView* tableView_notifications;
@property (nonatomic, strong) CXCalendarView* calendarView;
@property (nonatomic, assign) NSInteger dateId_selected;
- (void)test;
@end

@implementation HANotificationListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    UILocalNotification* notification = [[UILocalNotification alloc]init];
//    NSDateFormatter* formatter = NSDateFormatter.new;
//    formatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
//    //    formatter.timeZone = nsloc
//    NSString* str_date = @"2013-12-10-07-49-00";
//    //    NSString* str_date = @"2013-12-08-23-51-00";
//    NSDate* date_fire = [formatter dateFromString:str_date];
////    NSDate* date_fire = [NSDate dateWithTimeIntervalSinceNow:3 * 60];
//    notification.fireDate = date_fire;
//    notification.timeZone = [NSTimeZone defaultTimeZone];
//    notification.alertBody = @"It's a good day.";
//    notification.alertAction = @"View";
//    notification.repeatInterval = NSCalendarUnitDay;
//	
//    notification.applicationIconBadgeNumber = 4;
//    notification.soundName = @"三星优美闹钟铃声.caf";
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView_notifications = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView_notifications.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView_notifications.delegate = self;
    self.tableView_notifications.dataSource = self;
    [self.view addSubview:self.tableView_notifications];
    [self test];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test
{
//    NSInteger dateId = 20131229;
//    NSDate* date = [HADayObject getDateWithDateId:dateId];
//    NSInteger dateId_new = [HADayObject getDateIDWithDate:date];
//    for (NSInteger i = 1; i <= 10; i ++)
//    {
//        NSInteger dateId_next = [HADayObject getDays:i afterDateId:dateId_new];
////        NSLog(@"%d", dateId_next);
//        NSInteger weekday = [HADayObject getWeekDayWithDateId:dateId_next];
//        NSLog(@"%d is weekday: %d", dateId_next, weekday);
//    }
//    return;

//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    HASituation* newSituation = [[HASituation alloc]init];
//    newSituation.id_situation = 4;
//    newSituation.str_name = @"临时";
//    HAAlarm* alarm = [[HAAlarm alloc]init];
//    alarm.str_alarm = @"It's a good day~ :)";
//    alarm.str_name = @"起床";
//    alarm.hour = 7;
//    alarm.minitue = 49;
//    [newSituation updateWithAlarms:[NSArray arrayWithObject:alarm]];
//
//    [[HASituationManager sharedInstance] updateSituationWithSituation:newSituation toSituationId:newSituation.id_situation];
//    [[HASituationManager sharedInstance] addSituation:newSituation];
//
//    NSInteger dateId = 20140214;
//    [[HACalendarManager sharedInstance] scheduleDateID:dateId withSituation:4];
//
//    alarm.hour = 7;
//    [[HASituationManager sharedInstance] updateSituationWithSituation:newSituation toSituationId:newSituation.id_situation];
//
    
    
//    [[HACalendarManager sharedInstance] scheduleNextTenDays];
//    
//    [self.tableView_notifications reloadData];
    
    self.calendarView = [[CXCalendarView alloc]init];
    self.calendarView.frame = self.view.bounds;
    self.calendarView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.calendarView.backgroundColor = [UIColor redColor];
    self.calendarView.calendar = [NSCalendar currentCalendar];
    [self.view addSubview:self.calendarView];
    self.calendarView.delegate = self;
    self.calendarView.selectedDate = [NSDate date];
    
    UIButton* button_switch = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_switch setBackgroundColor:[UIColor greenColor]];
    float width = 50;
    float height = 50;
    button_switch.frame = CGRectMake(self.view.bounds.size.width - width, 0, width, height);
    [self.view addSubview:button_switch];
    [button_switch addTarget:self action:@selector(switchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    HADBAccessClassHelper* helper = [HADBAccessClassHelper sharedInstance];
//    [helper updateMessage:@"delete from calendar"];
//    NSLog(@"%@", [[helper queryCalendarDB] description]);
//    [helper addSituationID:1 forDayId:2];
    NSLog(@"%@", [[helper queryCalendarDB] description]);
//    [helper updateDayId:2 withSituationId:2];
//    NSLog(@"%@", [[helper queryCalendarDB] description]);
//    [helper deleteDayId:2];
//    NSLog(@"%@", [[helper queryCalendarDB] description]);
//    [helper updateMessage:@"delete from alarm"];
//    NSLog(@"%@", [helper queryAlarmDB]);
//    HAAlarm* alarm = [[HAAlarm alloc]init];
//    alarm.alarmId = 100;
//    alarm.str_title = @"t_title";
//    alarm.str_name = @"t_name";
//    alarm.str_alarm = @"t_message";
//    alarm.situationId = 2;
//    alarm.hour = 8;
//    alarm.minitue = 20;
//    [helper addAlarm:alarm];
//    NSLog(@"%@", [helper queryAlarmDB]);
//    alarm.hour = 10;
//    [helper updateAlarm:alarm];
//    NSLog(@"%@", [helper queryAlarmDB]);
//    [helper deleteAlarm:alarm];
    NSLog(@"%@", [helper queryAlarmDB]);
    
    HASituation* situation_week = [[HASituationManager sharedInstance] getWeekDaySituation];
    //update
    NSArray* arr_alarms = situation_week.arr_alarms;
    HAAlarm* alarm = [arr_alarms firstObject];
    alarm.hour = 6;
    alarm.minitue = 31;
    [situation_week updateAlarm:alarm];
    
    //add
//    HAAlarm* alarm_temp = [[HAAlarm alloc]init];
//    alarm_temp.hour = 10;
//    alarm_temp.minitue = 1;
//    alarm_temp.alarmId = 10;
//    [situation_week addAlarm:alarm_temp];
    
    //delete
//    NSArray* arr_alarms = situation_week.arr_alarms;
//    HAAlarm* alarm_temp = [arr_alarms lastObject];
//    [situation_week deleteAlarm:alarm_temp];
    
    [[HACalendarManager sharedInstance] scheduleNextTenDays];
    [self.tableView_notifications reloadData];
    
//    [HADBAccessClassHelper destroy];
}

- (IBAction)switchButtonClicked:(id)sender
{
    self.calendarView.hidden = !self.calendarView.isHidden;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[UIApplication sharedApplication].scheduledLocalNotifications count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell"];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notificationCell"];
    }
    NSInteger row = indexPath.row;
    NSArray* arr_notifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    if (arr_notifications.count <= row)
    {
        cell.textLabel.text = @"error out of index";
    }
    else{
        UILocalNotification* notification = [arr_notifications objectAtIndex:row];
        NSDate* date = notification.fireDate;
        NSDateFormatter* formatter = NSDateFormatter.new;
        formatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
        NSString* str_text = [formatter stringFromDate:date];
        cell.textLabel.text = str_text;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - CXCalendarViewDelegate
- (void) calendarView: (CXCalendarView *) calendarView
        didSelectDate: (NSDate *) selectedDate
{
    self.dateId_selected = [DateUtils getDayIdWithDate:selectedDate];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"选择样式" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"工作日", @"假期", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 != buttonIndex)
    {
        NSInteger situationId = 0;
        switch (buttonIndex) {
            case 1:
            {
                situationId = SITUATION_WEEKDAY;
            }
                break;
             case 2:
            {
                situationId = SITUATION_HOLIDAY;
            }
                break;
            default:
                break;
        }
        if (0 != situationId)
        {
            [[HACalendarManager sharedInstance] scheduleDateID:self.dateId_selected withSituation:situationId];
        }
    }
    [[HACalendarManager sharedInstance] scheduleNextTenDays];
    [self.tableView_notifications reloadData];
}
@end
