//
//  TimelineCollectionViewCell.h
//  Sprout
//
//  Created by Jeff Morris on 10/24/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineCollectionViewCellDelegate.h"

@class Timeline;

typedef NS_ENUM(NSInteger, TimelineCellState) {
    TimelineCellStateNormal = 0,        // Shows images only
    TimelineCellStateNormalAndDate = 1, // Shows image and date
    TimelineCellStateEdit = 2           // Shows image, date, and delete button
};

@interface TimelineCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<TimelineCollectionViewCellDelegate> timelineDelegate;

- (void)setTimeline:(Timeline *)timeline withDisplayType:(TimelineCellState)state;

@end
