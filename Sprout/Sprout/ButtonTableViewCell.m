//
//  ButtonTableViewCell.m
//  Sprout
//
//  Created by Jeff Morris on 10/21/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "ButtonTableViewCell.h"

@implementation ButtonTableViewCell

- (IBAction)buttonTaped:(id)sender
{
    if ([self buttonCallBack]) self.buttonCallBack([self button]);
}

- (void)roundCornersForView:(UIView*)view
{
    if (view) {
        [[view layer] setMasksToBounds:YES];
        [[view layer] setCornerRadius:5.0];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self roundCornersForView:[self button]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
