//
//  AccountInformationViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 19/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "AccountInformationViewController.h"

@implementation AccountInformationViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setController];
}
- (void)setController{
    self.view.backgroundColor = [UIColor whiteColor];
    utils = [[UIUtils alloc]init];
    
    [self setNavigationBar];
    
    signedIn = NO;
    
    if(signedIn){
        [self setLayoutForAlreadySignedIn];
    }else{
        [self setLayoutForDefault];
    }
}
- (void)setLayoutForAlreadySignedIn{
    [self addRightBarButton];
    [self addSeparatorForFields];
    [self addLabelsForFields];
    [self addInfoLabelsForFields];
}
- (void)addSeparatorForFields{
    CGFloat y = 20;
    for (y = 60; y < 181; y += 60) {
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-10, 2)];
        separator.backgroundColor = [utils colorMenuButtonsSeparator];
        [self.view addSubview:separator];
    }
}
- (void)addLabelsForFields{
    CGFloat y = 15;
    for (NSString *str in @[@"Name",@"Email",@"Gender"]) {
        UILabel *lblNote = [[UILabel alloc] init];
        lblNote.attributedText = [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                            NSFontAttributeName: [utils fontRegularForSize:14]}];
        [lblNote sizeToFit];
        lblNote.frame = CGRectMake(15, y, lblNote.frame.size.width, lblNote.frame.size.height);
        [self.view addSubview:lblNote];
        y += 60;
    }
}
- (void)addInfoLabelsForFields{
    CGFloat y = 33;
    for (NSString *str in @[@"Iryna Aharkova",@"irina@appsitude.com",@"Female"]) {
        UILabel *lblNote = [[UILabel alloc] init];
        lblNote.attributedText = [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:128.f/255.f green:126.f/255.f blue:125.f/255.f alpha:1.f],
                                                                                            NSFontAttributeName: [utils fontRegularForSize:18]}];
        [lblNote sizeToFit];
        lblNote.frame = CGRectMake(10, y, lblNote.frame.size.width, lblNote.frame.size.height);
        [self.view addSubview:lblNote];
        y += 60;
    }
}
- (void)addRightBarButton{
    UIButton *download = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [download setBackgroundImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:download];
    self.navigationItem.rightBarButtonItem = barButton;
}
- (void)setLayoutForDefault{
    UILabel *lblSignIn = [[UILabel alloc]init];
    lblSignIn.attributedText = [[NSAttributedString alloc]initWithString:@"SIGN IN" attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                                                                                 NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                                 NSFontAttributeName: [utils fontRegularForSize:14]}];
    [lblSignIn sizeToFit];
    
    UILabel *lblOr = [[UILabel alloc]init];
    lblOr.attributedText = [[NSAttributedString alloc]initWithString:@"  or  " attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                             NSFontAttributeName: [utils fontRegularForSize:14]}];
    [lblOr sizeToFit];
    
    UILabel *lblSignUp = [[UILabel alloc]init];
    lblSignUp.attributedText = [[NSAttributedString alloc]initWithString:@"SIGN UP" attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                                                                                 NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                                 NSFontAttributeName: [utils fontRegularForSize:14]}];
    [lblSignUp sizeToFit];
    
    CGFloat totalLabelsWidth = lblSignIn.frame.size.width + lblOr.frame.size.width + lblSignUp.frame.size.width;
    CGFloat originY = self.view.frame.size.height * 0.09;
    
    lblSignIn.frame = CGRectMake((self.view.frame.size.width - totalLabelsWidth) / 2, originY, lblSignIn.frame.size.width, lblSignIn.frame.size.height);
    lblOr.frame = CGRectMake((self.view.frame.size.width - totalLabelsWidth) / 2 + lblSignIn.frame.size.width, originY, lblOr.frame.size.width, lblOr.frame.size.height);
    lblSignUp.frame = CGRectMake((self.view.frame.size.width - totalLabelsWidth) / 2 + lblSignIn.frame.size.width + lblOr.frame.size.width, originY, lblSignUp.frame.size.width, lblSignUp.frame.size.height);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedSignUp:)];
    [lblSignUp setUserInteractionEnabled:YES];
    [lblSignUp addGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedSignIn:)];
    [lblSignIn setUserInteractionEnabled:YES];
    [lblSignIn addGestureRecognizer:tap];
    
    [self.view addSubview:lblSignIn];
    [self.view addSubview:lblOr];
    [self.view addSubview:lblSignUp];
    
    UILabel *lblNote = [[UILabel alloc]init];
    lblNote.numberOfLines = 0;
    lblNote.textAlignment = NSTextAlignmentCenter;
    lblNote.attributedText = [[NSAttributedString alloc]initWithString:@"to check and edit your account information.\nYou can do that once you're ready :)\n\n*required for sharing within community" attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                                 NSFontAttributeName: [utils fontRegularForSize:14]}];
    [lblNote sizeToFit];
    lblNote.frame = CGRectMake((self.view.frame.size.width - lblNote.frame.size.width) / 2, originY + lblOr.frame.size.height * 1.2, lblNote.frame.size.width, lblNote.frame.size.height);
    [self.view addSubview:lblNote];
}
- (void)tappedSignIn:(UITapGestureRecognizer *)sender{
    SignInViewController *signController = [[SignInViewController alloc] init];
    signController.accountInfoController = self;
    [self.navigationController pushViewController:signController animated:YES];
}
- (void)tappedSignUp:(UITapGestureRecognizer *)sender{
    SignUpViewController *signController = [[SignUpViewController alloc] init];
    signController.accountInfoController = self;
    [self.navigationController pushViewController:signController animated:YES];
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
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setTitleViewForNavBar{
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [utils attrString:@"Account Information" withFont:[utils fontForNavBarTitle] color:[UIColor whiteColor] andCharSpacing:[NSNumber numberWithInt:0]];
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    
    self.navigationItem.titleView = label;
}
@end
