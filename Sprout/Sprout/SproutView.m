//
//  SproutView.m
//  Sprout
//
//  Created by Jeff Morris on 10/26/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SproutView.h"

#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "DataObjects.h"
#import "UIImage+animatedGIF.h"
#import "SDWebImage/UIImageView+WebCache.h"

#define DEFAULT_IMAGE_NAME      @"logo-white"
#define DEFAULT_BTN_IMAGE_NAME  @"button-play"

#define KVO_PROJECT_SLIDE_TIME  @"slideTime"
#define KVO_PROJECT_TIMELINES   @"timelines"

@interface SproutView () <CAAnimationDelegate>

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *playButton;

@end

@implementation SproutView

# pragma mark Private

- (NSArray*)timelinesSorted
{
    return [[self project] timelinesArraySortedOldestToNewest];
}

- (void)playSprout
{
    [self playSproutView];
}

- (void)playSproutGIF
{
    if ([[[self project] playing] boolValue]) {
        NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
        NSArray *timelines = [self timelinesSorted];
        for (Timeline *timeline in timelines) {
            UIImage *timelineImage = [timeline imageThumbnail];
            if (timelineImage) {
                [imagesArray addObject:timelineImage];
            }
        }
        NSUInteger kFrameCount = [imagesArray count];
        NSNumber *duration = [NSNumber numberWithFloat:[[[self project] slideTime] floatValue]];
        NSDictionary *fileProperties =
        @{ (__bridge id)kCGImagePropertyGIFDictionary: @{
                   // 0 means loop forever
                   (__bridge id)kCGImagePropertyGIFLoopCount: @0 }
           };
        NSDictionary *frameProperties =
        @{ (__bridge id)kCGImagePropertyGIFDictionary: @{
                   // A float (not double!) in seconds, rounded to centiseconds in the GIF data
                   (__bridge id)kCGImagePropertyGIFDelayTime: duration }
           };
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.gif"];
        CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
        CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
        for (NSUInteger i = 0; i < kFrameCount; i++) {
            @autoreleasepool {
                // UIImage *image = frameImage(CGSizeMake(300, 300), M_PI * 2 * i / kFrameCount);
                CGImageDestinationAddImage(destination, ((UIImage *)[imagesArray objectAtIndex:i]).CGImage, (__bridge CFDictionaryRef)frameProperties);
            }
        }
        
        if (!CGImageDestinationFinalize(destination)) {
            NSLog(@"failed to finalize image destination");
        }
        CFRelease(destination);
        
        [[self imageView] setContentMode:UIViewContentModeScaleAspectFill];
        [[self imageView] setImage:[UIImage animatedImageWithAnimatedGIFURL:fileURL]];
        [[self playButton] setImage:nil forState:UIControlStateNormal];
    } else {
        NSArray *timelines = [self timelinesSorted];
        if ([timelines count]>0) {
            Timeline *timeline = [timelines objectAtIndex:0];
            UIImage *timelineImage = [timeline imageThumbnail];
            if (timelineImage) {
                [[self imageView] setContentMode:UIViewContentModeScaleAspectFill];
                [[self imageView] setImage:timelineImage];
            } else {
                [[self imageView] setContentMode:UIViewContentModeCenter];
                [[self imageView] setImage:[UIImage imageNamed:DEFAULT_IMAGE_NAME]];
            }
        } else {
            [[self imageView] setContentMode:UIViewContentModeCenter];
            [[self imageView] setImage:[UIImage imageNamed:DEFAULT_IMAGE_NAME]];
        }
        [[self playButton] setImage:[UIImage imageNamed:DEFAULT_BTN_IMAGE_NAME] forState:UIControlStateNormal];
    }
}

