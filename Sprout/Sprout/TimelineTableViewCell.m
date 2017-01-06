//
//  TimelineTableViewCell.m
//  Sprout
//
//  Created by Jeff Morris on 10/21/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "TimelineTableViewCell.h"
#import "UIUtils.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DataObjects.h"
#import "TimelineCollectionViewCell.h"
#import "TimelineCollectionViewCellDelegate.h"
#import "SyncQueue.h"
#import "TimelineWebService.h"

@interface TimelineTableViewCell () <TimelineCollectionViewCellDelegate>

@end

@implementation TimelineTableViewCell

# pragma mark Private

- (void)setProject:(Project *)project
{
    _project = project;
    [[self collectionView] reloadData];
}

# pragma mark UITableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[self collectionView] registerClass:[TimelineCollectionViewCell class]
              forCellWithReuseIdentifier:@"TimelineCollectionViewCell"];
    [[self collectionView] setDelegate:self];
    [[self collectionView] setDataSource:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

# pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]==0) {
        [[self projectDelegate] useCameraToAddNewSproutToProject:[self project]];
    }
}

# pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)cv numberOfItemsInSection:(NSInteger)section
{
    return (([self project]) ? [[[self project] timelinesArraySorted] count] : 0) + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TimelineCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TimelineCollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[TimelineCollectionViewCell alloc] init];
    }
    Timeline *timeline = nil;
    if ([self project] && [indexPath row]>0) {
        timeline = [[[self project] timelinesArraySorted] objectAtIndex:[indexPath row]-1];
    }
    [cell setTimeline:timeline withDisplayType:([self editState]) ? TimelineCellStateEdit : TimelineCellStateNormalAndDate];
    [cell setTimelineDelegate:self];
    return cell;
}

# pragma mark TimelineCollectionViewCellDelegate

- (void)deleteTimeline:(Timeline *)timeline
{
    [UIUtils hapticFeedback];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Delete Sprout Photo", @"Delete Sprout Photo")
                                                                   message:NSLocalizedString(@"Are you sure you want to delete this sprout photo from your project?", @"Are you sure you want to delete this sprout photo from your project?")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Delete Photo", @"Delete Photo")
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                NSNumber *serverId = [timeline serverId];
                                                [timeline deleteAndSave];
                                                [[SyncQueue manager] addService:[TimelineWebService deleteTimelineId:serverId withCallback:^(NSError *error, SproutWebService *service) {
                                                    if (!error) {
                                                        // Add a service call to check for videos...
                                                        [SyncAllData syncProjectVideos:nil];
                                                    }
                                                }]];
                                                [[self collectionView] reloadData];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}

@end
