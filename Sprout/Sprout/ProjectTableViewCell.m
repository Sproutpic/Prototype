//
//  ProjectTableViewCell.m
//  Sprout
//
//  Created by Jeff Morris on 10/9/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "ProjectTableViewCell.h"
#import "UIUtils.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "TimelineCollectionViewCell.h"
#import "DataObjects.h"

@implementation ProjectTableViewCell

# pragma mark Private

- (void)blankCollectionViewTapped
{
    if ([self projectDelegate]) [[self projectDelegate] showProjectDetails:[self project]];
}

- (void)setProject:(Project *)project
{
    _project = project;
    [[self titleLabel] setText:[project title]];
    [[self descriptionLabel] setText:[project subtitle]];
    [[self collectionView] invalidateIntrinsicContentSize];
    [[self collectionView] reloadData];
}

- (void)setProjectDelegate:(id<ProjectTableViewCellDelegate>)projectDelegate
{
    _projectDelegate = projectDelegate;
    if ([[self collectionView] backgroundView]) {
        NSArray *gestures = [[self collectionView] gestureRecognizers];
        for (UIGestureRecognizer *gest in gestures) {
            [[[self collectionView] backgroundView] removeGestureRecognizer:gest];
        }
    }
    if (_projectDelegate) {
        [[self collectionView] setBackgroundView:[[UIView alloc] init]];
        [[[self collectionView] backgroundView] addGestureRecognizer:
         [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blankCollectionViewTapped)]];
    }
}

# pragma mark UITableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[self titleLabel] setTextColor:[UIUtils colorNavigationBar]];
    [[self descriptionLabel] setTextColor:[UIColor grayColor]];
    [[self collectionView] registerClass:[TimelineCollectionViewCell class]
              forCellWithReuseIdentifier:@"TimelineCollectionViewCell"];
    [[self collectionView] setBackgroundColor:[UIColor clearColor]];
    [[self collectionView] setDelegate:self];
    [[self collectionView] setDataSource:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)prepareForReuse
{
    [[self titleLabel] setText:nil];
    [[self descriptionLabel] setText:nil];
    [[self collectionView] setContentOffset:CGPointMake(-8, 0) animated:NO];
}

# pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]==0) {
        if ([self projectDelegate]) [[self projectDelegate] useCameraToAddNewSproutToProject:[self project]];
    } else if ([[self projectDelegate] respondsToSelector:@selector(showProjectDetails:)]) {
        if ([self projectDelegate]) [[self projectDelegate] showProjectDetails:[self project]];
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
    [cell setTimeline:timeline withDisplayType:TimelineCellStateNormal];
    return cell;
}

@end
