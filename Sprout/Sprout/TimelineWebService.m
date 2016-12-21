//
//  TimelineWebService.m
//  Sprout
//
//  Created by Jeff Morris on 11/23/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "TimelineWebService.h"
#import "DataObjects.h"

#define SERVICE_URL_GET_TIMELINES       [NSString stringWithFormat:@"%@/GetSproutImages",SPROUT_API_URL]
#define PARAM_KEY_GET_TIMELINES         @"filteredImages"
#define PARAM_KEY_GET_TIMELINE_IDS      @"imageIds"

#define SERVICE_URL_GET_TIMLINE_BY_ID   [NSString stringWithFormat:@"%@/GetSproutImageById",SPROUT_API_URL]
#define SERVICE_URL_UPDATE_TIMLINE      [NSString stringWithFormat:@"%@/UploadSproutImage",SPROUT_API_URL]
#define SERVICE_URL_DELETE_TIMLINE      [NSString stringWithFormat:@"%@/DeleteSproutImage",SPROUT_API_URL]
#define SERVICE_URL_GET_IMAGE           @"SERVICE_URL_GET_IMAGE"

#define PARAM_KEY_PROJECT_SERVER_ID     @"projectId"
#define PARAM_KEY_GET_TIMELINE_IMG_ID   @"sproutImageId"
#define PARAM_KEY_GET_TIMELINE_WIDTH    @"width"
#define PARAM_KEY_GET_TIMELINE_HEIGHT   @"height"
#define PARAM_KEY_GET_TIMELINE_ORDER    @"pictureOrder"
#define PARAM_KEY_GET_TIMELINE_URL      @"serverUrl"
#define PARAM_KEY_GET_TIMELINE_CREATED  @"createdDt"
#define PARAM_KEY_GET_TIMELINE_UPDATED  @"updatedDt"

#define HEADER_KEY_UPLOAD_PROJECT_ID    @"projectId"
#define HEADER_KEY_UPLOAD_PICTURE_ORDER @"pictureOrder"
#define HEADER_KEY_GET_TIMELINE_UUID    @"timelineUUID"

#define PARAM_KEY_UPLOADE_FILE_DATA     @"file"


@implementation TimelineWebService

# pragma mark Private

- (Project*)getProjectByID:(NSNumber*)projectId
{
    return (Project*)[[CoreDataAccessKit sharedInstance]
                      findAnObject:NSStringFromClass([Project class])
                      forPredicate:[NSPredicate predicateWithFormat:@"serverId = %@",projectId]
                      withSort:nil
                      inMOC:[self moc]];
}

# pragma mark TimelineWebService

+ (TimelineWebService*)getTimelineForProjectId:(NSNumber*)projectId
                                  withCallback:(SproutServiceCallBack)callBack
{
    if (!projectId) return nil;
    TimelineWebService *service = [[TimelineWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:SERVICE_URL_GET_TIMELINES];
    [service setParameters:@{ PARAM_KEY_PROJECT_SERVER_ID : projectId }];
    [service setServiceTag:SERVICE_URL_GET_TIMELINES];
    [service setOauthEnabled:YES];
    return service;
}

+ (TimelineWebService*)getTimelineById:(Timeline*)timeline
                          withCallback:(SproutServiceCallBack)callBack
{
    if (!timeline) return nil;
    TimelineWebService *service = [[TimelineWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:SERVICE_URL_GET_TIMLINE_BY_ID];
    [service setParameters:@{ PARAM_KEY_GET_TIMELINE_IMG_ID : [timeline serverId] }];
    [service setServiceTag:SERVICE_URL_GET_TIMLINE_BY_ID];
    [service setOauthEnabled:YES];
    return service;
}

+ (TimelineWebService*)syncTimeline:(Timeline*)timeline
                       withCallback:(SproutServiceCallBack)callBack
{
    if (!timeline || ![timeline uuid] || ![timeline project] || [[[timeline project] serverId] integerValue]<=0 ) return nil;

    TimelineWebService *service = nil;
    NSData *imgData = [timeline imageData];
    if (imgData) {
        service = [[TimelineWebService alloc] init];
        [service setServiceCallBack:callBack];
        [service setUrl:SERVICE_URL_UPDATE_TIMLINE];
        [service setContentType:ContentTypeFormData];
        [service setHeaders:@{ HEADER_KEY_UPLOAD_PROJECT_ID : [[timeline project] serverId],
                               HEADER_KEY_UPLOAD_PICTURE_ORDER : [timeline serverPictureOrder] }];
        [service setParameters:@{ PARAM_KEY_UPLOADE_FILE_DATA : imgData }];
        [service setServiceTag:[timeline uuid]];
        [service setOauthEnabled:YES];
    }
    
    return service;
}

+ (TimelineWebService*)deleteTimelineId:(NSNumber*)serverId
                           withCallback:(SproutServiceCallBack)callBack
{
    if (!serverId) return nil;
    TimelineWebService *service = [[TimelineWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:SERVICE_URL_DELETE_TIMLINE];
    [service setParameters:@{ PARAM_KEY_GET_TIMELINE_IMG_ID : serverId }];
    [service setServiceTag:SERVICE_URL_DELETE_TIMLINE];
    [service setOauthEnabled:YES];
    return service;
}

+ (TimelineWebService*)loadTimelineImage:(Timeline*)timeline
                            withCallback:(SproutServiceCallBack)callBack
{
    if (!timeline) return nil;
    TimelineWebService *service = [[TimelineWebService alloc] init];
    [service setFakeService:YES];
    [service setServiceTag:[timeline uuid]];
    [service setServiceCallBack:^(NSError *error, SproutWebService *service) {
        Timeline *timeline = [Timeline findByUUID:[service serviceTag] withMOC:[service moc]];
        if (timeline && [timeline serverURL]) {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[timeline serverURL]]]];
                if (img) {
                    NSString *imageName = [timeline saveImage:img];
                    NSString *thumbnailImgName = [timeline saveThumbnailImage:img];
                    if (imageName && thumbnailImgName) {
                        NSDate *now = [NSDate date];
                        [timeline setLocalURL:imageName];
                        [timeline setLocalThumbnailURL:thumbnailImgName];
                        [timeline setLastModified:now];
                        [[timeline project] setLastModified:now];
                        [timeline save];
                        NSLog(@"Saved new image - %@",imageName);
                    } else {
                        NSLog(@"Issue trying to save image");
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (callBack) callBack(error,service);
                });
            });
        } else if (callBack) {
            callBack(error,service);
        }
    }];
    return service;
}

