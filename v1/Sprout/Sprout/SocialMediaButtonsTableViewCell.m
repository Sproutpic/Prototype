//
//  SocialMediaButtonsTableViewCell.m
//  Sprout
//
//  Created by Jeff Morris on 10/21/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SocialMediaButtonsTableViewCell.h"
#import "DataObjects.h"

@interface SocialMediaButtonsTableViewCell ()

- (IBAction)socialButtonTapped:(id)sender;

@end

@implementation SocialMediaButtonsTableViewCell

- (void)configrueButtons
{
    [[self button1] setImage:[UIImage imageNamed:@"button-facebook-off"] forState:UIControlStateNormal];
    [[self button4] setImage:[UIImage imageNamed:@"button-twitter-off"] forState:UIControlStateNormal];

    if ([[[self project] sproutSocial] boolValue]) {
        [[self button1] setEnabled:YES];
        [[self button4] setEnabled:YES];
        [[self button5] setImage:[UIImage imageNamed:@"button-logo-on"] forState:UIControlStateNormal];
    } else {
        [[self button1] setEnabled:NO];
        [[self button4] setEnabled:NO];
        [[self button5] setImage:[UIImage imageNamed:@"button-logo-off"] forState:UIControlStateNormal];
    }
}

- (void)setProject:(Project *)project
{
    _project = project;
    [self configrueButtons];
}

- (IBAction)socialButtonTapped:(id)sender
{
    if ([sender isEqual:[self button1]]) {
        if (_socialMediaCallBack) _socialMediaCallBack(SocialMediaFacebook, [self project]);
    } else if ([sender isEqual:[self button2]]) {
        NSLog(@"Instagram Button Tapped");
    } else if ([sender isEqual:[self button3]]) {
        NSLog(@"YouTube Button Tapped");
    } else if ([sender isEqual:[self button4]]) {
        if (_socialMediaCallBack) _socialMediaCallBack(SocialMediaTwitter, [self project]);
    } else if ([sender isEqual:[self button5]]) {
        if (_socialMediaCallBack) _socialMediaCallBack(SocialMediaSprout, [self project]);
    }
    [self configrueButtons];
}

@end
