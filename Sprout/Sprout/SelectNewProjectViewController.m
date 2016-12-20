//
//  SelectNewProjectViewController.m
//  Sprout
//
//  Created by Jeff Morris on 10/19/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SelectNewProjectViewController.h"
#import "DataObjects.h"
#import "UIUtils.h"
#import "ProjectDetailViewController.h"

typedef enum NewSproutType {
    NST_Selfie = 0,
    NST_Mirror = 1,
    NST_Portrait = 2,
    NST_Landscape = 3
} NewSproutType;

@interface SelectNewProjectViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *rows;

@end

@implementation SelectNewProjectViewController

# pragma mark Private

- (NSArray*)rowDataAtIndex:(NSInteger)row
{
    return [[self rows] objectAtIndex:row];
}

- (void)createProjectAndShowCamera:(NSInteger)row forNewSproutType:(NewSproutType)type
{
    NSArray *rowData = [self rowDataAtIndex:row];
    NSManagedObjectContext *moc = [[CoreDataAccessKit sharedInstance] managedObjectContext];
    Project *project = [Project createNewProject:[rowData objectAtIndex:0]
                                        subTitle:[rowData objectAtIndex:3]
                        withManagedObjectContext:moc];
    [project setRepeatNextDate:[NSDate date]];
    
    switch (row) {
        case 0: { // NST_Selfie
            [project setRemindEnabled:@(YES)];
            [project setFrontCameraEnabled:@(YES)];
            [project setRepeatFrequency:@(RF_Daily)];
        } break;
        case 1: { // NST_Mirror
            [project setRemindEnabled:@(YES)];
            [project setFrontCameraEnabled:@(NO)];
            [project setRepeatFrequency:@(RF_Daily)];
        } break;
        case 2: { // NST_Portrait
            [project setRemindEnabled:@(YES)];
            [project setFrontCameraEnabled:@(NO)];
            [project setRepeatFrequency:@(RF_Weekly)];
        } break;
        case 3: { // NST_Landscape
            [project setSlideTime:[NSDecimalNumber decimalNumberWithString:@"1.5"]];
            [project setFrontCameraEnabled:@(NO)];
            [project setRemindEnabled:@(NO)];
            [project setRepeatFrequency:@(RF_Weekly)];
        } break;
    }
    
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
    [self setTitle:NSLocalizedString(@"New Sprout", @"New Sprout")];
}

- (UITabBarItem*)tabBarItem
{
    return [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"New Sprout", @"New Sprout")
                                         image:[UIImage imageNamed:@"tab-plus-grey"]
                                           tag:2];
}

# pragma mark BaseViewControllerDelegate

- (void)setController
{
    // Row Data: [ "Title", "ButtonImage", NST_Type(Int), "Description" ]

    [self setRows:
     @[
       @[@"Selfie Sprout",@"button-selfie",@(NST_Selfie),
         NSLocalizedString(@"A Selfie Sprout is meant to be taken with the front facing camera. We'll remind you every day to update your selfie sprout.",
                           @"A Selfie Sprout is meant to be taken with the front facing camera. We'll remind you every day to update your selfie sprout.")],
       @[@"Mirror Sprout",@"button-mirror",@(NST_Mirror),
         NSLocalizedString(@"A Mirror Sprout is designed to use the back camera when you are infront of a mirror, so you can create a sprout when you are at the gym or at home.",
                           @"A Mirror Sprout is designed to use the back camera when you are infront of a mirror, so you can create a sprout when you are at the gym or at home.")],
       @[@"Portrait Sprout",@"button-pet",@(NST_Portrait),
         NSLocalizedString(@"A Portrait Sprout uses the back camera so you can create a sprout of someone else. We'll remind you every day to update your sprout.",
                           @"A Portrait Sprout uses the back camera so you can create a sprout of someone else. We'll remind you every day to update your sprout.")],
       @[@"Landscape Sprout",@"button-nature",@(NST_Landscape),
         NSLocalizedString(@"A Landscape Sprout is designed to use the back camera so you can create a sprout of a tree, plant, or just a beautiful view.",
                           @"A Landscape Sprout is designed to use the back camera so you can create a sprout of a tree, plant, or just a beautiful view.")]
       ]];
    [super setController];
    [[self collectionView] registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
}

- (void)addRightBarButton
{
    [self createSettingsNavButton];
}

# pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *rowData = [self rowDataAtIndex:[indexPath row]];
    NSString *prefName = [NSString stringWithFormat:@"SproutHelpAlert-%d",[[rowData objectAtIndex:2] intValue]];
    
    [UIUtils hapticFeedback];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:prefName]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:prefName];
        [[NSUserDefaults standardUserDefaults] synchronize];

        UIAlertController *alert = [[UIAlertController alloc] init];
        [alert setTitle:[rowData objectAtIndex:0]];
        [alert setMessage:[rowData objectAtIndex:3]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@ %@",
                                                         NSLocalizedString(@"Create", @"Create"),[rowData objectAtIndex:0]]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    [self createProjectAndShowCamera:[indexPath row]
                                                                    forNewSproutType:NST_Selfie];
                                                }]];
        [[self navigationController] presentViewController:alert animated:YES completion:nil];
    } else {
        [self createProjectAndShowCamera:[indexPath row] forNewSproutType:(NewSproutType)[rowData objectAtIndex:2]];
    }
}

# pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)cv numberOfItemsInSection:(NSInteger)section
{
    return [[self rows] count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UICollectionViewCell alloc] init];
    } else {
        NSArray *views = [[cell contentView] subviews];
        for (UIView *view in views) {
            [view removeFromSuperview];
        }
    }
    
    CGRect cellFrame = [cell bounds];
    
    NSArray *rowData = [self rowDataAtIndex:[indexPath row]];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellFrame.size.width, cellFrame.size.height-20)];
    [iv setClipsToBounds:YES];
    [iv setContentMode:UIViewContentModeCenter];
    [iv setImage:[UIImage imageNamed:[rowData objectAtIndex:1]]];
    [iv setBackgroundColor:[UIColor clearColor]];
    [[cell contentView] addSubview:iv];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, cellFrame.size.height-35, cellFrame.size.width-10, 22)];
    [lbl setText:[rowData objectAtIndex:0]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setTextColor:[UIColor whiteColor]];
    [[cell contentView] addSubview:lbl];
    
    [[cell contentView] setBackgroundColor:[UIUtils colorNavigationBar]];
    [[cell layer] setMasksToBounds:YES];
    [[cell layer] setCornerRadius:10.0];
    [[cell layer] setBackgroundColor:[[UIUtils colorNavigationBar] CGColor]];
    
    return cell;
}

// MARK: UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (collectionView.bounds.size.width - (16 * 3))/2;
    return CGSizeMake(width, width);
}

@end
