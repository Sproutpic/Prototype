//
//  EnablePasscodeViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 21/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUtils.h"

@interface EnablePasscodeViewController : UIViewController<UITextFieldDelegate>{
    UIUtils *utils;
    UITextField *field;
    UILabel *lblPass;
}

@end
