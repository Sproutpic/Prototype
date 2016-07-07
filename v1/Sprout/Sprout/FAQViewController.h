//
//  FAQViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 06/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUtils.h"


@interface FAQViewController : UIViewController{
    UIUtils *utils;
    NSMutableArray *questions;
    UIScrollView *questionScroller;
}

@end
