//
//  SelectTableViewController.h
//  Sprout
//
//  Created by Jeff Morris on 10/29/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum SelectRowDataOrder {
    SelectRD_Title = 0,
    SelectRD_Subtitle,
    SelectRD_Selected
} SelectRowDataOrder;

@protocol SelectTableViewControllerDelegate <NSObject>

- (void)selectionMade:(NSArray*)rows forIndex:(NSInteger)index withTag:(NSInteger)tag;

@end

@interface SelectTableViewController : UITableViewController

// Row Data: [ SelectRD_Title(String), SelectRD_Subtitle(String), SelectRD_Selected(Bool) ]
@property (strong, nonatomic) NSArray *rows;
@property (nonatomic) NSInteger tag;
@property (weak, nonatomic) id<SelectTableViewControllerDelegate> selectDelegate;

@end
