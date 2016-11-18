//
//  AppDelegate+DemoData.m
//  Sprout
//
//  Created by Jeff Morris on 10/11/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "AppDelegate+DemoData.h"
#import "CoreDataAccessKit.h"
#import "DataObjects.h"

@implementation AppDelegate (DemoData)

- (void)createTimelinesFor:(NSArray*)urls forProject:(Project*)project withMoc:(NSManagedObjectContext*)moc
{
    for (NSString *url in urls) {
        [Timeline createNewTimelineWithServerURL:url forProject:project withMOC:[project managedObjectContext]];
    }
}

- (void)createDemoData
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"DemoDataCreated"]) return; // Only run this once...
    
    NSManagedObjectContext *moc = [[CoreDataAccessKit sharedInstance] createNewManagedObjectContextwithName:@"TempData" andConcurrency:NSMainQueueConcurrencyType];
    
    [self createTimelinesFor:@[@"http://cdn4.fast-serve.net/cdn/plugplants/Pack-X6-Blue-Agapanthus-Perennial-Summer-Flowering-Plug-Plants_700_600_78HAG.jpg",
                               @"https://s-media-cache-ak0.pinimg.com/564x/36/d4/08/36d408bdaf1b71825edde18ed7bc3690.jpg",
                               @"https://s-media-cache-ak0.pinimg.com/236x/6b/14/7a/6b147af37bf15c7f10c3583c247fc5b2.jpg",
                               @"https://s-media-cache-ak0.pinimg.com/236x/c2/a4/df/c2a4df1e8aad6b6f5404bdf8ac0c1cc7.jpg"]
                  forProject:[Project createNewProject:@"Project Title 1"
                                              subTitle:@"This is a description about this project, telling what user is tracking here and any other information user is willing to note down about it."
                              withManagedObjectContext:moc]
                     withMoc:moc];
    
    [self createTimelinesFor:@[@"http://ghk.h-cdn.co/assets/15/33/980x490/landscape-1439490128-plants.jpg",
                               @"http://cdn3.fast-serve.net/cdn/plugplants/_0_0_6PNES.jpg",
                               @"http://cdn1.fast-serve.net/cdn/plugplants/Pack-x6-Mimulus-39-Glutinosus-39-Monkey-Plant-Hanging-Basket-Garden-Plug-Plants_700_600_7GH4I.jpg",
                               @"https://s-media-cache-ak0.pinimg.com/236x/44/97/88/449788a41a9d826eace28f363fb80b69.jpg"]
                  forProject:[Project createNewProject:@"Project Title 2"
                                              subTitle:@"This is a description about this project, telling what user is tracking here and any other information user is willing to note down about it."
                              withManagedObjectContext:moc]
                     withMoc:moc];
    
    [self createTimelinesFor:@[@"http://cdn4.fast-serve.net/cdn/plugplants/Pack-X6-Blue-Agapanthus-Perennial-Summer-Flowering-Plug-Plants_700_600_78HAG.jpg",
                               @"https://s-media-cache-ak0.pinimg.com/564x/36/d4/08/36d408bdaf1b71825edde18ed7bc3690.jpg",
                               @"https://s-media-cache-ak0.pinimg.com/236x/6b/14/7a/6b147af37bf15c7f10c3583c247fc5b2.jpg",
                               @"https://s-media-cache-ak0.pinimg.com/236x/c2/a4/df/c2a4df1e8aad6b6f5404bdf8ac0c1cc7.jpg"]
                  forProject:[Project createNewProject:@"Project Title 3"
                                              subTitle:@"This is a description about this project, telling what user is tracking here and any other information user is willing to note down about it."
                              withManagedObjectContext:moc]
                     withMoc:moc];
    
    [self createTimelinesFor:@[@"http://ghk.h-cdn.co/assets/15/33/980x490/landscape-1439490128-plants.jpg",
                               @"http://cdn3.fast-serve.net/cdn/plugplants/_0_0_6PNES.jpg",
                               @"http://cdn1.fast-serve.net/cdn/plugplants/Pack-x6-Mimulus-39-Glutinosus-39-Monkey-Plant-Hanging-Basket-Garden-Plug-Plants_700_600_7GH4I.jpg",
                               @"https://s-media-cache-ak0.pinimg.com/236x/44/97/88/449788a41a9d826eace28f363fb80b69.jpg"]
                  forProject:[Project createNewProject:@"Project Title 4"
                                              subTitle:@"This is a description about this project, telling what user is tracking here and any other information user is willing to note down about it."
                              withManagedObjectContext:moc]
                     withMoc:moc];
    
    [moc save:nil]; // Save the data
    
    // Update the prefs so we don't run this again...
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DemoDataCreated"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
