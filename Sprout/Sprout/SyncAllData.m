//
//  SyncAllData.m
//  Sprout
//
//  Created by Jeff Morris on 11/23/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SyncAllData.h"
#import "DataObjects.h"
#import "ProjectWebService.h"
#import "TimelineWebService.h"
#import "SyncQueue.h"

@implementation SyncAllData

+ (void)syncNewProjects:(SyncAllDataCallBack)callBack;
{
    // Get all the projects that have not been synced up from the server yet
    NSArray *newProjects = [[CoreDataAccessKit sharedInstance]
                            findObjects:NSStringFromClass([Project class])
                            forPredicate:[NSPredicate predicateWithFormat:@"serverId <= 0"]
                            withSort:@[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:YES]]
                            inMOC:[[CoreDataAccessKit sharedInstance]
                                   createNewManagedObjectContextwithName:@"SyncAllNew"
                                   andConcurrency:NSPrivateQueueConcurrencyType]];
    for (Project *project in newProjects) {
        [[SyncQueue manager] addService:[ProjectWebService syncProject:project withCallback:^(NSError *error, SproutWebService *service) {
//            if (!error) {
//                [[SyncQueue manager] addService:[TimelineWebService getSproutImagesForProject:project withCallback:nil]];
//            }
        }]];
    }
    if (callBack) {
        callBack();
    }
}

+ (void)now:(SyncAllDataCallBack)callBack;
{
    // First, sync all the projects with SproutPic remove server
    [[SyncQueue manager] addService:[ProjectWebService getAllProjectsWithCallback:^(NSError *error, SproutWebService *service) {
        if (!error) {
            // Now sync all the timelines for these projects
            NSArray *projects = [[CoreDataAccessKit sharedInstance]
                                 findObjects:NSStringFromClass([Project class])
                                 forPredicate:[NSPredicate predicateWithFormat:@"serverId > 0"]
                                 withSort:@[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:YES]]
                                 inMOC:[[CoreDataAccessKit sharedInstance]
                                        createNewManagedObjectContextwithName:@"SyncTimelines"
                                        andConcurrency:NSPrivateQueueConcurrencyType]];
            for (Project *project in projects) {
                [[SyncQueue manager] addService:[TimelineWebService getSproutImagesForProjectId:[project serverId] withCallback:nil]];
            }
            // Next sync all the projects that have not been uploaded to the server yet
            [SyncAllData syncNewProjects:callBack];
        }
    }]];
}

@end
