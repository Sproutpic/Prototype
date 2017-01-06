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
    [self layoutSubviews];
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

- (void)layoutSubviews
{
    if (![self titleLabel]) {
        // Create Title Label
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.bounds.size.width-11-8, 21)];
        [lbl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [lbl setFont:[UIFont systemFontOfSize:18.0]];
        [lbl setTextColor:[UIUtils colorNavigationBar]];
        [[self contentView] addSubview:lbl];
        [self setTitleLabel:lbl];
        
        // Create image for Accessor
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-right"]];
        [imgV setFrame:CGRectMake(self.bounds.size.width-11-8, 8, 11, 21)];
        [imgV setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin];
        [[self contentView] addSubview:imgV];
    }
    
    if (![self collectionView]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(120, 120)];
        [layout setMinimumLineSpacing:10.0];
        [layout setSectionInset:UIEdgeInsetsMake(1, 1, 1, 1)];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        UICollectionView * cv = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 35, self.bounds.size.width, 128)
                                                   collectionViewLayout:layout];
        [cv setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [cv setContentInset:UIEdgeInsetsMake(0, 8, 0, 8)];
        [cv setAlwaysBounceHorizontal:YES];
        [cv setContentMode:UIViewContentModeLeft];
        [cv setShowsHorizontalScrollIndicator:NO];
        
        [cv registerClass:[TimelineCollectionViewCell class] forCellWithReuseIdentifier:@"TimelineCollectionViewCell"];
        [cv setBackgroundColor:[UIColor clearColor]];
        [[self contentView] addSubview:cv];
        [self setCollectionView:cv];
    }
    
    if (![self descriptionLabel]) {
        // Create Description Label
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 169, self.bounds.size.width, 44)];
        [lbl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [lbl setFont:[UIFont systemFontOfSize:12.0]];
        [lbl setNumberOfLines:3];
        [lbl setTextColor:[UIColor grayColor]];
        [[self contentView] addSubview:lbl];
        [self setDescriptionLabel:lbl];
    }
    
    // Update some elements
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
