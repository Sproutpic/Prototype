//
//  CameraViewController.m
//  Sprout
//
//  Created by Jeff Morris on 10/9/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "CameraViewController.h"
#import "DataObjects.h"
#import "UIUtils.h"

#define FLASH_BUTTON_ON_STR     NSLocalizedString(@"On", @"On")
#define FLASH_BUTTON_OFF_STR    NSLocalizedString(@"Off", @"Off")
#define FLASH_BUTTON_AUTO_STR   NSLocalizedString(@"Auto", @"Auto")

#define PREF_FLASH_ON_BOOL      @"PREF_FLASH_ON_BOOL"
#define PREF_FLASH_OFF_BOOL     @"PREF_FLASH_OFF_BOOL"
#define PREF_FLASH_AUTO_BOOL    @"PREF_FLASH_AUTO_BOOL"

@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong,nonatomic) UIImagePickerController *imgPicker;
@property (strong,nonatomic) UIView *pickerView;
@property (strong,nonatomic) IBOutlet UIView *shutterView;
@property (strong,nonatomic) IBOutlet UIButton *shutterBtn;
@property (strong,nonatomic) UIButton *flashAutoBtn;
@property (strong,nonatomic) UIButton *flashOnBtn;
@property (strong,nonatomic) UIButton *flashOffBtn;

@end

@implementation CameraViewController

# pragma mark Private

- (UIImage *)fixOrientation:(UIImage *)image
{
    // No-op if the orientation is already correct
    // if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch ([image imageOrientation]) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch ([image imageOrientation]) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch ([image imageOrientation]) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    if ([[self imgPicker] cameraDevice] == UIImagePickerControllerCameraDeviceFront){
        img = [UIImage imageWithCGImage:cgimg scale:img.scale orientation:UIImageOrientationUpMirrored];
    }
    
    return img;
}

- (IBAction)switchCameraButtonTapped:(UIButton *)sender
{
    switch ([[self imgPicker] cameraDevice]) {
        case UIImagePickerControllerCameraDeviceFront: {
            [[self imgPicker] setCameraDevice:UIImagePickerControllerCameraDeviceRear];
            [[self project] setFrontCameraEnabled:@(NO)];
        } break;
        case UIImagePickerControllerCameraDeviceRear: {
            [[self imgPicker] setCameraDevice:UIImagePickerControllerCameraDeviceFront];
            [[self project] setFrontCameraEnabled:@(YES)];
        } break;
    }
}

- (IBAction)tappedCloseButton:(UIButton *)sender
{
    [[self navigationController] dismissViewControllerAnimated:YES completion:^{
        if (_cameraCallBack) _cameraCallBack([self project]);
    }];
}

- (IBAction)onAction:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PREF_FLASH_ON_BOOL];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:PREF_FLASH_OFF_BOOL];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:PREF_FLASH_AUTO_BOOL];
    [self configureFlashButtons];
}

- (IBAction)offAction:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:PREF_FLASH_ON_BOOL];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PREF_FLASH_OFF_BOOL];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:PREF_FLASH_AUTO_BOOL];
    [self configureFlashButtons];
}

- (IBAction)autoAction:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:PREF_FLASH_ON_BOOL];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:PREF_FLASH_OFF_BOOL];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PREF_FLASH_AUTO_BOOL];
    [self configureFlashButtons];
}

