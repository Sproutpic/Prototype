//
//  SocialMediaButtonsTableViewCell.h
//  Sprout
//
//  Created by Jeff Morris on 10/21/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum SocialMediaType {
    SocialMediaFacebook = 0,
    SocialMediaTwitter,
    SocialMediaSprout
} SocialMediaType;

@class Project;

@interface SocialMediaButtonsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;

@property (weak, nonatomic) Project *project;

typedef void (^ SocialMediaCallBack)(SocialMediaType mediaType, Project *project);
@property (strong, nonatomic) SocialMediaCallBack socialMediaCallBack;


@end
