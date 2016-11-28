//
//  TimelineWebService.h
//  Sprout
//
//  Created by Jeff Morris on 11/23/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SproutWebService.h"

@class Project, Timeline;

@interface TimelineWebService : SproutWebService

+ (TimelineWebService*)getSproutImagesForProjectId:(NSNumber*)projectId
                                      withCallback:(SproutServiceCallBack)callBack;

+ (TimelineWebService*)getSproutImageById:(Timeline*)timeline
                             withCallback:(SproutServiceCallBack)callBack;

+ (TimelineWebService*)syncTimeline:(Timeline*)timeline
                       withCallback:(SproutServiceCallBack)callBack;

+ (TimelineWebService*)deleteTimelineId:(NSNumber*)serverId
                           withCallback:(SproutServiceCallBack)callBack;

@end
