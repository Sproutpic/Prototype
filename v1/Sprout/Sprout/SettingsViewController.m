//
//  SettingsViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 05/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setController];
}
- (void)setController{
    self.view.backgroundColor = [UIColor whiteColor];
    utils = [[UIUtils alloc]init];
    
    [self setNavigationBar];
    
    [self setMenu];
    
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
    [back addTarget:self action:@selector(backToMyProjects:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = barButton;
}
- (IBAction)backToMyProjects:(UIButton *)sender{
    [self.sidePanelController showCenterPanelAnimated:YES];
}
- (void)setTitleViewForNavBar{
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [utils attrString:@"Settings" withFont:[utils fontForNavBarTitle] color:[UIColor whiteColor] andCharSpacing:[NSNumber numberWithInt:0]];
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    
    self.navigationItem.titleView = label;
}
- (void)setMenu{
    [self setButtons:@[@"About Sproutpic",
                       @"FAQ",
                       @"Account Information",
                       @"Change Password",
                       @"Secure Access"]];
    
    
}
- (void)setButtons:(NSArray *) selection{
    CGFloat y = 10;
    for (NSString *str in selection) {
        [self.view addSubview:[self addButton:str withOriginY:y]];
        [self.view addSubview:[self addSeparator:[utils colorMenuButtonsSeparator] withOriginY:y + 50]];
        y += 52;
    }
}
- (UIButton *)addButton:(NSString *)str withOriginY:(CGFloat)y{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-10, 50)];
    [self setTitleForButton:str forButton:button];
    [button addSubview:[self addArrowRight]];
    [button addTarget:self action:@selector(menuButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (IBAction)menuButtonTapped:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
            [self.navigationController pushViewController:[[AboutViewController alloc] init] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[[FAQViewController alloc] init] animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[[AccountInformationViewController alloc] init] animated:YES];
            break;
        case 4:
            [self.navigationController pushViewController:[[SecureAccessViewController alloc] init] animated:YES];
            break;
        case 5:
            [self.navigationController pushViewController:[[ChangePasswordViewController alloc] init] animated:YES];
            break;
        default:
            break;
    }
}
- (void)setTitleForButton:(NSString *)str forButton:(UIButton *)button{
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [utils attrString:str withFont:[utils fontForNavBarTitle] color:[UIColor blackColor] andCharSpacing:[NSNumber numberWithInt:0]];
    [label sizeToFit];
    label.frame = CGRectMake(10, (button.frame.size.height - label.frame.size.height)/2  , label.frame.size.width, label.frame.size.height);
    [button addSubview:label];
    
    [self setTagForButtons:button withStr:str];
}
- (void)setTagForButtons:(UIButton *)button withStr:(NSString *)str{
    if ([str isEqualToString:@"About Sproutpic"]) {
        button.tag = 1;
    }else if ([str isEqualToString:@"FAQ"]){
        button.tag = 2;
    }else if ([str isEqualToString:@"Account Information"]){
        button.tag = 3;
    }else if ([str isEqualToString:@"Change Password"]){
        button.tag = 5;
    }else if ([str isEqualToString:@"Secure Access"]){
        button.tag = 4;
    }
}
- (UIView *)addSeparator:(UIColor *)color withOriginY:(CGFloat)y{
    UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-10, 2)];
    separator.backgroundColor = color;
    return separator;
}
- (UIImageView *)addArrowRight{
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-38, 16, 10, 18)];
    arrow.image = [UIImage imageNamed:@"arrow_right"];
    return arrow;
}
@end
