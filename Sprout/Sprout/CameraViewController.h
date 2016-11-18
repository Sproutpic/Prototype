//
//  CameraViewController.h
//  Sprout
//
//  Created by Jeff Morris on 10/9/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "BaseViewController.h"

@class Project;

@interface CameraViewController : BaseViewController

@property (strong, nonatomic) Project *project;
@property (strong, nonatomic) NSManagedObjectContext *moc;

@property (strong, nonatomic) CameraCallBack cameraCallBack;

- (IBAction)takePictureButtonTapped:(UIButton *)sender;

@end
