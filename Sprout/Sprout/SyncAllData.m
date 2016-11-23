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

+ (void)syncNewProjects
{
    // Setup variables first
    CoreDataAccessKit *cdak = [CoreDataAccessKit sharedInstance];
    NSManagedObjectContext *moc = [cdak createNewManagedObjectContextwithName:@"SyncAll" andConcurrency:NSPrivateQueueConcurrencyType];

    // Get all the projects that have not been synced up from the server yet
    NSArray *newProjects = [cdak findObjects:@"Projects"
                                forPredicate:[NSPredicate predicateWithFormat:@"serverId <=0"]
                                    withSort:@[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:YES]]
                                       inMOC:moc];
    for (Project *project in newProjects) {
        [[SyncQueue manager] addService:[ProjectWebService syncProject:project withCallback:nil]];
    }
}

+ (void)now
{
    // First, sync all the projects with SproutPic remove server
    [[SyncQueue manager] addService:[ProjectWebService getAllProjectsWithCallback:^(NSError *error, SproutWebService *service) {
        if (!error) {
            // Next sync all the projects that have not been uploaded to the server yet
            [SyncAllData syncNewProjects];
        }
    }]];
}

@end
