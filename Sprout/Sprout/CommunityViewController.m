//
//  CommunityViewController.m
//  Sprout
//
//  Created by Jeff Morris on 10/9/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "CommunityViewController.h"
#import "UIUtils.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SproutWebService.h"

@implementation CommunityViewController

# pragma mark Private

- (void)setupWeb
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [webView setBackgroundColor:[UIColor whiteColor]];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:SPROUT_COMMUNITY_URL]]];
    [[self view] addSubview:webView];
}

# pragma mark BaseViewController

- (void)setController
{
    [super setController];
    [self setupWeb];
}

- (void)setNavigationBar
{
    [super setNavigationBar];
    [self setTitle:NSLocalizedString(@"Community Sprouts", @"Community Sprouts")];
}

- (void)addRightBarButton
{
    [self createSettingsNavButton];
}

# pragma mark UIViewController

- (UITabBarItem*)tabBarItem
{
    return [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Community", @"Community")
                                         image:[UIImage imageNamed:@"tab-team-grey"]
                                           tag:3];
}

@end
