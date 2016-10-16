//
//  SecureAccessViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 19/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

// TODO - Rewrite entire class...

#import "SecureAccessViewController.h"
#import "UIUtils.h"

@implementation SecureAccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setController];
}

- (void)setController
{
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [self setNavigationBar];
    [self setPassCodeView];
    pickerData = [[NSMutableArray alloc]initWithObjects:@"1 min",@"5 mins",@"10 mins",@"15 mins", @"45 mins",@"60 mins", nil];
    autolockSelect = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 216)];
    autolockSelect.showsSelectionIndicator = YES;
    autolockSelect.hidden = NO;
    autolockSelect.delegate = self;
    autolockSelect.dataSource = self;
    [self.view addSubview:autolockSelect];
    pickerTool = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40)];
    pickerTool.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.8, 0, self.view.frame.size.width * 0.2, 40)];
    [button setAttributedTitle:[[NSAttributedString alloc]initWithString:@"Done" attributes:@{NSForegroundColorAttributeName: [UIUtils colorNavigationBar], NSFontAttributeName:[UIUtils fontBoldForSize:16]}] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [pickerTool addSubview:button];
    [self.view addSubview:pickerTool];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    
}

- (void)setPassCodeView
{
    [self formatBlackNoteWithOrigin:24.5 andString:@"Enable Passcode" forView:self.view];
    
    [self setSeparatorView];
    [self setSwitch];
    switcherView = [[UIView alloc] initWithFrame:CGRectMake(0, 62, self.view.frame.size.width, 0)];
    switcherView.clipsToBounds = YES;
    switcherView.alpha = 0;
    [self.view addSubview:switcherView];
    [self switcherViewOff];
}

- (void)setSeparatorView
{
    [self formatSeparatorWithOriginY:60 forView:self.view];
}

- (void)setSwitch
{
    enableSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 65, 16.5, 0, 0)];
    [self.view addSubview:enableSwitch];
    enableSwitch.onTintColor = [UIUtils colorNavigationBar];
    enableSwitch.backgroundColor = [UIColor colorWithRed:173.f/255.f green:175.f/255.f blue:177.f/255.f alpha:1];
    enableSwitch.tintColor = [UIColor colorWithRed:173.f/255.f green:175.f/255.f blue:177.f/255.f alpha:1];
    enableSwitch.layer.cornerRadius = 16.0;
    [enableSwitch addTarget:self action:@selector(switched:)
    forControlEvents:UIControlEventValueChanged];
}

- (IBAction)switched:(UISwitch *)sender
{
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

- (void)switcherViewOn
{
    [self.navigationController pushViewController:[[EnablePasscodeViewController alloc] init] animated:YES];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 53)];
    [button addTarget:self action:@selector(changePass:) forControlEvents:UIControlEventTouchUpInside];
    [switcherView addSubview:button];
    [self formatSeparatorWithOriginY:53 forView:switcherView];
    [self formatBlackNoteWithOrigin:17.5 andString:@"Change Passcode" forView:switcherView];
    [switcherView addSubview:[self addArrowRightWithOriginY:17.5]];
    [self formatSeparatorWithOriginY:135 forView:switcherView];
    button = [[UIButton alloc]initWithFrame:CGRectMake(0, 135, self.view.frame.size.width, 53)];
    [button addTarget:self action:@selector(autoLockTap:) forControlEvents:UIControlEventTouchUpInside];
    [switcherView addSubview:button];
    [self formatBlackNoteWithOrigin:154.5 andString:@"Auto-lock in" forView:switcherView];
    [switcherView addSubview:[self addArrowRightWithOriginY:156.5]];
    [self addMinutes];
    [self formatGreenNoteWithOrigin:61 andString:@"Don't worry about your projects and progress\nsecurity by setting up a passcode." forView:switcherView];
    [self formatSeparatorWithOriginY:193 forView:switcherView];
    [self formatGreenNoteWithOrigin:210 andString:@"In case you forget your passcode, you'll be\nsuggested to contact us for recovery.\n\nIf you're a registered user your data is synced\nwith your account and you will be able to\nre-enter your sign in information to access\nyour data and change the passcode." forView:switcherView];
    
    switcherView.frame = CGRectMake(0, 62, self.view.frame.size.width, self.view.frame.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        switcherView.alpha = 1;
    } ];
}

