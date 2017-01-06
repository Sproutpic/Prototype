//
//  SyncWebService.h
//  Sprout
//
//  Created by Jeff Morris on 12/19/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SproutWebService.h"
#import "DataObjects.h"

@interface SyncWebService : SproutWebService

+ (SproutWebService*)syncAllProjectsWithRemoteServerWithCallback:(SproutServiceCallBack)callBack;

+ (SproutWebService*)syncProject:(Project*)project
                    withCallback:(SproutServiceCallBack)callBack;

+ (SproutWebService*)syncTimeLineForProject:(Project*)project
                               withCallback:(SproutServiceCallBack)callBack;

+ (SproutWebService*)syncProjectVideosWithCallback:(SproutServiceCallBack)callBack;

@end
