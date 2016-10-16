//
//  ServerRecord.h
//  Sprout
//
//  Created by Jeff Morris on 10/10/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ServerRecord : NSManagedObject

@property (nonatomic, retain) NSNumber *serverId;
@property (nonatomic, retain) NSDate *lastSync;
@property (nonatomic, retain) NSDate *created;

@end
