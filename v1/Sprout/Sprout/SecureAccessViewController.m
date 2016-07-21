//
//  SecureAccessViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 19/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SecureAccessViewController.h"

@implementation SecureAccessViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setController];
}
- (void)setController{
    self.view.backgroundColor = [UIColor whiteColor];
    utils = [[UIUtils alloc]init];
    
    [self setNavigationBar];
    [self setPassCodeView];
}
- (void)setPassCodeView{
    [self formatBlackNoteWithOrigin:24.5 andString:@"Enable Passcode" forView:self.view];
    
    [self setSeparatorView];
    [self setSwitch];
    switcherView = [[UIView alloc] initWithFrame:CGRectMake(0, 62, self.view.frame.size.width, 0)];
    switcherView.clipsToBounds = YES;
    switcherView.alpha = 0;
    [self.view addSubview:switcherView];
    [self switcherViewOff];
}
- (void)setSeparatorView{
    [self formatSeparatorWithOriginY:60 forView:self.view];
}
- (void)setSwitch{
    enableSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 65, 16.5, 0, 0)];
    [self.view addSubview:enableSwitch];
    enableSwitch.onTintColor = [utils colorNavigationBar];
    [enableSwitch addTarget:self action:@selector(switched:)
    forControlEvents:UIControlEventValueChanged];
}
-(IBAction)switched:(UISwitch *)sender{
    [UIView animateWithDuration:0.2 animations:^{
        switcherView.alpha = 0;
    } completion:^(BOOL finished){
        for (UIView *view in switcherView.subviews) {
            [view removeFromSuperview];
        }
        if(sender.on){
            [self switcherViewOn];
        }else{
            [self switcherViewOff];
        }
    }];
}
- (void)switcherViewOn{
    [self.navigationController pushViewController:[[EnablePasscodeViewController alloc] init] animated:YES];
    
    [self formatSeparatorWithOriginY:53 forView:switcherView];
    [self formatBlackNoteWithOrigin:17.5 andString:@"Change Passcode" forView:switcherView];
    [switcherView addSubview:[self addArrowRightWithOriginY:15.5]];
    [self formatSeparatorWithOriginY:135 forView:switcherView];
    [self formatBlackNoteWithOrigin:154.5 andString:@"Auto-lock in" forView:switcherView];
    [switcherView addSubview:[self addArrowRightWithOriginY:152.5]];
    [self addMinutes];
    [self formatGreenNoteWithOrigin:61 andString:@"Don't worry about your projects and progress\nsecurity by setting up a passcode." forView:switcherView];
    [self formatSeparatorWithOriginY:193 forView:switcherView];
    [self formatGreenNoteWithOrigin:210 andString:@"In case you forget your passcode, you'll be\nsuggested to contact us for recovery.\n\nIf you're a registered user your data is synced\nwith your account and you will be able to\nre-enter your sign in information to access\nyour data and change the passcode." forView:switcherView];
    
    switcherView.frame = CGRectMake(0, 62, self.view.frame.size.width, self.view.frame.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        switcherView.alpha = 1;
    } ];
}
- (void)addMinutes{
    UILabel *lblNote = [[UILabel alloc] init];
    lblNote.attributedText = [[NSAttributedString alloc]initWithString:@"15 min" attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                        NSFontAttributeName: [utils fontBoldForSize:14]}];
    [lblNote sizeToFit];
    lblNote.frame = CGRectMake(self.view.frame.size.width - lblNote.frame.size.width - 42, 158.5, lblNote.frame.size.width, lblNote.frame.size.height);
    [switcherView addSubview:lblNote];
}
- (UIImageView *)addArrowRightWithOriginY:(CGFloat)y{
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-32, y, 22, 25)];
    arrow.image = [UIImage imageNamed:@"arrow_right"];
    return arrow;
}
- (void)formatSeparatorWithOriginY:(CGFloat)y forView:(UIView *)view{
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, 2)];
    separator.backgroundColor = [utils colorMenuButtonsSeparator];
    [view addSubview:separator];
}
- (void)formatGreenNoteWithOrigin:(CGFloat)y andString:(NSString *)str forView:(UIView *)view{
    UILabel *lblNote = [[UILabel alloc] init];
    lblNote.numberOfLines = 0;
    lblNote.attributedText = [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                                                                                                                                                                                                                                                                                         NSFontAttributeName: [utils fontRegularForSize:13]}];
    [lblNote sizeToFit];
    lblNote.frame = CGRectMake(15, y, lblNote.frame.size.width, lblNote.frame.size.height);
    [view addSubview:lblNote];
}
- (void)formatBlackNoteWithOrigin:(CGFloat)y andString:(NSString *)str forView:(UIView *)view{
    UILabel *lblNote = [[UILabel alloc]init];
    lblNote.attributedText = lblNote.attributedText = [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                                                                                                                             NSFontAttributeName: [utils fontRegularForSize:18]}];
    [lblNote sizeToFit];
    lblNote.frame = CGRectMake(15, y, lblNote.frame.size.width, lblNote.frame.size.height);
    [view addSubview:lblNote];
}
- (void)switcherViewOff{
    UILabel *lblNote = [[UILabel alloc] init];
    lblNote.numberOfLines = 0;
    lblNote.attributedText = [[NSAttributedString alloc]initWithString:@"Don't worry about your projects and progress\nsecurity by setting up a passcode." attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                                                                NSFontAttributeName: [utils fontRegularForSize:13]}];
    [lblNote sizeToFit];
    lblNote.frame = CGRectMake(15, 20, lblNote.frame.size.width, lblNote.frame.size.height);
    [switcherView addSubview:lblNote];
    switcherView.frame = CGRectMake(0, 62, self.view.frame.size.width, 25 + lblNote.frame.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        switcherView.alpha = 1;
    } ];
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
    label.attributedText = [utils attrString:@"Secure Access" withFont:[utils fontForNavBarTitle] color:[UIColor whiteColor] andCharSpacing:[NSNumber numberWithInt:0]];
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    
    self.navigationItem.titleView = label;
}
@end
