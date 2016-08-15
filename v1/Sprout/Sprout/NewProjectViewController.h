//
//  NewProjectViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 05/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUtils.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "CameraViewController.h"

@interface NewProjectViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    UIUtils *utils;
    UIScrollView *scroller;
    UITextField *fieldTitle;
    UITextView *fieldDesc;
    UIView *textViewsept, *remindView;
}
@end
