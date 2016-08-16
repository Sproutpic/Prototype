//
//  NewProjectViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 05/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "NewProjectViewController.h"

@implementation NewProjectViewController
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

-(void)viewDidAppear:(BOOL)animated{
    for (UIView *view in scroller.subviews) {
        [view removeFromSuperview];
    }
    [self viewDidLoad];
}

- (void)setupLayout{
    scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [scroller setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:scroller];
    
    fieldTitle = [[UITextField alloc] initWithFrame:CGRectMake(15, 7, scroller.frame.size.width - 15, 50)];
    fieldTitle.font = [utils fontRegularForSize:18];
    fieldTitle.textColor = [utils colorNavigationBar];
    fieldTitle.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Project Title" attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar], NSFontAttributeName: [utils fontRegularForSize:18]}];
    fieldTitle.tintColor = [utils colorNavigationBar];
    fieldTitle.delegate = self;
    UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(0, 49, fieldTitle.frame.size.width, 1)];
    separator.backgroundColor = [[utils colorNavigationBar]colorWithAlphaComponent:0.5];
    [fieldTitle addSubview:separator];
    [scroller addSubview:fieldTitle];
    
    UILabel *lblDesc = [[UILabel alloc] init];
    lblDesc.font = [utils fontRegularForSize:18];
    lblDesc.textColor = [utils colorNavigationBar];
    lblDesc.text = @"Project Description";
    [lblDesc sizeToFit];
    lblDesc.frame = CGRectMake(15, 17 + fieldTitle.frame.size.height, lblDesc.frame.size.width, lblDesc.frame.size.height);
    [scroller addSubview:lblDesc];
    
    UILabel *lblOpt = [[UILabel alloc] init];
    lblOpt.font = [utils fontRegularForSize:16];
    lblOpt.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.8];
    lblOpt.text = @"  (optional)";
    [lblOpt sizeToFit];
    lblOpt.frame = CGRectMake(15 + lblDesc.frame.size.width, 17 + fieldTitle.frame.size.height, lblOpt.frame.size.width, lblOpt.frame.size.height);
    [scroller addSubview:lblOpt];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineSpacing = 11.f;
    paraStyle.minimumLineHeight = 11.f;
    paraStyle.maximumLineHeight = 11.f;
    
    fieldDesc = [[UITextView alloc]initWithFrame:CGRectMake(15, lblOpt.frame.origin.y + lblOpt.frame.size.height + 12, scroller.frame.size.width - 30, 86)];
    fieldDesc.tintColor = [utils colorNavigationBar];
    fieldDesc.delegate = self;
    
    fieldDesc.attributedText = [[NSAttributedString alloc] initWithString:@"This is a description about this project, telling what user is tracking here and any other information user is willing to note down about it." attributes:@{NSFontAttributeName: [utils fontRegularForSize:16], NSForegroundColorAttributeName: [UIColor colorWithRed:67.f/255.f green:61.f/255.f blue:60.f/255.f alpha:1.f], NSParagraphStyleAttributeName: paraStyle}];
    CGRect rect = [fieldDesc.attributedText boundingRectWithSize:CGSizeMake(fieldDesc.frame.size.width - 15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    fieldDesc.frame = CGRectMake(10, fieldDesc.frame.origin.y, fieldDesc.frame.size.width + 5, rect.size.height + 15);
    [scroller addSubview:fieldDesc];
    
    separator = [[UIView alloc]initWithFrame:CGRectMake(5, fieldDesc.frame.size.height - 1, fieldDesc.frame.size.width, 1)];
    separator.backgroundColor = [[utils colorNavigationBar]colorWithAlphaComponent:0.5];
    textViewsept = separator;
    [fieldDesc addSubview:textViewsept];
    
    UIImageView *sprout = [[UIImageView alloc] initWithFrame:CGRectMake(0, fieldDesc.frame.origin.y + fieldDesc.frame.size.height, scroller.frame.size.width, self.view.frame.size.width * 0.6)];
    [sprout sd_setImageWithURL:[NSURL URLWithString:@"https://naturewallpaperhd.files.wordpress.com/2013/11/flower-backgraund-full-hd-nature-and-purple-flowers-for-your-96290.jpg"]];
    sprout.userInteractionEnabled = YES;
    [sprout addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeSprout:)]];
    [scroller addSubview:sprout];
    
    remindView = [[UIView alloc] initWithFrame:CGRectMake(0, sprout.frame.size.height + sprout.frame.origin.y, scroller.frame.size.width, 57)];
    remindView.clipsToBounds = YES;
    
    UILabel *lblRemind = [[UILabel alloc] init];
    lblRemind.text = @"Remind me";
    lblRemind.font = [utils fontRegularForSize:18];
    lblRemind.textColor = [UIColor colorWithRed:67.f/255.f green:61.f/255.f blue:60.f/255.f alpha:1.f];
    [lblRemind sizeToFit];
    lblRemind.frame = CGRectMake(15, (57 - lblRemind.frame.size.height) / 2 + 3, lblRemind.frame.size.width, lblRemind.frame.size.height);
    [remindView addSubview:lblRemind];
    
    lblRemind = [[UILabel alloc] init];
    lblRemind.text = @"Mon, 1 Jul'16, at 4:12 pm";
    lblRemind.font = [utils fontBoldForSize:14];
    lblRemind.textColor = [utils colorNavigationBar];
    [lblRemind sizeToFit];
    lblRemind.frame = CGRectMake(remindView.frame.size.width - lblRemind.frame.size.width - 15, (57 - lblRemind.frame.size.height) / 2 + 63, lblRemind.frame.size.width, lblRemind.frame.size.height);
    [remindView addSubview:lblRemind];
    
    lblRemind = [[UILabel alloc] init];
    lblRemind.text = @"Remind on";
    lblRemind.font = [utils fontRegularForSize:18];
    lblRemind.textColor = [UIColor colorWithRed:67.f/255.f green:61.f/255.f blue:60.f/255.f alpha:1.f];
    [lblRemind sizeToFit];
    lblRemind.frame = CGRectMake(15, (57 - lblRemind.frame.size.height) / 2 + 60, lblRemind.frame.size.width, lblRemind.frame.size.height);
    [remindView addSubview:lblRemind];
    
    lblRemind = [[UILabel alloc] init];
    lblRemind.text = @"Everyday";
    lblRemind.font = [utils fontBoldForSize:14];
    lblRemind.textColor = [utils colorNavigationBar];
    [lblRemind sizeToFit];
    lblRemind.frame = CGRectMake(remindView.frame.size.width - lblRemind.frame.size.width - 40, (57 - lblRemind.frame.size.height) / 2 + 122, lblRemind.frame.size.width, lblRemind.frame.size.height);
    [remindView addSubview:lblRemind];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(remindView.frame.size.width - 28, (57 - lblRemind.frame.size.height) / 2 + 122, 11, 18)];
    imageView.image = [UIImage imageNamed:@"arrow_right"];
    [remindView addSubview:imageView];
    
    lblRemind = [[UILabel alloc] init];
    lblRemind.text = @"Repeat";
    lblRemind.font = [utils fontRegularForSize:18];
    lblRemind.textColor = [UIColor colorWithRed:67.f/255.f green:61.f/255.f blue:60.f/255.f alpha:1.f];
    [lblRemind sizeToFit];
    lblRemind.frame = CGRectMake(15, (57 - lblRemind.frame.size.height) / 2 + 122, lblRemind.frame.size.width, lblRemind.frame.size.height);
    [remindView addSubview:lblRemind];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(remindView.frame.size.width - 28, (57 - lblRemind.frame.size.height) / 2 + 182, 11, 18)];
    imageView.image = [UIImage imageNamed:@"arrow_right"];
    [remindView addSubview:imageView];
    
    lblRemind = [[UILabel alloc] init];
    lblRemind.text = @"Never";
    lblRemind.font = [utils fontBoldForSize:14];
    lblRemind.textColor = [utils colorNavigationBar];
    [lblRemind sizeToFit];
    lblRemind.frame = CGRectMake(remindView.frame.size.width - lblRemind.frame.size.width - 40, (57 - lblRemind.frame.size.height) / 2 + 182, lblRemind.frame.size.width, lblRemind.frame.size.height);
    [remindView addSubview:lblRemind];
    
    lblRemind = [[UILabel alloc] init];
    lblRemind.text = @"Finish";
    lblRemind.font = [utils fontRegularForSize:18];
    lblRemind.textColor = [UIColor colorWithRed:67.f/255.f green:61.f/255.f blue:60.f/255.f alpha:1.f];
    [lblRemind sizeToFit];
    lblRemind.frame = CGRectMake(15, (57 - lblRemind.frame.size.height) / 2 + 182, lblRemind.frame.size.width, lblRemind.frame.size.height);
    [remindView addSubview:lblRemind];
    
    separator = [[UIView alloc]initWithFrame:CGRectMake(0, 56, remindView.frame.size.width, 1)];
    separator.backgroundColor = [UIColor colorWithRed:187.f/255.f green:186.f/255.f blue:186.f/255.f alpha:1.f];
    [remindView addSubview:separator];
    separator = [[UIView alloc]initWithFrame:CGRectMake(0, 114, remindView.frame.size.width, 1)];
    separator.backgroundColor = [UIColor colorWithRed:187.f/255.f green:186.f/255.f blue:186.f/255.f alpha:1.f];
    [remindView addSubview:separator];
    separator = [[UIView alloc]initWithFrame:CGRectMake(0, 174, remindView.frame.size.width, 1)];
    separator.backgroundColor = [UIColor colorWithRed:187.f/255.f green:186.f/255.f blue:186.f/255.f alpha:1.f];
    [remindView addSubview:separator];
    separator = [[UIView alloc]initWithFrame:CGRectMake(0, 237, remindView.frame.size.width, 1)];
    separator.backgroundColor = [UIColor colorWithRed:187.f/255.f green:186.f/255.f blue:186.f/255.f alpha:1.f];
    [remindView addSubview:separator];
    
    UISwitch *switchRemind = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 65, 13.5, 0, 0)];
    [remindView addSubview:switchRemind];
    switchRemind.onTintColor = [utils colorNavigationBar];
    switchRemind.backgroundColor = [UIColor colorWithRed:173.f/255.f green:175.f/255.f blue:177.f/255.f alpha:1];
    switchRemind.tintColor = [UIColor colorWithRed:173.f/255.f green:175.f/255.f blue:177.f/255.f alpha:1];
    switchRemind.layer.cornerRadius = 16.0;
    [switchRemind addTarget:self action:@selector(switched:) forControlEvents:UIControlEventValueChanged];
    
    [scroller addSubview:remindView];
    
    [self updateScroller];
}

