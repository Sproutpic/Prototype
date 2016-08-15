//
//  AboutViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 27/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController
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
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(((self.view.frame.size.width) / 2) - ((65 * 1.11)), 15, 65 * 1.11, 65)];
    logo.image = [UIImage imageNamed:@"Logo-2"];
    [self.view addSubview:logo];
    
    UILabel *logoLabel = [[UILabel alloc] init];
    logoLabel.text = @"SproutPic";
    logoLabel.font = [utils fontRegularForSize:22];
    logoLabel.textColor =[utils colorNavigationBar];
    [logoLabel sizeToFit];
    logoLabel.frame = CGRectMake(logo.frame.origin.x + logo.frame.size.width * 0.55, (15 + logo.frame.size.height) - logoLabel.frame.size.height, logoLabel.frame.size.width, logoLabel.frame.size.height);
    [self.view addSubview:logoLabel];
    
    UILabel *lblNote = [[UILabel alloc]init];
    lblNote.text = @"Inspire Change";
    lblNote.font = [utils fontRegularForSize:16];
    lblNote.textColor =[utils colorNavigationBar];
    [lblNote sizeToFit];
    lblNote.frame = CGRectMake((self.view.frame.size.width-lblNote.frame.size.width)/2, logoLabel.frame.origin.y + logoLabel.frame.size.height + 10, lblNote.frame.size.width, lblNote.frame.size.height);
    [self.view addSubview:lblNote];
    
    UIView *questionView = [[UIView alloc] init];
    
    //[self setQuestionAnswer:questionView question:@"What" answer:@"Easy to use application to track progression of your activies. Make shots and create sprout to view the all-in-one progression and share it with friends."];
    UILabel *question = [[UILabel alloc]init];
    question.text = @"What?";
    question.textColor = [utils colorNavigationBar];
    question.font = [utils fontRegularForSize:14];
    [question sizeToFit];
    question.frame = CGRectMake(0, 0, question.frame.size.width, question.frame.size.height);
    [questionView addSubview:question];
    
    UILabel *answer = [[UILabel alloc]init];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.lineSpacing = 3;
    answer.numberOfLines = 0;
    answer.attributedText = [[NSAttributedString alloc] initWithString:@"Easy to use application to track progression of your activies. Make shots and create sprout to view the all-in-one progression and share it with friends." attributes:@{NSFontAttributeName: [utils fontRegularForSize:14],
                                                                                                                                                                                                                                                 NSKernAttributeName:[NSNumber numberWithFloat:0.f],
                                                                                                                                                                                                                                                 NSParagraphStyleAttributeName: paraStyle}];
    CGRect rect = [answer.attributedText boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    answer.frame = CGRectMake(0, question.frame.origin.y + question.frame.size.height + 3, self.view.frame.size.width - 30, rect.size.height);
    [questionView addSubview:answer];
    
    question = [[UILabel alloc]init];
    question.text = @"Why?";
    question.textColor = [utils colorNavigationBar];
    question.font = [utils fontRegularForSize:14];
    [question sizeToFit];
    question.frame = CGRectMake(0, answer.frame.origin.y + answer.frame.size.height + 20, question.frame.size.width, question.frame.size.height);
    [questionView addSubview:question];
    
    answer = [[UILabel alloc]init];
    answer.numberOfLines = 0;
    answer.attributedText = [[NSAttributedString alloc] initWithString:@"We created SproutPic because we wanted to help you show the world change in action." attributes:@{NSFontAttributeName: [utils fontRegularForSize:14],
                                                                                                                                                                                                                                                 NSKernAttributeName:[NSNumber numberWithFloat:0.f],
                                                                                                                                                                                                                                                 NSParagraphStyleAttributeName: paraStyle}];
    rect = [answer.attributedText boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    answer.frame = CGRectMake(0, question.frame.origin.y + question.frame.size.height + 3, self.view.frame.size.width - 30, rect.size.height);
    [questionView addSubview:answer];
    
    question = [[UILabel alloc]init];
    question.text = @"Questions?";
    question.textColor = [utils colorNavigationBar];
    question.font = [utils fontRegularForSize:14];
    [question sizeToFit];
    question.frame = CGRectMake(0, answer.frame.origin.y + answer.frame.size.height + 20, question.frame.size.width, question.frame.size.height);
    [questionView addSubview:question];
    
    answer = [[UILabel alloc]init];
    answer.numberOfLines = 0;
    answer.attributedText = [[NSAttributedString alloc] initWithString:@"Check FAQ section or contact us directly a support@sproutpic.com." attributes:@{NSFontAttributeName: [utils fontRegularForSize:14],
                                                                                                                                                                           NSKernAttributeName:[NSNumber numberWithFloat:0.f],
                                                                                                                                                                           NSParagraphStyleAttributeName: paraStyle}];
    rect = [answer.attributedText boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    answer.frame = CGRectMake(0, question.frame.origin.y + question.frame.size.height + 3, self.view.frame.size.width - 30, rect.size.height);
    [questionView addSubview:answer];
    
    [questionView sizeToFit];
    questionView.frame = CGRectMake(15, lblNote.frame.origin.y + lblNote.frame.size.height + 25, questionView.frame.size.width, questionView.frame.size.height);
    
    [self.view addSubview:questionView];
    
    UILabel *link = [[UILabel alloc]init];
    link.font = [utils fontRegularForSize:14];
    link.textColor = [utils colorNavigationBar];
    link.attributedText = [[NSAttributedString alloc] initWithString:@"Terms and Conditions" attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    [link sizeToFit];
    link.frame = CGRectMake((self.view.frame.size.width - link.frame.size.width)/ 2, self.view.frame.size.height - link.frame.size.height - 124, link.frame.size.width, link.frame.size.height);
    [self.view addSubview:link];
    
    link = [[UILabel alloc]init];
    link.font = [utils fontRegularForSize:14];
    link.textColor = [utils colorNavigationBar];
    link.attributedText = [[NSAttributedString alloc] initWithString:@"Pivacy Policy" attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    [link sizeToFit];
    link.frame = CGRectMake((self.view.frame.size.width - link.frame.size.width)/ 2, self.view.frame.size.height - link.frame.size.height - 84, link.frame.size.width, link.frame.size.height);
    [self.view addSubview:link];
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
    label.attributedText = [utils attrString:@"About SproutPic" withFont:[utils fontForNavBarTitle] color:[UIColor whiteColor] andCharSpacing:[NSNumber numberWithInt:0]];
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    
    self.navigationItem.titleView = label;
}
@end
