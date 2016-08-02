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

@interface CameraViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    UIUtils *utils;
    UIButton *on,*off,*autoFlash;
}
@property (strong,nonatomic)UIImagePickerController * picker;
@property (strong,nonatomic)UIView * shutterView;
@end
