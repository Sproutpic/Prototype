//
//  SyncWebService.m
//  Sprout
//
//  Created by Jeff Morris on 12/19/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SyncWebService.h"
#import "DataObjects.h"
#import "SyncQueue.h"
#import "ProjectWebService.h"
#import "TimelineWebService.h"

#define SERVICE_URL_FAKE_SYNC_SERVICE       @"fakeSyncService"
#define SERVICE_URL_SYNC_ALL_PROJECTS       @"syncAllProjects"

#define PARAM_KEY_PROJECT_UUID              @"projectUUID"

@implementation SyncWebService

# pragma mark SyncWebService

+ (SproutWebService*)fakeServiceToHoldCallback:(SproutServiceCallBack)callBack
{
    SyncWebService *service = [[SyncWebService alloc] init];
    [service setFakeService:YES];
    [service setServiceCallBack:callBack];
    [service setServiceTag:SERVICE_URL_FAKE_SYNC_SERVICE];
    return service;
}

+ (SproutWebService*)syncAllProjectsWithRemoteServerWithCallback:(SproutServiceCallBack)callBack
{
    SyncWebService *service = [[SyncWebService alloc] init];
    [service setFakeService:YES];
    [service setServiceCallBack:callBack];
    [service setServiceTag:SERVICE_URL_SYNC_ALL_PROJECTS];
    return service;
}

+ (SproutWebService*)syncProject:(Project*)project
                    withCallback:(SproutServiceCallBack)callBack
{
    SproutWebService *service = nil;
    if (project) {
        service = [ProjectWebService syncProject:project withCallback:^(NSError *error, SproutWebService *service) {
            if (!error && project && ![project isFault]) {
                [[SyncQueue manager] addService:[SyncWebService syncTimeLineForProject:project withCallback:callBack]];
            } else if (callBack) { // Hold on to the callback...
                [[SyncQueue manager] addService:[SyncWebService fakeServiceToHoldCallback:callBack]];
            }
        }];
    } else if (callBack) {
        service = [SyncWebService fakeServiceToHoldCallback:callBack];
    }
    return service;
}

+ (SproutWebService*)syncTimeLineForProject:(Project*)project
                               withCallback:(SproutServiceCallBack)callBack
{
    SproutWebService *service = nil;
    if (project && [[project serverId] integerValue] > 0) {
        service = [TimelineWebService getTimelineForProjectId:[project serverId] withCallback:^(NSError *error, SproutWebService *service) {
            
            if (!error) {
                // Next sync any timelines that have not been saved with the server...
                NSArray *unsyncedTimeLines = [[CoreDataAccessKit sharedInstance]
                                              findObjects:NSStringFromClass([Timeline class])
                                              forPredicate:[NSPredicate predicateWithFormat:@"(serverId <= 0) AND (project = %@)",project] // Don't forget marked for delete
                                              withSort:nil
                                              inMOC:[service moc]];
                for (Timeline *tl in unsyncedTimeLines) {
                    [[SyncQueue manager] addService:[TimelineWebService syncTimeline:tl withCallback:nil]];
                }
            }
            // Hold on to the callback...
            if (callBack) {
                [[SyncQueue manager] addService:[SyncWebService fakeServiceToHoldCallback:callBack]];
            }
            
        }];
    } else if (callBack) {
        service = [SyncWebService fakeServiceToHoldCallback:callBack];
    }
    return service;
}

# pragma mark SproutWebServiceDelegate

- (void)completedSuccess:(id)responseObject
{
    
    if ([[self serviceTag] isEqualToString:SERVICE_URL_SYNC_ALL_PROJECTS]) {

        // Call the sync all projects, and then after completely, add other service calls for other sync magic
        [[SyncQueue manager] addService:[ProjectWebService getAllProjectsWithCallback:^(NSError *error, SproutWebService *service) {
            if (!error) {
                // Now sync all the timelines for these projects
                NSArray *projects = [[CoreDataAccessKit sharedInstance]
                                     findObjects:NSStringFromClass([Project class])
                                     forPredicate:[NSPredicate predicateWithFormat:@"serverId > 0 AND markedForDelete = NO"] // Don't forget the mark for delete.
                                     withSort:@[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:YES]]
                                     inMOC:[self moc]];
                for (Project *project in projects) {
                    [[SyncQueue manager] addService:[SyncWebService syncTimeLineForProject:project withCallback:nil]];
                }
                
                // Get all the projects that have not been synced up from the server yet
                NSArray *newProjects = [[CoreDataAccessKit sharedInstance]
                                        findObjects:NSStringFromClass([Project class])
                                        forPredicate:[NSPredicate predicateWithFormat:@"serverId <= 0 AND markedForDelete = NO"] // Don't forget the mark for delete.
                                        withSort:@[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:YES]]
                                        inMOC:[self moc]];
                for (Project *project in newProjects) {
                    [[SyncQueue manager] addService:[SyncWebService syncProject:project withCallback:nil]];
                }
                
                // Now, hold on to the callback until queue is cleared, a litte more.
                if ([self serviceCallBack]) {
                    [[SyncQueue manager] addService:[SyncWebService fakeServiceToHoldCallback:[self serviceCallBack]]];
                    [self setServiceCallBack:nil]; // We are hold on to the callback, so clear it out for now.
                }
            }
        }]];
        
    } else if ([[self serviceTag] isEqualToString:SERVICE_URL_FAKE_SYNC_SERVICE]) {
        
        // Do Nothing...
        
    }
    
    [super completedSuccess:responseObject];
}

@end
