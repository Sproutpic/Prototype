//
//  ProjectWebService.h
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SproutWebService.h"

@class Project;

@interface ProjectWebService : SproutWebService

+ (ProjectWebService*)getAllProjectsWithCallback:(SproutServiceCallBack)callBack;

+ (ProjectWebService*)getProjectById:(NSNumber*)serverId
                        withCallback:(SproutServiceCallBack)callBack;

+ (ProjectWebService*)syncProject:(Project*)project
                     withCallback:(SproutServiceCallBack)callBack;

+ (ProjectWebService*)deleteProjectById:(NSNumber*)serverId
                           withCallback:(SproutServiceCallBack)callBack;

+ (ProjectWebService*)createProjectVideo:(Project*)project
                            withCallback:(SproutServiceCallBack)callBack;

@end
