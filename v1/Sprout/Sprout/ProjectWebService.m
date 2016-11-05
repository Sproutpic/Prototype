//
//  ProjectWebService.m
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "ProjectWebService.h"
#import "DataObjects.h"

@implementation ProjectWebService

# pragma mark ProjectWebService

+ (ProjectWebService*)uploadSprout:(Project*)project
                  forUserWithEmail:(NSString*)email
                      withCallback:(SproutServiceCallBack)callBack
{
    ProjectWebService *service = [[ProjectWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:[NSString stringWithFormat:@"%@/UploadSprout",SPROUT_API_URL]];
    [service setParameters:@{ @"title" : [project title],
                              @"description" : [project subtitle],
                              @"userName" : email,
                              @"pathToImagesFolder" : @"",
                              @"sproutFileName" : @"",
                              @"framesPerMinute" : @(30),
                              @"startDt" : [project created],
                              @"endDt" : [project created]
                              }];
    [service start];
    return service;
}


+ (ProjectWebService*)updateSprout:(Project*)project
                  forUserWithEmail:(NSString*)email
                      withCallback:(SproutServiceCallBack)callBack
{
    ProjectWebService *service = [[ProjectWebService alloc] init];
    [service setServiceCallBack:callBack];
    [service setUrl:[NSString stringWithFormat:@"%@/UpdateSprout",SPROUT_API_URL]];
    [service setParameters:@{ @"sproutId" : @([[project serverId] longLongValue]),
                              @"title" : [project title],
                              @"description" : [project subtitle],
                              @"userName" : email,
                              @"pathToImagesFolder" : @"",
                              @"sproutFileName" : @"",
                              @"framesPerMinute" : @(30),
                              @"startDt" : [project created],
                              @"endDt" : [project created]
                              }];
    [service start];
    return service;
}

@end
