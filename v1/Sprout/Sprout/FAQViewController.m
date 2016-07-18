//
//  FAQViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 06/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "FAQViewController.h"

@implementation FAQViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setController];
}
- (void)setController{
    self.view.backgroundColor = [UIColor whiteColor];
    utils = [[UIUtils alloc]init];
    questionScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:questionScroller];
    
    [self setNavigationBar];
    [self populateQuestions];
    [self setControllerWithQuestions];
}
- (void)setControllerWithQuestions{
    CGFloat y = 5;
    int tag = 0;
    for (NSDictionary *questionDictionary in questions) {
        [self setButtonForQuestion:questionDictionary withOriginY:y];
        ((UIButton *)[questionDictionary objectForKey:@"questionView"]).tag = tag;
        [questionScroller addSubview:((UIButton *)[questionDictionary objectForKey:@"questionView"])];
        y += 52;
        tag ++;
    }
}
- (void)setButtonForQuestion:(NSDictionary *)dictionary withOriginY:(CGFloat)y{
    UIButton *button = ((UIButton *)[dictionary objectForKey:@"questionView"]);
    button.frame = CGRectMake(15, y, self.view.frame.size.width-15, 52);
    [button addTarget:self action:@selector(tappedFAQButton:) forControlEvents:UIControlEventTouchUpInside];
    [self formatButtonForQuestion:dictionary];
}
- (void)formatButtonForQuestion:(NSDictionary *)dictionary{
    [self formatButtonViews:dictionary];
    [self addButtonViews:dictionary];
}
- (void)formatButtonViews:(NSDictionary *)dictionary{
    [self formatSeparator:((UIView *)[dictionary objectForKey:@"questionSeparator"])];
    [self formatArrow:((UIImageView *)[dictionary objectForKey:@"questionArrowImageView"])];
    [self formatQuestionLabel:((UILabel *)[dictionary objectForKey:@"questionLabel"]) withQuestion:((NSString *)[dictionary objectForKey:@"question"])];
}
- (void)addButtonViews:(NSDictionary *)dictionary{
    UIButton *button = ((UIButton *)[dictionary objectForKey:@"questionView"]);
    
    [button addSubview:((UIView *)[dictionary objectForKey:@"questionSeparator"])];
    [button addSubview:((UIImageView *)[dictionary objectForKey:@"questionArrowImageView"])];
    [button addSubview:((UILabel *)[dictionary objectForKey:@"questionLabel"])];
}
-(void)formatSeparator:(UIView *)separator{
    separator.frame = CGRectMake(0, 50, self.view.frame.size.width-15, 2);
    separator.backgroundColor = [utils colorMenuButtonsSeparator];
}
-(void)formatArrow:(UIImageView *)arrow{
    arrow.frame = CGRectMake(self.view.frame.size.width-50, 20, 20, 10);
    arrow.image = [UIImage imageNamed:@"downArrow"];
}
-(void)formatQuestionLabel:(UILabel *)questionLabel withQuestion:(NSString *)question{
    questionLabel.text = [NSString stringWithFormat:@"Q. %@",question];
    questionLabel.font = [utils fontRegularForSize:14];
    questionLabel.textColor = [UIColor blackColor];
    [questionLabel sizeToFit];
    questionLabel.frame = CGRectMake(0, (50 - questionLabel.frame.size.height) / 2, questionLabel.frame.size.width, questionLabel.frame.size.height);
}
- (IBAction)tappedFAQButton:(UIButton *)sender{
    if((((UILabel *)([((NSDictionary *)questions[(int)sender.tag]) objectForKey:@"questionView"]))).frame.size.height == 52){
        [self resetQuestionViews];
        [self openQuestionAtIndex:(int)sender.tag];
        [self updateScrollerContentHeight];
    }else{
        [self resetQuestionViews];
        [self updateScrollerContentHeight];
    }
}
- (void)resetQuestionViews{
    [self closeAllQuestions];
    for (NSDictionary *questionDictionary in questions) {
        [self formatButtonViews:questionDictionary];
    }
}
- (void)openQuestionAtIndex:(int)index{
    int hover = 0;
    CGFloat y = 0.0f;
    for (NSDictionary *questionDictionary in questions) {
        if (hover == index) {
            CGFloat answerLabelHeight = [self addAnswerToQuestionView:((UIButton *) [questionDictionary objectForKey:@"questionView"]) withAnswerView:((UILabel *) [questionDictionary objectForKey:@"answerLabel"]) andAnswer:((NSString *) [questionDictionary objectForKey:@"answer"]) ];
            [UIView animateWithDuration:0.2 animations:^{
                UIButton * button = (UIButton *) [questionDictionary objectForKey:@"questionView"];
                button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, button.frame.size.width, answerLabelHeight + 52);
                UIView *separator = (UIView *) [questionDictionary objectForKey:@"questionSeparator"];
                separator.frame = CGRectMake(separator.frame.origin.x, answerLabelHeight + 50, separator.frame.size.width, separator.frame.size.height);
            }];
            y += ((UIButton *) [questionDictionary objectForKey:@"questionView"]).frame.origin.y + answerLabelHeight + 52;
        }else if(hover > index){
            [UIView animateWithDuration:0.5 animations:^{
                UIButton * button = (UIButton *) [questionDictionary objectForKey:@"questionView"];
                button.frame = CGRectMake(button.frame.origin.x, y, button.frame.size.width, button.frame.size.height);
            }];
            y += ((UIButton *) [questionDictionary objectForKey:@"questionView"]).frame.size.height;
        }
        hover ++;
    }
    
    [self setQuestionViewActive:questions[index]];
}
- (void)updateScrollerContentHeight{
    questionScroller.contentSize = CGSizeMake(self.view.frame.size.width, [self getButtonsTotalHeight]);
}
- (CGFloat)getButtonsTotalHeight{
    CGFloat height = 20.0f;
    for (NSDictionary *dictionary in questions) {
        height += ((UIButton *)[dictionary objectForKey:@"questionView"]).frame.size.height;
    }
    return height;
}
- (CGFloat)addAnswerToQuestionView:(UIButton *)button withAnswerView:(UILabel *)answerLabel andAnswer:(NSString *)answer{
    CGRect size = [[NSString stringWithFormat:@"A. %@",answer] boundingRectWithSize:CGSizeMake(self.view.frame.size.width * 0.88, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [utils fontForFAQAnswerActive]} context:nil];
    answerLabel = [[UILabel alloc]init];
    answerLabel.numberOfLines = 0;
    answerLabel.font = [utils fontForFAQAnswerActive];
    answerLabel.text = [NSString stringWithFormat:@"A. %@",answer];
    answerLabel.frame = CGRectMake(0, 40, size.size.width,size.size.height);
    answerLabel.alpha = 0;
    [button addSubview:answerLabel];
    [UIView animateWithDuration:0.2 animations:^{
        answerLabel.alpha = 1;
    }];
    return size.size.height;
}
- (void) closeAllQuestions{
    CGFloat y = 5.f;
    for (NSDictionary *questionDictionary in questions) {
        for (id sub in ((UIButton *) [questionDictionary objectForKey:@"questionView"]).subviews) {
            if ([sub isKindOfClass:[UILabel class]]) {
                if ([[NSString stringWithFormat:@"%hu",[((UILabel *)sub).text characterAtIndex:0]] isEqualToString:@"65"]) {
                    [UIView animateWithDuration:0.2 animations:^{
                        ((UILabel *)sub).alpha = 0;
                    } completion:^(BOOL finished){
                        [sub removeFromSuperview];
                    }];
                }
            }
        }
        [UIView animateWithDuration:0.2 animations:^{
            UIButton * button = (UIButton *) [questionDictionary objectForKey:@"questionView"];
            button.frame = CGRectMake(button.frame.origin.x, y, button.frame.size.width, 52);
            UIView *separator = (UIView *) [questionDictionary objectForKey:@"questionSeparator"];
            separator.frame = CGRectMake(separator.frame.origin.x, 7, separator.frame.size.width, separator.frame.size.height);
        }];
        y += 52;
    }
}
- (void)setQuestionViewActive:(NSMutableDictionary *)dictionary{
    ((UILabel *) [dictionary objectForKey:@"questionLabel"]).font = [utils fontRegularForSize:14];
    ((UILabel *) [dictionary objectForKey:@"questionLabel"]).textColor = [utils colorNavigationBar];
    [((UILabel *) [dictionary objectForKey:@"questionLabel"]) sizeToFit];
    ((UILabel *) [dictionary objectForKey:@"questionLabel"]).frame = CGRectMake(0, (50 - ((UILabel *) [dictionary objectForKey:@"questionLabel"]).frame.size.height) / 2, ((UILabel *) [dictionary objectForKey:@"questionLabel"]).frame.size.width, ((UILabel *) [dictionary objectForKey:@"questionLabel"]).frame.size.height);
    ((UIImageView *) [dictionary objectForKey:@"questionArrowImageView"]).image = [UIImage imageNamed:@"upArrow"];
}
- (void)populateQuestions{
    questions = [[NSMutableArray alloc]initWithObjects:[[NSMutableDictionary alloc] initWithDictionary:@{@"questionArrowImageView":[[UIImageView alloc] init],
                                                                                                         @"questionLabel":[[UILabel alloc] init],
                                                                                                         @"answerLabel":[[UILabel alloc] init],
                                                                                                         @"questionView":[[UIButton alloc]init],
                                                                                                         @"questionSeparator":[[UIView alloc]init],
                                                                                                         @"question":@"My Question number one?",
                                                                                                         @"answer":@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."}],
                 [[NSMutableDictionary alloc] initWithDictionary:@{@"questionArrowImageView":[[UIImageView alloc] init],
                                                                   @"questionLabel":[[UILabel alloc] init],
                                                                   @"questionView":[[UIButton alloc]init],
                                                                   @"questionSeparator":[[UIView alloc]init],
                                                                   @"question":@"My Question number two?",
                                                                   @"answer":@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."}],
                 [[NSMutableDictionary alloc] initWithDictionary:@{@"questionArrowImageView":[[UIImageView alloc] init],
                                                                   @"questionLabel":[[UILabel alloc] init],
                                                                   @"questionView":[[UIButton alloc]init],
                                                                   @"questionSeparator":[[UIView alloc]init],
                                                                   @"question":@"My Question number three?",
                                                                   @"answer":@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."}],
                 [[NSMutableDictionary alloc] initWithDictionary:@{@"questionArrowImageView":[[UIImageView alloc] init],
                                                                   @"questionLabel":[[UILabel alloc] init],
                                                                   @"questionView":[[UIButton alloc]init],
                                                                   @"questionSeparator":[[UIView alloc]init],
                                                                   @"question":@"My Question number four?",
                                                                   @"answer":@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."}],
                 [[NSMutableDictionary alloc] initWithDictionary:@{@"questionArrowImageView":[[UIImageView alloc] init],
                                                                   @"questionLabel":[[UILabel alloc] init],
                                                                   @"questionView":[[UIButton alloc]init],
                                                                   @"questionSeparator":[[UIView alloc]init],
                                                                   @"question":@"My Question number five?",
                                                                   @"answer":@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."}],
                 [[NSMutableDictionary alloc] initWithDictionary:@{@"questionArrowImageView":[[UIImageView alloc] init],
                                                                   @"questionLabel":[[UILabel alloc] init],
                                                                   @"questionView":[[UIButton alloc]init],
                                                                   @"questionSeparator":[[UIView alloc]init],
                                                                   @"question":@"My Question number six?",
                                                                   @"answer":@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."}],
                 [[NSMutableDictionary alloc] initWithDictionary:@{@"questionArrowImageView":[[UIImageView alloc] init],
                                                                   @"questionLabel":[[UILabel alloc] init],
                                                                   @"questionView":[[UIButton alloc]init],
                                                                   @"questionSeparator":[[UIView alloc]init],
                                                                   @"question":@"My Question number seven?",
                                                                   @"answer":@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."}], nil];
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
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void)setTitleViewForNavBar{
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [utils attrString:@"FAQ" withFont:[utils fontForNavBarTitle] color:[UIColor whiteColor] andCharSpacing:[NSNumber numberWithInt:0]];
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    
    self.navigationItem.titleView = label;
}
@end
