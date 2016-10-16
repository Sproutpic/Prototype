//
//  BaseViewController.m
//  Sprout
//
//  Created by Jeff Morris on 10/9/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation BaseViewController

# pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [self setController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

# pragma mark BaseViewControllerDelegate

- (void)setController
{
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self setNavigationBar];
}

- (void)setNavigationBar
{
    [self setTitle:NSLocalizedString(@"SproutPic", @"SproutPic")];
    [self addLeftBarButton];
    [self addRightBarButton];
}

- (void)addLeftBarButton
{
    // Implement in overridding class
}

- (void)addRightBarButton
{
    // Implement in overridding class
}

- (UITableView*)createBaseTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStylePlain];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setTableFooterView:[self fakeTableFooter]];
    return tableView;
}

- (UIView*)fakeTableFooter
{
    UIView *view = [[UIView alloc] init];
    [view setFrame:CGRectMake(0, 0, 1, 1)];
    return view;
}

# pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseCell = @"UITableViewCellStyleValue1";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:reuseCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseCell];
    }
    return cell;
}

@end
