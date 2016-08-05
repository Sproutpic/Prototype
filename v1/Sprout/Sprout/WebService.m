//
//  WebService.m
//  Sprout
//
//  Created by LLDM 0038 on 05/08/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "WebService.h"

@implementation WebService
//requests
- (void)getRequestFromUrl:(NSString *)url withParams:(NSDictionary *) params{
    AppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    [self showProgress];
    appDel.window.userInteractionEnabled = NO;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        [SVProgressHUD dismiss];
        NSLog(@"RESPONSE: %@", responseObject);
        [self recieveResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [SVProgressHUD dismiss];
        appDel.window.userInteractionEnabled = YES;
        NSLog(@"ERROR: %@", error);
        [self errorConnection];
    }];
}
- (void)postRequestFromUrl:(NSString *)url withParams:(NSDictionary *) params{
    AppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    [self showProgress];
    appDel.window.userInteractionEnabled = NO;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    [manager POST:url parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [SVProgressHUD dismiss];
              appDel.window.userInteractionEnabled = YES;
              NSLog(@"RESPONSE: %@", responseObject);
              [self recieveResponse:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [SVProgressHUD dismiss];
              appDel.window.userInteractionEnabled = YES;
              NSLog(@"ERROR: %@", error);
              [self errorConnection];
          }];
}
-(void)recieveResponse: (id)responseObject{

}
-(void)errorConnection{

}
- (void)showProgress{
    [SVProgressHUD show];
}
@end
