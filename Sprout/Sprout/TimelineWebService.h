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

+ (TimelineWebService*)getSproutImagesForProject:(Project*)project
                                    withCallback:(SproutServiceCallBack)callBack;

+ (TimelineWebService*)getSproutImageById:(Timeline*)timeline
                             withCallback:(SproutServiceCallBack)callBack;

+ (TimelineWebService*)syncTimeline:(Timeline*)timeline
                       withCallback:(SproutServiceCallBack)callBack;

+ (TimelineWebService*)deleteTimeline:(Timeline*)timeline
                         withCallback:(SproutServiceCallBack)callBack;

@end
