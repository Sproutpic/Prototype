//
//  FAQViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 06/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "FAQViewController.h"

@interface FAQViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *rows;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation FAQViewController

# pragma mark Private

- (NSArray*)rowDataAtIndex:(NSInteger)row
{
    return [[self rows] objectAtIndex:row];
}

# pragma mark UIViewController

- (void)viewDidLoad
{
    [self setRows:
     [@[
        [@[@(NO),@"Q: My question number 1",@"A: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."] mutableCopy],
        [@[@(NO),@"Q: My question number 2",@"A: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."] mutableCopy],
        [@[@(NO),@"Q: My question number 3",@"A: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."] mutableCopy],
        [@[@(NO),@"Q: My question number 4",@"A: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."] mutableCopy],
        [@[@(NO),@"Q: My question number 5",@"A: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."] mutableCopy],
        [@[@(NO),@"Q: My question number 6",@"A: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."] mutableCopy],
        [@[@(NO),@"Q: My question number 7",@"A: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."] mutableCopy],
        ] mutableCopy]];
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"FAQ", @"FAQ")];
}

# pragma mark BaseViewControllerDelegate

- (void)setController
{
    [super setController];
    [self setTableView:[self createBaseTableView]];
    [[self view] addSubview:[self tableView]];
}

# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *dataRow = (NSMutableArray*)[self rowDataAtIndex:[indexPath row]];
    [dataRow replaceObjectAtIndex:0 withObject:@(![[dataRow objectAtIndex:0] boolValue])];
    [tv reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dataRow = [self rowDataAtIndex:indexPath.row];
    return ([[dataRow objectAtIndex:0] boolValue]) ? 150.0 : 44.0; // TODO - Make the height dynamic...
}

# pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return [[self rows] count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseCell = @"UITableViewCellStyleSubtitle";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:reuseCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseCell];
        [[cell detailTextLabel] setNumberOfLines:100];
    }
    NSArray *dataRow = [self rowDataAtIndex:indexPath.row];
    [[cell textLabel] setText:[dataRow objectAtIndex:1]];
    if ([[dataRow objectAtIndex:0] boolValue]) {
        [[cell detailTextLabel] setText:[dataRow objectAtIndex:2]];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upArrow"]]];
    } else {
        [[cell detailTextLabel] setText:nil];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downArrow"]]];
    }
    return cell;
}

@end
