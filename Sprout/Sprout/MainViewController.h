//
//  MainViewController.h
//  Sprout
//
//  Created by LLDM 0038 on 13/06/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"

@interface MainViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong,nonatomic) NSMutableArray * startSprout;
@property (strong,nonatomic)UIImagePickerController * picker;
@property (strong,nonatomic)UIImageView * prevImg;
@property (strong,nonatomic)UIImageView * sproutImg;
@property (strong,nonatomic)NSNumber * isPlaying;
@property (strong,nonatomic)UICollectionView * savedSproutView;
@end
