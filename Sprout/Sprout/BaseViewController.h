//
//  BaseViewController.h
//  Sprout
//
//  Created by Jeff Morris on 10/9/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentUser.h"

@class Project;
@class JVFloatLabeledTextField, JVFloatLabeledTextView;
@class CameraViewController;

@protocol BaseViewControllerDelegate <NSObject>

- (void)setController;
- (void)setNavigationBar;
- (void)addLeftBarButton;
- (void)addRightBarButton;

- (UITableView*)createBaseTableView:(UITableViewStyle)tableStyle;
- (UIWebView*)createBaseWebView;
- (void)addSproutLogoTableFooter:(UITableView*)tableView;
- (UIView*)fakeTableFooter;

@end

@interface BaseViewController : UIViewController <BaseViewControllerDelegate>

typedef void (^ CameraCallBack)(Project *project);

- (void)createSettingsNavButton;
- (void)createEditNavButton;
- (void)createCloseNavButton;
- (void)createDoneNavButton;
- (void)createCancelNavButton;

- (void)showCameraForNewSprout:(Project*)project withCameraCallback:(CameraCallBack)completion;

- (void)displayMessageWithTitle:(NSString*)title andBody:(NSString*)message withHandler:(void (^)(UIAlertAction *action))handler;
- (void)displayMessageWithTitle:(NSString*)title andBody:(NSString*)message;
- (void)displayMessageWithBody:(NSString*)message;
- (void)displayUnderConstructionAlert;

- (void)showFullScreenSpinner:(BOOL)shouldShow;

- (void)roundCornersForView:(UIView*)view;

- (void)themeFloatTextField:(JVFloatLabeledTextField*)textField withBK:(UIView*)view;
- (void)themeFloatTextView:(JVFloatLabeledTextView*)textView withBK:(UIView*)view;

@end
