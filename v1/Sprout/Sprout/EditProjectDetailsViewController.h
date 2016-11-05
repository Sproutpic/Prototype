//
//  EditProjectViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 02/08/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProjectViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate> {
    UIUtils *utils;
    UIScrollView *scroller;
    UITextField *fieldTitle, *fieldTag;
    UITextView *fieldDesc;
    UIView *textViewsept, *sliderView,*restView;
    UILabel *sliderCounter;
    UIImageView *sprout, * play;
    BOOL isPlaying;
    UISlider *slider;
    NSURL *sproutGifUrl;
    NSMutableArray *forSavePaths;
}

@property (strong,nonatomic) UIImage *image;
@property (strong, nonatomic) NSString* imagePath;
@property (strong,nonatomic) NSMutableArray * startSprout,*imagesArray;
@property (strong,nonatomic) PHAssetCollection *assetCollection;
@property (strong,nonatomic)__block PHFetchResult *photosAsset;
@property (strong,nonatomic)__block PHAssetCollection *collection;
@property (strong,nonatomic)__block PHObjectPlaceholder *placeholder;

- (void)uploadSuccessful:(NSDictionary *)result;

@end
