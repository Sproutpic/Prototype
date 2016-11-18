//
//  PrivacyPolicyViewController.m
//  Sprout
//
//  Created by Jeff Morris on 11/17/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "PrivacyPolicyViewController.h"

@interface PrivacyPolicyViewController ()

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation PrivacyPolicyViewController

# pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"Privacy Policy", @"Privacy Policy")];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSString *pageURL = [[NSBundle mainBundle] pathForResource:@"privacy_policy" ofType:@"html"];
    NSString *contents = [NSString stringWithContentsOfFile:pageURL encoding:NSUTF8StringEncoding error:NULL];
    [[self webView] loadHTMLString:contents baseURL:[NSURL fileURLWithPath:pageURL]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self webView] setFrame:[[self view] bounds]];
}

# pragma mark BaseViewControllerDelegate

- (void)setController
{
    [super setController];
    [self setWebView:[self createBaseWebView]];
    [[self view] addSubview:[self webView]];
}

@end
