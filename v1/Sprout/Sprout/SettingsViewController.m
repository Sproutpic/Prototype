//
//  SettingsViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 05/07/2016.
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
    [[self navigationController] dismissViewControllerAnimated:YES completion:^{}];
}

- (NSArray*)rowDataAtIndex:(NSInteger)row
{
    return [[self rows] objectAtIndex:row];
}

# pragma mark UIViewController

- (void)viewDidLoad
{
    [self setRows:
     @[
       @[@(NO),@"About Sproutpic",@"AboutViewController"],
       @[@(NO),@"FAQ",@"FAQViewController"],
       @[@(NO),@"Account Information",@"AccountInformationViewController"],
       // TODO - Only show if logged in...
       // [[NSUserDefaults standardUserDefaults] objectForKey:@"user"]
       @[@(YES),@"Change Password",@"ChangePasswordViewController"],
       @[@(NO),@"Secure Access",@"SecureAccessViewController"],
       ]];
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"Settings", @"Settings")];
}

# pragma mark BaseViewControllerDelegate

- (void)setController
{
    [super setController];
    [self setTableView:[self createBaseTableView]];
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
    NSArray *dataRow = [self rowDataAtIndex:indexPath.row];
    UIViewController *vc = [[NSClassFromString([dataRow objectAtIndex:2]) alloc] init];
    if (vc) {
        [[self navigationController] pushViewController:vc animated:YES];
    }
}

# pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return [[self rows] count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseCell = @"UITableViewCellStyleValue1";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:reuseCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseCell];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]]];
    }
    NSArray *dataRow = [self rowDataAtIndex:indexPath.row];
    [[cell textLabel] setText:[dataRow objectAtIndex:1]];
    return cell;
}

@end
