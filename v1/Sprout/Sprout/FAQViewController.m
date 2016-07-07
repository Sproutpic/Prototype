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
    CGFloat y = 20;
    for (NSDictionary *questionDictionary in questions) {
        [self setButtonForQuestion:questionDictionary withOriginY:y];
        [questionScroller addSubview:((UIButton *)[questionDictionary objectForKey:@"questionView"])];
        y += 52;
    }
}
- (void)setButtonForQuestion:(NSDictionary *)dictionary withOriginY:(CGFloat)y{
    UIButton *button = ((UIButton *)[dictionary objectForKey:@"questionView"]);
    button.frame = CGRectMake(20, y, self.view.frame.size.width-20, 52);
    [self formatButtonForQuestion:dictionary];
}
- (void)formatButtonForQuestion:(NSDictionary *)dictionary{
    UIButton *button = ((UIButton *)[dictionary objectForKey:@"questionView"]);
    [self formatSeparator:((UIView *)[dictionary objectForKey:@"questionSeparator"])];
    [button addSubview:((UIView *)[dictionary objectForKey:@"questionSeparator"])];
}
-(void)formatSeparator:(UIView *)separator{
    separator.frame = CGRectMake(10, 50, self.view.frame.size.width-30, 2);
    separator.backgroundColor = [utils colorMenuButtonsSeparator];
}
- (void)populateQuestions{
    questions = [[NSMutableArray alloc]initWithObjects:[[NSMutableDictionary alloc] initWithDictionary:@{@"questionMarkImageView":[[UIImageView alloc] init],
                                                                                                         @"questionArrowImageView":[[UIImageView alloc] init],
                                                                                                         @"questionLabel":[[UILabel alloc] init],
                                                                                                         @"questionView":[[UIButton alloc]init],
                                                                                                         @"questionSeparator":[[UIView alloc]init],
                                                                                                         @"question":@"My Question number one?",
                                                                                                         @"answer":@"Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus."}],
                 [[NSMutableDictionary alloc] initWithDictionary:@{@"questionMarkImageView":[[UIImageView alloc] init],
                                                                   @"questionArrowImageView":[[UIImageView alloc] init],
                                                                   @"questionLabel":[[UILabel alloc] init],
                                                                   @"questionView":[[UIButton alloc]init],
                                                                   @"questionSeparator":[[UIView alloc]init],
                                                                   @"question":@"My Question number two?",
                                                                   @"answer":@"Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus."}],
                 [[NSMutableDictionary alloc] initWithDictionary:@{@"questionMarkImageView":[[UIImageView alloc] init],
                                                                   @"questionArrowImageView":[[UIImageView alloc] init],
                                                                   @"questionLabel":[[UILabel alloc] init],
                                                                   @"questionView":[[UIButton alloc]init],
                                                                   @"questionSeparator":[[UIView alloc]init],
                                                                   @"question":@"My Question number three?",
                                                                   @"answer":@"Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus."}],
                 [[NSMutableDictionary alloc] initWithDictionary:@{@"questionMarkImageView":[[UIImageView alloc] init],
                                                                   @"questionArrowImageView":[[UIImageView alloc] init],
                                                                   @"questionLabel":[[UILabel alloc] init],
                                                                   @"questionView":[[UIButton alloc]init],
                                                                   @"questionSeparator":[[UIView alloc]init],
                                                                   @"question":@"My Question number four?",
                                                                   @"answer":@"Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus."}],
                 [[NSMutableDictionary alloc] initWithDictionary:@{@"questionMarkImageView":[[UIImageView alloc] init],
                                                                   @"questionArrowImageView":[[UIImageView alloc] init],
                                                                   @"questionLabel":[[UILabel alloc] init],
                                                                   @"questionView":[[UIButton alloc]init],
                                                                   @"questionSeparator":[[UIView alloc]init],
                                                                   @"question":@"My Question number five?",
                                                                   @"answer":@"Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus."}],
                 [[NSMutableDictionary alloc] initWithDictionary:@{@"questionMarkImageView":[[UIImageView alloc] init],
                                                                   @"questionArrowImageView":[[UIImageView alloc] init],
                                                                   @"questionLabel":[[UILabel alloc] init],
                                                                   @"questionView":[[UIButton alloc]init],
                                                                   @"questionSeparator":[[UIView alloc]init],
                                                                   @"question":@"My Question number six?",
                                                                   @"answer":@"Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus."}],
                 [[NSMutableDictionary alloc] initWithDictionary:@{@"questionMarkImageView":[[UIImageView alloc] init],
                                                                   @"questionArrowImageView":[[UIImageView alloc] init],
                                                                   @"questionLabel":[[UILabel alloc] init],
                                                                   @"questionView":[[UIButton alloc]init],
                                                                   @"questionSeparator":[[UIView alloc]init],
                                                                   @"question":@"My Question number seven?",
                                                                   @"answer":@"Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus."}], nil];
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
