//
//  WebService.h
//  Sprout
//
//  Created by LLDM 0038 on 05/08/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "SignUpViewController.h"
@class SignUpViewController;
#import "SignInViewController.h"
@class SignInViewController;
#import "URLUtils.h"

@interface WebService : NSObject{
    NSString *fromRequest;
}
@property (strong,nonatomic)SignUpViewController *signUpController;
@property (strong,nonatomic)SignInViewController *signInController;

- (void)requestSignUpUser:(NSDictionary *)params withTarget:(SignUpViewController *)controller;
- (void)requestSignInUser:(NSDictionary *)params withTarget:(SignInViewController *)controller;
@end