- (UIImage*)sproutFirstImage
{
    UIImage *img = nil;
    NSArray *timelines = [self timelinesSorted];
    if (timelines && [timelines count]>0) {
        Timeline *timeline = [timelines objectAtIndex:0];
        img = [timeline imageThumbnail];
        [[self imageView] setContentMode:UIViewContentModeScaleAspectFill];
    }
    if (!img) {
        [[self imageView] setContentMode:UIViewContentModeCenter];
        img = [UIImage imageNamed:DEFAULT_IMAGE_NAME];
    }
    return img;
}

- (void)playSproutView
{
    if ([[[self project] playing] boolValue]) {
        NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
        NSArray *timelines = [self timelinesSorted];
        for (Timeline *timeline in timelines) {
            UIImage *timelineImage = [timeline imageThumbnail];
            if (timelineImage) {
                [imagesArray addObject:timelineImage];
            }
            [[self imageView] setContentMode:UIViewContentModeScaleAspectFill];
        }
        if ([imagesArray count]<=0) {
            [imagesArray addObject:[self sproutFirstImage]];
        }
        [[self imageView] setAnimationImages:imagesArray];
        [[self imageView] setAnimationDuration:[[[self project] slideTime] floatValue]*[imagesArray count]];
        [[self imageView] startAnimating];
        
        [[self playButton] setImage:nil forState:UIControlStateNormal];
    } else {
        [[self imageView] stopAnimating];
        [[self imageView] setImage:[self sproutFirstImage]];
        [[self playButton] setImage:[UIImage imageNamed:DEFAULT_BTN_IMAGE_NAME] forState:UIControlStateNormal];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:KVO_PROJECT_SLIDE_TIME]) {
        if ([[[self project] playing] boolValue]) {
            [[self imageView] stopAnimating];
            NSArray *timelines = [self timelinesSorted];
            [[self imageView] setAnimationDuration:[[[self project] slideTime] floatValue]*[timelines count]];
            [[self imageView] startAnimating];
        }
    } else if ([keyPath isEqualToString:KVO_PROJECT_TIMELINES]) {
        if ([[[self project] playing] boolValue]) {
            [self playSproutView];
        } else if ([object isDeleted]) {
            [self playSproutView];
        }
    }
}

- (void)dealloc
{
    if (_project) {
        [_project removeObserver:self forKeyPath:KVO_PROJECT_SLIDE_TIME];
        [_project removeObserver:self forKeyPath:KVO_PROJECT_TIMELINES];
    }
}

# pragma mark Public

- (IBAction)playButtonTapped:(id)sender
{
    [[self project] setPlaying:@(![[[self project] playing] boolValue])];
    [[self project] save];
    [self playSprout];
}

- (void)setProject:(Project *)project
{
    if (_project) {
        [_project removeObserver:self forKeyPath:KVO_PROJECT_SLIDE_TIME];
        [_project removeObserver:self forKeyPath:KVO_PROJECT_TIMELINES];
    }
    _project = project;
    [self layoutSubviews];
    if (_project) {
        [_project addObserver:self
                   forKeyPath:KVO_PROJECT_SLIDE_TIME
                      options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                      context:NULL];
        
        [_project addObserver:self
                   forKeyPath:KVO_PROJECT_TIMELINES
                      options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                      context:NULL];
    }
}

# pragma mark UIView

- (void)layoutSubviews
{
    if ([self imageView]==nil) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:[self bounds]];
        [iv setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
        [iv setContentMode:UIViewContentModeScaleAspectFill];
        [iv setClipsToBounds:YES];
        [iv setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.25]];
        [self setImageView:iv];
        [self addSubview:[self imageView]];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:[self bounds]];
        [btn setContentMode:UIViewContentModeCenter];
        [btn setAutoresizingMask:[[self imageView] autoresizingMask]];
        [btn addTarget:self action:@selector(playButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor clearColor]];
        [self setPlayButton:btn];
        [self addSubview:[self playButton]];

        [[self layer] setCornerRadius:10.0];
        [[self layer] setMasksToBounds:YES];
    }
    
    [self playSprout]; // This will setup the rest of the view for the current play state
}

@end
