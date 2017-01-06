//
//  BaseViewController.m
//  Sprout
//
//  Created by Jeff Morris on 10/9/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "BaseViewController.h"
#import "SVProgressHUD.h"
#import "UIUtils.h"
#import "TPKeyboardAvoidingTableView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"
#import "CameraViewController.h"
#import "SettingsViewController.h"
#import "DataObjects.h"
#import "CTFeedbackViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface BaseViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Project *tempProject;
@property (strong, nonatomic) NSManagedObjectContext *tempMoc;
@property (strong, nonatomic) CameraCallBack tempCameraCallBack;

@end

@implementation BaseViewController

# pragma mark Private

- (IBAction)tappedSettingsButton:(UIButton *)sender
{
    [UIUtils hapticFeedback];
    [[self navigationController] presentViewController:[[UINavigationController alloc] initWithRootViewController:[[SettingsViewController alloc] init]]
                                              animated:YES
                                            completion:nil];
}

- (IBAction)tappedEditButton:(UIButton *)sender
{
    
}

- (IBAction)tappedCloseButton:(UIButton *)sender
{
    
}

- (IBAction)tappedDoneButton:(UIButton *)sender
{
    
}

- (IBAction)tappedCancelButton:(UIButton *)sender
{
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [self setController];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[self view] isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView*)[self view];
        [scrollView setContentSize:[[self view] bounds].size];
        [scrollView setAlwaysBounceVertical:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

# pragma mark BaseViewController

- (void)createSettingsNavButton
{
    UIBarButtonItem *settingsBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button-settings"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(tappedSettingsButton:)];
    [[self navigationItem] setRightBarButtonItem:settingsBtn];
}

- (void)createEditNavButton
{
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button-pencil"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(tappedEditButton:)];
    [[self navigationItem] setRightBarButtonItem:editBtn];
}

- (void)createCloseNavButton
{
    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc]
                                 initWithImage:[UIImage imageNamed:@"close"]
                                 style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(tappedCloseButton:)];
    [[self navigationItem] setLeftBarButtonItem:closeBtn];
}

- (void)createDoneNavButton
{
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                target:self
                                action:@selector(tappedDoneButton:)];
    [[self navigationItem] setRightBarButtonItem:doneBtn];
}

- (void)createCancelNavButton
{
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                  target:self
                                  action:@selector(tappedCancelButton:)];
    [[self navigationItem] setLeftBarButtonItem:cancelBtn];
}

- (void)showCameraForNewSprout:(Project*)project withCameraCallback:(CameraCallBack)completion
{
    [self setTempProject:project]; // This is so we can retain the MOC...
    [self setTempMoc:[project managedObjectContext]]; // This is so we can retain the MOC...
    [self setTempCameraCallBack:completion];
    
    // TODO - Check to see if the device even has a camera, if not, display an error message
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            CameraViewController *vc = [[CameraViewController alloc] init];
            [vc setProject:[self tempProject]];
            [vc setCameraCallBack:[self tempCameraCallBack]];
            [vc setMoc:[self tempMoc]];
            [[self navigationController] presentViewController:[[UINavigationController alloc] initWithRootViewController:vc]
                                                      animated:YES
                                                    completion:nil];
        } else {
            [self displayMessageWithBody:
             NSLocalizedString(@"To create new Sprout project or add photos to your current projects, you'll need to grant camera access to the SproutPic app in settings.",
                               @"To create new Sprout project or add photos to your current projects, you'll need to grant camera access to the SproutPic app in settings.")];
        }
    }];
}

- (void)displayMessageWithTitle:(NSString*)title andBody:(NSString*)message withHandler:(void (^)(UIAlertAction *action))handler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK")
                                              style:UIAlertActionStyleDefault
                                            handler:handler]];
    [[self navigationController] presentViewController:alert animated:YES completion:nil];
}

- (void)displayMessageWithTitle:(NSString*)title andBody:(NSString*)message
{
    [self displayMessageWithTitle:title andBody:message withHandler:nil];
}

- (void)displayMessageWithBody:(NSString*)message
{
    [self displayMessageWithTitle:nil andBody:message];
}

- (void)displayUnderConstructionAlert
{
    [UIUtils hapticFeedback];
    [self displayMessageWithTitle:NSLocalizedString(@"Next Version", @"Next Version")
                          andBody:NSLocalizedString(@"Under Construction! We'll update this in a future release.",
                                                    @"Under Construction! We'll update this in a future release.")];
}

