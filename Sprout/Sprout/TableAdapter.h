//
//  TableAdapter.h
//  Sprout
//
//  Created by Jeff Morris on 10/11/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface TableAdapter : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSString *entityName;
@property (strong, nonatomic) NSString *sectionNameKeyPath;
@property (strong, nonatomic) NSPredicate *predicate;
@property (strong, nonatomic) NSArray *sortDescriptors;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContect;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *noDataView;

typedef UITableViewCell* (^ ConfigureTableCellBlock)(UITableView* tableView, NSIndexPath* indexPath, NSManagedObject* managedObject);
@property (strong, nonatomic) ConfigureTableCellBlock configureTableCellBlock;

- (instancetype)initForTableView:(UITableView*)tableView
                       forEntity:(NSString*)entity
                       predicate:(NSPredicate*)predicate
                            sort:(NSArray*)sortDescriptors
                  sectionNameKey:(NSString*)sectionNameKeyPath
            managedObjectContext:(NSManagedObjectContext*)managedObjectContect
     withConfigureTableCellBlock:(ConfigureTableCellBlock)configureTableCellBlock;

@end