# pragma mark Sync Methods

- (NSNumber*)syncTimelineWithDictionary:(NSDictionary*)timelineDict withTimeline:(Timeline*)timeline
{
    NSNumber *serverId = @(0);
    if (timelineDict) {
        // Create a shortcut for the CoreDataAccessKit
        CoreDataAccessKit *cdak = [CoreDataAccessKit sharedInstance];
        Project *currentProject = nil;
        BOOL localUpload = NO;
        
        // First get all the attributes
        NSNumber *projectId = [self numberForKey:PARAM_KEY_PROJECT_SERVER_ID inDict:timelineDict];
        serverId = [self numberForKey:PARAM_KEY_GET_TIMELINE_IMG_ID inDict:timelineDict];
        if (timeline && [[timeline serverId] integerValue]<=0 && serverId) {
            [timeline setServerId:serverId];
            localUpload = YES;
        }
        NSString *serverURL = [self stringForKey:PARAM_KEY_GET_TIMELINE_URL inDict:timelineDict];
        if (serverURL && ![serverURL hasPrefix:@"http://sproutpic.com"]) {
            serverURL = [NSString stringWithFormat:@"%@/%@",SPROUT_URL,serverURL];
        }
        NSNumber *pictureOrder = [self numberForKey:PARAM_KEY_GET_TIMELINE_ORDER inDict:timelineDict];
        NSDate *created = [self dateForKey:PARAM_KEY_GET_TIMELINE_CREATED inDict:timelineDict];;
        NSDate *lastModified = [self dateForKey:PARAM_KEY_GET_TIMELINE_UPDATED inDict:timelineDict];;
        
        // Now, find timeline to update, or create a new one.
        if (!timeline && serverId && [serverId integerValue]>0) {
            timeline = (Timeline*)[cdak findAnObject:NSStringFromClass([Timeline class])
                                        forPredicate:[NSPredicate predicateWithFormat:@"serverId = %@",serverId]
                                            withSort:nil
                                               inMOC:[self moc]];
        }
        // Check for the project we want to link this timeline to...
        if (timeline) {
            currentProject = [timeline project];
        }
        if (!currentProject && projectId && [projectId integerValue]>0) {
            currentProject = (Project*)[cdak findAnObject:NSStringFromClass([Project class])
                                             forPredicate:[NSPredicate predicateWithFormat:@"serverId = %@",projectId]
                                                 withSort:nil
                                                    inMOC:[self moc]];
        }
        // Check to see if we need to create a new timeline and link it to the current project
        if (!timeline && currentProject) {
            timeline = [Timeline createNewTimelineWithServerURL:serverURL forProject:currentProject withMOC:[self moc]];
            [timeline setServerId:serverId];
            [timeline setCreated:created];
            [timeline setLastModified:lastModified];
        }
        
        // Finally, sync all the data points
        if (![[timeline serverURL] isEqualToString:serverURL]) {
            [timeline setServerURL:serverURL];
            if (!localUpload) {
                [timeline deleteLocalImages];
                [timeline setLocalURL:nil];
            }
        }
        if (![[timeline order] isEqualToNumber:pictureOrder]) { [timeline setOrder:pictureOrder]; }
        if (![[timeline created] isEqualToDate:created]) { [timeline setCreated:created]; }
        if (![[timeline lastSync] isEqualToDate:lastModified]) {
            [timeline setLastModified:lastModified];
            [timeline setLastSync:lastModified];
        }
        
        if ([timeline hasChanges] && ![timeline localURL] && [timeline serverURL]) {
            [timeline loadImageRemotely];
        }
        
    }
    return serverId;
}

