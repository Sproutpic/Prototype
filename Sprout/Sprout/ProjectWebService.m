//
//  ProjectWebService.m
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "ProjectWebService.h"
#import "DataObjects.h"

#define SERVICE_URL_GET_PROJECTS        [NSString stringWithFormat:@"%@/GetProjects",SPROUT_API_URL]
#define PARAM_KEY_GET_PROJECT_PROJECTS  @"filteredProjects"
#define PARAM_KEY_GET_PROJECT_IDS       @"projectIds"

#define SERVICE_URL_GET_PROJECT_BY_ID   [NSString stringWithFormat:@"%@/GetProjectById",SPROUT_API_URL]

#define SERVICE_URL_CREATE_PROJECT      [NSString stringWithFormat:@"%@/CreateProject",SPROUT_API_URL]

#define SERVICE_URL_UPDATE_PROJECT      [NSString stringWithFormat:@"%@/UpdateProject",SPROUT_API_URL]

#define SERVICE_URL_DELETE_PROJECT      [NSString stringWithFormat:@"%@/DeleteProject",SPROUT_API_URL]

#define SERVICE_URL_CREATE_VIDEO        [NSString stringWithFormat:@"%@/CreateSproutVideo",SPROUT_API_URL]

#define PARAM_KEY_PROJECT_SERVER_ID     @"sproutId"
//#define PARAM_KEY_PROJECT_OWNER_ID      @"sproutOwnerId" // Not used...
#define PARAM_KEY_PROJECT_VIDEO_PATH    @"videoPath"
#define PARAM_KEY_PROJECT_VIDEO_DATE    @"videoUpdatedDt"
#define PARAM_KEY_PROJECT_VIDEO_VIEW_CT @"videoViewCount"
#define PARAM_KEY_PROJECT_FEATURE_IND   @"featuredInd" // Not sure what this is...
#define PARAM_KEY_PROJECT_FRONT_CAMERA  @"frontCameraInd"
#define PARAM_KEY_PROJECT_USE_SHADOW    @"useShadow" // Need to add
#define PARAM_KEY_PROJECT_TITLE         @"title"
#define PARAM_KEY_PROJECT_DESCRIPTION   @"description" // I assume this is the same as subtitle
#define PARAM_KEY_PROJECT_REMINDER_ON   @"reminderEnabledInd"
#define PARAM_KEY_PROJECT_REPEAT_FREQ   @"repeatFrequency"
#define PARAM_KEY_PROJECT_REPEAT_DATE   @"repeatDate" // Need to add
#define PARAM_KEY_PROJECT_SPROUT_PUBLIC @"sproutPublicInd"
#define PARAM_KEY_PROJECT_SLIDE_DURAT   @"slideDuration"
#define PARAM_KEY_PROJECT_CREATE_DATE   @"createdDt" // Used only for projects pulled from server
//#define PARAM_KEY_PROJECT_CREATE_BY     @"createdBy" // Not used
#define PARAM_KEY_PROJECT_UPDATE_DATE   @"updatedDt" // Not used
//#define PARAM_KEY_PROJECT_UPDATE_BY     @"updatedBy" // Not used

@interface ProjectWebService ()
@property (strong, nonatomic) Project* project;
@end

@implementation ProjectWebService

# pragma mark ProjectWebService

