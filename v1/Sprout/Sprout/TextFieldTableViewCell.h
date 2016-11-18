//
//  TextFieldTableViewCell.h
//  Sprout
//
//  Created by Jeff Morris on 10/21/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"

@interface TextFieldTableViewCell : UITableViewCell <UITextFieldDelegate, UITextViewDelegate>

typedef void (^ TextFieldCallBack)(UITextField *textfield);
@property (strong, nonatomic) TextFieldCallBack textFieldCallback;

typedef void (^ TextViewCallBack)(UITextView *textview);
@property (strong, nonatomic) TextViewCallBack textViewCallback;

@property (weak, nonatomic) IBOutlet UIView *backgroundTxtView;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textfield;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextView *textview;

@end
