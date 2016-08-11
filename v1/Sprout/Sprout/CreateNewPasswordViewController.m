//
//  CreateNewPasswordViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 25/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "CreateNewPasswordViewController.h"

@implementation CreateNewPasswordViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setController];
}
- (void)setController{
    self.view.backgroundColor = [UIColor whiteColor];
    utils = [[UIUtils alloc]init];
    
    [self setNavigationBar];
    [self setupLayout];
}
- (void)setupLayout{
    [self setupFields];
    [self showRecoveryAlert];
}
- (void)showRecoveryAlert{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Recovery Verification" message:@"Verification code was sent to your email. Please check your email and insert the code into the field to proceed to setup a new password." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].placeholder = @"Code";
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    (buttonIndex == 0) ? [self.navigationController popViewControllerAnimated:YES] : NO;
}
- (void)setupFields{
    for (int i = 0; i<2; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.09, 17 + (60 * i), self.view.frame.size.width * 0.82, 44)];
        view.layer.borderWidth = 1.2;
        view.layer.borderColor = [utils colorNavigationBar].CGColor;
        view.layer.cornerRadius = 3;
        
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(view.frame.origin.x + 15, view.frame.origin.y, view.frame.size.width - 15 - view.frame.size.height, view.frame.size.height)];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.alignment = NSTextAlignmentCenter;
        field.delegate = self;
        //field.backgroundColor = [UIColor greenColor];
        field.textColor = [utils colorNavigationBar];
        field.tintColor = [utils colorNavigationBar];
        field.font = [utils fontRegularForSize:15];
        field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                                     NSFontAttributeName: [utils fontRegularForSize:15]}];
        [self.view addSubview:view];
        
        switch (i) {
            case 0:{
                field.secureTextEntry = YES;
                field.keyboardType = UIKeyboardTypeEmailAddress;
                field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                                                             NSFontAttributeName: [utils fontRegularForSize:15]}];
                fieldNewPass = field;
                [self.view addSubview:fieldNewPass];
                
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - field.frame.size.height * 0.1, field.frame.origin.y + field.frame.size.height * 0.3, field.frame.size.height * 0.4, field.frame.size.height * 0.4)];
                image.image = [UIImage imageNamed:@"eyeFilled"];
                image.userInteractionEnabled = YES;
                image.tag = 0;
                [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedEye:)]];
                
                [self.view addSubview:image];
            }
                break;
            case 1:{
                field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Repeat Password" attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                                                                NSFontAttributeName: [utils fontRegularForSize:15]}];
                fieldRepeatPass = field;
                [self.view addSubview:fieldRepeatPass];
                
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - field.frame.size.height * 0.1, field.frame.origin.y + field.frame.size.height * 0.4, field.frame.size.height * 0.4, field.frame.size.height * 0.25)];
                image.image = [UIImage imageNamed:@"eye"];
                image.userInteractionEnabled = YES;
                image.tag = 1;
                [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedEye:)]];
                
                [self.view addSubview:image];
            }
                break;
            default:
                break;
        }
    }
}
- (void)tappedEye:(UITapGestureRecognizer *)sender{
    ((UITextField *)((sender.view.tag == 0) ? fieldNewPass : fieldRepeatPass)).secureTextEntry = ((UITextField *)((sender.view.tag == 0) ? fieldNewPass : fieldRepeatPass)).secureTextEntry ? NO : YES;
    
    [UIView animateWithDuration:0.1 animations:^{
        ((UIImageView *)sender.view).alpha = 0;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.0 animations:^{
            ((UIImageView *)sender.view).frame = ((UIImageView *)sender.view).frame.size.height == 17.6 ?CGRectMake(self.view.frame.size.width * 0.82 - 44 * 0.1, (((UIImageView *)sender.view).frame.origin.y - (13.2)) + 44 * 0.4, 44 * 0.4, 44 * 0.25):CGRectMake(self.view.frame.size.width * 0.82 - 44 * 0.1, (((UIImageView *)sender.view).frame.origin.y - (17.6)) + 44 * 0.3, 44 * 0.4, 44 * 0.4);
            ((UIImageView *)sender.view).image = [((UIImageView *)sender.view).image isEqual:[UIImage imageNamed:@"eyeFilled"]] ? [UIImage imageNamed:@"eye"] : [UIImage imageNamed:@"eyeFilled"];
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.1 animations:^{
                ((UIImageView *)sender.view).alpha = 1;
            }];
        }];
    }];
}
- (void)setNavigationBar{
    self.navigationController.navigationBar.barTintColor = [utils colorNavigationBar];
    self.navigationController.navigationBar.backgroundColor = [utils colorNavigationBar];
    self.navigationController.navigationBar.translucent = NO;
    
    [self setTitleViewForNavBar];
    [self addLeftBarButton];
    [self addRightBarButton];
}
- (void)addLeftBarButton{
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [back setBackgroundImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = barButton;
}
- (void)addRightBarButton{
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [back setBackgroundImage:[UIImage imageNamed:@"circleCheck"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(tappedConfirmNewPassword:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.rightBarButtonItem = barButton;
}
- (IBAction)tappedConfirmNewPassword:(id)sender{
    if ([[fieldNewPass.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] || [[fieldRepeatPass.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        [self showAlertWithMessage:@"Please enter new password."];
    }else if([fieldNewPass.text isEqualToString:fieldRepeatPass.text]){
        [self showAlertWithMessage:@"Password not equal."];
    }else{

    }
}
- (void)showAlertWithMessage:(NSString *)str{
    [[[UIAlertView alloc]initWithTitle:@"" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}
- (IBAction)backToMenu:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setTitleViewForNavBar{
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [utils attrString:@"Create New Password" withFont:[utils fontForNavBarTitle] color:[UIColor whiteColor] andCharSpacing:[NSNumber numberWithInt:0]];
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    
    self.navigationItem.titleView = label;
}
@end
