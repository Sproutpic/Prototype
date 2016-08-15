//
//  CameraViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 02/08/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUtils.h"
#import "AppDelegate.h"
#import "EditProjectViewController.h"
#import "SVProgressHUD.h"

@interface CameraViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate>{
    UIUtils *utils;
    UIButton *on,*off,*autoFlash;
}
@property (strong,nonatomic)UIImagePickerController * picker;
@property (strong,nonatomic)UIView * shutterView;
@property (strong,nonatomic)NSDictionary<NSString *,id> * currentInfo;
@property (strong,nonatomic)UIImageView * prevImg;
@property (strong,nonatomic)NSMutableArray * startSprout;

@end