-(void)updateScroller{
    scroller.contentSize = CGSizeMake(scroller.frame.size.width, remindView.frame.origin.y +remindView.frame.size.height + 15);
}

- (IBAction)switched:(UISwitch *)sender{
    [UIView animateWithDuration:0.2 animations:^{
        if(sender.on){
            remindView.frame = CGRectMake(remindView.frame.origin.x,remindView.frame.origin.y, remindView.frame.size.width,238);
        }else{
            remindView.frame = CGRectMake(remindView.frame.origin.x,remindView.frame.origin.y, remindView.frame.size.width,57);
        }
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 animations:^{
            [self updateScroller];
        }];
    }];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"This is a description about this project, telling what user is tracking here and any other information user is willing to note down about it."]) {
        textView.text = @"";
    }
    [UIView animateWithDuration:0.2 animations:^{
        textViewsept.frame = CGRectMake(textView.frame.size.width, fieldDesc.frame.size.height - 1, 0, 1);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineSpacing = 11.f;
    paraStyle.minimumLineHeight = 11.f;
    paraStyle.maximumLineHeight = 11.f;
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:@{NSFontAttributeName: [utils fontRegularForSize:16], NSForegroundColorAttributeName: [UIColor colorWithRed:67.f/255.f green:61.f/255.f blue:60.f/255.f alpha:1.f], NSParagraphStyleAttributeName: paraStyle}];
    CGRect rect = [textView.attributedText boundingRectWithSize:CGSizeMake(textView.frame.size.width - 15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    [UIView animateWithDuration:0.2 animations:^{
        textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, rect.size.height + 15);
        textViewsept.frame = CGRectMake(5, textView.frame.size.height - 1, textView.frame.size.width, 1);
        remindView.frame = CGRectMake(remindView.frame.origin.x, fieldDesc.frame.size.height + fieldDesc.frame.origin.y + 41, remindView.frame.size.width, remindView.frame.size.height);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 animations:^{
            [self updateScroller];
        }];
    }];
}

- (void)makeSprout:(UITapGestureRecognizer *)sender{
    [self.navigationController pushViewController:[[CameraViewController alloc]init] animated:YES];
}

- (void)setNavigationBar{
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
    UIButton *download = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [download setBackgroundImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:download];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (IBAction)backToMenu:(UIButton *)sender{
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    [appDel resetTab];
    appDel.label.textColor = [utils colorNavigationBar];
    appDel.imageView.image = [UIImage imageNamed:@"projector-green"];
    self.tabBarController.selectedIndex = 0;
}

- (void)setTitleViewForNavBar{
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [utils attrString:@"SproutPic" withFont:[utils fontForNavBarTitle] color:[UIColor whiteColor] andCharSpacing:[NSNumber numberWithInt:0]];
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    
    self.navigationItem.titleView = label;
}

@end
