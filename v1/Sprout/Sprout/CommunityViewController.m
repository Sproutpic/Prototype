//
//  CommunityViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 05/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "CommunityViewController.h"
#import <UIKit/UIKit.h>

@implementation CommunityViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setController];
}
- (void)setController{
    self.view.backgroundColor = [UIColor whiteColor];
    utils = [[UIUtils alloc]init];
    [self setNavigationBar];
    [self populateProjects];
    [self setupWeb];
    //[self setupLayout];
}
-(void)setupWeb{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    webView.backgroundColor = [UIColor whiteColor];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://softclover.com/Community"]]];
    [self.view addSubview:webView];
}
- (void)populateProjects{
    _projects = [[NSMutableArray alloc]initWithArray:@[@{@"projectTitle":@"Project Title",
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
- (void)setupLayout{
    UIView *filters = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 37)];
    filters.backgroundColor = [UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1.f];
    [self.view addSubview:filters];
    
    fSprout = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, filters.frame.size.width / 4, filters.frame.size.height)];
    fSprout.text = @"My Sprout";
    fSprout.textColor = [UIColor colorWithRed:120.f/255.f green:120.f/255.f blue:120.f/255.f alpha:1.f];
    fSprout.textAlignment = NSTextAlignmentCenter;
    fSprout.font = [utils fontBoldForSize:12];
    fSprout.tag = 0;
    [fSprout addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectFilter:)]];
    fSprout.userInteractionEnabled = YES;
    [self.view addSubview:fSprout];
    
    fFeatured = [[UILabel alloc]initWithFrame:CGRectMake(filters.frame.size.width / 4, 0, filters.frame.size.width / 4, filters.frame.size.height)];
    fFeatured.text = @"Featured";
    fFeatured.textColor = [UIColor colorWithRed:120.f/255.f green:120.f/255.f blue:120.f/255.f alpha:1.f];
    fFeatured.textAlignment = NSTextAlignmentCenter;
    fFeatured.font = [utils fontBoldForSize:12];
    fFeatured.tag = 1;
    [fFeatured addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectFilter:)]];
    fFeatured.userInteractionEnabled = YES;
    [self.view addSubview:fFeatured];
    
    fTopViewed = [[UILabel alloc]initWithFrame:CGRectMake(filters.frame.size.width / 4 * 2, 0, filters.frame.size.width / 4, filters.frame.size.height)];
    fTopViewed.text = @"Top Viewed";
    fTopViewed.textColor = [UIColor colorWithRed:120.f/255.f green:120.f/255.f blue:120.f/255.f alpha:1.f];
    fTopViewed.textAlignment = NSTextAlignmentCenter;
    fTopViewed.font = [utils fontBoldForSize:12];
    fTopViewed.tag = 2;
    [fTopViewed addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectFilter:)]];
    fTopViewed.userInteractionEnabled = YES;
    [self.view addSubview:fTopViewed];
    
    fLongest = [[UILabel alloc]initWithFrame:CGRectMake(filters.frame.size.width / 4 * 3,0, filters.frame.size.width / 4, filters.frame.size.height)];
    fLongest.text = @"Longest";
    fLongest.textColor = [UIColor colorWithRed:120.f/255.f green:120.f/255.f blue:120.f/255.f alpha:1.f];
    fLongest.textAlignment = NSTextAlignmentCenter;
    fLongest.font = [utils fontBoldForSize:12];
    fLongest.tag = 3;
    [fLongest addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectFilter:)]];
    fLongest.userInteractionEnabled = YES;
    [self.view addSubview:fLongest];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 37, self.view.frame.size.width, self.view.frame.size.height - 87 - 64)];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    [self.view addSubview:_table];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _projects.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = [((NSDictionary *)(_projects[indexPath.row])) objectForKey:@"projectTitle"];
    titleLabel.font = [utils fontRegularForSize:18];
    titleLabel.textColor = [utils colorNavigationBar];
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(15, 12, titleLabel.frame.size.width, titleLabel.frame.size.height);
    [cell.contentView addSubview:titleLabel];
    
    titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"2k views";
    titleLabel.font = [utils fontRegularForSize:16];
    titleLabel.textColor = [utils colorNavigationBar];
    titleLabel.textAlignment = NSTextAlignmentRight;
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(self.view.frame.size.width - 15 - titleLabel.frame.size.width, 15, titleLabel.frame.size.width, titleLabel.frame.size.height);
    [cell.contentView addSubview:titleLabel];
    
    UIImageView *sprout = [[UIImageView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, self.view.frame.size.width, self.view.frame.size.width * 0.6)];
    sprout.contentMode = UIViewContentModeScaleAspectFill;
    [sprout sd_setImageWithURL:[NSURL URLWithString:((NSString *)[((NSDictionary *)(_projects[indexPath.row])) objectForKey:@"projectThumbnails"][indexPath.row])]];
    sprout.clipsToBounds = YES;
    UIImageView *play = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.405, self.view.frame.size.width * 0.205, self.view.frame.size.width * 0.19, self.view.frame.size.width * 0.19)];
    play.image = [UIImage imageNamed:@"play-button"];
    [sprout addSubview:play];
    [cell.contentView addSubview:sprout];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //paraStyle.alignment = NSTextAlignmentJustified;
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    //paraStyle.firstLineHeadIndent = 0.1;
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, sprout.frame.size.width - 40, 100)];
    descLabel.numberOfLines = 3;
    descLabel.attributedText = [[NSAttributedString alloc]initWithString:[((NSDictionary *)(_projects[indexPath.row])) objectForKey:@"projectDetail"] attributes:@{NSParagraphStyleAttributeName: paraStyle,
                                                                                                                                        NSFontAttributeName: [utils fontRegularForSize:12],
                                                                                                                                        NSForegroundColorAttributeName: [UIColor grayColor]}];
    [descLabel sizeToFit];
    descLabel.frame = CGRectMake(15, sprout.frame.size.height + sprout.frame.origin.y + 10, descLabel.frame.size.width, descLabel.frame.size.height);
    [cell.contentView addSubview:descLabel];
    UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(15, descLabel.frame.size.height + descLabel.frame.origin.y + 9, self.view.frame.size.width - 15, 1)];
    separator.backgroundColor = [[utils colorNavigationBar] colorWithAlphaComponent:0.3f];
    [cell.contentView addSubview:separator];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"P";
    titleLabel.font = [utils fontRegularForSize:18];
    titleLabel.textColor = [utils colorNavigationBar];
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(10, 12, titleLabel.frame.size.width, titleLabel.frame.size.height);
    UIImageView *sprout = [[UIImageView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, self.view.frame.size.width, self.view.frame.size.width * 0.6)];
    sprout.contentMode = UIViewContentModeScaleAspectFill;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //paraStyle.alignment = NSTextAlignmentJustified;
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    //paraStyle.firstLineHeadIndent = 0.1;
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, sprout.frame.size.width - 20, 100)];
    descLabel.numberOfLines = 3;
    descLabel.attributedText = [[NSAttributedString alloc]initWithString:[((NSDictionary *)(_projects[indexPath.row])) objectForKey:@"projectDetail"] attributes:@{NSParagraphStyleAttributeName: paraStyle,
                                                                                                                                                                   NSFontAttributeName: [utils fontRegularForSize:13],
                                                                                                                                                                   NSForegroundColorAttributeName: [UIColor grayColor]}];
    [descLabel sizeToFit];
    descLabel.frame = CGRectMake(10, sprout.frame.size.height + sprout.frame.origin.y + 10, descLabel.frame.size.width, descLabel.frame.size.height);
    return descLabel.frame.origin.y + descLabel.frame.size.height + 9;
}
- (void)selectFilter:(UITapGestureRecognizer *)sender{
    [self resetFilter];
    ((UILabel *)sender.view).textColor = [utils colorNavigationBar];
    [self showLine:((UILabel *)sender.view)];
    switch (sender.view.tag) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        default:
            break;
    }
}
-(void)showLine:(UILabel *)label{
    [UIView animateWithDuration:0.2 animations:^{
        underlineView.alpha = 0;
    } completion:^(BOOL finished){
        [underlineView removeFromSuperview];
        CGRect rect = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, label.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[utils fontBoldForSize:12]} context:nil];
        underlineView = [[UIView alloc]initWithFrame:CGRectMake(label.frame.origin.x + ((label.frame.size.width - rect.size.width)/2), label.frame.size.height * 0.92, rect.size.width, label.frame.size.height * 0.08)];
        underlineView.backgroundColor = [utils colorNavigationBar];
        underlineView.alpha = 0;
        [self.view addSubview:underlineView];
        [UIView animateWithDuration:0.2 animations:^{
            underlineView.alpha = 1;
        }];
    }];
}
-(void)resetFilter{
    fSprout.textColor = [UIColor colorWithRed:120.f/255.f green:120.f/255.f blue:120.f/255.f alpha:1.f];
    fFeatured.textColor = [UIColor colorWithRed:120.f/255.f green:120.f/255.f blue:120.f/255.f alpha:1.f];
    fTopViewed.textColor = [UIColor colorWithRed:120.f/255.f green:120.f/255.f blue:120.f/255.f alpha:1.f];
    fLongest.textColor = [UIColor colorWithRed:120.f/255.f green:120.f/255.f blue:120.f/255.f alpha:1.f];
}
- (void)setNavigationBar{
    [self setTitleViewForNavBar];
    [self addRightBarButton];
    [self addLeftBarButton];
}
- (void)addRightBarButton{
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [back setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(tappedSettingsButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.rightBarButtonItem = barButton;
}
- (void)addLeftBarButton{
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [back setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(tappedSettingsButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = barButton;
}
- (IBAction)tappedSettingsButton:(UIButton *)sender{
    searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 0)];
    searchView.backgroundColor = [utils colorNavigationBar];
    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 35, 12, 20, 20)];
    [close setImage:[UIImage imageNamed:@"exk"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeSearchView:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:close];
    searchView.clipsToBounds = YES;
    sillhou = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    sillhou.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    sillhou.alpha = 0;
    UIView *textContainer = [[UIView alloc] initWithFrame:CGRectMake(10, 8, self.view.frame.size.width - 55, 28)];
    textContainer.layer.cornerRadius = 4;
    textContainer.backgroundColor = [UIColor whiteColor];
    [searchView addSubview:textContainer];
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(8, -1, 30, 30)];
    [searchButton addTarget:self action:@selector(searchEmpty:) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setImage:[UIImage imageNamed:@"search-small"] forState:UIControlStateNormal];
    [textContainer addSubview:searchButton];
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(38, 0, textContainer.frame.size.width - 43, 28)];
    searchField.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    searchField.font = [utils fontRegularForSize:12];
    searchField.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search request" attributes:@{NSForegroundColorAttributeName: [[UIColor blackColor] colorWithAlphaComponent:0.3],
                                                                                                                  NSFontAttributeName:[utils fontRegularForSize:12]}];
    [textContainer addSubview:searchField];
    [self.navigationController.view addSubview:sillhou];
    [self.navigationController.view addSubview:searchView];
    [UIView animateWithDuration:0.2 animations:^{
        searchView.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
        sillhou.alpha = 1;
        [searchField becomeFirstResponder];
    }];
}
-(IBAction)searchEmpty:(UIButton *)sender{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if ([[NSString stringWithFormat:@"%@",noResultView] isEqualToString:@"(null)"]) {
        noResultView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50)];
        noResultView.backgroundColor = [UIColor whiteColor];
        noResultView.alpha = 0;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((noResultView.frame.size.width * .4), noResultView.frame.size.width * .425, noResultView.frame.size.width * .2, noResultView.frame.size.height * .2)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"zoom"];
        [noResultView addSubview:imageView];
        UILabel *label = [[UILabel alloc] init];
        label.attributedText = [[NSAttributedString alloc] initWithString:@"No results found\n\nTry again" attributes:@{NSForegroundColorAttributeName: [utils colorNavigationBar], NSFontAttributeName: [utils fontRegularForSize:16]}];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
        label.frame = CGRectMake((self.view.frame.size.width - label.frame.size.width)/2, noResultView.frame.size.width * .75, label.frame.size.width, label.frame.size.height);
        [noResultView addSubview:label];
        [self.view addSubview:noResultView];
    }
    [UIView animateWithDuration:0.2 animations:^{
        sillhou.alpha = 0;
        noResultView.alpha = 1;
    } completion:^(BOOL finished){
        [sillhou removeFromSuperview];
    }];
}
-(IBAction)closeSearchView:(UIButton *)sender{
    [UIView animateWithDuration:0.2 animations:^{
        searchView.frame = CGRectMake(0, 20, self.view.frame.size.width, 0);
        sillhou.alpha = 0;
        noResultView.alpha = 0;
    } completion:^(BOOL finished){
        [searchView removeFromSuperview];
        [noResultView removeFromSuperview];
        [sillhou removeFromSuperview];
    }];
}
- (void)setTitleViewForNavBar{
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [utils attrString:@"SproutPic" withFont:[utils fontRegularForSize:16] color:[UIColor whiteColor] andCharSpacing:[NSNumber numberWithInt:0]];
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    
    self.navigationItem.titleView = label;
}

@end
