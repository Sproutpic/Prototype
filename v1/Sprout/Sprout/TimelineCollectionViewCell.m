//
//  TimelineCollectionViewCell.m
//  Sprout
//
//  Created by Jeff Morris on 10/24/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "TimelineCollectionViewCell.h"
#import "UIUtils.h"
#import "DataObjects.h"

#define KVO_TIMELINE_LOCAL_URL  @"localURL"

@interface PaddedLabel : UILabel
@end

@implementation PaddedLabel

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {0, 5, 0, 5};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end

@interface TimelineCollectionViewCell ()

@property (strong, nonatomic) Timeline *timeline;
@property (nonatomic) TimelineCellState state;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) UILabel *dateLbl;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation TimelineCollectionViewCell

# pragma mark Private

- (void)deleteButtonTapped:(id)sender
{
    if ([self timelineDelegate] && [[self timelineDelegate] respondsToSelector:@selector(deleteTimeline:)]) {
        [[self timelineDelegate] deleteTimeline:[self timeline]];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:KVO_TIMELINE_LOCAL_URL]) {
        [self layoutSubviews];
    }
}

- (void)dealloc
{
    if (_timeline) {
        [_timeline removeObserver:self forKeyPath:KVO_TIMELINE_LOCAL_URL];
    }
}

# pragma mark TimelineCollectionViewCell

- (void)setTimeline:(Timeline *)timeline withDisplayType:(TimelineCellState)state;
{
    if (_timeline) {
        [_timeline removeObserver:self forKeyPath:KVO_TIMELINE_LOCAL_URL];
    }
    _timeline = timeline;
    _state = state;
    [self layoutSubviews];
    if ([self timeline]) {
        [[self timeline] addObserver:self
                   forKeyPath:KVO_TIMELINE_LOCAL_URL
                      options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                      context:NULL];
    }
}

# pragma mark UICollectionViewCell

- (void)layoutSubviews
{
    if (![self dateFormatter]) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:NSLocalizedString(@"MM/dd/yy hh:mma", @"MM/dd/yy hh:mma")];
        [self setDateFormatter:df];
    }
    
    if (![self imageView]) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:[self bounds]];
        [iv setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
        [[self contentView] addSubview:iv];
        [self setImageView:iv];
        
        [[self contentView] setBackgroundColor:[UIUtils colorNavigationBar]];
        [[self layer] setMasksToBounds:YES];
        [[self layer] setCornerRadius:10.0];
        [[self layer] setBackgroundColor:[[UIUtils colorNavigationBar] CGColor]];
    }
    
    if (![self deleteBtn]) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setFrame:CGRectMake(self.bounds.size.width-35, 0, 35, 35)];
        [btn addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [btn setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.75]];
        [[btn layer] setMasksToBounds:YES];
        [[btn layer] setCornerRadius:5.0];
        
        [[self contentView] addSubview:btn];
        [self setDeleteBtn:btn];
    }
    
    if (![self dateLbl]) {
        UILabel *lbl = [[PaddedLabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-16,
                                                                 self.bounds.size.width, 16)];
        [lbl setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.50]];
        [lbl setTextColor:[UIColor whiteColor]];
        [lbl setFont:[UIFont boldSystemFontOfSize:10.0]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [[self contentView] addSubview:lbl];
        [self setDateLbl:lbl];
    }
    
    if ([self timeline]) {
        if ([[self timeline] localURL]) {
            [[self imageView] setContentMode:UIViewContentModeScaleAspectFill];
        } else {
            [[self imageView] setContentMode:UIViewContentModeCenter];
        }
        [[self imageView] setImage:[[self timeline] imageOrTempImage]];
        [[self dateLbl] setText:[[self dateFormatter] stringFromDate:[[self timeline] created]]];
        switch ([self state]) {
            case TimelineCellStateNormal: {
                [[self deleteBtn] setHidden:YES];
                [[self dateLbl] setHidden:YES];
            } break;
            case TimelineCellStateNormalAndDate: {
                [[self deleteBtn] setHidden:YES];
                [[self dateLbl] setHidden:NO];
            } break;
            case TimelineCellStateEdit: {
                [[self deleteBtn] setHidden:NO];
                [[self dateLbl] setHidden:NO];
            } break;
        }
    } else {
        [[self imageView] setContentMode:UIViewContentModeCenter];
        [[self imageView] setImage:[UIImage imageNamed:@"button-plus"]];
        [[self deleteBtn] setHidden:YES];
        [[self dateLbl] setHidden:NO];
        [[self dateLbl] setText:NSLocalizedString(@"Add Photo", @"Add Photo")];
    }
    
}

@end
