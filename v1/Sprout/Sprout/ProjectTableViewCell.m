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
#import "Project.h"
#import "Timeline.h"

@implementation ProjectTableViewCell

# pragma mark Private

- (void)setProject:(Project *)project
{
    _project = project;
    [[self titleLabel] setText:[project title]];
    [[self descriptionLabel] setText:[project subtitle]];
    [[self collectionView] reloadData];
}

# pragma mark UITableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[self titleLabel] setTextColor:[UIUtils colorNavigationBar]];
    [[self descriptionLabel] setTextColor:[UIColor grayColor]];
    [[self collectionView] registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
//    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
//    [flow setItemSize:CGSizeMake(128, 128)];
//    [flow setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    [[self collectionView] setCollectionViewLayout:flow];
    [[self collectionView] setDelegate:self];
    [[self collectionView] setDataSource:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

# pragma mark UICollectionViewDelegate


# pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)cv numberOfItemsInSection:(NSInteger)section
{
    return ([self project]) ? [[[[self project] timelines] allObjects] count] : 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];

    if (!cell) {
        cell = [[UICollectionViewCell alloc] init];
    }

    if ([self project]) {
        Timeline *timeline = [[[[self project] timelines] allObjects] objectAtIndex:[indexPath row]];
        NSString *imgURL = [timeline serverURL];
//        NSString *imgURL = [[[self project] objectForKey:@"projectThumbnails"] objectAtIndex:[indexPath row]];
        UIImageView *iv = [[UIImageView alloc] init];
        [iv setContentMode:UIViewContentModeScaleAspectFill];
        [iv setFrame:CGRectMake(1, 1, 126, 126)];
        [iv setClipsToBounds:YES];
        [iv sd_setImageWithURL:[NSURL URLWithString:imgURL]
              placeholderImage:nil];
        [[cell contentView] addSubview:iv];
        [cell setBackgroundColor:[UIColor blackColor]];
    }
    
    return cell;
}

@end
