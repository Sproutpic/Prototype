//
//  EditProjectViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 02/08/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUtils.h"

@interface EditProjectViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>{
    UIUtils *utils;
    UIScrollView *scroller;
    UITextField *fieldTitle, *fieldTag;
    UITextView *fieldDesc;
    UIView *textViewsept, *sliderView,*restView;
    UILabel *sliderCounter;
    UIImageView *sprout, * play;
}
@property (strong,nonatomic)UIImage *image;
@end
