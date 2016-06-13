//
//  MainViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 13/06/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"start sprout");
    _startSprout = [[NSMutableArray alloc] init];
    _isPlaying = [NSNumber numberWithBool:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _picker.allowsEditing = NO;
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    UIToolbar *toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width, 55)];
    
    toolBar.barStyle =  UIBarStyleDefault;
    UIButton * switchCameraBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [switchCameraBtn setImage:[UIImage imageNamed:@"switch_camera"] forState:UIControlStateNormal];
    [switchCameraBtn addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    NSArray *items=[NSArray arrayWithObjects:
                    /*[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel  target:self action:@selector(cancelPicture)],*/
                    [[UIBarButtonItem alloc] initWithCustomView:switchCameraBtn],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera  target:self action:@selector(shootPicture)],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay  target:self action:@selector(playSprout)],
                    nil];
    [toolBar setItems:items];
    
    // create the overlay view
    UIView * overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    // important - it needs to be transparent so the camera preview shows through!
    overlayView.opaque=NO;
    overlayView.backgroundColor=[UIColor clearColor];
    _prevImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 140)];
    _prevImg.alpha = 0.3;
    _sproutImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 140)];
    [overlayView addSubview:_prevImg];
    [overlayView addSubview:_sproutImg];
    // parent view for our overlay
    UIView *cameraView=[[UIView alloc] initWithFrame:self.view.bounds];
    [cameraView addSubview:overlayView];
    [cameraView addSubview:toolBar];
    
    _picker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO){
        NSLog(@"Camera not available");
        return;
    }
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _picker.delegate = self;
    
    // hide the camera controls
    _picker.showsCameraControls=NO;
    [_picker setCameraOverlayView:cameraView];
    [self presentViewController:_picker animated:YES completion:nil];
    // Do any additional setup after loading the view.
}
-(void) shootPicture {
    [_picker takePicture];
}
-(void) playSprout{
    NSLog(@"playing: %@",_isPlaying);
    if ([_isPlaying boolValue]) {
        _isPlaying = [NSNumber numberWithBool:NO];
        NSArray *animationArray=@[];
        _sproutImg.animationImages=animationArray;
    }else{
        _isPlaying = [NSNumber numberWithBool:YES];
        NSArray *animationArray=[NSArray arrayWithArray:_startSprout];
        _sproutImg.animationImages=animationArray;
        _sproutImg.animationDuration=0.5;
        _sproutImg.animationRepeatCount=0;
        [_sproutImg startAnimating];
    }
}
- (IBAction)cancelPicture {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)switchCamera {
    NSLog(@"touchme: %ld",(long)_picker.cameraDevice);
    if(_picker.cameraDevice == UIImagePickerControllerCameraDeviceFront){
        _picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }else {
        _picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"didcancel");
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //NSLog(@"info%@",info);
    [_startSprout addObject:[self fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]]];
    _prevImg.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_picker dismissViewControllerAnimated:NO completion:^{[self presentViewController:_picker animated:NO completion:nil];}];
}
-(UIImage *)fixOrientation:(UIImage *)image{
    if (image.imageOrientation == UIImageOrientationUp) {
        return image;
    }
    UIGraphicsBeginImageContextWithOptions(image.size, NO,image.scale);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    [image drawInRect:rect];
    
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
