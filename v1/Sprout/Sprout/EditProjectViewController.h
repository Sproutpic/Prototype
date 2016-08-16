//
//  EditProjectViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 02/08/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUtils.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>
#import "UIImage+animatedGIF.h"
#import "SVProgressHUD.h"
#import <Photos/Photos.h>
#import "AppDelegate.h"
#import "WebService.h"
@class WebService;
#import "FTPManager.h"

@interface EditProjectViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>{
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
    WebService *webService;
    FTPManager *ftpManager;
    NSMutableArray *forSavePaths;
}
@property (strong,nonatomic)UIImage *image;
@property (strong,nonatomic)NSMutableArray * startSprout,*imagesArray;
@property (strong,nonatomic)PHAssetCollection *assetCollection;
@property (strong,nonatomic)__block PHFetchResult *photosAsset;
@property (strong,nonatomic)__block PHAssetCollection *collection;
@property (strong,nonatomic)__block PHObjectPlaceholder *placeholder;
-(void)uploadSuccessful:(NSDictionary *)result;
@end