- (void)showFullScreenSpinner:(BOOL)shouldShow
{
    if (shouldShow) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [[SVProgressHUD appearance] setDefaultStyle:SVProgressHUDStyleCustom];
        [[SVProgressHUD appearance] setForegroundColor:[UIUtils colorNavigationBar]];
        [[SVProgressHUD appearance] setBackgroundColor:[UIColor whiteColor]];
        [[SVProgressHUD appearance] setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
    } else {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [SVProgressHUD dismiss];
    }
}

- (void)roundCornersForView:(UIView*)view
{
    if (view) {
        [[view layer] setMasksToBounds:YES];
        [[view layer] setCornerRadius:5.0];
    }
}

- (void)themeFloatTextField:(JVFloatLabeledTextField*)textField withBK:(UIView*)view
{
    [textField setTintColor:[UIUtils colorNavigationBar]];
    [textField setFloatingLabelTextColor:[UIUtils colorNavigationBar]];
    [textField setFloatingLabelActiveTextColor:[UIUtils colorNavigationBar]];
    [self roundCornersForView:view];
}

- (void)themeFloatTextView:(JVFloatLabeledTextView*)textView withBK:(UIView*)view
{
    [textView setTintColor:[UIUtils colorNavigationBar]];
    [textView setFloatingLabelTextColor:[UIUtils colorNavigationBar]];
    [textView setFloatingLabelActiveTextColor:[UIUtils colorNavigationBar]];
    [self roundCornersForView:view];
}

# pragma mark BaseViewControllerDelegate

- (void)setController
{
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self setNavigationBar];
}

- (void)setNavigationBar
{
    [self setTitle:NSLocalizedString(@"SproutPic", @"SproutPic")];
    [self addLeftBarButton];
    [self addRightBarButton];
}

- (void)addBackBarButton
{
    // Implement in overridding class
}

- (void)addLeftBarButton
{
    // Implement in overridding class
}

- (void)addRightBarButton
{
    // Implement in overridding class
}

- (UITableView*)createBaseTableView:(UITableViewStyle)tableStyle
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:tableStyle];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setTableFooterView:[self fakeTableFooter]];
    return tableView;
}

- (UIWebView*)createBaseWebView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[[self view] bounds]];
    return webView;
}

- (void)showFeedbackViewController:(NSString*)additionalContent
{
    CTFeedbackViewController *cc = [[CTFeedbackViewController alloc]
                                    initWithTopics:@[
                                                     NSLocalizedString(@"General Feedback", @"General Feedback"),
                                                     NSLocalizedString(@"Feature Request", @"Feature Request"),
                                                     NSLocalizedString(@"Bug/Issue", @"Bug/Issue")
                                                     ]
                                    localizedTopics:@[
                                                      NSLocalizedString(@"General Feedback", @"General Feedback"),
                                                      NSLocalizedString(@"Feature Request", @"Feature Request"),
                                                      NSLocalizedString(@"Bug/Issue", @"Bug/Issue")
                                                      ]];
    [cc setUseHTML:YES];
    [cc setToRecipients:@[@"info@sproutpic.com"]];
    if (additionalContent && [additionalContent isKindOfClass:[NSString class]]) {
        [cc setAdditionalDiagnosticContent:additionalContent];
    }
    [[self navigationController] pushViewController:cc animated:YES];
}

- (void)addSproutLogoTableFooter:(UITableView*)tableView
{
    UIImageView *tableFooter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-green"]];
    [tableFooter setFrame:CGRectMake(0, 0, [[self view] bounds].size.width, 100)];
    [tableFooter setContentMode:UIViewContentModeCenter];
    [tableFooter setUserInteractionEnabled:YES];
    [tableView setTableFooterView:tableFooter];
}

- (void)addFeedbackButtonToFooter:(UITableView*)tableView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake([[tableView tableFooterView] bounds].size.width-50, 25, 50, 50)];
    [btn setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [btn setImage:[UIImage imageNamed:@"button-feedback"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showFeedbackViewController:) forControlEvents:UIControlEventTouchUpInside];
    [[tableView tableFooterView] addSubview:btn];
}

- (UIView*)fakeTableFooter
{
    UIView *view = [[UIView alloc] init];
    [view setFrame:CGRectMake(0, 0, 1, 1)];
    return view;
}

# pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseCell = @"UITableViewCellStyleValue1";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:reuseCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseCell];
    }
    return cell;
}

@end
