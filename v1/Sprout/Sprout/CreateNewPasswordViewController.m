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
}
- (void)setupFields{
    for (int i = 0; i<2; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.09, 17 + (60 * i), self.view.frame.size.width * 0.82, 44)];
        view.layer.borderWidth = 1.2;
        view.layer.borderColor = [utils colorNavigationBar].CGColor;
        view.layer.cornerRadius = 3;
        
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(view.frame.origin.x + 15, view.frame.origin.y, view.frame.size.width - 15, view.frame.size.height)];
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
            case 0:
                field.keyboardType = UIKeyboardTypeEmailAddress;
                field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                                                             NSFontAttributeName: [utils fontRegularForSize:15]}];
                fieldNewPass = field;
                [self.view addSubview:fieldNewPass];
                break;
            case 1:{
                field.secureTextEntry = YES;
                field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Repeat Password" attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                                                                NSFontAttributeName: [utils fontRegularForSize:15]}];
                fieldRepeatPass = field;
                [self.view addSubview:fieldRepeatPass];
            }
                break;
            default:
                break;
        }
    }
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
    label.attributedText = [utils attrString:@"Create New Password" withFont:[utils fontForNavBarTitle] color:[UIColor whiteColor] andCharSpacing:[NSNumber numberWithInt:0]];
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    
    self.navigationItem.titleView = label;
}
@end
