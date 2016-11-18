//
//  TableAdapter.m
//  Sprout
//
//  Created by Jeff Morris on 10/11/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "TableAdapter.h"

@implementation TableAdapter

# pragma mark Private

- (void)createFetchResultsController
{
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName]
                                              inManagedObjectContext:[self managedObjectContect]];
    [fetchRequest setEntity:entity];
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:10];
    // Set the predicate
    [fetchRequest setPredicate:[self predicate]];    
    // Edit the sort key as appropriate.
    if ([self sortDescriptors]==nil) {
        [self setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]]];
    }
    [fetchRequest setSortDescriptors:[self sortDescriptors]];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *afrc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                           managedObjectContext:[self managedObjectContect]
                                                                             sectionNameKeyPath:[self sectionNameKeyPath]
                                                                                      cacheName:nil];
    [self setFetchedResultsController:afrc];
    [[self fetchedResultsController] setDelegate:self];
    
    NSError *error = nil;
    if ([self fetchedResultsController] && ![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }

}

# pragma mark TableAdapter

- (instancetype)initForTableView:(UITableView*)tableView
                       forEntity:(NSString*)entity
                       predicate:(NSPredicate*)predicate
                            sort:(NSArray*)sortDescriptors
                  sectionNameKey:(NSString*)sectionNameKeyPath
            managedObjectContext:(NSManagedObjectContext*)managedObjectContect
     withConfigureTableCellBlock:(ConfigureTableCellBlock)configureTableCellBlock
{
    if (self = [super init]) {
        [self setTableView:tableView];
        [[self tableView] setDataSource:self];
        [self setEntityName:entity];
        [self setPredicate:predicate];
        [self setSortDescriptors:sortDescriptors];
        [self setSectionNameKeyPath:sectionNameKeyPath];
        [self setManagedObjectContect:managedObjectContect];
        [self setConfigureTableCellBlock:configureTableCellBlock];
        [self createFetchResultsController];
    }
    return self;
}

# pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    if ([self fetchedResultsController]==nil) return 1;
    return [[[self fetchedResultsController] sections] count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _configureTableCellBlock(tv,indexPath,[[self fetchedResultsController] objectAtIndexPath:indexPath]);
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    NSInteger returnValue = 0;
    if ([self fetchedResultsController]==nil ||
        [[self fetchedResultsController] sections]==nil ||
        [[[self fetchedResultsController] sections] count]<=section ||
        [[[self fetchedResultsController] sections] objectAtIndex:section]==nil) {
        returnValue = 0;
    } else {
        returnValue = [[[[self fetchedResultsController] sections] objectAtIndex:section] numberOfObjects];
    }
    return returnValue;
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
    if (sectionInfo==nil) return @"";
    return [sectionInfo name];
}

# pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self tableView]deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default: break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tv = [self tableView];
    indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    newIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row inSection:newIndexPath.section];
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tv insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            if (_configureTableCellBlock) {
                _configureTableCellBlock(tv,indexPath,anObject);
            }
            break;
        case NSFetchedResultsChangeMove:
            [tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tv insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] endUpdates];
}

@end
