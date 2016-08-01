//
//  EditProjectDetailsViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 29/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUtils.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface EditProjectDetailsViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>{
    UIUtils *utils;
    UIScrollView *scroller;
    UITextField *fieldTitle;
    UITextView *fieldDesc;
    UIView *textViewsept, *remindView;
    UILabel *projectPhotosLabel;
}
@property (strong,nonatomic)NSDictionary *project;
@property (strong,nonatomic)UICollectionView *photosCollection;
@end
