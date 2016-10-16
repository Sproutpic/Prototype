//
//  MyProjectsViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 05/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "MyProjectsViewController.h"
#import "SettingsViewController.h"
#import "UIUtils.h"
#import "ProjectDetailViewController.h"
#import "ProjectTableViewCell.h"
#import "CoreDataAccessKit.h"
#import "TableAdapter.h"
#import "Project.h"
#import "Timeline.h"

@interface MyProjectsViewController () <UITableViewDelegate>

@property (strong, nonatomic) NSNumber *useFile;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TableAdapter *tableAdapter;
@property (strong, nonatomic) UITabBarItem *tabBarItemHack;

@end

@implementation MyProjectsViewController

# pragma mark Private

- (IBAction)tappedSettingsButton:(UIButton *)sender
{
    [[self navigationController] presentViewController:[[UINavigationController alloc] initWithRootViewController:[[SettingsViewController alloc] init]]
                                              animated:YES
                                            completion:nil];
}

- (ConfigureTableCellBlock)createConfigureTableCellBlock
{
    return ^(UITableView* tableView, NSIndexPath* indexPath, NSManagedObject* managedObject) {
        ProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectTableViewCell" forIndexPath:indexPath];
        [cell setProject:(Project*)managedObject];
        return cell;
    };
}

- (void)createTabBarItem
{
    if (![self tabBarItemHack]) {
        [self setTabBarItemHack:[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"My Project", @"My Project")
                                                              image:[UIImage imageNamed:@"projector-grey"]
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
    [self setTableView:[self createBaseTableView]];
    [self setTableAdapter:[[TableAdapter alloc] initForTableView:[self tableView]
                                                       forEntity:NSStringFromClass([Project class])
                                                       predicate:nil
                                                            sort:[Project sortDescriptors]
                                                  sectionNameKey:nil
                                            managedObjectContext:[[CoreDataAccessKit sharedInstance] createNewManagedObjectContext]
                                     withConfigureTableCellBlock:
                           ^(UITableView* tableView, NSIndexPath* indexPath, NSManagedObject* managedObject) {
                               ProjectTableViewCell *cell = (ProjectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ProjectTableViewCell"];
                               if (!cell) {
                                   UIViewController *vc = [[UIViewController alloc] initWithNibName:@"ProjectTableViewCell" bundle:nil];
                                   cell = (ProjectTableViewCell*)[vc view];
                               }
                               [cell setProject:(Project*)managedObject];
                               return cell;
                           }]];
    [[self view] addSubview:[self tableView]];
}

- (void)addRightBarButton
{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(tappedSettingsButton:)];
    [[self navigationItem] setRightBarButtonItem:backBtn];
}

# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    
    ProjectDetailViewController *pdvc = [[ProjectDetailViewController alloc] init];
    pdvc.project = [[[self tableAdapter] fetchedResultsController] objectAtIndexPath:indexPath];
    pdvc.useFile = _useFile;
    
    [[self navigationController] pushViewController:pdvc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220.0;
}
@end
