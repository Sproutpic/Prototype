//
//  CameraViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 02/08/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "CameraViewController.h"

@implementation CameraViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setController];
}
- (void)setController{
    self.view.backgroundColor = [UIColor blackColor];
    utils = [[UIUtils alloc]init];
    
    [self setNavigationBar];
    [self setupLayout];
}
-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    [UIView animateWithDuration:0.2 animations:^{
        appDel.tabBarView.alpha = 0;
    }];
    [self.navigationController.view addSubview:_shutterView];
}
-(void)viewDidDisappear:(BOOL)animated{
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    [UIView animateWithDuration:0.2 animations:^{
        appDel.tabBarView.alpha = 1;
    }];
    [_shutterView removeFromSuperview]; 
}
- (void) setupLayout{
    [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"tempSprout"];
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _picker.allowsEditing = NO;
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    _picker.view.transform = CGAffineTransformMakeScale(1, 1.03);
    _picker.view.frame = CGRectMake(0, -(_picker.view.frame.size.height * .03) - 2, _picker.view.frame.size.width, _picker.view.frame.size.height);
    UIView * overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _picker.view.frame.size.width, _picker.view.frame.size.height)];
    overlayView.opaque=YES;
    overlayView.backgroundColor=[UIColor clearColor];
    _picker.showsCameraControls=NO;
    _shutterView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - self.view.frame.size.height * 0.12) / 2, self.view.frame.size.height * 0.87, self.view.frame.size.height * 0.12, self.view.frame.size.height * 0.12)];
    _shutterView.layer.cornerRadius = _shutterView.frame.size.height * 0.5;
    _shutterView.backgroundColor = [UIColor whiteColor];
    UIButton *shutterButton = [[UIButton alloc]initWithFrame:CGRectMake(_shutterView.frame.size.width * 0.075, _shutterView.frame.size.width * 0.075, _shutterView.frame.size.width * 0.85, _shutterView.frame.size.width * 0.85)];
    shutterButton.backgroundColor = [utils colorNavigationBar];
    shutterButton.clipsToBounds = YES;
    shutterButton.layer.cornerRadius = shutterButton.frame.size.width * 0.5;
    shutterButton.layer.borderWidth = 2;
    [shutterButton addTarget:self action:@selector(shootPicture) forControlEvents:UIControlEventTouchUpInside];
    [_shutterView addSubview:shutterButton];
    _shutterView.clipsToBounds = YES;
    [self.navigationController.view addSubview:_shutterView];
    [self.view addSubview:_picker.view];
    //[self presentViewController:_picker animated:YES completion:nil];
}
-(void) shootPicture {
    [_picker takePicture];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    EditProjectViewController *editController = [[EditProjectViewController alloc] init];
    editController.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.navigationController pushViewController:editController animated:YES];
}
- (void)setNavigationBar{
    [self setTitleViewForNavBar];
    [self addLeftBarButton];
    [self addRightBarButton];
}
- (void)addLeftBarButton{
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [back setBackgroundImage:[UIImage imageNamed:@"exk"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = barButton;
}
- (void)addRightBarButton{
    UIButton *download = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 24)];
    [download setBackgroundImage:[UIImage imageNamed:@"Refresh"] forState:UIControlStateNormal];
    [download addTarget:self action:@selector(switchCamera:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:download];
    self.navigationItem.rightBarButtonItem = barButton;
}
- (IBAction)switchCamera:(UIButton *)sender{
    if(_picker.cameraDevice == UIImagePickerControllerCameraDeviceFront){
        _picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }else {
        _picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
}
- (IBAction)backToMenu:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [_shutterView removeFromSuperview];
}
- (void)setTitleViewForNavBar{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * .5, 44)];
    self.navigationItem.titleView.userInteractionEnabled = YES;
    UIButton *flash = [[UIButton alloc]initWithFrame:CGRectMake(view.frame.size.width * .4, 0, view.frame.size.width * .3, view.frame.size.height)];
    [flash setAttributedTitle:[[NSAttributedString alloc] initWithString:@"off" attributes:@{NSFontAttributeName: [utils fontRegularForSize:14], NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
    [flash addTarget:self action:@selector(offAction:) forControlEvents:UIControlEventTouchUpInside];
    off = flash;
    [view addSubview:off];
    flash = [[UIButton alloc]initWithFrame:CGRectMake(view.frame.size.width * .3 * 2 + view.frame.size.width * .1, 0, view.frame.size.width * .3, view.frame.size.height)];
    [flash setAttributedTitle:[[NSAttributedString alloc] initWithString:@"on" attributes:@{NSFontAttributeName: [utils fontRegularForSize:14], NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
    [flash addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    on = flash;
    [view addSubview:on];
    flash = [[UIButton alloc]initWithFrame:CGRectMake(view.frame.size.width * .1, 0, view.frame.size.width * .3, view.frame.size.height)];
    [flash setAttributedTitle:[[NSAttributedString alloc] initWithString:@"auto" attributes:@{NSFontAttributeName: [utils fontRegularForSize:14], NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
    [flash addTarget:self action:@selector(autoAction:) forControlEvents:UIControlEventTouchUpInside];
    autoFlash = flash;
    [view addSubview:autoFlash];
    UIImageView *bolt = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9.5, view.frame.size.width * 0.1, 25)];
    bolt.image = [UIImage imageNamed:@"Flash setting"];
    [view addSubview:bolt];
    self.navigationItem.titleView = view;
}
-(IBAction)onAction:(UIButton *)sender{
    [self resetFlash];
    [on setAttributedTitle:[[NSAttributedString alloc] initWithString:@"on" attributes:@{NSFontAttributeName: [utils fontBoldForSize:14], NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
    _picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
}
-(IBAction)offAction:(UIButton *)sender{
    [self resetFlash];
    [off setAttributedTitle:[[NSAttributedString alloc] initWithString:@"off" attributes:@{NSFontAttributeName: [utils fontBoldForSize:14], NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
    _picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
}
-(IBAction)autoAction:(UIButton *)sender{
    [self resetFlash];
    [autoFlash setAttributedTitle:[[NSAttributedString alloc] initWithString:@"auto" attributes:@{NSFontAttributeName: [utils fontBoldForSize:14], NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
    _picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
}
-(void)resetFlash{
    [on setAttributedTitle:[[NSAttributedString alloc] initWithString:@"on" attributes:@{NSFontAttributeName: [utils fontRegularForSize:14], NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
    [off setAttributedTitle:[[NSAttributedString alloc] initWithString:@"off" attributes:@{NSFontAttributeName: [utils fontRegularForSize:14], NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
    [autoFlash setAttributedTitle:[[NSAttributedString alloc] initWithString:@"auto" attributes:@{NSFontAttributeName: [utils fontRegularForSize:14], NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
}
@end
