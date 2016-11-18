//
//  TermsAndConditionsViewController.m
//  Sprout
//
//  Created by Jeff Morris on 11/17/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "TermsAndConditionsViewController.h"

@interface TermsAndConditionsViewController ()

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation TermsAndConditionsViewController

# pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"Terms and Conditions", @"Terms and Conditions")];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *pageURL = [[NSBundle mainBundle] pathForResource:@"terms_and_conditions" ofType:@"html"];
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