# pragma mark SproutWebServiceDelegate

- (void)completedSuccess:(id)responseObject
{
    if ([[self serviceTag] isEqualToString:SERVICE_URL_GET_TIMELINES]) {

        // Create an array to track the ids that have been synced
        NSMutableArray *syncedIds = [@[] mutableCopy];
        Project *project = [self getProjectByID:[[self parameters] objectForKey:PARAM_KEY_PROJECT_SERVER_ID]];
        
        // Now, sync all the projects that were returned...
        NSArray *timelines = [responseObject objectForKey:PARAM_KEY_GET_TIMELINES];
        for (NSDictionary *timelineDicts in timelines) {
            NSNumber *serverId = [self syncTimelineWithDictionary:timelineDicts withTimeline:nil];
            if (serverId && [serverId integerValue]>0) { [syncedIds addObject:serverId]; }
        }
        
        // Next we want to delete any projects that are no longer on the server (also don't delete any that have not been saved)
        NSArray *delTimelines = [[CoreDataAccessKit sharedInstance]
                                 findObjects:NSStringFromClass([Timeline class])
                                 forPredicate:[NSPredicate predicateWithFormat:@"(NOT serverId IN %@) AND (serverId > 0) AND (project = %@)",syncedIds,project]
                                 withSort:nil
                                 inMOC:[self moc]];
        for (Timeline *tl in delTimelines) {
            [[self moc] deleteObject:tl];
        }

    } else if ([[self serviceTag] isEqualToString:SERVICE_URL_GET_TIMLINE_BY_ID]) {
        
        // Get the timeline and update it...
        Timeline *timeline = nil;
        NSNumber *serverId = [[self parameters] objectForKey:PARAM_KEY_GET_TIMELINE_IMG_ID];
        if (serverId && [serverId integerValue]>0) {
            timeline = (Timeline*)[[CoreDataAccessKit sharedInstance]
                                   findAnObject:NSStringFromClass([Timeline class])
                                   forPredicate:[NSPredicate predicateWithFormat:@"serverId = %@",serverId]
                                   withSort:nil
                                   inMOC:[self moc]];
        }
        [self syncTimelineWithDictionary:responseObject withTimeline:timeline];
        
    } else if ([[self url] isEqualToString:SERVICE_URL_UPDATE_TIMLINE] && [self serviceTag]) {
        
        Timeline *timeline = [Timeline findByUUID:[self serviceTag] withMOC:[self moc]];
        if (timeline) {
            [self syncTimelineWithDictionary:responseObject withTimeline:timeline];
        }
        
    } else if ([[self serviceTag] isEqualToString:SERVICE_URL_DELETE_TIMLINE]) {
        
        NSNumber *serverId = [[self parameters] objectForKey:PARAM_KEY_GET_TIMELINE_IMG_ID];
        // Now, find the timeline and delete it.
        if (serverId && [serverId integerValue]>0) {
            Timeline *timeline = (Timeline*)[[CoreDataAccessKit sharedInstance]
                                             findAnObject:NSStringFromClass([Timeline class])
                                             forPredicate:[NSPredicate predicateWithFormat:@"serverId = %@",serverId]
                                             withSort:nil
                                             inMOC:[self moc]];
            if (timeline) { [timeline deleteAndSave]; }
        }
     
    } else if ([[self serviceTag] isEqualToString:SERVICE_URL_GET_IMAGE]) {
        // Do nothing, the magic is in the callback...
    }
    
    // Lastly, save the MOC
    [[self moc] saveAll];
    
    [super completedSuccess:responseObject];
}

- (void)completedFailure:(NSError*)error
{
    NSLog(@"Error - %@",error);
    
    [super completedFailure:error];
}

@end
