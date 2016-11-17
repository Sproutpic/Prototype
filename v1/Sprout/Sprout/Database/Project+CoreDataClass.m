//
//  Project+CoreDataClass.m
//  Sprout
//
//  Created by Jeff Morris on 10/22/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "Project+CoreDataClass.h"
#import "Timeline+CoreDataClass.h"
#import "DataObjects.h"
#import "JDMLocalNotification.h"
#import "ProjectWebService.h"
#import "CoreDataAccessKit.h"

@implementation Project

# pragma mark Private

- (NSCalendarUnit)calendarUnitForRepeatFrequency
{
    switch ([[self repeatFrequency] integerValue]) {
        case RF_Daily: return NSCalendarUnitDay;
        case RF_Weekly: return NSCalendarUnitWeekday;
        case RF_BiWeekly: return NSCalendarUnitWeekday;
        case RF_Monthly: return NSCalendarUnitMonth;
        case RF_Every_Hour: return NSCalendarUnitHour;
        default: return NSCalendarUnitDay;
    }
}

- (UILocalNotification*)createLocalNotification
{
    UILocalNotification *ln = nil;
    if ([[self remindEnabled] boolValue]) {
        NSCalendarUnit unit = [self calendarUnitForRepeatFrequency];
        //NSLog(@"--- NOW - %@",[[NSDate date] description]);
        //NSLog(@"---- REPEAT - %@",[[self repeatNextDate] description]);
        while ([[self repeatNextDate] compare:[NSDate date]]!=NSOrderedDescending) {
            //NSLog(@"NOW - %@",[[NSDate date] description]);
            //NSLog(@"REPEAT - %@",[[self repeatNextDate] description]);
            NSDate *nextDate = [self repeatNextDate];
            switch ([[self repeatFrequency] integerValue]) {
                case RF_Daily: {
                    nextDate = [[NSCalendar currentCalendar] dateByAddingUnit:unit value:1 toDate:nextDate options:NSCalendarMatchNextTime];
                } break;
                case RF_Weekly: {
                    nextDate = [[NSCalendar currentCalendar] dateByAddingUnit:unit value:7 toDate:nextDate options:NSCalendarMatchNextTime];
                } break;
                case RF_BiWeekly: {
                    nextDate = [[NSCalendar currentCalendar] dateByAddingUnit:unit value:14 toDate:nextDate options:NSCalendarMatchNextTime];
                } break;
                case RF_Monthly: {
                    nextDate = [[NSCalendar currentCalendar] dateByAddingUnit:unit value:1 toDate:nextDate options:NSCalendarMatchNextTime];
                } break;                case RF_Every_Hour: {
                    nextDate = [[NSCalendar currentCalendar] dateByAddingUnit:unit value:1 toDate:nextDate options:NSCalendarMatchNextTime];
                } break;
                default: {
                    nextDate = [[NSCalendar currentCalendar] dateByAddingUnit:unit value:1 toDate:nextDate options:NSCalendarMatchNextTime];
                } break;
            }
            [self setRepeatNextDate:nextDate];
        }
        NSLog(@"Created Local Notification at - %@",[[self repeatNextDate] description]);
        ln = [JDMLocalNotification sendAlertNowWithMessage:[NSString stringWithFormat:NSLocalizedString(@"It's time to take a photo for your %@ project",
                                                                                                        @"It's time to take a photo for your %@ project"),
                                                            ([self title]) ? [self title] : NSLocalizedString(@"SproutPic", @"SproutPic")]
                                                  andSound:JDM_Notification_Sound_Default
                                             andBadgeCount:NO_BADGE_UPDATE
                                                    onDate:[self repeatNextDate]
                                            repeatInterval:unit
                                              withUserInfo:@{ NOTIFICATION_KEY_PROJECT_UUID : [self uuid]}];
    }
    return ln;
}


# pragma mark Public