- (IBAction)changePass:(id)sender
{
    [self.navigationController pushViewController:[[EnablePasscodeViewController alloc] init] animated:YES];
}

- (IBAction)autoLockTap:(id)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        autolockSelect.backgroundColor = [UIColor whiteColor];
        autolockSelect.frame = CGRectMake(0, self.view.frame.size.height - 216, self.view.frame.size.width, 216);
        pickerTool.frame = CGRectMake(0, autolockSelect.frame.origin.y - 40, self.view.frame.size.width, 40);
    }];
}

- (IBAction)doneAction:(id)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        autolockSelect.backgroundColor = [UIColor whiteColor];
        autolockSelect.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 216);
        pickerTool.frame = CGRectMake(0, autolockSelect.frame.origin.y, self.view.frame.size.width, 40);
    }];
}

- (void)addMinutes
{
    UILabel *lblNote = [[UILabel alloc] init];
    lblNote.attributedText = [[NSAttributedString alloc]initWithString:@"15 min" attributes:@{NSForegroundColorAttributeName: [UIUtils colorNavigationBar],
                                                                                        NSFontAttributeName: [UIUtils fontBoldForSize:14]}];
    [lblNote sizeToFit];
    lblNote.frame = CGRectMake(self.view.frame.size.width - lblNote.frame.size.width - 42, 158.5, lblNote.frame.size.width, lblNote.frame.size.height);
    [switcherView addSubview:lblNote];
}

- (UIImageView *)addArrowRightWithOriginY:(CGFloat)y{
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-27, y, 10, 18)];
    arrow.image = [UIImage imageNamed:@"arrow_right"];
    return arrow;
}
- (void)formatSeparatorWithOriginY:(CGFloat)y forView:(UIView *)view{
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, 2)];
    separator.backgroundColor = [UIUtils colorMenuButtonsSeparator];
    [view addSubview:separator];
}
- (void)formatGreenNoteWithOrigin:(CGFloat)y andString:(NSString *)str forView:(UIView *)view{
    UILabel *lblNote = [[UILabel alloc] init];
    lblNote.numberOfLines = 0;
    lblNote.attributedText = [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName: [UIUtils colorNavigationBar],
                                                                                                                                                                                                                                                                                                                                                         NSFontAttributeName: [UIUtils fontRegularForSize:13]}];
    [lblNote sizeToFit];
    lblNote.frame = CGRectMake(15, y, lblNote.frame.size.width, lblNote.frame.size.height);
    [view addSubview:lblNote];
}
- (void)formatBlackNoteWithOrigin:(CGFloat)y andString:(NSString *)str forView:(UIView *)view{
    UILabel *lblNote = [[UILabel alloc]init];
    lblNote.attributedText = lblNote.attributedText = [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                                                                                                                             NSFontAttributeName: [UIUtils fontRegularForSize:18]}];
    [lblNote sizeToFit];
    lblNote.frame = CGRectMake(15, y, lblNote.frame.size.width, lblNote.frame.size.height);
    [view addSubview:lblNote];
}
- (void)switcherViewOff{
    UILabel *lblNote = [[UILabel alloc] init];
    lblNote.numberOfLines = 0;
    lblNote.attributedText = [[NSAttributedString alloc]initWithString:@"Don't worry about your projects and progress\nsecurity by setting up a passcode." attributes:@{NSForegroundColorAttributeName: [UIUtils colorNavigationBar],
                                                                                                                                NSFontAttributeName: [UIUtils fontRegularForSize:13]}];
    [lblNote sizeToFit];
    lblNote.frame = CGRectMake(15, 20, lblNote.frame.size.width, lblNote.frame.size.height);
    [switcherView addSubview:lblNote];
    switcherView.frame = CGRectMake(0, 62, self.view.frame.size.width, 25 + lblNote.frame.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        switcherView.alpha = 1;
    } ];
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
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setTitleViewForNavBar{
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [UIUtils attrString:@"Secure Access" withFont:[UIUtils fontForNavBarTitle] color:[UIColor whiteColor] andCharSpacing:[NSNumber numberWithInt:0]];
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    
    self.navigationItem.titleView = label;
}
@end
