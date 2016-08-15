//
//  EnablePasscodeViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 21/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "EnablePasscodeViewController.h"

@implementation EnablePasscodeViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setController];
}
- (void)setController{
    self.view.backgroundColor = [UIColor whiteColor];
    utils = [[UIUtils alloc]init];
    
    [self setNavigationBar];
    [self setPasscodeLayout];
}
-(void)setPasscodeLayout{
    lblPass = [self formatLabel:@"Enter Passcode" withOriginY:self.view.frame.size.height * 0.07];
    [self.view addSubview:lblPass];
    [self addLines];
    field = [[UITextField alloc] init];
    field.delegate = self;
    field.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:field];
    UITapGestureRecognizer *tapOpenKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOpenKeyBoard:)];
    [self.view addGestureRecognizer:tapOpenKeyboard];
}
-(void)tappedOpenKeyBoard:(UITapGestureRecognizer *)sender{
    [field becomeFirstResponder];
}
-(UILabel *)formatLabel:(NSString *)str withOriginY:(CGFloat)y{
    UILabel *lblNote = [[UILabel alloc] init];
    lblNote.attributedText = [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar],
                                                                                        NSFontAttributeName:[utils fontRegularForSize:15]}];
    lblNote.textAlignment = NSTextAlignmentCenter;
    lblNote.numberOfLines = 0;
    [lblNote sizeToFit];
    lblNote.frame = CGRectMake((self.view.frame.size.width - lblNote.frame.size.width)/2, y, lblNote.frame.size.width, lblNote.frame.size.height);
    return lblNote;
}
- (void)addLines{
    for (int i = 0; i<4; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * (0.11 + (0.21 * i)), self.view.frame.size.height * 0.32, self.view.frame.size.width * 0.15, 2)];
        view.backgroundColor = [utils colorNavigationBar];
        [self.view addSubview:view];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([[NSString stringWithFormat:@"%@%@",textField.text,string] length] == 4) {
        [lblPass removeFromSuperview];
        lblPass = [self formatLabel:@"Confirm Passcode" withOriginY:self.view.frame.size.height * 0.08];
        [self.view addSubview:lblPass];
    }
    if([[NSString stringWithFormat:@"%@%@",textField.text,string] length] == 8){
        [lblPass removeFromSuperview];
        lblPass = [self formatLabel:@"Confirm Passcode\n* Doesnt Match!" withOriginY:self.view.frame.size.height * 0.08];
        [self.view addSubview:lblPass];
    }
    return YES;
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
    [back setBackgroundImage:[UIImage imageNamed:@"exk"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.rightBarButtonItem = barButton;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[[UIView alloc] init]];
}
- (IBAction)backToMenu:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setTitleViewForNavBar{
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [utils attrString:@"Enable Passcode" withFont:[utils fontForNavBarTitle] color:[UIColor whiteColor] andCharSpacing:[NSNumber numberWithInt:0]];
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    
    self.navigationItem.titleView = label;
}
@end
