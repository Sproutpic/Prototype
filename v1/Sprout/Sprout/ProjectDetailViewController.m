//
//  ProjectDetailViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 29/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "ProjectDetailViewController.h"

@implementation ProjectDetailViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setController];
}
- (void)setController{
    self.view.backgroundColor = [UIColor whiteColor];
    utils = [[UIUtils alloc]init];
    
    [self setNavigationBar];
    forCreate = YES;
    [self setupLayout];
}
- (void)setupLayout{
    scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
     [self.view addSubview:scroller];
    if (forCreate) {
        [self setupLayoutForCreate];
    }else{
        [self setupLayoutForEdit];
    }
}
- (void)setupLayoutForCreate{
    for (UIView *view in scroller.subviews) {
        [view removeFromSuperview];
    }
    
    UIButton *btnCreate = [[UIButton alloc] initWithFrame:CGRectMake(0, scroller.frame.size.height - 44, self.view.frame.size.width, 44)];
    btnCreate.backgroundColor = [utils colorNavigationBar];
    [btnCreate setAttributedTitle:[[NSAttributedString alloc] initWithString:@"CREATE SPROUT >>" attributes:@{NSFontAttributeName: [utils fontRegularForSize:17],
                                                                                                            NSForegroundColorAttributeName: [UIColor whiteColor]}] forState:UIControlStateNormal];
    [scroller addSubview:btnCreate];
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.text = ((NSString *)[_project objectForKey:@"projectTitle"]).uppercaseString ;
    lblTitle.textColor = [utils colorNavigationBar];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [utils fontRegularForSize:18];
    [lblTitle sizeToFit];
    lblTitle.frame = CGRectMake(0, 28, self.view.frame.size.width, lblTitle.frame.size.height);
    [scroller addSubview:lblTitle];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, lblTitle.frame.size.height + 40, self.view.frame.size.width - 30, 100)];
    descLabel.numberOfLines = 0;
    descLabel.attributedText = [[NSAttributedString alloc]initWithString:[_project objectForKey:@"projectDetail"] attributes:@{NSParagraphStyleAttributeName: paraStyle,
                                                                                                                               NSFontAttributeName: [utils fontRegularForSize:16],
                                                                                                                               NSForegroundColorAttributeName: [UIColor grayColor]}];
    CGRect rect = [descLabel .attributedText boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    descLabel.frame = CGRectMake(15, lblTitle.frame.size.height + 40, descLabel.frame.size.width, rect.size.height);
    [scroller addSubview:descLabel];
    
    lblTitle = [[UILabel alloc] init];
    lblTitle.text = @"PROJECT TIMELINE" ;
    lblTitle.textColor = [utils colorNavigationBar];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [utils fontRegularForSize:18];
    [lblTitle sizeToFit];
    lblTitle.frame = CGRectMake(0, descLabel.frame.origin.y + descLabel.frame.size.height + 28, self.view.frame.size.width, lblTitle.frame.size.height);
    [scroller addSubview:lblTitle];
    
    UIImageView *btnExpand = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40, lblTitle.frame.origin.y, 20, 20)];
    btnExpand.image = [UIImage imageNamed:@"Out"];
    [btnExpand addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandAction:)]];
    btnExpand.userInteractionEnabled = YES;
    [scroller addSubview:btnExpand];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _timelineCollection = [[UICollectionView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * 0.01), lblTitle.frame.origin.y + lblTitle.frame.size.height + 15, self.view.frame.size.width - (self.view.frame.size.width * 0.02), self.view.frame.size.height - (123 + lblTitle.frame.origin.y + lblTitle.frame.size.height)) collectionViewLayout:layout];
    _timelineCollection.delegate = self;
    _timelineCollection.dataSource = self;
    [_timelineCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    _timelineCollection.backgroundColor = [UIColor whiteColor];
    [_timelineCollection sizeToFit];
    [scroller addSubview:_timelineCollection];
    scroller.contentSize = CGSizeMake(scroller.frame.size.width, scroller.subviews.lastObject.frame.origin.y + scroller.subviews.lastObject.frame.size.height);
}
- (void)setupLayoutForEdit{
    for (UIView *view in scroller.subviews) {
        [view removeFromSuperview];
    }
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.text = ((NSString *)[_project objectForKey:@"projectTitle"]).uppercaseString ;
    lblTitle.textColor = [utils colorNavigationBar];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [utils fontRegularForSize:18];
    [lblTitle sizeToFit];
    lblTitle.frame = CGRectMake(0, 28, self.view.frame.size.width, lblTitle.frame.size.height);
    [scroller addSubview:lblTitle];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, lblTitle.frame.size.height + 40, self.view.frame.size.width - 30, 100)];
    descLabel.numberOfLines = 0;
    descLabel.attributedText = [[NSAttributedString alloc]initWithString:[_project objectForKey:@"projectDetail"] attributes:@{NSParagraphStyleAttributeName: paraStyle,
                                                                                                                               NSFontAttributeName: [utils fontRegularForSize:16],
                                                                                                                               NSForegroundColorAttributeName: [UIColor grayColor]}];
    CGRect rect = [descLabel .attributedText boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    descLabel.frame = CGRectMake(15, lblTitle.frame.size.height + 40, descLabel.frame.size.width, rect.size.height);
    [scroller addSubview:descLabel];
    
    lblTitle = [[UILabel alloc] init];
    lblTitle.text = @"PROJECT TIMELINE" ;
    lblTitle.textColor = [utils colorNavigationBar];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [utils fontRegularForSize:18];
    [lblTitle sizeToFit];
    lblTitle.frame = CGRectMake(0, descLabel.frame.origin.y + descLabel.frame.size.height + 28, self.view.frame.size.width, lblTitle.frame.size.height);
    [scroller addSubview:lblTitle];
    
    UIImageView *btnExpand = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40, lblTitle.frame.origin.y, 20, 20)];
    btnExpand.image = [UIImage imageNamed:@"In"];
    [btnExpand addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandAction:)]];
    btnExpand.userInteractionEnabled = YES;
    [scroller addSubview:btnExpand];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _timelineCollection = [[UICollectionView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * 0.01), lblTitle.frame.origin.y + lblTitle.frame.size.height + 15, self.view.frame.size.width - (self.view.frame.size.width * 0.02), self.view.frame.size.height - (123 + lblTitle.frame.origin.y + lblTitle.frame.size.height)) collectionViewLayout:layout];
    _timelineCollection.delegate = self;
    _timelineCollection.dataSource = self;
    [_timelineCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_timelineCollection sizeToFit];
    _timelineCollection.frame = CGRectMake(_timelineCollection.frame.origin.x, _timelineCollection.frame.origin.y + 6, _timelineCollection.frame.size.width, _timelineCollection.frame.size.height);
    _timelineCollection.backgroundColor = [UIColor whiteColor];
    [scroller addSubview:_timelineCollection];
    
    lblTitle = [[UILabel alloc] init];
    lblTitle.text = @"PROJECT SPROUT" ;
    lblTitle.textColor = [utils colorNavigationBar];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [utils fontRegularForSize:18];
    [lblTitle sizeToFit];
    lblTitle.frame = CGRectMake(0, _timelineCollection.frame.origin.y + _timelineCollection.frame.size.height - 15, self.view.frame.size.width, lblTitle.frame.size.height);
    [scroller addSubview:lblTitle];
    
    sprout = [[UIImageView alloc] initWithFrame:CGRectMake(0, lblTitle.frame.origin.y + lblTitle.frame.size.height + 10, scroller.frame.size.width, self.view.frame.size.width * 0.6)];
    if ([_useFile boolValue]) {
        sprout.image = [UIImage imageWithContentsOfFile:((NSString *)[_project objectForKey:@"projectThumbnails"][0])];
    } else {
        [sprout sd_setImageWithURL:[NSURL URLWithString:((NSString *)[_project objectForKey:@"projectThumbnails"][0])]];
    }
    play = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.405, self.view.frame.size.width * 0.205, self.view.frame.size.width * 0.19, self.view.frame.size.width * 0.19)];
    play.image = [UIImage imageNamed:@"play-button"];
    [sprout addSubview:play];
    [scroller addSubview:sprout];
    
    lblTitle = [[UILabel alloc] init];
    lblTitle.text = @"SHARE YOUR SPROUT WITH FRIENDS" ;
    lblTitle.textColor = [utils colorNavigationBar];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [utils fontRegularForSize:15];
    [lblTitle sizeToFit];
    lblTitle.frame = CGRectMake(0, sprout.frame.origin.y + sprout.frame.size.height + 20, self.view.frame.size.width, lblTitle.frame.size.height);
    [scroller addSubview:lblTitle];
    
    CGFloat lastY = 0;
    for (int i = 0; i < 5; i++) {
        UIImageView *imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(i * (self.view.frame.size.width / 5), lblTitle.frame.origin.y + lblTitle.frame.size.height + 13, self.view.frame.size.width / 5, self.view.frame.size.width * 0.11)];
        lastY = imageIcon.frame.origin.y + imageIcon.frame.size.height;
        imageIcon.contentMode = UIViewContentModeScaleAspectFit;
        imageIcon.userInteractionEnabled = YES;
        imageIcon.tag = i;
        [imageIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIcon:)]];
        switch (i) {
            case 0:
                imageIcon.image = [UIImage imageNamed:@"Facebook"];
                break;
            case 1:
                imageIcon.image = [UIImage imageNamed:@"inst"];
                break;
            case 2:
                imageIcon.image = [UIImage imageNamed:@"youtube"];
                break;
            case 3:
                imageIcon.image = [UIImage imageNamed:@"Twit"];
                break;
            case 4:
                imageIcon.image = [UIImage imageNamed:@"logo-on"];
                break;
            default:
                break;
        }
        [scroller addSubview:imageIcon];
    }
    
    
    
    UIButton *btnCreate = [[UIButton alloc] initWithFrame:CGRectMake(0, lastY + 30, self.view.frame.size.width, 44)];
    btnCreate.backgroundColor = [utils colorNavigationBar];
    [btnCreate setAttributedTitle:[[NSAttributedString alloc] initWithString:@"EDIT SPROUT >>" attributes:@{NSFontAttributeName: [utils fontRegularForSize:17],
                                                                                                            NSForegroundColorAttributeName: [UIColor whiteColor]}] forState:UIControlStateNormal];
    [btnCreate addTarget:self action:@selector(editProject:) forControlEvents:UIControlEventTouchUpInside];
    [scroller addSubview:btnCreate];
    scroller.contentSize = CGSizeMake(scroller.frame.size.width, scroller.subviews.lastObject.frame.origin.y + scroller.subviews.lastObject.frame.size.height);
}
- (void)tapIcon:(UITapGestureRecognizer *)sender{
    ((UIImageView *)sender.view).image = sender.view.tag == 0 ? ([((UIImageView *)sender.view).image isEqual:[UIImage imageNamed:@"Facebook"]] ? [UIImage imageNamed:@"Facebook-on"] : [UIImage imageNamed:@"Facebook"]) : (((UIImageView *)sender.view).image = sender.view.tag == 1 ? ([((UIImageView *)sender.view).image isEqual:[UIImage imageNamed:@"Inst-on"]] ? [UIImage imageNamed:@"inst"] : [UIImage imageNamed:@"Inst-on"]) : ((((UIImageView *)sender.view).image = sender.view.tag == 2 ? ([((UIImageView *)sender.view).image isEqual:[UIImage imageNamed:@"Youtube-on"]] ? [UIImage imageNamed:@"youtube"] : [UIImage imageNamed:@"Youtube-on"]) : ((((UIImageView *)sender.view).image = sender.view.tag == 3 ? ([((UIImageView *)sender.view).image isEqual:[UIImage imageNamed:@"Twit-on"]] ? [UIImage imageNamed:@"Twit"] : [UIImage imageNamed:@"Twit-on"]) : ([((UIImageView *)sender.view).image isEqual:[UIImage imageNamed:@"logo"]] ? [UIImage imageNamed:@"logo-on"] : [UIImage imageNamed:@"logo"]))))));
}
- (void)expandAction:(UITapGestureRecognizer *)sender{
    if (forCreate) {
        [self setupLayoutForEdit];
    }else{
        [self setupLayoutForCreate];
    }
    forCreate = forCreate ? NO : YES;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return ((NSArray *)[_project objectForKey:@"projectThumbnails"]).count + 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width * 0.2375, self.view.frame.size.width * 0.2375);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return self.view.frame.size.width * 0.01;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.view.frame.size.width * 0.01;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (indexPath.row == ((NSArray *)[_project objectForKey:@"projectThumbnails"]).count) {
        cell.contentView.backgroundColor = [utils colorNavigationBar];
        UILabel *lblCell = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height / 5 * 4, cell.contentView.frame.size.width, cell.contentView.frame.size.height / 5)];
        lblCell.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        lblCell.text = @"ADD PHOTO";
        lblCell.textColor = [UIColor whiteColor];
        lblCell.textAlignment = NSTextAlignmentCenter;
        lblCell.font = [utils fontRegularForSize:cell.contentView.frame.size.height / 8.5];
        [cell.contentView addSubview:lblCell];
        UIImageView *plus = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.height * 0.325, cell.contentView.frame.size.height * 0.25, cell.contentView.frame.size.height * 0.35, cell.contentView.frame.size.height * 0.35)];
        plus.image = [UIImage imageNamed:@"plus"];
        [cell.contentView addSubview:plus];
    }else{
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.frame];
        if ([_useFile boolValue]) {
            imageView.image = [UIImage imageWithContentsOfFile:((NSString *)[_project objectForKey:@"projectThumbnails"][indexPath.row])];
        } else {
            [imageView sd_setImageWithURL:[NSURL URLWithString:((NSString *)[_project objectForKey:@"projectThumbnails"][indexPath.row])]];
        }
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [cell.contentView addSubview:imageView];
        UILabel *lblCell = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height / 5 * 4, cell.contentView.frame.size.width, cell.contentView.frame.size.height / 5)];
        lblCell.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        lblCell.font = [utils fontRegularForSize:cell.contentView.frame.size.height / 8.5];
        [cell.contentView addSubview:lblCell];
        lblCell = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height / 5 * 4, cell.contentView.frame.size.width - cell.contentView.frame.size.height / 13, cell.contentView.frame.size.height / 5)];
        lblCell.text = @"05 JAN 16";
        lblCell.textColor = [UIColor whiteColor];
        lblCell.textAlignment = NSTextAlignmentRight;
        lblCell.font = [utils fontRegularForSize:cell.contentView.frame.size.height / 8.5];
        [cell.contentView addSubview:lblCell];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == ((NSArray *)[_project objectForKey:@"projectThumbnails"]).count) {
        [self.navigationController pushViewController:[[CameraViewController alloc]init] animated:YES];
    }
}
- (void)addCreateButton{
    UIButton *btnCreate = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 108, self.view.frame.size.width, 44)];
    btnCreate.backgroundColor = [utils colorNavigationBar];
    [btnCreate setAttributedTitle:[[NSAttributedString alloc] initWithString:@"CREATE SPROUT >>" attributes:@{NSFontAttributeName: [utils fontRegularForSize:17],
                                                                                                               NSForegroundColorAttributeName: [UIColor whiteColor]}] forState:UIControlStateNormal];
    [self.view addSubview:btnCreate];
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
    [download setBackgroundImage:[UIImage imageNamed:@"Pen"] forState:UIControlStateNormal];
    [download addTarget:self action:@selector(editProject:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:download];
    self.navigationItem.rightBarButtonItem = barButton;
}
- (IBAction)editProject:(UIButton *)sender{
    EditProjectDetailsViewController *editScreen = [[EditProjectDetailsViewController alloc] init];
    editScreen.project = _project;
    editScreen.useFile = _useFile;
    [self.navigationController pushViewController:editScreen animated:YES];
}
- (IBAction)backToMenu:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setTitleViewForNavBar{
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [utils attrString:@"Project Details" withFont:[utils fontForNavBarTitle] color:[UIColor whiteColor] andCharSpacing:[NSNumber numberWithInt:0]];
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    
    self.navigationItem.titleView = label;
}
@end
