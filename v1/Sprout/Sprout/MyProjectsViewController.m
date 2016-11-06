//
//  MyProjectsViewController.m
//  Sprout
//
//  Created by Jeff Morris on 10/9/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "MyProjectsViewController.h"
#import "UIUtils.h"
#import "ProjectDetailViewController.h"
#import "ProjectTableViewCell.h"
#import "TableAdapter.h"
#import "DataObjects.h"
#import <AVFoundation/AVFoundation.h>

@interface MyProjectsViewController () <UITableViewDelegate, ProjectTableViewCellDelegate>

@property (strong, nonatomic) NSNumber *useFile;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TableAdapter *tableAdapter;
@property (strong, nonatomic) UITabBarItem *tabBarItemHack;

@end

@implementation MyProjectsViewController

# pragma mark Private

- (void)pushProjectDetailsViewController:(Project *)project animated:(BOOL)animate completion:(void (^ __nullable)(void))completion
{
    if (project) {
        [UIUtils hapticFeedback];
        ProjectDetailViewController *pdvc = [[ProjectDetailViewController alloc] init];
        pdvc.project = project;
        [CATransaction begin];
        [[self navigationController] pushViewController:pdvc animated:animate];
        if (completion) {
            [CATransaction setCompletionBlock:completion];
        }
        [CATransaction commit];
    }
}

- (ConfigureTableCellBlock)createConfigureTableCellBlock
{
    return ^(UITableView* tableView, NSIndexPath* indexPath, NSManagedObject* managedObject) {
        ProjectTableViewCell *cell = (ProjectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ProjectTableViewCell"];
        if (!cell) {
            UIViewController *vc = [[UIViewController alloc] initWithNibName:@"ProjectTableViewCell" bundle:nil];
            cell = (ProjectTableViewCell*)[vc view];
        }
        [cell setProject:(Project*)managedObject];
        [cell setProjectDelegate:self];
        return cell;
    };
}

- (void)createTabBarItem
{
    if (![self tabBarItemHack]) {
        [self setTabBarItemHack:[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"My Sprouts", @"My Sprouts")
                                                              image:[UIImage imageNamed:@"tab-projector-grey"]
                                                                tag:1]];
    }
}

# pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"My Sprouts", @"My Sprouts")];
    [self createTabBarItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self tableView] setFrame:[[self view] bounds]];    
}

- (UITabBarItem*)tabBarItem
{
    [self createTabBarItem];
    return [self tabBarItemHack];
}

# pragma mark BaseViewControllerDelegate

- (void)setController
{
    [super setController];
    [self setTableView:[self createBaseTableView:UITableViewStylePlain]];
    [[self tableView] setDelegate:self];
    [self setTableAdapter:[[TableAdapter alloc] initForTableView:[self tableView]
                                                       forEntity:NSStringFromClass([Project class])
                                                       predicate:[NSPredicate predicateWithFormat:@"created != nil"]
                                                            sort:[Project sortDescriptors]
                                                  sectionNameKey:nil
                                            managedObjectContext:[[CoreDataAccessKit sharedInstance] managedObjectContext]
                                     withConfigureTableCellBlock:[self createConfigureTableCellBlock]]];
    [self addSproutLogoTableFooter:[self tableView]];
    [[self view] addSubview:[self tableView]];
}

- (void)addRightBarButton
{
    [self createSettingsNavButton];
}

# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    [self pushProjectDetailsViewController:[[[self tableAdapter] fetchedResultsController] objectAtIndexPath:indexPath] animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220.0;
}

# pragma mark ProjectTableViewCellDelegate

- (void)useCameraToAddNewSproutToProject:(Project*)project
{
    NSIndexPath *indexPath = [[[self tableAdapter] fetchedResultsController] indexPathForObject:project];
    if (indexPath) [[self tableView] selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self pushProjectDetailsViewController:[[[self tableAdapter] fetchedResultsController] objectAtIndexPath:indexPath] animated:NO completion:^{
        [self showCameraForNewSprout:project withCameraCallback:nil];
    }];
    if (indexPath) [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showProjectDetails:(Project*)project
{
    NSIndexPath *indexPath = [[[self tableAdapter] fetchedResultsController] indexPathForObject:project];
    if (indexPath) [[self tableView] selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self pushProjectDetailsViewController:project animated:YES completion:nil];
    if (indexPath) [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
}

@end
