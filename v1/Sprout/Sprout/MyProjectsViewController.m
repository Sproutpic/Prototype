//
//  MyProjectsViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 05/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "MyProjectsViewController.h"

@implementation MyProjectsViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setController];
}
- (void)setController{
    self.view.backgroundColor = [UIColor whiteColor];
    utils = [[UIUtils alloc]init];
    //nav = [[UIApplication sharedApplication] delegate].nav;
    
    [self setNavigationBar];
    [self populateProjects];
    [self setProjectScroller];
}
- (void)setNavigationBar{
    self.navigationController.navigationBar.barTintColor = [utils colorNavigationBar];
    self.navigationController.navigationBar.backgroundColor = [utils colorNavigationBar];
    self.navigationController.navigationBar.translucent = NO;
    [self setTitleViewForNavBar];
    [self addRightBarButton];
}
- (void)addRightBarButton{
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [back setBackgroundImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(tappedSettingsButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.rightBarButtonItem = barButton;
}
- (IBAction)tappedSettingsButton:(UIButton *)sender{
    [self.sidePanelController showRightPanelAnimated:YES];
}
- (void)setTitleViewForNavBar{
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [utils attrString:@"SproutPic" withFont:[utils fontForFAQQuestionActive] color:[UIColor whiteColor] andCharSpacing:[NSNumber numberWithInt:0]];
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    
    self.navigationItem.titleView = label;
}
- (void)setProjectScroller{
    projectScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 104)];
    [self setEachProjectPreview];
    [self.view addSubview:projectScroller];
}
- (void)setEachProjectPreview{
    CGFloat y = 20.0f;
    for (NSDictionary *dictionary in projects) {
        currentDictionary = dictionary;
        [self setPerProjectContainerWithY:y];
        y += projectScroller.frame.size.height * 0.4 + 20;
    }
    [self updateScrollerContentHeight];
}
- (void)setPerProjectContainerWithY:(int)y{
    UIView *projectView = [[UIView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, projectScroller.frame.size.height * 0.4)];
    [self setupProjectView:projectView];
    [projectScroller addSubview:projectView];
}
- (void)setupProjectView:(UIView *)projectView{
    projectView.backgroundColor = [utils colorSproutGreen];
    [self setupProjectTitleLabel:projectView];
    [self setupProjectDescription:projectView];
    [self setupPreviewScroller:projectView];
}
- (void)setupProjectDescription:(UIView *)projectView{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentJustified;
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.firstLineHeadIndent = 0.1;
    
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, projectView.frame.size.width - 20, 100)];
    descLabel.numberOfLines = 3;
    descLabel.attributedText = [[NSAttributedString alloc]initWithString:[currentDictionary objectForKey:@"projectDetail"] attributes:@{NSParagraphStyleAttributeName: paraStyle,
                                                                                                                                        NSFontAttributeName: [utils fontRegularForSize:13],
                                                                                                                                        NSForegroundColorAttributeName: [utils colorNavigationBar]}];
    [descLabel sizeToFit];
    descLabel.frame = CGRectMake(10, projectView.frame.size.height - descLabel.frame.size.height - 15, descLabel.frame.size.width, descLabel.frame.size.height);
    [projectView addSubview:descLabel];
}

- (void)setupProjectTitleLabel:(UIView *)projectView{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = [currentDictionary objectForKey:@"projectTitle"];
    titleLabel.font = [utils fontBoldForSize:13];
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(10, 10, titleLabel.frame.size.width, titleLabel.frame.size.height);
    [projectView addSubview:titleLabel];
}
- (void)setupPreviewScroller:(UIView *)projectView{
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 15 + projectView.subviews[0].frame.size.height, self.view.frame.size.width, projectView.frame.size.height - (40 + projectView.subviews[0].frame.size.height + projectView.subviews[projectView.subviews.count - 1].frame.size.height))];
    scroller.showsHorizontalScrollIndicator = NO;
    
    [self setupImages:scroller];
    
    [projectView addSubview:scroller];
}
- (void)setupImages:(UIScrollView *)scroller{
    CGFloat x = 10.0f;
    for (NSString *str in ((NSArray *)[currentDictionary objectForKey:@"projectThumbnails"])) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, scroller.frame.size.width * 0.40, scroller.frame.size.height)];
        image.layer.borderWidth = 0.5;
        [image sd_setImageWithURL:[NSURL URLWithString:str]];
        [scroller addSubview:image];
        x += scroller.frame.size.width * 0.40 + 10;
        scroller.contentSize = CGSizeMake(x, scroller.frame.size.height);
    }
}
- (void)updateScrollerContentHeight{
    CGFloat height = 20.0f;
    for (UIView *view in projectScroller.subviews) {
        height += view.frame.size.height;
    }
    projectScroller.contentSize = CGSizeMake(self.view.frame.size.width, height);
}
- (void)populateProjects{
    projects = [[NSMutableArray alloc]initWithArray:@[@{@"projectTitle":@"Project Title",
                                                        @"projectDetail":@"This is a description about this project, telling what user is tracking here and any other information user is willing to note down about it.",
                                                        @"projectThumbnails":@[@"http://cdn4.fast-serve.net/cdn/plugplants/Pack-X6-Blue-Agapanthus-Perennial-Summer-Flowering-Plug-Plants_700_600_78HAG.jpg",
                                                                               @"https://s-media-cache-ak0.pinimg.com/564x/36/d4/08/36d408bdaf1b71825edde18ed7bc3690.jpg",
                                                                               @"https://s-media-cache-ak0.pinimg.com/236x/6b/14/7a/6b147af37bf15c7f10c3583c247fc5b2.jpg",
                                                                               @"https://s-media-cache-ak0.pinimg.com/236x/c2/a4/df/c2a4df1e8aad6b6f5404bdf8ac0c1cc7.jpg"]},
                                                      @{@"projectTitle":@"Project Title",
                                                        @"projectDetail":@"This is a description about this project, telling what user is tracking here and any other information user is willing to note down about it.",
                                                        @"projectThumbnails":@[@"http://quinnburrell.com/wp-content/uploads/2014/09/Pitcher-Plants-thumbnail.jpg",
                                                                               @"http://cdn3.fast-serve.net/cdn/plugplants/_0_0_6PNES.jpg",
                                                                               @"http://cdn1.fast-serve.net/cdn/plugplants/Pack-x6-Mimulus-39-Glutinosus-39-Monkey-Plant-Hanging-Basket-Garden-Plug-Plants_700_600_7GH4I.jpg",
                                                                               @"https://s-media-cache-ak0.pinimg.com/236x/44/97/88/449788a41a9d826eace28f363fb80b69.jpg"]}]];
}
@end
