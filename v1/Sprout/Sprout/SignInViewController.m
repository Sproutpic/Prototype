//
//  SignInViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 21/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

// TODO - Rewrite entire class...

#import "SignInViewController.h"
#import "UIUtils.h"

@implementation SignInViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setController];
}
- (void)setController{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationBar];
    [self setupLayout];
}
- (void)setupLayout{
    [self setupFields];
    [self setupSignInButton];
    [self setupFooter];
}
- (void)setupFields{
    for (int i = 0; i<2; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.09, 17 + (60 * i), self.view.frame.size.width * 0.82, 44)];
        view.layer.borderWidth = 1.2;
        view.layer.borderColor = [UIUtils colorNavigationBar].CGColor;
        view.layer.cornerRadius = 3;
        
        UITextField *field = [[UITextField alloc] initWithFrame:view.frame];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.alignment = NSTextAlignmentCenter;
        field.delegate = self;
        field.textAlignment = NSTextAlignmentCenter;
        field.textColor = [UIUtils colorNavigationBar];
        field.tintColor = [UIUtils colorNavigationBar];
        field.font = [UIUtils fontRegularForSize:15];
        field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: [UIUtils colorNavigationBar],
                                                                                                     NSFontAttributeName: [UIUtils fontRegularForSize:15],
                                                                                                     NSParagraphStyleAttributeName: paraStyle}];
        [self.view addSubview:view];
        
        switch (i) {
            case 0:
                field.keyboardType = UIKeyboardTypeEmailAddress;
                field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Type Your Email Here" attributes:@{NSForegroundColorAttributeName: [UIUtils colorNavigationBar],
                                                                                                                             NSFontAttributeName: [UIUtils fontRegularForSize:15],
                                                                                                                             NSParagraphStyleAttributeName: paraStyle}];
                fieldEmail = field;
                [self.view addSubview:fieldEmail];
                break;
            case 1:{
                field.secureTextEntry = YES;
                field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Type Your Password Here" attributes:@{NSForegroundColorAttributeName: [UIUtils colorNavigationBar],
                                                                                                                                NSFontAttributeName: [UIUtils fontRegularForSize:15],
                                                                                                                                NSParagraphStyleAttributeName: paraStyle}];
                field.frame = CGRectMake(field.frame.origin.x + field.frame.size.width * 0.15, field.frame.origin.y, field.frame.size.width * 0.7, field.frame.size.height);
                fieldPassword = field;
                [self.view addSubview:fieldPassword];
            }
                break;
            default:
                break;
        }
    }
}
- (void)setupSignInButton{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.09, 137, self.view.frame.size.width * 0.82, 44)];
    button.backgroundColor = [UIUtils colorNavigationBar];
    button.layer.cornerRadius = 3;
    [button setAttributedTitle:[[NSAttributedString alloc]initWithString:@"Sign In" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                                 NSFontAttributeName: [UIUtils fontRegularForSize:15]}] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tappedSignIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (IBAction)tappedSignIn:(id)sender{
    if ([self isFilled]) {
        NSLog(@"email:%@\npassword:%@",fieldEmail.text,[[fieldPassword.text dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0]);
        webService = [[WebService alloc] init];
        [webService requestSignInUser:@{@"email":fieldEmail.text,
                                        @"encodedPassword":[[fieldPassword.text dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0]} withTarget:self];
    }else{
        [self showAlertWithMessage:@"Please fill in all fields."];
    }
}
-(BOOL)isFilled{
    return [[NSString stringWithFormat:@"%d%d",[[fieldEmail.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""],[[fieldPassword.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]] isEqualToString:@"00"] ? YES:NO;
}
- (void)setupFooter{
    UILabel *lblNote = [[UILabel alloc] init];
    lblNote.attributedText =  [[NSAttributedString alloc]initWithString:@"Restore Password" attributes:@{NSForegroundColorAttributeName: [UIUtils colorNavigationBar],
                                                                                                NSFontAttributeName: [UIUtils fontRegularForSize:15],
                                                                                                NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    [lblNote sizeToFit];
    lblNote.frame = CGRectMake(self.view.frame.size.width * 0.91 - lblNote.frame.size.width, 207, lblNote.frame.size.width, lblNote.frame.size.height);
    lblNote.userInteractionEnabled = YES;
    [lblNote addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRestorePass:)]];
    [self.view addSubview:lblNote];
}
- (void)tappedRestorePass:(UITapGestureRecognizer *)sender{
    if ([[fieldEmail.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        [self showAlertWithMessage:@"Please enter email address."];
    }else{
        webService = [[WebService alloc] init];
        [webService requestRestorePassword:@{@"email":fieldEmail.text} withTarget:self];
    }
}
- (void)restoreSuccess{
    CreateNewPasswordViewController *newPassController = [[CreateNewPasswordViewController alloc] init];
    //newPassController.email = fieldEmail.text;
    [self.navigationController pushViewController:newPassController animated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)setNavigationBar{
    self.navigationController.navigationBar.barTintColor = [UIUtils colorNavigationBar];
    self.navigationController.navigationBar.backgroundColor = [UIUtils colorNavigationBar];
    self.navigationController.navigationBar.translucent = NO;
    
    [self setTitleViewForNavBar];
    [self addLeftBarButton];
}
- (void)addLeftBarButton{
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [back setBackgroundImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = barButton;
}
- (IBAction)backToMenu:(UIButton *)sender{
    [self.navigationController popToViewController:_accountInfoController animated:YES];
}
- (void)setTitleViewForNavBar{
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [UIUtils attrString:@"Sign In" withFont:[UIUtils fontForNavBarTitle] color:[UIColor whiteColor] andCharSpacing:[NSNumber numberWithInt:0]];
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    
    self.navigationItem.titleView = label;
}
- (void)showAlertWithMessage:(NSString *)str{
    [[[UIAlertView alloc]initWithTitle:@"" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}
- (void)signInSuccess:(id) result{
    [[NSUserDefaults standardUserDefaults] setObject:@{@"email":fieldEmail.text,
                                                       @"name":[result objectForKey:@"UserName"]} forKey:@"user"];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
