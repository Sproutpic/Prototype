//
//  JDMLocalNotification.h
//
//  Created by Morris, Jeffrey on 4/16/15.
//  Copyright (c) 2015 JDMdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JDM_Notification_Sound) {
    JDM_Notification_Sound_None = 0,    // No sound
    JDM_Notification_Sound_Default = 1, // Default sound
    JDM_Notification_Sound_Warning = 2, // Warning sound
    JDM_Notification_Sound_Success = 3, // Success sound
    JDM_Notification_Sound_Failure = 4, // Failure sound
};

typedef NS_ENUM(NSInteger, JDM_Notification_Type) {
    JDM_Notification_Type_New = 0,      // No sound
    JDM_Notification_Type_Updated = 1,  // Default sound
    JDM_Notification_Type_Removed = 2,  // Warning sound
};

#define NO_BADGE_UPDATE -1

@interface JDMLocalNotification : NSObject

// Create a new alert right now with a specific message
+ (UILocalNotification*)sendAlertNowWithMessage:(NSString*)msg;

// Helper method
+ (UILocalNotification*)sendAlertNowWithMessage:(NSString*)msg
                                       andSound:(JDM_Notification_Sound)sound;

// Helper method
+ (UILocalNotification*)sendAlertNowWithMessage:(NSString*)msg
                                       andSound:(JDM_Notification_Sound)sound
                        andIncreaseBadgingCount:(BOOL)increase;

// Helper method
+ (UILocalNotification*)sendAlertNowWithMessage:(NSString*)msg
                                       andSound:(JDM_Notification_Sound)sound
                                  andBadgeCount:(NSInteger)badge;

// Helper method
+ (UILocalNotification*)sendAlertNowWithMessage:(NSString*)msg
                                       andSound:(JDM_Notification_Sound)sound
                                  andBadgeCount:(NSInteger)badge
                                   withUserInfo:(NSDictionary*)userInfo;

// Create a new alert with all specific data
+ (UILocalNotification*)sendAlertNowWithMessage:(NSString*)msg
                                       andSound:(JDM_Notification_Sound)sound
                                  andBadgeCount:(NSInteger)badge
                                         onDate:(NSDate*)onDate
                                 repeatInterval:(NSCalendarUnit)repeat
                                   withUserInfo:(NSDictionary*)userInfo;

// Get all scheduled local notifications
+ (NSArray*)allScheduledNotifications;

// Find a specific local notification by UUID tag
+ (UILocalNotification*)findLocalNotifications:(NSString*)tag;

// Find the UUID tag for a specific local notification
+ (NSString*)tagForNotifications:(UILocalNotification*)notification;

// Cancel a specific local notification
+ (void)cancelLocalNotification:(UILocalNotification*)notification;

// Completely destructive, and will remove all local notifications for this app
+ (void)cancelAllLocalNotifications;

@end
