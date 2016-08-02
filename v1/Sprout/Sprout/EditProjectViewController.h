//
//  EditProjectViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 02/08/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUtils.h"

@interface EditProjectViewController : UIViewController{
    UIUtils *utils;
    UIScrollView *scroller;
}
@property (strong,nonatomic)UIImage *image;
@end
