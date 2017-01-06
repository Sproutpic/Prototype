//
//  SettingsViewController.m
//  Sprout
//
//  Created by Jeff Morris on 10/10/2016
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIUtils.h"
#import "OnboardingManager.h"
#import "CTFeedbackViewController.h"
#import "AccountInformationViewController.h"

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic) BOOL showSignIn;

@end

@implementation SettingsViewController

# pragma mark Private

- (void)doneButtonTapped:(id)sender
{
    [UIUtils hapticFeedback];
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray*)rowDataAtIndex:(NSIndexPath*)indexPath
{
    return [[[[self tableData] objectAtIndex:[indexPath section]] objectAtIndex:1] objectAtIndex:[indexPath row]];
}

# pragma mark SettingsViewController

+ (SettingsViewController*)signUpViewController
{
    SettingsViewController *vc = [[SettingsViewController alloc] init];
    [vc setShowSignIn:YES];
    return vc;
}

# pragma mark UIViewController

- (void)viewDidLoad
{
    [self setTableData:
     @[
       @[@"",
         @[
             @[@"About Sproutpic",@"AboutViewController",@(NO)],
             @[@"FAQ",@"FAQViewController",@(NO)],
             @[@"Account Information",@"AccountInformationViewController",@(YES)],
             @[@"Welcome - Onboarding",@"OnboardingManager",@(NO)],
             ]
         ],
       @[@"",
         @[
             @[@"Send Us Feedback",@"CTFeedbackViewController",@(NO)]
             ]
         ]
       ]
     ];
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"Settings", @"Settings")];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] setFrame:[[self view] bounds]];
    [[self tableView] reloadData];
    if ([self showSignIn]) {
        [self setShowSignIn:NO];
        [[self navigationController] pushViewController:[AccountInformationViewController signUpViewController] animated:NO];
    }
}

- (UITabBarItem*)tabBarItem
{
    return [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Settings", @"Settings")
                                         image:[UIImage imageNamed:@"button-settings"]
                                           tag:2];
}

# pragma mark BaseViewControllerDelegate

- (void)setController
{
    [super setController];
    [self setTableView:[self createBaseTableView:UITableViewStyleGrouped]];
    [self addSproutLogoTableFooter:[self tableView]];
    [[self view] addSubview:[self tableView]];
}

- (void)setNavigationBar
{
    [super setNavigationBar];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                               target:self
                                                                                               action:@selector(doneButtonTapped:)]];
}

# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    [UIUtils hapticFeedback];
    NSArray *dataRow = [self rowDataAtIndex:indexPath];
    if ([[dataRow objectAtIndex:1] isEqualToString:@"OnboardingManager"]) {
        [OnboardingManager showOnboardingOn:[self navigationController] forceShow:YES];
    } else {
        UIViewController *vc = nil;
        if ([[dataRow objectAtIndex:2] boolValue]) {
            vc = [[NSClassFromString([dataRow objectAtIndex:1]) alloc] initWithNibName:[dataRow objectAtIndex:1] bundle:nil];
        } else {
            vc = [[NSClassFromString([dataRow objectAtIndex:1]) alloc] init];
        }
        if ([[dataRow objectAtIndex:1] isEqualToString:@"CTFeedbackViewController"]) {
            CTFeedbackViewController *cc = [[CTFeedbackViewController alloc]
                                            initWithTopics:@[
                                                             NSLocalizedString(@"General Feedback", @"General Feedback"),
                                                             NSLocalizedString(@"Feature Request", @"Feature Request"),
                                                             NSLocalizedString(@"Bug/Issue", @"Bug/Issue")
                                                             ]
                                            localizedTopics:@[
                                                              NSLocalizedString(@"General Feedback", @"General Feedback"),
                                                              NSLocalizedString(@"Feature Request", @"Feature Request"),
                                                              NSLocalizedString(@"Bug/Issue", @"Bug/Issue")
                                                              ]];
            
            [cc setUseHTML:YES];
            [cc setToRecipients:@[@"info@sproutpic.com"]];
            vc = cc;
        }
        if (vc) {
            [[self navigationController] pushViewController:vc animated:YES];
        }
    }

}

# pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self tableData] count];
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return [[[[self tableData] objectAtIndex:section] objectAtIndex:1] count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseCell = @"UITableViewCellStyleValue1";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:reuseCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseCell];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-right"]]];
    }
    NSArray *dataRow = [self rowDataAtIndex:indexPath];
    [[cell textLabel] setText:[dataRow objectAtIndex:0]];
    return cell;
}

@end