- (NSAttributedString*)stringAttributes:(NSString*)title withColor:(UIColor*)color
{
    UIFont *font = [UIUtils fontBoldForSize:12];
    return [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
}

- (void)configureButton:(UIButton*)btn withTitle:(NSString*)title asSelected:(BOOL)selected
{
    if (selected) {
        [[btn layer] setBackgroundColor:[[UIColor whiteColor] CGColor]];
        [btn setAttributedTitle:[self stringAttributes:title withColor:[UIUtils colorNavigationBar]] forState:UIControlStateNormal];
    } else {
        [[btn layer] setBackgroundColor:[[UIColor clearColor] CGColor]];
        [btn setAttributedTitle:[self stringAttributes:title withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    }
    [[btn layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[btn layer] setBorderWidth:1.0];
    [[btn layer] setCornerRadius:[btn frame].size.height/2];
    [[btn layer] setMasksToBounds:YES];
}

- (void)configureFlashButtons
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:PREF_FLASH_AUTO_BOOL]) {
        [self configureButton:[self flashOnBtn] withTitle:FLASH_BUTTON_ON_STR asSelected:NO];
        [self configureButton:[self flashOffBtn] withTitle:FLASH_BUTTON_OFF_STR asSelected:NO];
        [self configureButton:[self flashAutoBtn] withTitle:FLASH_BUTTON_AUTO_STR asSelected:YES];
        [[self imgPicker] setCameraFlashMode:UIImagePickerControllerCameraFlashModeAuto];
    } else if ([[NSUserDefaults standardUserDefaults] boolForKey:PREF_FLASH_ON_BOOL]) {
        [self configureButton:[self flashOnBtn] withTitle:FLASH_BUTTON_ON_STR asSelected:YES];
        [self configureButton:[self flashOffBtn] withTitle:FLASH_BUTTON_OFF_STR asSelected:NO];
        [self configureButton:[self flashAutoBtn] withTitle:FLASH_BUTTON_AUTO_STR asSelected:NO];
        [[self imgPicker] setCameraFlashMode:UIImagePickerControllerCameraFlashModeOn];
    } else {
        [self configureButton:[self flashOnBtn] withTitle:FLASH_BUTTON_ON_STR asSelected:NO];
        [self configureButton:[self flashOffBtn] withTitle:FLASH_BUTTON_OFF_STR asSelected:YES];
        [self configureButton:[self flashAutoBtn] withTitle:FLASH_BUTTON_AUTO_STR asSelected:NO];
        [[self imgPicker] setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
    }
}

- (void)saveImage:(UIImage*)saveImg info:(NSDictionary<NSString *,id>*)info completion:(void (^ __nullable)(void))completion
{
    [self showFullScreenSpinner:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *img = [UIImage imageWithData:UIImagePNGRepresentation(saveImg)];
        if (img) {
            NSString *imageName = [Timeline saveImage:img];
            NSString *thumbnailImgName = [Timeline saveThumbnailImage:img];
            if (imageName && thumbnailImgName) {
                dispatch_async(dispatch_get_main_queue(), ^{
                Timeline *tl = [Timeline createNewTimelineWithServerURL:nil forProject:[self project] withMOC:[self moc]];
                    NSDate *now = [NSDate date];
                    [tl setLocalURL:imageName];
                    [tl setLocalThumbnailURL:thumbnailImgName];
                    [tl setLastModified:now];
                    [[tl project] setLastModified:now];
                    [tl save];
                    NSLog(@"Saved new image - %@",imageName);
                    [self showFullScreenSpinner:NO];
                    if (completion) { completion(); }
                });
            } else {
                NSLog(@"Issue trying to save image");
            }
        }
    });
}

# pragma mark Public

- (IBAction)takePictureButtonTapped:(UIButton *)sender
{
    [[self imgPicker] takePicture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

# pragma mark BaseViewController

- (void)setController
{
    [super setController];
    [[self view] setBackgroundColor:[UIColor blackColor]];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self setImgPicker:[[UIImagePickerController alloc] init]];
        //[[[self imgPicker] view] setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
        [[[self imgPicker] view] setFrame:[[self view] bounds]];
        [[self imgPicker] setDelegate:self];
        [[self imgPicker] setAllowsEditing:NO];
        [[self imgPicker] setSourceType:UIImagePickerControllerSourceTypeCamera];
        [[self imgPicker] setCameraDevice:[[[self project] frontCameraEnabled] boolValue]?UIImagePickerControllerCameraDeviceFront:UIImagePickerControllerCameraDeviceRear];
        [[self imgPicker] setShowsCameraControls:NO];
        [[self imgPicker] setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
        [self setPickerView:[[self imgPicker] view]];
    }
    
    UIImage *img = nil;
    NSArray *timelines = [Project timelinesArraySorted:[self project]];
    if ([timelines count]>0) {
        img = [Timeline imageThumbnail:[timelines objectAtIndex:[timelines count]-1]];
    }
    
    UIView *ol = [[UIView alloc] initWithFrame:[[self view] bounds]];
    
    CGRect frame = [[self pickerView] bounds];
    frame.origin.y = (self.view.bounds.size.height-frame.size.width-[self shutterBtn].frame.size.height)/3;
    frame.size.height =  frame.size.width;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    [imgView setImage:img];
    [imgView setAlpha:0.3];
    [imgView setClipsToBounds:YES];
    [imgView setUserInteractionEnabled:NO];
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
    [imgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [ol addSubview:imgView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, imgView.frame.origin.y)];
    [topView setBackgroundColor:[UIColor blackColor]];
    [ol addSubview:topView];
    
    UIView *btmView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.origin.y+frame.size.height, frame.size.width, 500)];
    [btmView setBackgroundColor:[UIColor blackColor]];
    [ol addSubview:btmView];
    
    [[self imgPicker] setCameraOverlayView:ol];
    
    [[[self shutterBtn] layer] setCornerRadius:[self shutterBtn].frame.size.height/2];
    [[[self shutterBtn] layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[[self shutterBtn] layer] setBorderWidth:4.0];
    [[self shutterBtn] setClipsToBounds:YES];
    
    [self configureFlashButtons];
    
//    [[self pickerView] setFrame:
//     CGRectMake(0, (self.view.frame.size.height-[self pickerView].bounds.size.height-[self shutterBtn].frame.size.height)/2,
//                [self pickerView].bounds.size.width, [self pickerView].bounds.size.height)];
    [[self view] insertSubview:[self pickerView] belowSubview:[self shutterView]];
//    CGRect frame = [[self pickerView] frame];
//    frame.size.width = self.view.bounds.size.width;
//    frame.size.height = self.view.bounds.size.width;
//    [[self pickerView] setFrame:frame];

}

- (void)setNavigationBar
{
    [super setNavigationBar];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 32)];
    
    int padding = 10;
    
    UIImageView *bolt = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [bolt setImage:[UIImage imageNamed:@"camera-flash-setting"]];
    [bolt setContentMode:UIViewContentModeCenter];
    [view addSubview:bolt];

    int btnWidth = (view.frame.size.width - bolt.frame.size.width - (padding * 2)) / 3;
    int btnHieght = view.frame.size.height;

    [self setFlashAutoBtn:[[UIButton alloc]initWithFrame:CGRectMake(bolt.frame.size.width, 0, btnWidth, btnHieght)]];
    [[self flashAutoBtn] addTarget:self action:@selector(autoAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:[self flashAutoBtn]];
    
    [self setFlashOffBtn:[[UIButton alloc] initWithFrame:CGRectMake(bolt.frame.size.width + padding + btnWidth, 0, btnWidth, btnHieght)]];
    [[self flashOffBtn] addTarget:self action:@selector(offAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:[self flashOffBtn]];
    
    [self setFlashOnBtn:[[UIButton alloc]initWithFrame:CGRectMake(bolt.frame.size.width + padding * 2 + btnWidth * 2, 0, btnWidth, btnHieght)]];
    [[self flashOnBtn] addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:[self flashOnBtn]];
    
    [[self navigationItem] setTitleView:view];
    [[[self navigationItem] titleView] setUserInteractionEnabled:YES];
}

- (void)addLeftBarButton
{
    [self createCloseNavButton];
}

- (void)addRightBarButton
{
    UIBarButtonItem *swapBtn = [[UIBarButtonItem alloc]
                                initWithImage:[UIImage imageNamed:@"camera-swap"]
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(switchCameraButtonTapped:)];
    [[self navigationItem] setRightBarButtonItem:swapBtn];
}

# pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *img = [self fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]];
    [self saveImage:img info:info completion:^{
        [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
        if (_cameraCallBack) _cameraCallBack([self project]);
    }];
}

@end
