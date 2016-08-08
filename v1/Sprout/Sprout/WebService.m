//
//  WebService.m
//  Sprout
//
//  Created by LLDM 0038 on 05/08/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "WebService.h"

@implementation WebService
- (void)requestSignUpUser:(NSDictionary *)params withTarget:(SignUpViewController *)controller{
    fromRequest = @"requestSignUpUser";
    [self getRequestFromUrl:[[[URLUtils alloc]init] urlCreateUser] withParams:params];
    _signUpController = controller;    
}
- (void)requestSignInUser:(NSDictionary *)params withTarget:(SignInViewController *)controller{
    fromRequest = @"requestSignInUser";
    [self getRequestFromUrl:[[[URLUtils alloc]init] urlLoginUser] withParams:params];
    _signInController = controller;
}

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
        appDel.window.userInteractionEnabled = YES;
        NSLog(@"RESPONSE: %@", responseObject);
        [self recieveResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [SVProgressHUD dismiss];
        appDel.window.userInteractionEnabled = YES;
        NSLog(@"ERROR: %@", error);
        [self errorConnection:error];
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
              [self errorConnection:error];
          }];
}
-(void)recieveResponse: (id)responseObject{
    if ([[responseObject objectForKey:@"Succeeded"] boolValue]) {
        if ([fromRequest isEqualToString:@"requestSignUpUser"]) {
            [_signUpController signUpSuccess];
        }else if ([fromRequest isEqualToString:@"requestSignInUser"]) {
            [_signInController signInSuccess];
        }
    }else{
        if ([fromRequest isEqualToString:@"requestSignUpUser"]) {
            [_signUpController showAlertWithMessage:((NSArray *)[responseObject objectForKey:@"Errors"])[0]];
        }else if ([fromRequest isEqualToString:@"requestSignInUser"]) {
            [_signInController showAlertWithMessage:((NSArray *)[responseObject objectForKey:@"Errors"])[0]];
        }
    }
}
-(void)errorConnection:(NSError *)error{
    if ([fromRequest isEqualToString:@"requestSignUpUser"]) {
        [_signUpController showAlertWithMessage:@"Error Connection"];
    }else if ([fromRequest isEqualToString:@"requestSignInUser"]) {
        [_signInController showAlertWithMessage:[NSString stringWithFormat:@"%@",[error description]]];
    }
    
}
- (void)showProgress{
    [[SVProgressHUD appearance] setDefaultStyle:SVProgressHUDStyleCustom];
    [[SVProgressHUD appearance] setForegroundColor:[UIColor colorWithRed:101.0f/255.0f green:179.0f/255.0f blue:179.0f/255.0f alpha:1.0f]];
    [[SVProgressHUD appearance] setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD show];
}
@end
