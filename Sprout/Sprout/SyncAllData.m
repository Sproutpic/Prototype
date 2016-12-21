//
//  SyncAllData.m
//  Sprout
//
//  Created by Jeff Morris on 11/23/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SyncAllData.h"
#import "DataObjects.h"
#import "SyncQueue.h"
#import "SyncWebService.h"

@implementation SyncAllData

+ (void)now:(SyncAllDataCallBack)callBack;
{
    [[SyncQueue manager] addService:[SyncWebService syncAllProjectsWithRemoteServerWithCallback:^(NSError *error, SproutWebService *service) {
        if (callBack) {
            callBack();
        }
    }]];
}


+ (void)syncProjectVideos:(SyncAllDataCallBack)callBack;
{
    [[SyncQueue manager] addService:[SyncWebService syncProjectVideosWithCallback:^(NSError *error, SproutWebService *service) {
        if (callBack) {
            callBack();
        }
    }]];
}

@end
