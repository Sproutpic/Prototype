//
//  SelectTableViewController.m
//  Sprout
//
//  Created by Jeff Morris on 10/29/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SelectTableViewController.h"
#import "UIUtils.h"

@implementation SelectTableViewController

# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [UIUtils hapticFeedback];
    if ([self selectDelegate]) {
        [[self selectDelegate] selectionMade:[self rows] forIndex:[indexPath row] withTag:[self tag]];
    }
}

# pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self rows] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCellStyleSubtitle"];
    NSArray *row = [[self rows] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[row objectAtIndex:SelectRD_Title]];
    [[cell detailTextLabel] setText:[row objectAtIndex:SelectRD_Subtitle]];
    [cell setAccessoryType:([[row objectAtIndex:SelectRD_Selected] boolValue])?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    return cell;
}

@end
