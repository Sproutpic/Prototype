//
//  EditProjectDetailsViewController.m
//  Sprout
//
//  Created by LLDM 0038 on 29/07/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "EditProjectDetailsViewController.h"


@implementation EditProjectDetailsViewController
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
    scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:scroller];
    
    fieldTitle = [[UITextField alloc] initWithFrame:CGRectMake(15, 7, scroller.frame.size.width - 15, 50)];
    fieldTitle.font = [utils fontRegularForSize:18];
    fieldTitle.textColor = [utils colorNavigationBar];
    fieldTitle.text = [_project objectForKey:@"projectTitle"];
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
    fieldDesc = [[UITextView alloc]initWithFrame:CGRectMake(15, lblOpt.frame.origin.y + lblOpt.frame.size.height + 15, scroller.frame.size.width - 15, 0)];
    fieldDesc.tintColor = [utils colorNavigationBar];
    fieldDesc.delegate = self;
    fieldDesc.attributedText = [[NSAttributedString alloc] initWithString:[_project objectForKey:@"projectDetail"] attributes:@{NSFontAttributeName: [utils fontRegularForSize:16], NSForegroundColorAttributeName: [UIColor colorWithRed:67.f/255.f green:61.f/255.f blue:60.f/255.f alpha:1.f], NSParagraphStyleAttributeName: paraStyle}];
    CGRect rect = [fieldDesc.attributedText boundingRectWithSize:CGSizeMake(fieldDesc.frame.size.width - 15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    fieldDesc.frame = CGRectMake(10, fieldDesc.frame.origin.y, fieldDesc.frame.size.width + 5, rect.size.height + 15);
    [scroller addSubview:fieldDesc];
    separator = [[UIView alloc]initWithFrame:CGRectMake(5, fieldDesc.frame.size.height - 1, fieldDesc.frame.size.width, 1)];
    separator.backgroundColor = [[utils colorNavigationBar]colorWithAlphaComponent:0.5];
    textViewsept = separator;
    [fieldDesc addSubview:textViewsept];
    
    remindView = [[UIView alloc] initWithFrame:CGRectMake(0, fieldDesc.frame.size.height + fieldDesc.frame.origin.y + 41, scroller.frame.size.width, 57)];
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
     [switchRemind addTarget:self action:@selector(switched:)
     forControlEvents:UIControlEventValueChanged];
    
    [scroller addSubview:remindView];
    
    projectPhotosLabel = [[UILabel alloc] init];
    projectPhotosLabel.text = @"Project Photos";
    projectPhotosLabel.font = [utils fontRegularForSize:18];
    projectPhotosLabel.textColor = [utils colorNavigationBar];
    projectPhotosLabel.textAlignment = NSTextAlignmentCenter;
    [projectPhotosLabel sizeToFit];
    projectPhotosLabel.frame = CGRectMake(0, remindView.frame.size.height + remindView.frame.origin.y + 44, remindView.frame.size.width, projectPhotosLabel.frame.size.height);
    [scroller addSubview:projectPhotosLabel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _photosCollection = [[UICollectionView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * 0.0475), projectPhotosLabel.frame.origin.y + projectPhotosLabel.frame.size.height + 15, self.view.frame.size.width - (self.view.frame.size.width * 0.095), 50) collectionViewLayout:layout];
    _photosCollection.scrollEnabled = NO;
    _photosCollection.delegate = self;
    _photosCollection.dataSource = self;
    [_photosCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    _photosCollection.backgroundColor = [UIColor whiteColor];
    [scroller addSubview:_photosCollection];
    [self updateScroller];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return ((NSArray *)[_project objectForKey:@"projectThumbnails"]).count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width * 0.27, self.view.frame.size.width * 0.27);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.view.frame.size.width * 0.0475;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.view.frame.size.width * 0.0475;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, cell.contentView.frame.size.width - 4,  cell.contentView.frame.size.width - 4)];
    if ([_useFile boolValue]) {
        imageView.image = [UIImage imageWithContentsOfFile:((NSString *)[_project objectForKey:@"projectThumbnails"][indexPath.row])];
    } else {
        [imageView sd_setImageWithURL:[NSURL URLWithString:((NSString *)[_project objectForKey:@"projectThumbnails"][indexPath.row])]];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [cell.contentView addSubview:imageView];
    UIButton *removeButton = [[UIButton alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - (self.view.frame.size.width * 0.049), 0, (self.view.frame.size.width * 0.049), (self.view.frame.size.width * 0.049))];
    removeButton.backgroundColor = [utils colorNavigationBar];
    removeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    removeButton.layer.borderWidth = 1;
    removeButton.layer.cornerRadius = 3;
    removeButton.tag = indexPath.row;
    removeButton.imageView.contentMode = UIViewContentModeCenter;
    [removeButton setImage:[self imageWithImage:[UIImage imageNamed:@"exk"] scaledToSize:CGSizeMake(removeButton.frame.size.height * 0.65, removeButton.frame.size.height * 0.65)] forState:UIControlStateNormal];
    [removeButton addTarget:self action:@selector(removeItem:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:removeButton];
    _photosCollection.frame = CGRectMake(_photosCollection.frame.origin.x, _photosCollection.frame.origin.y, _photosCollection.frame.size.width, _photosCollection.contentSize.height);
    [self updateScroller];
    return cell;
}
-(IBAction)removeItem:(UIButton *)sender{
    [((NSMutableArray *)[_project objectForKey:@"projectThumbnails"]) removeObjectAtIndex:sender.tag];
    [_photosCollection deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]]];
    [_photosCollection reloadData];
}
-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)updateScroller{
    scroller.contentSize = CGSizeMake(scroller.frame.size.width, _photosCollection.frame.origin.y + _photosCollection.frame.size.height + 15);
}
- (IBAction)switched:(UISwitch *)sender{
    [UIView animateWithDuration:0.2 animations:^{
        if(sender.on){
            remindView.frame = CGRectMake(remindView.frame.origin.x,remindView.frame.origin.y, remindView.frame.size.width,238);
        }else{
            remindView.frame = CGRectMake(remindView.frame.origin.x,remindView.frame.origin.y, remindView.frame.size.width,57);
        }
        projectPhotosLabel.frame = CGRectMake(0, remindView.frame.size.height + remindView.frame.origin.y + 40, remindView.frame.size.width, projectPhotosLabel.frame.size.height);
        _photosCollection.frame = CGRectMake(_photosCollection.frame.origin.x, projectPhotosLabel.frame.origin.y + projectPhotosLabel.frame.size.height + 15, _photosCollection.frame.size.width, _photosCollection.contentSize.height);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 animations:^{
            [self updateScroller];
        }];
    }];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.2 animations:^{
        textViewsept.frame = CGRectMake(textView.frame.size.width, fieldDesc.frame.size.height - 1, 0, 1);
    }];
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
        projectPhotosLabel.frame = CGRectMake(0, remindView.frame.size.height + remindView.frame.origin.y + 40, remindView.frame.size.width, projectPhotosLabel.frame.size.height);
        _photosCollection.frame = CGRectMake(_photosCollection.frame.origin.x, projectPhotosLabel.frame.origin.y + projectPhotosLabel.frame.size.height + 15, _photosCollection.frame.size.width, _photosCollection.contentSize.height);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 animations:^{
            [self updateScroller];
        }];
    }];
}
- (void)setNavigationBar{
    [self setTitleViewForNavBar];
    [self addLeftBarButton];
    [self addRightBarButton];
}
- (void)addLeftBarButton{
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [back setBackgroundImage:[UIImage imageNamed:@"exk"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = barButton;
}
- (void)addRightBarButton{
    UIButton *download = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [download setBackgroundImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    [download addTarget:self action:@selector(updateProjectDetail) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:download];
    self.navigationItem.rightBarButtonItem = barButton;
}
- (void)updateProjectDetail{
    if (!([fieldTitle.text isEqualToString:[_project objectForKey:@"projectTitle"]]) || !([fieldDesc.text isEqualToString:[_project objectForKey:@"projectDetail"]])) {
        webService = [[WebService alloc] init];
        [webService requestUpdateSprout:@{@"sproutId":[_project objectForKey:@"sproutId"],
                                          @"title":fieldTitle.text,
                                          @"description":fieldDesc.text,
                                          @"userName":[[[NSUserDefaults standardUserDefaults] objectForKey:@"user"] objectForKey:@"name"],
                                          @"pathToImagesFolder":[_project objectForKey:@"pathToImagesFolder"],
                                          @"sproutFileName":[[NSString stringWithFormat:@"%@",[_project objectForKey:@"pathToImagesFolder"]] componentsSeparatedByString:@"/"].lastObject,
                                          @"framesPerMinute":[NSNumber numberWithInt:30],
                                          @"startDt":@"01/01/2016",
                                          @"endDt":@"01/31/206"} withTarget:self];
    }else{
        [self showAlertWithMessage:@"Already Updated"];
    }
}
- (void)showAlertWithMessage:(NSString *)str{
    [[[UIAlertView alloc]initWithTitle:@"" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}
- (IBAction)backToMenu:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setTitleViewForNavBar{
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [utils attrString:@"Edit Project Details" withFont:[utils fontForNavBarTitle] color:[UIColor whiteColor] andCharSpacing:[NSNumber numberWithInt:0]];
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    
    self.navigationItem.titleView = label;
}
@end
