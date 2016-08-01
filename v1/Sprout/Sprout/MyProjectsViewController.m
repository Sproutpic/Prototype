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
    [self setNavigationBar];
    [self populateProjects];
    [self setProjectScroller];
}
- (void)setNavigationBar{
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
    label.attributedText = [utils attrString:@"SproutPic" withFont:[utils fontRegularForSize:16] color:[UIColor whiteColor] andCharSpacing:[NSNumber numberWithInt:0]];
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    
    self.navigationItem.titleView = label;
}
- (void)setProjectScroller{
    projectScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 114)];
    [self setEachProjectPreview];
    [self.view addSubview:projectScroller];
}
- (void)setEachProjectPreview{
    CGFloat y = 20.0f;
    int tag = 0;
    for (NSDictionary *dictionary in projects) {
        currentDictionary = dictionary;
        [self setPerProjectContainerWithY:y withTag:tag];
        y += projectScroller.frame.size.height * 0.405 + 27;
        tag ++;
    }
    [self updateScrollerContentHeight];
}
- (void)setPerProjectContainerWithY:(int)y withTag:(int)tag{
    UIView *projectView = [[UIView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, projectScroller.frame.size.height * 0.405)];
    projectView.tag = tag;
    [self setupProjectView:projectView];
    [projectScroller addSubview:projectView];
}
- (void)setupProjectView:(UIView *)projectView{
    [self setupProjectTitleLabel:projectView];
    [self setupProjectDescription:projectView];
    [self setupPreviewScroller:projectView];
    [self setupSeparator:projectView];
    [self setupRighArrow:projectView];
}
- (void)setupRighArrow:(UIView *)projectView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(projectView.frame.size.width - 28, 5, 11, 18)];
    imageView.image = [UIImage imageNamed:@"arrow_right"];
    [projectView addSubview:imageView];
    
    UIButton *btnProjDetail = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, projectView.frame.size.width, 23)];
    [btnProjDetail addTarget:self action:@selector(showProjDetail:) forControlEvents:UIControlEventTouchUpInside];
    btnProjDetail.tag = projectView.tag;
    [projectView addSubview:btnProjDetail];
}
- (IBAction)showProjDetail:(UIButton *)sender{
    ProjectDetailViewController *projDetailController =[[ProjectDetailViewController alloc] init];
    projDetailController.project = [projects[sender.tag] mutableCopy];
    [self.tabBarController presentViewController:[[UINavigationController alloc] initWithRootViewController:projDetailController] animated:YES completion:nil];
}
- (void)setupSeparator:(UIView *)projectView{
    UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(10, projectView.frame.size.height + 11, projectView.frame.size.width, 1)];
    separator.backgroundColor = [[utils colorNavigationBar] colorWithAlphaComponent:0.3f];
    [projectView addSubview:separator];
}
- (void)setupProjectDescription:(UIView *)projectView{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //paraStyle.alignment = NSTextAlignmentJustified;
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    //paraStyle.firstLineHeadIndent = 0.1;
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, projectView.frame.size.width - 20, 100)];
    descLabel.numberOfLines = 3;
    descLabel.attributedText = [[NSAttributedString alloc]initWithString:[currentDictionary objectForKey:@"projectDetail"] attributes:@{NSParagraphStyleAttributeName: paraStyle,
                                                                                                                                        NSFontAttributeName: [utils fontRegularForSize:13],
                                                                                                                                        NSForegroundColorAttributeName: [UIColor grayColor]}];
    [descLabel sizeToFit];
    descLabel.frame = CGRectMake(10, projectView.frame.size.height - descLabel.frame.size.height + 1, descLabel.frame.size.width, descLabel.frame.size.height);
    [projectView addSubview:descLabel];
}

- (void)setupProjectTitleLabel:(UIView *)projectView{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = [currentDictionary objectForKey:@"projectTitle"];
    titleLabel.font = [utils fontBoldForSize:18];
    titleLabel.textColor = [utils colorNavigationBar];
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(10, 5, titleLabel.frame.size.width, titleLabel.frame.size.height);
    [projectView addSubview:titleLabel];
}
- (void)setupPreviewScroller:(UIView *)projectView{
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 15 + projectView.subviews[0].frame.size.height, self.view.frame.size.width, projectView.frame.size.height - (21 + projectView.subviews[0].frame.size.height + projectView.subviews[projectView.subviews.count - 1].frame.size.height))];
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
    projectScroller.contentSize = CGSizeMake(self.view.frame.size.width, projectScroller.subviews.lastObject.frame.origin.y + projectScroller.subviews.lastObject.frame.size.height);
}
- (void)populateProjects{
    projects = [[NSMutableArray alloc]initWithArray:@[@{@"projectTitle":@"Project Title",
                                                        @"projectDetail":@"This is a description about this project, telling what user is tracking here and any other information user is willing to note down about it.",
                                                        @"projectThumbnails":[[NSMutableArray alloc]initWithArray:@[@"http://cdn4.fast-serve.net/cdn/plugplants/Pack-X6-Blue-Agapanthus-Perennial-Summer-Flowering-Plug-Plants_700_600_78HAG.jpg",
                                                                                                                    @"https://s-media-cache-ak0.pinimg.com/564x/36/d4/08/36d408bdaf1b71825edde18ed7bc3690.jpg",
                                                                                                                    @"https://s-media-cache-ak0.pinimg.com/236x/6b/14/7a/6b147af37bf15c7f10c3583c247fc5b2.jpg",
                                                                                                                    @"https://s-media-cache-ak0.pinimg.com/236x/c2/a4/df/c2a4df1e8aad6b6f5404bdf8ac0c1cc7.jpg"]]},
                                                      @{@"projectTitle":@"Project Title",
                                                        @"projectDetail":@"This is a description about this project, telling what user is tracking here and any other information user is willing to note down about it.",
                                                        @"projectThumbnails":[[NSMutableArray alloc] initWithArray:@[@"http://ghk.h-cdn.co/assets/15/33/980x490/landscape-1439490128-plants.jpg",
                                                                                                                     @"http://cdn3.fast-serve.net/cdn/plugplants/_0_0_6PNES.jpg",
                                                                                                                     @"http://cdn1.fast-serve.net/cdn/plugplants/Pack-x6-Mimulus-39-Glutinosus-39-Monkey-Plant-Hanging-Basket-Garden-Plug-Plants_700_600_7GH4I.jpg",
                                                                                                                     @"https://s-media-cache-ak0.pinimg.com/236x/44/97/88/449788a41a9d826eace28f363fb80b69.jpg"]]},
                                                      @{@"projectTitle":@"Project Title",
                                                        @"projectDetail":@"This is a description about this project, telling what user is tracking here and any other information user is willing to note down about it.",
                                                        @"projectThumbnails":[[NSMutableArray alloc]initWithArray:@[@"http://cdn4.fast-serve.net/cdn/plugplants/Pack-X6-Blue-Agapanthus-Perennial-Summer-Flowering-Plug-Plants_700_600_78HAG.jpg",
                                                                                                                    @"https://s-media-cache-ak0.pinimg.com/564x/36/d4/08/36d408bdaf1b71825edde18ed7bc3690.jpg",
                                                                                                                    @"https://s-media-cache-ak0.pinimg.com/236x/6b/14/7a/6b147af37bf15c7f10c3583c247fc5b2.jpg",
                                                                                                                    @"https://s-media-cache-ak0.pinimg.com/236x/c2/a4/df/c2a4df1e8aad6b6f5404bdf8ac0c1cc7.jpg"]]}]];
}
@end
