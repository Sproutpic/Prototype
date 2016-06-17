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
    if([[((NSDictionary *)[((NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"savedSprout"]) objectAtIndex:indexPath.row]) objectForKey:@"withCircle"] boolValue]){
            NSMutableArray *imagesArray = [[NSMutableArray alloc]init];
            for (NSString *str in ((NSArray *)[((NSDictionary *)[((NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"savedSprout"]) objectAtIndex:indexPath.row]) objectForKey:@"sprout"])) {
                UIImage *bottomImage = [UIImage imageWithContentsOfFile:[((NSArray *)[((NSDictionary *)[((NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"savedSprout"]) objectAtIndex:indexPath.row]) objectForKey:@"sprout"]) objectAtIndex:0]]; //background image
                UIImage *image       = [self makeRoundCornersWithRadius:self.view.frame.size.width / 4 withImage:[self cropImage:[UIImage imageWithContentsOfFile:str] withRect:CGRectMake(self.view.frame.size.width / 4, self.view.frame.size.height * .25, self.view.frame.size.width * .5, self.view.frame.size.width * .5)]]; //foreground image
                
                CGSize newSize = CGSizeMake(_sproutImg.frame.size.width, _sproutImg.frame.size.height);
                UIGraphicsBeginImageContext( newSize );
                
                // Use existing opacity as is
                [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
                
                // Apply supplied opacity if applicable
                [image drawInRect:CGRectMake(self.view.frame.size.width / 4, self.view.frame.size.width / 3, self.view.frame.size.width * .5, self.view.frame.size.width * .5) blendMode:kCGBlendModeNormal alpha:1];
                
                UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                
                UIGraphicsEndImageContext();
                [imagesArray addObject:newImage];
            }
            NSUInteger kFrameCount = ((NSArray *)[((NSDictionary *)[((NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"savedSprout"]) objectAtIndex:indexPath.row]) objectForKey:@"sprout"]).count;
            NSDictionary *fileProperties = @{
                                             (__bridge id)kCGImagePropertyGIFDictionary: @{
                                                     (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                                     }
                                             };
            NSDictionary *frameProperties = @{
                                              (__bridge id)kCGImagePropertyGIFDictionary: @{
                                                      (__bridge id)kCGImagePropertyGIFDelayTime: @0.2f, // a float (not double!) in seconds, rounded to centiseconds in the GIF data
                                                      }
                                              };
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
            NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"animated%ld.png",(long)indexPath.row]];
            CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
            CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
            for (NSUInteger i = 0; i < kFrameCount; i++) {
                @autoreleasepool {
                    CGImageDestinationAddImage(destination, ((UIImage *)[imagesArray objectAtIndex:i]).CGImage, (__bridge CFDictionaryRef)frameProperties);
                }
            }
            if (!CGImageDestinationFinalize(destination)) {
                NSLog(@"failed to finalize image destination");
            }
            CFRelease(destination);
            imgView.image = [UIImage animatedImageWithAnimatedGIFURL:fileURL];
    }else{
        NSMutableArray *imagesArray = [[NSMutableArray alloc]init];
        for (NSString *str in ((NSArray *)[((NSDictionary *)[((NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"savedSprout"]) objectAtIndex:indexPath.row]) objectForKey:@"sprout"])) {
            [imagesArray addObject:[UIImage imageWithContentsOfFile:str]];
        }
        NSUInteger kFrameCount = ((NSArray *)[((NSDictionary *)[((NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"savedSprout"]) objectAtIndex:indexPath.row]) objectForKey:@"sprout"]).count;
        NSDictionary *fileProperties = @{
                                         (__bridge id)kCGImagePropertyGIFDictionary: @{
                                                 (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                                 }
                                         };
        NSDictionary *frameProperties = @{
                                          (__bridge id)kCGImagePropertyGIFDictionary: @{
                                                  (__bridge id)kCGImagePropertyGIFDelayTime: @0.2f, // a float (not double!) in seconds, rounded to centiseconds in the GIF data
                                                  }
                                          };
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"animated%ld.png",(long)indexPath.row]];
        CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
        CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
        for (NSUInteger i = 0; i < kFrameCount; i++) {
            @autoreleasepool {
                CGImageDestinationAddImage(destination, ((UIImage *)[imagesArray objectAtIndex:i]).CGImage, (__bridge CFDictionaryRef)frameProperties);
            }
        }
        if (!CGImageDestinationFinalize(destination)) {
            NSLog(@"failed to finalize image destination");
        }
        CFRelease(destination);
        NSLog(@"GIFurl=%@", fileURL);
        imgView.image = [UIImage animatedImageWithAnimatedGIFURL:fileURL];
    }
    imgView.layer.cornerRadius = 3;
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [cell addSubview:imgView];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_sproutImg.frame.size.width * 0.3, _sproutImg.frame.size.height * 0.3);
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
    UIButton * onOff = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [onOff setImage:[UIImage imageNamed:@"letter-t"] forState:UIControlStateNormal];
    [onOff addTarget:self action:@selector(onOffOpacity) forControlEvents:UIControlEventTouchUpInside];
    NSArray *items=[NSArray arrayWithObjects:
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel  target:self action:@selector(cancelPicture)],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                    [[UIBarButtonItem alloc] initWithCustomView:switchCameraBtn],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                    [[UIBarButtonItem alloc] initWithCustomView:onOff],
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
    UIButton * onOff = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [onOff setImage:[UIImage imageNamed:@"letter-t"] forState:UIControlStateNormal];
    [onOff addTarget:self action:@selector(onOffOpacity) forControlEvents:UIControlEventTouchUpInside];
    NSArray *items=[NSArray arrayWithObjects:
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel  target:self action:@selector(cancelPicture)],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                     [[UIBarButtonItem alloc] initWithCustomView:switchCameraBtn],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                    [[UIBarButtonItem alloc] initWithCustomView:onOff],
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
-(void) onOffOpacity {
    NSLog(@"cruel");
    if (_prevImg.alpha == (float)0.3) {
        NSLog(@"close");
        _prevImg.alpha = 0;
    }else{
        NSLog(@"cute-%f",_prevImg.alpha);
        _prevImg.alpha = 0.3;
    }
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
            _circleView.image = [UIImage new];
            _circleView.animationImages=@[];
        }
    }else{
        if(!(_circleView.hidden)){
            _circleView.layer.borderWidth = 0;
            _isPlaying = [NSNumber numberWithBool:YES];
            _startSprout = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tempSprout"] mutableCopy];
            if(_startSprout.count > 0){
                _circleView.image = [UIImage new];
                _circleView.alpha = 1;
                NSMutableArray *imagesArray = [[NSMutableArray alloc]init];
                for (NSString *str in _startSprout) {
                    UIImage *bottomImage = [UIImage imageWithContentsOfFile:[_startSprout objectAtIndex:0]]; //background image
                    UIImage *image       = [self makeRoundCornersWithRadius:self.view.frame.size.width / 4 withImage:[self cropImage:[UIImage imageWithContentsOfFile:str] withRect:CGRectMake(self.view.frame.size.width / 4, self.view.frame.size.height * .25, self.view.frame.size.width * .5, self.view.frame.size.width * .5)]]; //foreground image
                    
                    CGSize newSize = CGSizeMake(_sproutImg.frame.size.width, _sproutImg.frame.size.height);
                    UIGraphicsBeginImageContext( newSize );
                    
                    // Use existing opacity as is
                    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
                    
                    // Apply supplied opacity if applicable
                    [image drawInRect:CGRectMake(self.view.frame.size.width / 4, self.view.frame.size.width / 3, self.view.frame.size.width * .5, self.view.frame.size.width * .5) blendMode:kCGBlendModeNormal alpha:1];
                    
                    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                    
                    UIGraphicsEndImageContext();
                    [imagesArray addObject:newImage];
                }
                NSArray *animationArray=[NSArray arrayWithArray:imagesArray];
                NSUInteger kFrameCount = _startSprout.count;
                NSDictionary *fileProperties = @{
                                                 (__bridge id)kCGImagePropertyGIFDictionary: @{
                                                         (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                                         }
                                                 };
                NSDictionary *frameProperties = @{
                                                  (__bridge id)kCGImagePropertyGIFDictionary: @{
                                                          (__bridge id)kCGImagePropertyGIFDelayTime: @0.2f, // a float (not double!) in seconds, rounded to centiseconds in the GIF data
                                                          }
                                                  };
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
                NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.gif"];
                CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
                CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
                for (NSUInteger i = 0; i < kFrameCount; i++) {
                    @autoreleasepool {
                        //UIImage *image = frameImage(CGSizeMake(300, 300), M_PI * 2 * i / kFrameCount);
                        CGImageDestinationAddImage(destination, ((UIImage *)[imagesArray objectAtIndex:i]).CGImage, (__bridge CFDictionaryRef)frameProperties);
                    }
                }
                if (!CGImageDestinationFinalize(destination)) {
                    NSLog(@"failed to finalize image destination");
                }
                CFRelease(destination);
                //_circleView.image = [UIImage animatedImageWithAnimatedGIFURL:fileURL];
                _sproutImg.image = [UIImage animatedImageWithAnimatedGIFURL:fileURL];
                /*_circleView.animationImages=animationArray;
                _circleView.animationDuration=animationArray.count * 0.2;
                _circleView.animationRepeatCount=0;
                //[SVProgressHUD show];
                //[self performSelector:@selector(checkAnimate)];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                    [_circleView startAnimating];
                });*/
            }
        }else{
            _isPlaying = [NSNumber numberWithBool:YES];
            _startSprout = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tempSprout"] mutableCopy];
            NSMutableArray *imagesArray = [[NSMutableArray alloc]init];
            for (NSString *str in _startSprout) {
                [imagesArray addObject:[UIImage imageWithContentsOfFile:str]];
            }
            NSArray *animationArray=[NSArray arrayWithArray:imagesArray];
            NSUInteger kFrameCount = _startSprout.count;
            NSDictionary *fileProperties = @{
                                             (__bridge id)kCGImagePropertyGIFDictionary: @{
                                                     (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                                     }
                                             };
            NSDictionary *frameProperties = @{
                                              (__bridge id)kCGImagePropertyGIFDictionary: @{
                                                      (__bridge id)kCGImagePropertyGIFDelayTime: @0.2f, // a float (not double!) in seconds, rounded to centiseconds in the GIF data
                                                      }
                                              };
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
            NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.gif"];
            CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
            CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
            for (NSUInteger i = 0; i < kFrameCount; i++) {
                @autoreleasepool {
                    //UIImage *image = frameImage(CGSizeMake(300, 300), M_PI * 2 * i / kFrameCount);
                    CGImageDestinationAddImage(destination, ((UIImage *)[imagesArray objectAtIndex:i]).CGImage, (__bridge CFDictionaryRef)frameProperties);
                }
            }
            if (!CGImageDestinationFinalize(destination)) {
                NSLog(@"failed to finalize image destination");
            }
            CFRelease(destination);
           _sproutImg.image = [UIImage animatedImageWithAnimatedGIFURL:fileURL];
            NSLog(@"GIFurl=%@", fileURL);
            /*NSData *mydata = [[NSData alloc] initWithContentsOfURL:fileURL];
            UIImage *myimage = [[UIImage alloc] initWithData:mydata];
            
            _sproutImg.animationImages=@[myimage];;
            _sproutImg.animationDuration=animationArray.count * 0.2;
            _sproutImg.animationRepeatCount=0;
            //[SVProgressHUD show];
            //[self performSelector:@selector(checkAnimate)];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                [_sproutImg startAnimating];
            });*/
        }
    }
}
-(UIImage*)makeRoundCornersWithRadius:(const CGFloat)RADIUS withImage:(UIImage *)image {
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    const CGRect RECT = CGRectMake(0, 0, image.size.width, image.size.height);
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:RECT cornerRadius:RADIUS] addClip];
    // Draw your image
    [image drawInRect:RECT];
    
    // Get the image, here setting the UIImageView image
    //imageView.image
    UIImage* imageNew = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return imageNew;
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
            NSMutableArray *savedSprouts = (NSMutableArray *)[[[NSUserDefaults standardUserDefaults] objectForKey:@"savedSprout"] mutableCopy];
            if(!(_circleView.hidden)){
                [savedSprouts addObject:@{@"sprout":[[NSUserDefaults standardUserDefaults] objectForKey:@"tempSprout"],
                                          @"withCircle":@YES}];
            }else{
                [savedSprouts addObject:@{@"sprout":[[NSUserDefaults standardUserDefaults] objectForKey:@"tempSprout"],
                                          @"withCircle":@NO}];
            }
            [[NSUserDefaults standardUserDefaults] setObject:savedSprouts forKey:@"savedSprout"];
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
    if (![_isPlaying boolValue]) {
        [SVProgressHUD show];
        self.picker.view.userInteractionEnabled = NO;
        //[_startSprout addObject:[self fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]]];
        if(!(_circleView.hidden)){
            _startSprout = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tempSprout"] mutableCopy];
            if (_startSprout.count == 0) {
                int radius = self.view.frame.size.width/4;
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, _prevImg.bounds.size.width, _prevImg.bounds.size.height) cornerRadius:0];
                UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(radius, radius*4/3, 2.0*radius, 2.0*radius) cornerRadius:radius];
                [path appendPath:circlePath];
                [path setUsesEvenOddFillRule:YES];
                CAShapeLayer *maskLayer = [CAShapeLayer layer];
                maskLayer.fillRule  = kCAFillRuleEvenOdd;
                maskLayer.fillColor = [UIColor blackColor].CGColor;
                maskLayer.path      = path.CGPath;
                maskLayer.opacity = 1;
                _prevImg.layer.mask = maskLayer;
                _prevImg.image = [self fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]];
            }
        }else{
            _prevImg.image = [self fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]];
        }
        
        NSLog(@"sprout%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"tempSprout"]);
        _startSprout = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tempSprout"] mutableCopy];
        
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
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
        //});
        
        if(_picker.cameraDevice == UIImagePickerControllerCameraDeviceFront){
            _prevImg.transform = CGAffineTransformMakeScale(-1, 1);
        }
        
        [_picker dismissViewControllerAnimated:NO completion:^{[self presentViewController:_picker animated:NO completion:^{}];}];
    }
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
    
    CGSize newSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 140);
    UIGraphicsBeginImageContext(newSize);
    [normalizedImage drawInRect:CGRectMake(0,0,newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
