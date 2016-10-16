//
//  EditProjectDetailsViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 29/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebService, Project;

@interface EditProjectDetailsViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIAlertViewDelegate> {
    UIScrollView *scroller;
    UITextField *fieldTitle;
    UITextView *fieldDesc;
    UIView *textViewsept, *remindView;
    UILabel *projectPhotosLabel;
    WebService *webService;
}

@property (strong,nonatomic) Project *project;
@property (strong,nonatomic) UICollectionView *photosCollection;
@property (strong,nonatomic) NSNumber *useFile;

- (void)showAlertWithMessage:(NSString *)str;

@end
