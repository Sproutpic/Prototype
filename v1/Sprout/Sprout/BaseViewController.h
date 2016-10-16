//
//  BaseViewController.h
//  Sprout
//
//  Created by Jeff Morris on 10/9/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseViewControllerDelegate <NSObject>

- (void)setController;
- (void)setNavigationBar;
- (void)addLeftBarButton;
- (void)addRightBarButton;

- (UITableView*)createBaseTableView;
- (UIView*)fakeTableFooter;

@end

@interface BaseViewController : UIViewController <BaseViewControllerDelegate>

@end
