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

+ (ProjectWebService*)uploadSprout:(Project*)project
                  forUserWithEmail:(NSString*)email
                      withCallback:(SproutServiceCallBack)callBack;

+ (ProjectWebService*)updateSprout:(Project*)project
                  forUserWithEmail:(NSString*)email
                      withCallback:(SproutServiceCallBack)callBack;

@end
