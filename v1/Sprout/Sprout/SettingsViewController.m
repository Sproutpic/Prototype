//
//  SettingsViewController.m
//  Sprout
//
//  Created by Jeff Morris on 10/10/2016
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIUtils.h"

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *rows;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SettingsViewController

# pragma mark Private

- (void)doneButtonTapped:(id)sender
{
    [UIUtils hapticFeedback];
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray*)currentRows
{
    NSMutableArray *temp = [@[] mutableCopy];
    for (NSArray *row in [self rows]) {
        if ([CurrentUser isLoggedIn] || ![[row objectAtIndex:0] boolValue]) {
            [temp addObject:row];
        }
    }
    return temp;
}

- (NSArray*)rowDataAtIndex:(NSInteger)row
{
    return [[self currentRows] objectAtIndex:row];
}

# pragma mark UIViewController

- (void)viewDidLoad
{
    [self setRows:
     @[
       @[@(NO),@"About Sproutpic",@"AboutViewController",@(NO)],
       @[@(NO),@"FAQ",@"FAQViewController",@(NO)],
       @[@(NO),@"Account Information",@"AccountInformationViewController",@(YES)],
       @[@(YES),@"Change Password",@"AccountChangePasswordViewController",@(YES)]
       ]];
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"Settings", @"Settings")];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] setFrame:[[self view] bounds]];
    [[self tableView] reloadData];
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
    NSArray *dataRow = [self rowDataAtIndex:indexPath.row];
    UIViewController *vc = nil;
    if ([[dataRow objectAtIndex:3] boolValue]) {
        vc = [[NSClassFromString([dataRow objectAtIndex:2]) alloc] initWithNibName:[dataRow objectAtIndex:2] bundle:nil];
    } else {
        vc = [[NSClassFromString([dataRow objectAtIndex:2]) alloc] init];
    }
    if (vc) {
        [[self navigationController] pushViewController:vc animated:YES];
    }
}

# pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return [[self currentRows] count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseCell = @"UITableViewCellStyleValue1";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:reuseCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseCell];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-right"]]];
    }
    NSArray *dataRow = [self rowDataAtIndex:[indexPath row]];
    [[cell textLabel] setText:[dataRow objectAtIndex:1]];
    return cell;
}

@end
