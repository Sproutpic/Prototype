//
//  EditProjectDetailsViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 29/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUtils.h"

@interface EditProjectDetailsViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>{
    UIUtils *utils;
    UIScrollView *scroller;
    UITextField *fieldTitle;
    UITextView *fieldDesc;
}
@property (strong,nonatomic)NSDictionary *project;

@end