+ (ProjectWebService*)getAllProjectsWithCallback:(SproutServiceCallBack)callBack
{
    ProjectWebService *service = [[ProjectWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:SERVICE_URL_GET_PROJECTS];
    [service setServiceTag:SERVICE_URL_GET_PROJECTS];
    [service setOauthEnabled:YES];
    return service;
}

+ (ProjectWebService*)getProjectById:(NSNumber*)serverId
                        withCallback:(SproutServiceCallBack)callBack
{
    if (!serverId) return nil;
    ProjectWebService *service = [[ProjectWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:SERVICE_URL_GET_PROJECT_BY_ID];
    [service setParameters:@{ PARAM_KEY_PROJECT_SERVER_ID : serverId }];
    [service setServiceTag:SERVICE_URL_GET_PROJECT_BY_ID];
    [service setOauthEnabled:YES];
    return service;
}

+ (ProjectWebService*)syncProject:(Project*)project
                     withCallback:(SproutServiceCallBack)callBack
{
    if (!project) return nil;
    ProjectWebService *service = [[ProjectWebService alloc] init];
    [service setServiceCallBack:callBack];
    if ([[project serverId] integerValue]>0) {
        [service setUrl:SERVICE_URL_UPDATE_PROJECT];
        [service setProject:project];
        [service setParameters:
         @{
           PARAM_KEY_PROJECT_SERVER_ID : [project serverId],
           PARAM_KEY_PROJECT_TITLE : ([project title]) ? [project title] : @"",
           PARAM_KEY_PROJECT_DESCRIPTION : ([project subtitle]) ? [project subtitle] : @"",
           
           PARAM_KEY_PROJECT_FRONT_CAMERA : ([[project frontCameraEnabled] boolValue]) ? @"true" : @"false",
           PARAM_KEY_PROJECT_USE_SHADOW : ([[project useShadow] boolValue]) ? @"true" : @"false", // TODO - Still not added to service...
           PARAM_KEY_PROJECT_SLIDE_DURAT : ([project slideTime]) ? [NSString stringWithFormat:@"%0.5f",[[project slideTime] floatValue]] : @"0.5",
           PARAM_KEY_PROJECT_SPROUT_PUBLIC : ([[project sproutSocial] boolValue]) ? @"true" : @"false",
           
           PARAM_KEY_PROJECT_REMINDER_ON : ([[project remindEnabled] boolValue]) ? @"true" : @"false",
           PARAM_KEY_PROJECT_REPEAT_FREQ : ([project repeatFrequency]) ? [project repeatFrequency] : @(0),
           PARAM_KEY_PROJECT_REPEAT_DATE : ([project repeatNextDate]) ? [[service dateFormatter] stringFromDate:[project repeatNextDate]]: [NSNull null],
           }];
        [service setServiceTag:SERVICE_URL_UPDATE_PROJECT];
    } else {
        [service setUrl:SERVICE_URL_CREATE_PROJECT];
        [service setProject:project];
        [service setParameters:
         @{
           PARAM_KEY_PROJECT_TITLE : ([project title]) ? [project title] : @"",
           PARAM_KEY_PROJECT_DESCRIPTION : ([project subtitle]) ? [project subtitle] : @"",
           
           PARAM_KEY_PROJECT_FRONT_CAMERA : ([[project frontCameraEnabled] boolValue]) ? @"true" : @"false",
           PARAM_KEY_PROJECT_USE_SHADOW : ([[project useShadow] boolValue]) ? @"true" : @"false",
           PARAM_KEY_PROJECT_SLIDE_DURAT : ([project slideTime]) ? [NSString stringWithFormat:@"%0.5f",[[project slideTime] floatValue]] : @"0.5",
           PARAM_KEY_PROJECT_SPROUT_PUBLIC : ([[project sproutSocial] boolValue]) ? @"true" : @"false",
           
           PARAM_KEY_PROJECT_REMINDER_ON : ([[project remindEnabled] boolValue]) ? @"true" : @"false",
           PARAM_KEY_PROJECT_REPEAT_FREQ : ([project repeatFrequency]) ? [project repeatFrequency] : @(0),
           PARAM_KEY_PROJECT_REPEAT_DATE : ([project repeatNextDate]) ? [[service dateFormatter] stringFromDate:[project repeatNextDate]]: [NSNull null],
           }];
        [service setServiceTag:SERVICE_URL_CREATE_PROJECT];
    }
    [service setOauthEnabled:YES];
    return service;
}

+ (ProjectWebService*)deleteProjectById:(NSNumber*)serverId
                           withCallback:(SproutServiceCallBack)callBack
{
    if (!serverId) return nil;
    ProjectWebService *service = [[ProjectWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:SERVICE_URL_DELETE_PROJECT];
    [service setParameters:@{ PARAM_KEY_PROJECT_SERVER_ID : serverId }];
    [service setServiceTag:SERVICE_URL_DELETE_PROJECT];
    [service setOauthEnabled:YES];
    return service;
}

+ (ProjectWebService*)createProjectIdVideo:(NSNumber*)serverId
                              withCallback:(SproutServiceCallBack)callBack
{
    if (!serverId) return nil;
    ProjectWebService *service = [[ProjectWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:SERVICE_URL_CREATE_VIDEO];
    [service setParameters:@{ PARAM_KEY_PROJECT_SERVER_ID : serverId }];
    [service setServiceTag:SERVICE_URL_CREATE_VIDEO];
    [service setOauthEnabled:YES];
    return service;
}

# pragma mark Sync Methods

- (NSNumber*)syncProjectWithDictionary:(NSDictionary*)projectDict withProject:(Project*)project
{
    NSNumber *serverId = @(0);
    if (projectDict) {        
        // Create a shortcut for the CoreDataAccessKit
        CoreDataAccessKit *cdak = [CoreDataAccessKit sharedInstance];

        // First get all the attributes
        serverId = [self numberForKey:PARAM_KEY_PROJECT_SERVER_ID inDict:projectDict];
        if (project && [[project serverId] integerValue]<=0) { [project setServerId:serverId]; }
        NSString *title = [self stringForKey:PARAM_KEY_PROJECT_TITLE inDict:projectDict];
        NSString *subtitle = [self stringForKey:PARAM_KEY_PROJECT_DESCRIPTION inDict:projectDict];

        NSNumber *frontCameraEnabled = [self boolForKey:PARAM_KEY_PROJECT_FRONT_CAMERA inDict:projectDict];
        //NSNumber *useShadow = [self boolForKey:PARAM_KEY_PROJECT_USE_SHADOW inDict:projectDict];
        NSDecimalNumber *slideTime = [self decimalForKey:PARAM_KEY_PROJECT_SLIDE_DURAT inDict:projectDict];
        NSNumber *sproutSocial = [self boolForKey:PARAM_KEY_PROJECT_SPROUT_PUBLIC inDict:projectDict];
        
        NSNumber *remindEnabled = [self boolForKey:PARAM_KEY_PROJECT_REMINDER_ON inDict:projectDict];
        NSNumber *repeatFrequency = [self boolForKey:PARAM_KEY_PROJECT_REMINDER_ON inDict:projectDict];
        //NSDate *repeatNextDate = [self dateForKey:PARAM_KEY_PROJECT_REPEAT_DATE inDict:projectDict];

        NSString *videoURL = [self stringForKey:PARAM_KEY_PROJECT_VIDEO_PATH inDict:projectDict];
        NSDate *videoLastModified = [self dateForKey:PARAM_KEY_PROJECT_VIDEO_DATE inDict:projectDict];

        NSDate *created = [self dateForKey:PARAM_KEY_PROJECT_CREATE_DATE inDict:projectDict];;
        NSDate *lastModified = [self dateForKey:PARAM_KEY_PROJECT_UPDATE_DATE inDict:projectDict];;
        
        // Now, find project to update, or create a new one.
        if (!project && serverId && [serverId integerValue]>0) {
            project = (Project*)[cdak findAnObject:NSStringFromClass([Project class])
                                      forPredicate:[NSPredicate predicateWithFormat:@"serverId = %@",serverId]
                                          withSort:nil inMOC:[self moc]];
        }
        if (!project) {
            project = [Project createNewProject:title subTitle:subtitle withManagedObjectContext:[self moc]];
            [project setServerId:serverId];
            [project setCreated:created];
            [project setLastModified:[NSDate date]];
        }
        
        // Now sync all the data points
        if (![[project title] isEqualToString:title]) { [project setTitle:title]; }
        if (![[project subtitle] isEqualToString:subtitle]) { [project setSubtitle:subtitle]; }
        
        if (![[project frontCameraEnabled] isEqualToNumber:frontCameraEnabled]) { [project setFrontCameraEnabled:frontCameraEnabled]; }
        //if (![[project useShadow] isEqualToNumber:useShadow]) { [project setUseShadow:useShadow]; }
        if (![[project slideTime] isEqualToNumber:slideTime]) { [project setSlideTime:slideTime]; }
        if (![[project sproutSocial] isEqualToNumber:sproutSocial]) { [project setSproutSocial:sproutSocial]; }
        
        if (![[project remindEnabled] isEqualToNumber:remindEnabled]) { [project setRemindEnabled:remindEnabled]; }
        if (![[project repeatFrequency] isEqualToNumber:repeatFrequency]) { [project setRepeatFrequency:repeatFrequency]; }
        //if (![[project repeatNextDate] isEqualToDate:repeatNextDate]) { [project setRepeatNextDate:repeatNextDate]; }
        
        if (![[project videoURL] isEqualToString:videoURL]) { [project setVideoURL:videoURL]; }
        if (![[project videoLastModified] isEqualToDate:videoLastModified]) { [project setVideoLastModified:videoLastModified]; }
        
        if (![[project created] isEqualToDate:created]) { [project setCreated:created]; }
        if (![[project lastSync] isEqualToDate:lastModified]) {
            [project setLastModified:lastModified];
            [project setLastSync:lastModified];
        }
    }
    return serverId;
}

# pragma mark SproutWebServiceDelegate

- (void)completedSuccess:(id)responseObject
{
    if ([[self serviceTag] isEqualToString:SERVICE_URL_GET_PROJECTS]) {
        
        // Create an array to track the ids that have been synced
        NSMutableArray *syncedIds = [@[] mutableCopy];
        // Now, sync all the projects that were returned...
        NSArray *projects = [responseObject objectForKey:PARAM_KEY_GET_PROJECT_PROJECTS];
        for (NSDictionary *projectDict in projects) {
            NSNumber *serverId = [self syncProjectWithDictionary:projectDict withProject:nil];
            if (serverId && [serverId integerValue]>0) { [syncedIds addObject:serverId]; }
        }
        
        // Next we want to delete any projects that are no longer on the server (also don't delete any that have not been saved)
        CoreDataAccessKit *cdak = [CoreDataAccessKit sharedInstance];
        NSArray *delProjects = [cdak findObjects:NSStringFromClass([Project class])
                                    forPredicate:[NSPredicate predicateWithFormat:@"NOT serverId IN %@ AND serverId > 0",syncedIds]
                                        withSort:nil
                                           inMOC:[self moc]];
        for (Project *proj in delProjects) {
            [[self moc] deleteObject:proj];
        }

    } else if ([[self serviceTag] isEqualToString:SERVICE_URL_GET_PROJECT_BY_ID]) {
        
        // Get the project and update it...
        Project *project = nil;
        NSNumber *serverId = [[self parameters] objectForKey:PARAM_KEY_PROJECT_SERVER_ID];
        if (serverId && [serverId integerValue]>0) {
            CoreDataAccessKit *cdak = [CoreDataAccessKit sharedInstance];
            project = (Project*)[cdak findAnObject:NSStringFromClass([Project class])
                                      forPredicate:[NSPredicate predicateWithFormat:@"serverId = %@",serverId]
                                          withSort:nil
                                             inMOC:[self moc]];
        }
        [self syncProjectWithDictionary:responseObject withProject:project];
        
    } else if ([[self serviceTag] isEqualToString:SERVICE_URL_CREATE_PROJECT]) {
        
        // Get a new instance of the project and update it...
        Project *project = nil;
        if ([self project]) {
            CoreDataAccessKit *cdak = [CoreDataAccessKit sharedInstance];
            project = (Project*)[cdak findAnObject:NSStringFromClass([Project class])
                                      forPredicate:[NSPredicate predicateWithFormat:@"SELF = %@",[self project]]
                                          withSort:nil
                                             inMOC:[self moc]];
        }
        [self syncProjectWithDictionary:responseObject withProject:project];
        
    } else if ([[self serviceTag] isEqualToString:SERVICE_URL_UPDATE_PROJECT]) {
        
        // Get a new instance of the project and update it...
        Project *project = nil;
        if ([self project]) {
            CoreDataAccessKit *cdak = [CoreDataAccessKit sharedInstance];
            project = (Project*)[cdak findAnObject:NSStringFromClass([Project class])
                                      forPredicate:[NSPredicate predicateWithFormat:@"SELF = %@",[self project]]
                                          withSort:nil
                                             inMOC:[self moc]];
        }
        [self syncProjectWithDictionary:responseObject withProject:project];
        
    } else if ([[self serviceTag] isEqualToString:SERVICE_URL_DELETE_PROJECT]) {
        
        NSNumber *serverId = [[self parameters] objectForKey:PARAM_KEY_PROJECT_SERVER_ID];
        // Now, find the project and delete it.
        if (serverId && [serverId integerValue]>0) {
            Project *project = (Project*)[[CoreDataAccessKit sharedInstance]
                                          findAnObject:NSStringFromClass([Project class])
                                          forPredicate:[NSPredicate predicateWithFormat:@"serverId = %@",serverId]
                                          withSort:nil
                                          inMOC:[self moc]];
            if (project) { [project deleteAndSave]; }
        }
        
    } else if ([[self serviceTag] isEqualToString:SERVICE_URL_CREATE_VIDEO]) {
        // TODO - Save Video Information???
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
