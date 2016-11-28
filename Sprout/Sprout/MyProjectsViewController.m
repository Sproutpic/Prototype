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
#import "OnboardingManager.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "ProjectWebService.h"
#import "SyncQueue.h"
#import "NoDataView.h"

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
        ProjectTableViewCell *cell = (ProjectTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = (ProjectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ProjectTableViewCell"];
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

- (IBAction)noDataButtonTapped:(id)sender
{
    NSManagedObjectContext *moc = [[CoreDataAccessKit sharedInstance] createNewManagedObjectContextwithName:@"NewProject" andConcurrency:NSMainQueueConcurrencyType];
    Project *project = [Project createNewProject:NSLocalizedString(@"My First Selfie Sprout", @"My First Selfie Sprout")
                                        subTitle:NSLocalizedString(@"A Selfie Sprout is meant to be taken with the front facing camera. We'll remind you every day to update your selfie sprout.",
                                                                   @"A Selfie Sprout is meant to be taken with the front facing camera. We'll remind you every day to update your selfie sprout.")
                        withManagedObjectContext:moc];
    [project setRepeatNextDate:[NSDate date]];
    [project setRemindEnabled:@(YES)];
    [project setFrontCameraEnabled:@(YES)];
    [project setRepeatFrequency:@(RF_Daily)];
    [self showCameraForNewSprout:project withCameraCallback:^(Project *project) {
        if (project && [[project timelines] count]>0) {
            ProjectDetailViewController *pdvc = [[ProjectDetailViewController alloc] init];
            [pdvc setProject:project];
            [[self navigationController] pushViewController:pdvc animated:YES];
        }
    }];
}

# pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"My Sprouts", @"My Sprouts")];
    [self createTabBarItem];
    [[self tableView] registerClass:[ProjectTableViewCell class] forCellReuseIdentifier:@"ProjectTableViewCell"];
    
    // Pull to refresh configuration
    [[self tableView] addPullToRefreshWithActionHandler:^{
//        [[SyncQueue manager] addService:[ProjectWebService getAllProjectsWithCallback:^(NSError *error, SproutWebService *service) {
//            [[[self tableView] pullToRefreshView] stopAnimating];
//        }]];
        [SyncAllData now:^{
            [[[self tableView] pullToRefreshView] stopAnimating];
        }];
    }];
    [[[self tableView] pullToRefreshView] setArrowColor:[UIUtils colorNavigationBar]];
    [[[self tableView] pullToRefreshView] setTextColor:[UIUtils colorNavigationBar]];    
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
    
    [OnboardingManager showOnboardingOn:[self navigationController] forceShow:NO];
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
                                                       predicate:[NSPredicate predicateWithFormat:@"markedForDelete = %@",@(NO)]
                                                            sort:[Project sortDescriptors]
                                                  sectionNameKey:nil
                                            managedObjectContext:[[CoreDataAccessKit sharedInstance] managedObjectContext]
                                     withConfigureTableCellBlock:[self createConfigureTableCellBlock]]];
    NoDataView *ndv = (NoDataView*)[[[UIViewController alloc] initWithNibName:@"MyProjectNoDataVC" bundle:nil] view];
    [[ndv button] addTarget:self action:@selector(noDataButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self tableAdapter] setNoDataView:ndv];
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
