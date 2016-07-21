//
//  SignUpViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 21/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SignUpViewController.h"

@implementation SignUpViewController
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
    [self setupSignUPButton];
    [self setupFooter];
    [self setupCheckBox];
}
- (void)setupCheckBox{
    [self addCheckBox];
    UILabel *lblNote = [[UILabel alloc] init];
    lblNote.numberOfLines = 0;
    lblNote.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"I aggree to " attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                                                         NSFontAttributeName: [utils fontRegularForSize:13.3]}];
    [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"Terms and Condition" attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                                           NSFontAttributeName: [utils fontRegularForSize:13.3],
                                                                                                                   NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}]];
    [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" and " attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                                                   NSFontAttributeName: [utils fontRegularForSize:13.3]}]];
    [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"Privacy Policy" attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                                                   NSFontAttributeName: [utils fontRegularForSize:13.3],
                                                                                                                   NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}]];
    lblNote.attributedText = attrStr;
    CGRect size = [attrStr boundingRectWithSize:CGSizeMake(self.view.frame.size.width - (self.view.frame.size.width * 0.2 + 32), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    //lblNote.layer.borderWidth = 1;
    //[lblNote sizeToFit];
    lblNote.frame = CGRectMake(self.view.frame.size.width * 0.11 + 32, 198, self.view.frame.size.width - (self.view.frame.size.width * 0.2 + 32), size.size.height);
    [self.view addSubview:lblNote];
}
- (void)addCheckBox{
    UILabel *lblNote = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.11, 194, 22, 22)];
    lblNote.layer.borderWidth = 1.2;
    lblNote.textColor = [utils colorNavigationBar];
    lblNote.textAlignment = NSTextAlignmentCenter;
    lblNote.font = [utils fontRegularForSize:20];
    lblNote.layer.borderColor = [utils colorNavigationBar].CGColor;
    lblNote.layer.cornerRadius = 3;
    lblNote.userInteractionEnabled = YES;
    [lblNote addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCheck:)]];
    [self.view addSubview:lblNote];
}
- (void)tappedCheck:(UITapGestureRecognizer *)sender{
    ((UILabel *)sender.view).text = [((UILabel *)sender.view).text length] == 0 ? @"✓": @"";
}
- (void)setupFooter{
    UILabel *lblNote = [[UILabel alloc] init];
    lblNote.attributedText = [[NSAttributedString alloc]initWithString:@"Already SproutPic user?" attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                               NSFontAttributeName: [utils fontRegularForSize:15]}];
    [lblNote sizeToFit];
    lblNote.frame = CGRectMake(self.view.frame.size.width * 0.09, 337, lblNote.frame.size.width, lblNote.frame.size.height);
    [self.view addSubview:lblNote];
    
    lblNote = [[UILabel alloc] init];
    lblNote.attributedText =  [[NSAttributedString alloc]initWithString:@"Sign In" attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                                                NSFontAttributeName: [utils fontRegularForSize:15],
                                                                                                NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    [lblNote sizeToFit];
    lblNote.frame = CGRectMake(self.view.frame.size.width * 0.91 - lblNote.frame.size.width, 337, lblNote.frame.size.width, lblNote.frame.size.height);
    lblNote.userInteractionEnabled = YES;
    [lblNote addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedSignIn:)]];
    [self.view addSubview:lblNote];
}
- (void)tappedSignIn:(UITapGestureRecognizer *)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
    SignInViewController *signInController = [[SignInViewController alloc] init];
    signInController.accountInfoController = _accountInfoController;
    [self.navigationController pushViewController:signInController animated:YES];
}
- (void)setupSignUPButton{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.09, 263, self.view.frame.size.width * 0.82, 44)];
    button.backgroundColor = [utils colorNavigationBar];
    button.layer.cornerRadius = 3;
    [button setAttributedTitle:[[NSAttributedString alloc]initWithString:@"Sign Up" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                              NSFontAttributeName: [utils fontRegularForSize:15]}] forState:UIControlStateNormal];
    [self.view addSubview:button];
}
- (void)setupFields{
    for (int i = 0; i<3; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.09, 17 + (60 * i), self.view.frame.size.width * 0.82, 44)];
        view.layer.borderWidth = 1.2;
        view.layer.borderColor = [utils colorNavigationBar].CGColor;
        view.layer.cornerRadius = 3;
        
        UITextField *field = [[UITextField alloc] initWithFrame:view.frame];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.alignment = NSTextAlignmentCenter;
        field.delegate = self;
        field.textAlignment = NSTextAlignmentCenter;
        field.textColor = [utils colorNavigationBar];
        field.tintColor = [utils colorNavigationBar];
        field.font = [utils fontRegularForSize:15];
        field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                                     NSFontAttributeName: [utils fontRegularForSize:15],
                                                                                                     NSParagraphStyleAttributeName: paraStyle}];
        [self.view addSubview:view];
        
        switch (i) {
            case 0:
                fieldName = field;
                [self.view addSubview:fieldName];
                break;
            case 1:
                field.keyboardType = UIKeyboardTypeEmailAddress;
                field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Type Your Email Here" attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                                                             NSFontAttributeName: [utils fontRegularForSize:15],
                                                                                                                             NSParagraphStyleAttributeName: paraStyle}];
                fieldEmail = field;
                [self.view addSubview:fieldEmail];
                break;
            case 2:{
                field.secureTextEntry = YES;
                field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Type Your Password Here" attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                                                                NSFontAttributeName: [utils fontRegularForSize:15],
                                                                                                                                NSParagraphStyleAttributeName: paraStyle}];
                field.frame = CGRectMake(field.frame.origin.x + field.frame.size.width * 0.15, field.frame.origin.y, field.frame.size.width * 0.7, field.frame.size.height);
                fieldPassword = field;
                [self.view addSubview:fieldPassword];
                
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - field.frame.size.height * 0.1, field.frame.origin.y + field.frame.size.height * 0.3, field.frame.size.height * 0.4, field.frame.size.height * 0.4)];
                image.image = [UIImage imageNamed:@"eye"];
                image.userInteractionEnabled = YES;
                [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedShowPass:)]];
                
                [self.view addSubview:image];
                break;
            }
            default:
                break;
        }
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)tappedShowPass:(UITapGestureRecognizer *)sender{
    fieldPassword.secureTextEntry = fieldPassword.secureTextEntry ? NO : YES;
}

- (void)setNavigationBar{
    self.navigationController.navigationBar.barTintColor = [utils colorNavigationBar];
    self.navigationController.navigationBar.backgroundColor = [utils colorNavigationBar];
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
    label.attributedText = [utils attrString:@"Sign Up" withFont:[utils fontForNavBarTitle] color:[UIColor whiteColor] andCharSpacing:[NSNumber numberWithInt:0]];
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    
    self.navigationItem.titleView = label;
}
@end