+ (Project*)createNewProject:(NSString*)title
                    subTitle:(NSString*)subTitle
    withManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    NSDate *date = [NSDate date];
    NSDate *noonDate = [[NSCalendar currentCalendar] dateBySettingHour:12 minute:0 second:0 ofDate:date options:NSCalendarWrapComponents];
    
    Project *project = [NSEntityDescription insertNewObjectForEntityForName:@"Project"
                                                     inManagedObjectContext:managedObjectContext];
    [project setTitle:title];
    [project setSubtitle:subTitle];
    [project setRepeatNextDate:noonDate];
    [project setCreated:date];
    [project setSlideTime:@(1)];
    [project setRepeatFrequency:@(0)];
    return project;
}

+ (Project*)findByUUID:(NSString*)uuid
               withMOC:(NSManagedObjectContext*)moc
{
    Project *project = nil;
    if (uuid && moc) {
        project = (Project*)[[CoreDataAccessKit sharedInstance] findAnObject:@"Project"
                                                                forPredicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid]
                                                                    withSort:nil
                                                                       inMOC:moc];
    }
    return project;
}

+ (NSArray*)sortDescriptors
{
    return @[
             [NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO],
             [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES],
             [NSSortDescriptor sortDescriptorWithKey:@"subtitle" ascending:YES],
             [NSSortDescriptor sortDescriptorWithKey:@"lastModified" ascending:NO]
             ];
}

- (NSArray*)timelinesArraySorted
{
    return [[[self timelines] allObjects] sortedArrayUsingDescriptors:
            @[
              [NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO],
              [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:NO],
              ]];
}

- (void)updateScheduledNotification
{
    UILocalNotification *ln = nil;
    if ([[self remindEnabled] boolValue]) {
        // Verify we have notification configured
        if ([self notificationUUID]) {
            ln = [JDMLocalNotification findLocalNotifications:[self notificationUUID]];
            if (![[ln fireDate] isEqualToDate:[self repeatNextDate]]) {
                NSLog(@"Deleted Local Notification at - %@",[[ln fireDate] description]);
                [JDMLocalNotification cancelLocalNotification:ln];
                ln = nil;
            }
        }
        if (!ln) {
            // No notification setup, so go create one
            ln = [self createLocalNotification];
            [self setNotificationUUID:[JDMLocalNotification tagForNotifications:ln]];
            [self save];
        }
    } else {
        // See if we need to delete or clean up any notifications
        if ([self notificationUUID]) {
            ln = [JDMLocalNotification findLocalNotifications:[self notificationUUID]];
            if (ln) {
                NSLog(@"Deleted Local Notification at - %@",[[ln fireDate] description]);
                [JDMLocalNotification cancelLocalNotification:ln];
                [self setNotificationUUID:nil];
                [self save];
            }
        }
    }
}

+ (void)updateAllProjectNotifications
{
    CoreDataAccessKit *cd = [CoreDataAccessKit sharedInstance];
    NSManagedObjectContext *moc = [cd createNewManagedObjectContextwithName:@"UpdateAPNs" andConcurrency:NSPrivateQueueConcurrencyType];
    NSArray *allProjects = [cd findObjects:NSStringFromClass([Project class]) forPredicate:nil withSort:nil inMOC:moc];
    for (Project *project in allProjects) {
        [project updateScheduledNotification];
    }
}

# pragma mark NSManagedObject

- (void)awakeFromFetch
{
    [super awakeFromFetch];
    if (![self uuid]) {
        [self setUuid:[[NSUUID UUID] UUIDString]];
        [self save];
    }
}

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    NSDate *now = [NSDate date];
    [self setCreated:now];
    [self setLastModified:now];
    [self setUuid:[[NSUUID UUID] UUIDString]];
}

- (void)prepareForDeletion
{
    if ([self notificationUUID]) {
        UILocalNotification *ln = [JDMLocalNotification findLocalNotifications:[self notificationUUID]];
        if (ln) [JDMLocalNotification cancelLocalNotification:ln];
    }
}



@end
