//
//  TextFieldTableViewCell.m
//  Sprout
//
//  Created by Jeff Morris on 10/21/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "TextFieldTableViewCell.h"
#import "UIUtils.h"

@implementation TextFieldTableViewCell

- (void)roundCornersForView:(UIView*)view
{
    if (view) {
        [[view layer] setMasksToBounds:YES];
        [[view layer] setCornerRadius:5.0];
    }
}

- (void)themeFloatTextField:(JVFloatLabeledTextField*)textField withBK:(UIView*)view
{
    [textField setTintColor:[UIUtils colorNavigationBar]];
    [textField setFloatingLabelTextColor:[UIUtils colorNavigationBar]];
    [textField setFloatingLabelActiveTextColor:[UIUtils colorNavigationBar]];
    [textField setDelegate:self];
    [self roundCornersForView:view];
}

- (void)themeFloatTextView:(JVFloatLabeledTextView*)textView withBK:(UIView*)view
{
    [textView setTintColor:[UIUtils colorNavigationBar]];
    [textView setFloatingLabelTextColor:[UIUtils colorNavigationBar]];
    [textView setFloatingLabelActiveTextColor:[UIUtils colorNavigationBar]];
    [textView setDelegate:self];
    [self roundCornersForView:view];
}

# pragma mark UITableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self themeFloatTextField:[self textfield] withBK:[self backgroundTxtView]];
    [self themeFloatTextView:[self textview] withBK:[self backgroundTxtView]];
}

# pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self textFieldCallback]) self.textFieldCallback(textField);
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    if ([self textFieldCallback]) self.textFieldCallback(textField);
}

# pragma mark UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self textViewCallback]) self.textViewCallback(textView);
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([self textViewCallback]) self.textViewCallback(textView);
}

@end
