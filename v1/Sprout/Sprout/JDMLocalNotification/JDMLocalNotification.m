//
//  JDMLocalNotification.m
//
//  Created by Morris, Jeffrey on 4/16/15.
//  Copyright (c) 2015 JDMdesign. All rights reserved.
//

// Dev Docs:
// https://developer.apple.com/library/ios/documentation/iPhone/Reference/UILocalNotification_Class/index.html#//apple_ref/doc/c_ref/UILocalNotification

// NOTE: An application can have only a limited number of scheduled notifications; the system keeps the soonest-firing 64 notifications (with automatically rescheduled notifications counting as a single notification) and discards the rest

#import "JDMLocalNotification.h"
#import <UIKit/UIKit.h>

#define NOTIFICATION_KEY_TAG    @"NOTIFICATION_KEY_TAG"

@implementation JDMLocalNotification

///////////////////////////////////////////////////////////////////////////////////////////////////
// Private Methods

+ (NSString*)soundFileName:(JDM_Notification_Sound)sound
{
    switch (sound) {
        case JDM_Notification_Sound_None: return nil;
        case JDM_Notification_Sound_Default: return @"n_default.wav";
        case JDM_Notification_Sound_Warning: return @"n_default.wav";
        case JDM_Notification_Sound_Success: return @"n_default.wav";
        case JDM_Notification_Sound_Failure: return @"n_default.wav";
        default: return @"n_default.wav";
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Public Method(s)

+ (UILocalNotification*)sendAlertNowWithMessage:(NSString*)msg
{
    return [JDMLocalNotification sendAlertNowWithMessage:msg
                                                andSound:JDM_Notification_Sound_Default
                                           andBadgeCount:NO_BADGE_UPDATE
                                                  onDate:nil
                                          repeatInterval:0
                                            withUserInfo:nil];
}

+ (UILocalNotification*)sendAlertNowWithMessage:(NSString*)msg
                                       andSound:(JDM_Notification_Sound)sound
{
    return [JDMLocalNotification sendAlertNowWithMessage:msg
                                                andSound:sound
                                           andBadgeCount:NO_BADGE_UPDATE
                                                  onDate:nil
                                          repeatInterval:0
                                            withUserInfo:nil];
}

+ (UILocalNotification*)sendAlertNowWithMessage:(NSString*)msg
                                       andSound:(JDM_Notification_Sound)sound
                        andIncreaseBadgingCount:(BOOL)increase
{
    NSInteger badgeCount = (increase) ? [[UIApplication sharedApplication] applicationIconBadgeNumber]+1 : NO_BADGE_UPDATE;
    return [JDMLocalNotification sendAlertNowWithMessage:msg
                                                andSound:sound
                                           andBadgeCount:badgeCount
                                                  onDate:nil
                                          repeatInterval:0
                                            withUserInfo:nil];
}

+ (UILocalNotification*)sendAlertNowWithMessage:(NSString*)msg
                                       andSound:(JDM_Notification_Sound)sound
                                  andBadgeCount:(NSInteger)badge
{
    return [JDMLocalNotification sendAlertNowWithMessage:msg
                                                andSound:sound
                                           andBadgeCount:badge
                                                  onDate:nil
                                          repeatInterval:0
                                            withUserInfo:nil];
}

+ (UILocalNotification*)sendAlertNowWithMessage:(NSString*)msg
                                       andSound:(JDM_Notification_Sound)sound
                                  andBadgeCount:(NSInteger)badge
                                   withUserInfo:(NSDictionary*)userInfo
{
    return [JDMLocalNotification sendAlertNowWithMessage:msg
                                                andSound:sound
                                           andBadgeCount:badge
                                                  onDate:nil
                                          repeatInterval:0
                                            withUserInfo:userInfo];
}

// Main method for scheduling a local notification

+ (UILocalNotification*)sendAlertNowWithMessage:(NSString*)msg
                                       andSound:(JDM_Notification_Sound)sound
                                  andBadgeCount:(NSInteger)badge
                                         onDate:(NSDate*)onDate
                                 repeatInterval:(NSCalendarUnit)repeat
                                   withUserInfo:(NSDictionary*)userInfo
{
    UILocalNotification* alert = nil;
    if (msg) {
        alert = [[UILocalNotification alloc] init];
        if (!onDate) {
            onDate = [NSDate dateWithTimeIntervalSinceNow:1]; // Schedule it for 1 second from now
        }
        alert.fireDate = onDate;
        alert.repeatInterval = repeat;
        alert.alertBody = msg;
        alert.soundName = [JDMLocalNotification soundFileName:sound];
        if ( badge > NO_BADGE_UPDATE ) alert.applicationIconBadgeNumber = badge;
        NSMutableDictionary *mutableUserInfo = [@{} mutableCopy];
        if (userInfo) {
            mutableUserInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        }
        [mutableUserInfo setObject:[[NSUUID UUID] UUIDString] forKey:NOTIFICATION_KEY_TAG];
        alert.userInfo = mutableUserInfo;
        [[UIApplication sharedApplication] scheduleLocalNotification:alert];
    }
    return alert;
}

+ (NSString*)tagForNotifications:(UILocalNotification*)notification
{
    if (notification && [notification userInfo]) {
        return [[notification userInfo] objectForKey:NOTIFICATION_KEY_TAG];
    }
    return nil;
}

+ (NSArray*)allScheduledNotifications
{
    return [[UIApplication sharedApplication] scheduledLocalNotifications];
}

+ (UILocalNotification*)findLocalNotifications:(NSString*)tag
{
    UILocalNotification *foundNotification = nil;
    NSArray *allNotifications = [JDMLocalNotification allScheduledNotifications];
    for (UILocalNotification *notification in allNotifications) {
        NSString *curTag = [JDMLocalNotification tagForNotifications:notification];
        if (curTag && [curTag isEqualToString:tag]) {
            return notification;
        }
    }
    return foundNotification;
}

+ (void)cancelLocalNotification:(UILocalNotification*)notification
{
    if (notification) {
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
}

+ (void)cancelAllLocalNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
