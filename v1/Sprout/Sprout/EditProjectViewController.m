//image saver:http://stackoverflow.com/questions/10954380/save-photos-to-custom-album-in-iphones-photo-library
//  EditProjectViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 02/08/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "EditProjectViewController.h"

@implementation EditProjectViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setController];
}
- (void)setController{
    self.view.backgroundColor = [UIColor whiteColor];
    utils = [[UIUtils alloc]init];
    
    [self setNavigationBar];
    [self setupLayout];
}
- (void)setupLayout{
    scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:scroller];
    
    fieldTitle = [[UITextField alloc] initWithFrame:CGRectMake(15, 7, scroller.frame.size.width - 15, 50)];
    fieldTitle.font = [utils fontRegularForSize:18];
    fieldTitle.textColor = [utils colorNavigationBar];
    fieldTitle.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Project Title" attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar], NSFontAttributeName: [utils fontRegularForSize:18]}];
    fieldTitle.tintColor = [utils colorNavigationBar];
    fieldTitle.delegate = self;
    UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(0, 49, fieldTitle.frame.size.width, 1)];
    separator.backgroundColor = [[utils colorNavigationBar]colorWithAlphaComponent:0.5];
    [fieldTitle addSubview:separator];
    [scroller addSubview:fieldTitle];
    
    UILabel *lblDesc = [[UILabel alloc] init];
    lblDesc.font = [utils fontRegularForSize:18];
    lblDesc.textColor = [utils colorNavigationBar];
    lblDesc.text = @"Project Description";
    [lblDesc sizeToFit];
    lblDesc.frame = CGRectMake(15, 17 + fieldTitle.frame.size.height, lblDesc.frame.size.width, lblDesc.frame.size.height);
    [scroller addSubview:lblDesc];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineSpacing = 11.f;
    paraStyle.minimumLineHeight = 11.f;
    paraStyle.maximumLineHeight = 11.f;
    fieldDesc = [[UITextView alloc]initWithFrame:CGRectMake(15, lblDesc.frame.origin.y + lblDesc.frame.size.height + 15, scroller.frame.size.width - 15, 0)];
    fieldDesc.tintColor = [utils colorNavigationBar];
    fieldDesc.delegate = self;
    fieldDesc.attributedText = [[NSAttributedString alloc] initWithString:@"This is a description about this project, telling what user is tracking here and any other information user is willing to note down about it." attributes:@{NSFontAttributeName: [utils fontRegularForSize:16], NSForegroundColorAttributeName: [UIColor colorWithRed:67.f/255.f green:61.f/255.f blue:60.f/255.f alpha:1.f], NSParagraphStyleAttributeName: paraStyle}];
    CGRect rect = [fieldDesc.attributedText boundingRectWithSize:CGSizeMake(fieldDesc.frame.size.width - 15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    fieldDesc.frame = CGRectMake(10, fieldDesc.frame.origin.y, fieldDesc.frame.size.width + 5, rect.size.height + 15);
    [scroller addSubview:fieldDesc];
    separator = [[UIView alloc]initWithFrame:CGRectMake(5, fieldDesc.frame.size.height - 1, fieldDesc.frame.size.width, 1)];
    separator.backgroundColor = [[utils colorNavigationBar]colorWithAlphaComponent:0.5];
    textViewsept = separator;
    [fieldDesc addSubview:textViewsept];
    
    /*fieldTag = [[UITextField alloc] initWithFrame:CGRectMake(15, fieldDesc.frame.origin.y + fieldDesc.frame.size.height + 15, scroller.frame.size.width - 15, 50)];
    fieldTag.font = [utils fontRegularForSize:18];
    fieldTag.textColor = [utils colorNavigationBar];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithAttributedString:[[NSAttributedString alloc]initWithString:@"Tag Words " attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar], NSFontAttributeName: [utils fontRegularForSize:18]}]];
    [attrStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"(used for search; separate by coma)" attributes:@{NSFontAttributeName: [utils fontRegularForSize:12], NSForegroundColorAttributeName: [[UIColor grayColor]colorWithAlphaComponent:0.8]}]];
    fieldTag.attributedPlaceholder = attrStr;
    fieldTag.tintColor = [utils colorNavigationBar];
    fieldTag.delegate = self;
    separator = [[UIView alloc]initWithFrame:CGRectMake(0, 49, fieldTitle.frame.size.width, 1)];
    separator.backgroundColor = [[utils colorNavigationBar]colorWithAlphaComponent:0.5];
    [fieldTag addSubview:separator];
    [scroller addSubview:fieldTag];*/
    
    sliderView = [[UIView alloc] initWithFrame:CGRectMake(15, fieldDesc.frame.origin.y + fieldDesc.frame.size.height + 15, scroller.frame.size.width - 15, 75)];
    lblDesc = [[UILabel alloc] init];
    lblDesc.font = [utils fontRegularForSize:16];
    lblDesc.textColor = [utils colorNavigationBar];
    lblDesc.text = @"Slide Duration";
    [lblDesc sizeToFit];
    lblDesc.frame = CGRectMake(0, 0, lblDesc.frame.size.width, lblDesc.frame.size.height);
    [sliderView addSubview:lblDesc];
    separator = [[UIView alloc]initWithFrame:CGRectMake(0, 74, sliderView.frame.size.width, 1)];
    separator.backgroundColor = [[utils colorNavigationBar]colorWithAlphaComponent:0.5];
    [sliderView addSubview:separator];
    slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 25, sliderView.frame.size.width * 0.8, 25)];
    slider.minimumValue = 1;
    slider.maximumValue = 5;
    slider.continuous = YES;
    slider.value = 3;
    slider.tintColor = [utils colorNavigationBar];
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    sliderCounter = [[UILabel alloc] init];
    sliderCounter.text = @"3 sec";
    sliderCounter.textColor = [utils colorNavigationBar];
    sliderCounter.font = [utils fontRegularForSize:16];
    [sliderCounter sizeToFit];
    sliderCounter.frame = CGRectMake(sliderView.frame.size.width * 0.8 + 5, 25 + ((25 - sliderCounter.frame.size.height)/2), sliderCounter.frame.size.width, sliderCounter.frame.size.height);
    [sliderView addSubview:sliderCounter];
    [sliderView addSubview:slider];
    [scroller addSubview:sliderView];
    
    restView = [[UIView alloc] init];
    
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.text = @"PROJECT SPROUT" ;
    lblTitle.textColor = [utils colorNavigationBar];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [utils fontRegularForSize:18];
    [lblTitle sizeToFit];
    lblTitle.frame = CGRectMake(0, 0, self.view.frame.size.width, lblTitle.frame.size.height);
    [restView addSubview:lblTitle];
    
    CGFloat restViewHeight = lblTitle.frame.size.height;
    //self.view.frame.size.width * 0.6
    _startSprout = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tempSprout"] mutableCopy];
    _imagesArray = [[NSMutableArray alloc]init];
    for (NSString *str in _startSprout) {
        [_imagesArray addObject:[UIImage imageWithContentsOfFile:str]];
    }
    _image = _imagesArray[0];
    sprout = [[UIImageView alloc] initWithFrame:CGRectMake(0, lblTitle.frame.origin.y + lblTitle.frame.size.height + 10, scroller.frame.size.width, self.view.frame.size.height - 141)];
    sprout.contentMode = UIViewContentModeScaleAspectFill;
    sprout.image = [self fixOrientation:_image];
    sprout.clipsToBounds = YES;
    sprout.backgroundColor = [UIColor blackColor];
    //self.view.frame.size.width * 0.19
    play = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.405, self.view.frame.size.width * 0.55, self.view.frame.size.width * 0.19, self.view.frame.size.width * 0.19)];
    sprout.userInteractionEnabled = YES;
    isPlaying = NO;
    [sprout addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playSprout:)]];
    play.image = [UIImage imageNamed:@"play-button"];
    [sprout addSubview:play];
    [restView addSubview:sprout];
    
    restViewHeight += 10 + sprout.frame.size.height;
    
    lblTitle = [[UILabel alloc] init];
    lblTitle.text = @"SHARE YOUR SPROUT WITH FRIENDS" ;
    lblTitle.textColor = [utils colorNavigationBar];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [utils fontRegularForSize:15];
    [lblTitle sizeToFit];
    lblTitle.frame = CGRectMake(0, sprout.frame.origin.y + sprout.frame.size.height + 20, self.view.frame.size.width, lblTitle.frame.size.height);
    [restView addSubview:lblTitle];
    
    restViewHeight += lblTitle.frame.size.height + 20;
    
    CGFloat lastY = 0;
    for (int i = 0; i < 5; i++) {
        UIImageView *imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(i * (self.view.frame.size.width / 5), lblTitle.frame.origin.y + lblTitle.frame.size.height + 13, self.view.frame.size.width / 5, self.view.frame.size.width * 0.11)];
        lastY = imageIcon.frame.origin.y + imageIcon.frame.size.height;
        imageIcon.contentMode = UIViewContentModeScaleAspectFit;
        imageIcon.userInteractionEnabled = YES;
        imageIcon.tag = i;
        [imageIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIcon:)]];
        switch (i) {
            case 0:
                imageIcon.image = [UIImage imageNamed:@"Facebook"];
                restViewHeight += self.view.frame.size.width * 0.11 + 13;
                break;
            case 1:
                imageIcon.image = [UIImage imageNamed:@"inst"];
                break;
            case 2:
                imageIcon.image = [UIImage imageNamed:@"youtube"];
                break;
            case 3:
                imageIcon.image = [UIImage imageNamed:@"Twit"];
                break;
            case 4:
                imageIcon.image = [UIImage imageNamed:@"logo-on"];
                break;
            default:
                break;
        }
        [restView addSubview:imageIcon];
    }
    restView.frame = CGRectMake(0, sliderView.frame.origin.y + sliderView.frame.size.height + 15, scroller.frame.size.width, restViewHeight);
    [scroller addSubview:restView];
    [self updateScroller];
}
- (void)playSprout:(UITapGestureRecognizer *)sender{
    if (!isPlaying) {
        isPlaying = YES;
        [play removeFromSuperview];
        [self showProgress];
        self.view.userInteractionEnabled = NO;
        _startSprout = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tempSprout"] mutableCopy];
        NSMutableArray *imagesArray = [[NSMutableArray alloc]init];
        for (NSString *str in _startSprout) {
            [imagesArray addObject:[UIImage imageWithContentsOfFile:str]];
        }
        NSUInteger kFrameCount = _startSprout.count;
        NSNumber *duration = [NSNumber numberWithFloat:slider.value/imagesArray.count];
        NSDictionary *fileProperties = @{
                                         (__bridge id)kCGImagePropertyGIFDictionary: @{
                                                 (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                                 }
                                         };
        NSDictionary *frameProperties = @{
                                          (__bridge id)kCGImagePropertyGIFDictionary: @{
                                                  (__bridge id)kCGImagePropertyGIFDelayTime: duration, // a float (not double!) in seconds, rounded to centiseconds in the GIF data
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
        }else{
            [SVProgressHUD dismiss];
            self.view.userInteractionEnabled = YES;
        }
        CFRelease(destination);
        sprout.image = [UIImage animatedImageWithAnimatedGIFURL:fileURL];
        NSLog(@"GIFurl=%@", fileURL);
    }else{
        isPlaying = NO;
        [sprout addSubview:play];
        sprout.image = _image;
    }
}
- (void)tapIcon:(UITapGestureRecognizer *)sender{
    ((UIImageView *)sender.view).image = sender.view.tag == 0 ? ([((UIImageView *)sender.view).image isEqual:[UIImage imageNamed:@"Facebook"]] ? [UIImage imageNamed:@"Facebook-on"] : [UIImage imageNamed:@"Facebook"]) : (((UIImageView *)sender.view).image = sender.view.tag == 1 ? ([((UIImageView *)sender.view).image isEqual:[UIImage imageNamed:@"Inst-on"]] ? [UIImage imageNamed:@"inst"] : [UIImage imageNamed:@"Inst-on"]) : ((((UIImageView *)sender.view).image = sender.view.tag == 2 ? ([((UIImageView *)sender.view).image isEqual:[UIImage imageNamed:@"Youtube-on"]] ? [UIImage imageNamed:@"youtube"] : [UIImage imageNamed:@"Youtube-on"]) : ((((UIImageView *)sender.view).image = sender.view.tag == 3 ? ([((UIImageView *)sender.view).image isEqual:[UIImage imageNamed:@"Twit-on"]] ? [UIImage imageNamed:@"Twit"] : [UIImage imageNamed:@"Twit-on"]) : ([((UIImageView *)sender.view).image isEqual:[UIImage imageNamed:@"logo"]] ? [UIImage imageNamed:@"logo-on"] : [UIImage imageNamed:@"logo"]))))));
}
-(void)updateScroller{
    scroller.contentSize = CGSizeMake(scroller.frame.size.width,restView.frame.origin.y + restView.frame.size.height);
}
- (IBAction)sliderAction:(UISlider *)sender{
    int rounded = sender.value;  //Casting to an int will truncate, round down
    [sender setValue:rounded animated:NO];
    sliderCounter.text = [NSString stringWithFormat:@"%d sec",rounded];
    [sliderCounter sizeToFit];
    sliderCounter.frame = CGRectMake(sliderView.frame.size.width * 0.8 + 5, 25 + ((25 - sliderCounter.frame.size.height)/2), sliderCounter.frame.size.width, sliderCounter.frame.size.height);
    if (isPlaying) {
        [self showProgress];
        self.view.userInteractionEnabled = NO;
        _startSprout = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tempSprout"] mutableCopy];
        NSMutableArray *imagesArray = [[NSMutableArray alloc]init];
        for (NSString *str in _startSprout) {
            [imagesArray addObject:[UIImage imageWithContentsOfFile:str]];
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSUInteger kFrameCount = _startSprout.count;
        NSNumber *duration = [NSNumber numberWithFloat:slider.value/imagesArray.count];
        NSDictionary *fileProperties = @{
                                         (__bridge id)kCGImagePropertyGIFDictionary: @{
                                                 (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                                 }
                                         };
        NSDictionary *frameProperties = @{
                                          (__bridge id)kCGImagePropertyGIFDictionary: @{
                                                  (__bridge id)kCGImagePropertyGIFDelayTime: duration, // a float (not double!) in seconds, rounded to centiseconds in the GIF data
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
        }else{
            [SVProgressHUD dismiss];
            self.view.userInteractionEnabled = YES;
        }
        CFRelease(destination);
        sprout.image = [UIImage animatedImageWithAnimatedGIFURL:fileURL];
        NSLog(@"GIFurl=%@", fileURL);
        });
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"This is a description about this project, telling what user is tracking here and any other information user is willing to note down about it."]) {
        textView.text = @"";
    }
    [UIView animateWithDuration:0.2 animations:^{
        textViewsept.frame = CGRectMake(textView.frame.size.width, fieldDesc.frame.size.height - 1, 0, 1);
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([[textView.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        textView.text = @"This is a description about this project, telling what user is tracking here and any other information user is willing to note down about it.";
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineSpacing = 11.f;
    paraStyle.minimumLineHeight = 11.f;
    paraStyle.maximumLineHeight = 11.f;
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:@{NSFontAttributeName: [utils fontRegularForSize:16], NSForegroundColorAttributeName: [UIColor colorWithRed:67.f/255.f green:61.f/255.f blue:60.f/255.f alpha:1.f], NSParagraphStyleAttributeName: paraStyle}];
    CGRect rect = [textView.attributedText boundingRectWithSize:CGSizeMake(textView.frame.size.width - 15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    [UIView animateWithDuration:0.2 animations:^{
        textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, rect.size.height + 15);
        textViewsept.frame = CGRectMake(5, textView.frame.size.height - 1, textView.frame.size.width, 1);
        //fieldTag.frame = CGRectMake(15, fieldDesc.frame.origin.y + fieldDesc.frame.size.height + 15, scroller.frame.size.width - 15, 50);
        sliderView.frame = CGRectMake(15, fieldDesc.frame.origin.y + fieldDesc.frame.size.height + 15, scroller.frame.size.width - 15, 75);
        restView.frame = CGRectMake(0, sliderView.frame.origin.y + sliderView.frame.size.height + 15, scroller.frame.size.width, restView.frame.size.height);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 animations:^{
            [self updateScroller];
        }];
    }];
}
- (void)setNavigationBar{
    [self setTitleViewForNavBar];
    [self addLeftBarButton];
    [self addRightBarButton];
}
- (void)addLeftBarButton{
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [back setBackgroundImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = barButton;
}
- (void)addRightBarButton{
    UIButton *download = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [download setBackgroundImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:download];
    self.navigationItem.rightBarButtonItem = barButton;
}
- (IBAction)backToMenu:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setTitleViewForNavBar{
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [utils attrString:@"SproutPic" withFont:[utils fontForNavBarTitle] color:[UIColor whiteColor] andCharSpacing:[NSNumber numberWithInt:0]];
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    
    self.navigationItem.titleView = label;
}
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (UIImage *)fixOrientation:(UIImage *)image {
    
    // No-op if the orientation is already correct
    //if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
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
    
    switch (image.imageOrientation) {
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
    switch (image.imageOrientation) {
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
    img = [UIImage imageWithCGImage:cgimg scale:img.scale orientation:UIImageOrientationUpMirrored];
    return img;
}
- (void)showProgress{
    [[SVProgressHUD appearance] setDefaultStyle:SVProgressHUDStyleCustom];
    [[SVProgressHUD appearance] setForegroundColor:[UIColor colorWithRed:101.0f/255.0f green:179.0f/255.0f blue:179.0f/255.0f alpha:1.0f]];
    [[SVProgressHUD appearance] setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD show];
}
@end
