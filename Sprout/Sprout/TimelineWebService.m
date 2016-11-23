//
//  TimelineWebService.m
//  Sprout
//
//  Created by Jeff Morris on 11/23/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "TimelineWebService.h"
#import "DataObjects.h"

#define SERVICE_URL_GET_TIMELINES       [NSString stringWithFormat:@"%@/GetProjects",SPROUT_API_URL]
#define PARAM_KEY_GET_TIMELINES         @"filteredProjects"
#define PARAM_KEY_GET_TIMELINE_IDS      @"projectIds"

#define SERVICE_URL_GET_TIMLINE_BY_ID   [NSString stringWithFormat:@"%@/GetProjectById",SPROUT_API_URL]

#define SERVICE_URL_CREATE_TIMLINE      [NSString stringWithFormat:@"%@/CreateProject",SPROUT_API_URL]

#define SERVICE_URL_UPDATE_TIMLINE      [NSString stringWithFormat:@"%@/UpdateProject",SPROUT_API_URL]

#define SERVICE_URL_DELETE_TIMLINE      [NSString stringWithFormat:@"%@/DeleteProject",SPROUT_API_URL]

#define PARAM_KEY_PROJECT_SERVER_ID     @"projectId"
#define PARAM_KEY_TIMELINE_SERVER_ID    @"sproutId"

@implementation TimelineWebService

# pragma mark TimelineWebService

+ (TimelineWebService*)getSproutImagesForProject:(Project*)project
                                    withCallback:(SproutServiceCallBack)callBack
{
    TimelineWebService *service = [[TimelineWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:SERVICE_URL_GET_TIMELINES];
    [service setParameters:@{ PARAM_KEY_PROJECT_SERVER_ID : [project serverId] }];
    [service setServiceTag:SERVICE_URL_GET_TIMELINES];
    [service setOauthEnabled:YES];
    return service;
}

+ (TimelineWebService*)getSproutImageById:(Timeline*)timeline
                             withCallback:(SproutServiceCallBack)callBack
{
    TimelineWebService *service = [[TimelineWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:SERVICE_URL_GET_TIMLINE_BY_ID];
    [service setParameters:@{ PARAM_KEY_TIMELINE_SERVER_ID : [timeline serverId] }];
    [service setServiceTag:SERVICE_URL_GET_TIMLINE_BY_ID];
    [service setOauthEnabled:YES];
    return service;
}

+ (TimelineWebService*)syncTimeline:(Timeline*)timeline
                       withCallback:(SproutServiceCallBack)callBack
{
    return nil;
}

+ (TimelineWebService*)deleteTimeline:(Timeline*)timeline
                         withCallback:(SproutServiceCallBack)callBack
{
    TimelineWebService *service = [[TimelineWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:SERVICE_URL_DELETE_TIMLINE];
    [service setParameters:@{ PARAM_KEY_TIMELINE_SERVER_ID : [timeline serverId] }];
    [service setServiceTag:SERVICE_URL_DELETE_TIMLINE];
    [service setOauthEnabled:YES];
    return service;
}

# pragma mark Sync Methods

- (NSNumber*)syncTimelineWithDictionary:(NSDictionary*)timelineDict withTimeline:(Timeline*)timeline
{
    NSNumber *serverId = @(0);
    if (timelineDict) {

    }
    return serverId;
}

# pragma mark SproutWebServiceDelegate

- (void)completedSuccess:(id)responseObject
{
    if ([[self serviceTag] isEqualToString:SERVICE_URL_GET_TIMELINES]) {

    } else if ([[self serviceTag] isEqualToString:SERVICE_URL_GET_TIMLINE_BY_ID]) {

    } else if ([[self serviceTag] isEqualToString:SERVICE_URL_CREATE_TIMLINE]) {

    } else if ([[self serviceTag] isEqualToString:SERVICE_URL_UPDATE_TIMLINE]) {

    } else if ([[self serviceTag] isEqualToString:SERVICE_URL_DELETE_TIMLINE]) {

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
