//
//  TimelineCollectionViewCellDelegate.h
//  Sprout
//
//  Created by Jeff Morris on 10/24/16.
//  Copyright © 2016 sprout. All rights reserved.
//

@class Timeline;

@protocol TimelineCollectionViewCellDelegate <NSObject>

@optional

- (void)deleteTimeline:(Timeline*)timeline;

@end
