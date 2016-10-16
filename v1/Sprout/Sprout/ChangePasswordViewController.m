//
//  ChangePasswordViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 28/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

// TODO - Rewrite entire class...

#import "ChangePasswordViewController.h"
#import "UIUtils.h"

@implementation ChangePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setController];
}

- (void)setController
{
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [self setNavigationBar];
    [self setupLayout];
    [self addRightBarButton];
}

- (void)setupLayout
{
    [self setupFields];
}

- (void)addRightBarButton
{
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [back setBackgroundImage:[UIImage imageNamed:@"circleCheck"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(confirmChangePassword:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.rightBarButtonItem = barButton;
}
-(IBAction)confirmChangePassword:(id)sender{
    if ([self isNotFilledAll]) {
        [self showAlertWithMessage:@"Please complete all fields."];
    }else if(!([fieldNewPass.text isEqualToString:fieldRepeatPass.text])){
        [self showAlertWithMessage:@"New password mismatch."];
    }else{
        webService = [[WebService alloc] init];
        [webService requestChangePassword:@{@"email":[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"user"] objectForKey:@"email"]],
                                            @"oldPasswordEncoded":[[fieldCurrentPass.text dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0],
                                            @"newPasswordEncoded":[[fieldNewPass.text dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0]} withTarget:self];
    }
}
-(BOOL)isNotFilledAll{
    return ( [[fieldCurrentPass.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] || [[fieldNewPass.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] || [[fieldRepeatPass.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]);
}
- (void)setupFields{
    for (int i = 0; i<3; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.09, 17 + (60 * i), self.view.frame.size.width * 0.82, 44)];
        view.layer.borderWidth = 1.2;
        view.layer.borderColor = [UIUtils colorNavigationBar].CGColor;
        view.layer.cornerRadius = 3;
        
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(view.frame.origin.x + 15, view.frame.origin.y, view.frame.size.width - 15 - view.frame.size.height, view.frame.size.height)];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.alignment = NSTextAlignmentCenter;
        field.delegate = self;
        //field.backgroundColor = [UIColor greenColor];
        field.textColor = [UIUtils colorNavigationBar];
        field.tintColor = [UIUtils colorNavigationBar];
        field.font = [UIUtils fontRegularForSize:15];
        field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: [UIUtils colorNavigationBar],
                                                                                                     NSFontAttributeName: [UIUtils fontRegularForSize:15]}];
        [self.view addSubview:view];
        
        switch (i) {
            case 0:{
                field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Current Password" attributes:@{NSForegroundColorAttributeName: [UIUtils colorNavigationBar],
                                                                                                                        NSFontAttributeName: [UIUtils fontRegularForSize:15]}];
                fieldCurrentPass = field;
                [self.view addSubview:fieldCurrentPass];
                
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - field.frame.size.height * 0.1, field.frame.origin.y + field.frame.size.height * 0.4, field.frame.size.height * 0.4, field.frame.size.height * 0.25)];
                image.image = [UIImage imageNamed:@"eye"];
                image.userInteractionEnabled = YES;
                image.tag = 0;
                [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedEye:)]];
                
                [self.view addSubview:image];
            }
                break;
            case 1:{
                field.keyboardType = UIKeyboardTypeEmailAddress;
                field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName: [UIUtils colorNavigationBar],
                                                                                                                     NSFontAttributeName: [UIUtils fontRegularForSize:15]}];
                fieldNewPass = field;
                [self.view addSubview:fieldNewPass];
                
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - field.frame.size.height * 0.1, field.frame.origin.y + field.frame.size.height * 0.4, field.frame.size.height * 0.4, field.frame.size.height * 0.25)];
                image.image = [UIImage imageNamed:@"eye"];
                image.userInteractionEnabled = YES;
                image.tag = 1;
                [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedEye:)]];
                
                [self.view addSubview:image];
            }
                break;
            case 2:{
                field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Repeat Password" attributes:@{NSForegroundColorAttributeName: [UIUtils colorNavigationBar],
                                                                                                                        NSFontAttributeName: [UIUtils fontRegularForSize:15]}];
                fieldRepeatPass = field;
                [self.view addSubview:fieldRepeatPass];
                
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - field.frame.size.height * 0.1, field.frame.origin.y + field.frame.size.height * 0.4, field.frame.size.height * 0.4, field.frame.size.height * 0.25)];
                image.image = [UIImage imageNamed:@"eye"];
                image.userInteractionEnabled = YES;
                image.tag = 2;
                [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedEye:)]];
                
                [self.view addSubview:image];
            }
                break;
            default:
                break;
        }
    }
    UILabel *answer = [[UILabel alloc]init];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.lineSpacing = 3;
    paraStyle.alignment = NSTextAlignmentCenter;
    answer.numberOfLines = 0;
    answer.attributedText = [[NSAttributedString alloc] initWithString:@"We advice you to use strong password containing uppercase and lowercase letter together with digits.\n\nPassword should be at least 8 characters." attributes:@{NSFontAttributeName: [UIUtils fontRegularForSize:14],
                                                                                                                                                         NSKernAttributeName:[NSNumber numberWithFloat:0.f],
                                                                                                                                                                                                                                         NSForegroundColorAttributeName: [UIUtils colorNavigationBar],
                                                                                                                                                         NSParagraphStyleAttributeName: paraStyle}];
    CGRect rect = [answer.attributedText boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    answer.frame = CGRectMake((self.view.frame.size.width - (self.view.frame.size.width - 30)) / 2, 225, self.view.frame.size.width - 30, rect.size.height);
    [self.view addSubview:answer];
}
- (void)tappedEye:(UITapGestureRecognizer *)sender{
    sender.view.tag == 0 ? (fieldCurrentPass.secureTextEntry = fieldCurrentPass.secureTextEntry ? NO : YES):
    (sender.view.tag == 1 ? (fieldNewPass.secureTextEntry = fieldNewPass.secureTextEntry ? NO : YES) :
     (fieldRepeatPass.secureTextEntry = fieldRepeatPass.secureTextEntry ? NO : YES));
 
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
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setTitleViewForNavBar{
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [UIUtils attrString:@"Change Password" withFont:[UIUtils fontForNavBarTitle] color:[UIColor whiteColor] andCharSpacing:[NSNumber numberWithInt:0]];
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    
    self.navigationItem.titleView = label;
}
- (void)showAlertWithMessage:(NSString *)str{
    [[[UIAlertView alloc]initWithTitle:@"" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}
@end
