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
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSUserDefaults standardUserDefaults]setObject:@[] forKey:@"savedSprout"];
    UIButton *btnStart = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 100, 30)];
    [btnStart setAttributedTitle:[[NSAttributedString alloc] initWithString:@"New Sprout" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}] forState:UIControlStateNormal];
    [btnStart addTarget:self action:@selector(startSprout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnStart];
    btnStart = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 140, 20, 120, 30)];
    [btnStart setAttributedTitle:[[NSAttributedString alloc] initWithString:@"New Self Sprout" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}] forState:UIControlStateNormal];
    [btnStart addTarget:self action:@selector(startSelfSprout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnStart];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _savedSproutView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50) collectionViewLayout:layout];
    [_savedSproutView setDataSource:self];
    [_savedSproutView setDelegate:self];
    
    [_savedSproutView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_savedSproutView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:_savedSproutView];
    // Do any additional setup after loading the view.
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"savedSprout"]).count;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    imgView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",((NSArray *)[((NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"savedSprout"]) objectAtIndex:indexPath.row])[0]]];
    imgView.layer.cornerRadius = 3;
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [cell addSubview:imgView];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_savedSproutView.frame.size.width * 0.3, _savedSproutView.frame.size.height * 0.3);
}
-(IBAction)startSelfSprout:(id)sender{
    //_startSprout = [[NSMutableArray alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"tempSprout"];
    _isPlaying = [NSNumber numberWithBool:NO];
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _picker.allowsEditing = NO;
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    UIToolbar *toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width, 55)];
    
    toolBar.barStyle =  UIBarStyleDefault;
    UIButton * switchCameraBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [switchCameraBtn setImage:[UIImage imageNamed:@"circle-outline-xxl"] forState:UIControlStateNormal];
    [switchCameraBtn addTarget:self action:@selector(cirlcePicture) forControlEvents:UIControlEventTouchUpInside];
    NSArray *items=[NSArray arrayWithObjects:
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel  target:self action:@selector(cancelPicture)],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                    [[UIBarButtonItem alloc] initWithCustomView:switchCameraBtn],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera  target:self action:@selector(shootPicture)],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave  target:self action:@selector(saveSprout)],
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
    _sproutImg.transform = CGAffineTransformMakeScale(-1, 1);
    [overlayView addSubview:_prevImg];
    [overlayView addSubview:_sproutImg];
    // parent view for our overlay
    UIView *cameraView=[[UIView alloc] initWithFrame:self.view.bounds];
    
    _circleView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 4, self.view.frame.size.width / 3, self.view.frame.size.width / 2, self.view.frame.size.width / 2)];
    _circleView.layer.borderColor = [UIColor redColor].CGColor;
    _circleView.layer.borderWidth = 1;
    _circleView.hidden = YES;
    _circleView.layer.cornerRadius = self.view.frame.size.width / 4;
    _circleView.clipsToBounds = YES;
    _circleView.transform = CGAffineTransformMakeScale(-1, 1);
    _circleView.contentMode = UIViewContentModeScaleAspectFit;
    [overlayView addSubview:_circleView];
    [cameraView addSubview:overlayView];
    [cameraView addSubview:toolBar];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO){
        NSLog(@"Camera not available");
        return;
    }
    
    // hide the camera controls
    _picker.showsCameraControls=NO;
    [_picker setCameraOverlayView:cameraView];
    [self presentViewController:_picker animated:YES completion:nil];
}
-(IBAction)startSprout:(id)sender{
    //_startSprout = [[NSMutableArray alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"tempSprout"];
    _isPlaying = [NSNumber numberWithBool:NO];
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _picker.allowsEditing = NO;
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    UIToolbar *toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width, 55)];
    
    toolBar.barStyle =  UIBarStyleDefault;
    UIButton * switchCameraBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [switchCameraBtn setImage:[UIImage imageNamed:@"circle-outline-xxl"] forState:UIControlStateNormal];
    [switchCameraBtn addTarget:self action:@selector(cirlcePicture) forControlEvents:UIControlEventTouchUpInside];
    NSArray *items=[NSArray arrayWithObjects:
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel  target:self action:@selector(cancelPicture)],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                     [[UIBarButtonItem alloc] initWithCustomView:switchCameraBtn],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera  target:self action:@selector(shootPicture)],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave  target:self action:@selector(saveSprout)],
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
    
    _circleView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 4, self.view.frame.size.width / 3, self.view.frame.size.width / 2, self.view.frame.size.width / 2)];
    _circleView.layer.borderColor = [UIColor redColor].CGColor;
    _circleView.layer.borderWidth = 1;
    _circleView.hidden = YES;
    _circleView.layer.cornerRadius = self.view.frame.size.width / 4;
    _circleView.clipsToBounds = YES;
    [overlayView addSubview:_circleView];
    [cameraView addSubview:overlayView];
    [cameraView addSubview:toolBar];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO){
        NSLog(@"Camera not available");
        return;
    }
    
    // hide the camera controls
    _picker.showsCameraControls=NO;
    [_picker setCameraOverlayView:cameraView];
    [self presentViewController:_picker animated:YES completion:nil];
}
- (UIImage *)cropImage:(UIImage *)image withRect:(CGRect)rect {
    CGSize cropSize = rect.size;
    CGFloat widthScale = image.size.width/self.view.bounds.size.width;
    CGFloat heightScale = image.size.height/self.view.bounds.size.height;
    cropSize = CGSizeMake(rect.size.width*widthScale,
                          rect.size.width*widthScale);
    CGPoint pointCrop = CGPointMake(rect.origin.x*widthScale,
                                    rect.origin.y*heightScale);
    rect = CGRectMake(pointCrop.x, pointCrop.y, cropSize.width, cropSize.height);
    CGImageRef subImage = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:subImage];
    CGImageRelease(subImage);
    
    return croppedImage;
}
-(void) shootPicture {
    [_picker takePicture];
}
-(void) cirlcePicture {
    _startSprout = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tempSprout"] mutableCopy];
    if(_startSprout.count == 0){
        if(_circleView.hidden){
            _circleView.hidden = NO;
        }else{
            _circleView.hidden = YES;
        }
    }
}
-(void) playSprout{
    NSLog(@"playing: %@",_isPlaying);
    if ([_isPlaying boolValue]) {
        _isPlaying = [NSNumber numberWithBool:NO];
        NSArray *animationArray=@[];
        _sproutImg.animationImages=animationArray;
        _sproutImg.image = [UIImage new];
        if(!(_circleView.hidden)){
            _circleView.layer.borderWidth = 1;
        }
    }else{
        if(!(_circleView.hidden)){
            _circleView.layer.borderWidth = 0;
            _isPlaying = [NSNumber numberWithBool:YES];
            _startSprout = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tempSprout"] mutableCopy];
            if(_startSprout.count > 0){
                NSMutableArray *imagesArray = [[NSMutableArray alloc]init];
                for (NSString *str in _startSprout) {
                    [imagesArray addObject:[self cropImage:[UIImage imageWithContentsOfFile:str] withRect:CGRectMake(self.view.frame.size.width / 4, self.view.frame.size.height * .25, self.view.frame.size.width * .5, self.view.frame.size.width * .5)]];
                }
                NSArray *animationArray=[NSArray arrayWithArray:imagesArray];
                _sproutImg.image = [UIImage imageWithContentsOfFile:[_startSprout objectAtIndex:0]];
                _circleView.animationImages=animationArray;
                _circleView.animationDuration=animationArray.count * 0.2;
                _circleView.animationRepeatCount=0;
                //[SVProgressHUD show];
                //[self performSelector:@selector(checkAnimate)];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                    [_circleView startAnimating];
                });
            }
        }else{
            _isPlaying = [NSNumber numberWithBool:YES];
            _startSprout = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tempSprout"] mutableCopy];
            NSMutableArray *imagesArray = [[NSMutableArray alloc]init];
            for (NSString *str in _startSprout) {
                [imagesArray addObject:[UIImage imageWithContentsOfFile:str]];
            }
            NSArray *animationArray=[NSArray arrayWithArray:imagesArray];
            _sproutImg.animationImages=animationArray;
            _sproutImg.animationDuration=animationArray.count * 0.2;
            _sproutImg.animationRepeatCount=0;
            //[SVProgressHUD show];
            //[self performSelector:@selector(checkAnimate)];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                [_sproutImg startAnimating];
            });
        }
    }
}
/*- (IBAction)checkAnimate {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        if ([_sproutImg isAnimating]) {
            [SVProgressHUD dismiss];
        }else{
            [self performSelector:@selector(checkAnimate) withObject:nil afterDelay:0.2];
        }
    });
}*/
- (IBAction)cancelPicture {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveSprout {
    if (((NSArray *)[[[NSUserDefaults standardUserDefaults] objectForKey:@"tempSprout"] mutableCopy]).count > 0) {
        [self dismissViewControllerAnimated:YES completion:^{
            NSMutableArray *savedPathList = (NSMutableArray *)[[[NSUserDefaults standardUserDefaults] objectForKey:@"savedSprout"] mutableCopy];
            [savedPathList addObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"tempSprout"]];
            [[NSUserDefaults standardUserDefaults] setObject:savedPathList forKey:@"savedSprout"];
            [_savedSproutView reloadData];
        }];
    }
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
    [SVProgressHUD show];
    self.picker.view.userInteractionEnabled = NO;
    //[_startSprout addObject:[self fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]]];
    _prevImg.image = [self fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]];
    
    NSLog(@"sprout%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"tempSprout"]);
    _startSprout = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tempSprout"] mutableCopy];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *imageData = UIImagePNGRepresentation([self fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]]);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"cached-%lu-%lu.png",(unsigned long)_startSprout.count,(unsigned long)((NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"savedSprout"]).count]];
        
        NSLog((@"pre writing to file"));
        if (![imageData writeToFile:imagePath atomically:NO]){
            NSLog((@"Failed to cache image data to disk"));
        }
        else{
            NSLog(@"the cachedImagedPath is %@",imagePath);
            [_startSprout addObject:imagePath];
            [[NSUserDefaults standardUserDefaults]setObject:_startSprout forKey:@"tempSprout"];
            [SVProgressHUD dismiss];
            self.picker.view.userInteractionEnabled = YES;
        }
    });
    
    if(_picker.cameraDevice == UIImagePickerControllerCameraDeviceFront){
        _prevImg.transform = CGAffineTransformMakeScale(-1, 1);
    }
    
    [_picker dismissViewControllerAnimated:NO completion:^{[self presentViewController:_picker animated:NO completion:^{}];}];
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
