//
//  SproutWebService.h
//  Sprout
//
//  Created by Jeff Morris on 10/16/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

// API Docs: http://104.155.191.194/Help

#define DEMO_MODE               NO //YES
#define SPROUT_URL              @"http://104.155.191.194"
#define SPROUT_COMMUNITY_URL    [NSString stringWithFormat:@"%@/Community?hideMenu=true", SPROUT_URL]
#define SPROUT_API_URL          [NSString stringWithFormat:@"%@/api/Mobile", SPROUT_URL]

#define DEFAULT_DUMMY_PLACE_HOLDER      @"--"

typedef enum : NSUInteger {
    ContentTypeFormUrlEncoded, // The default...
    ContentTypeFormData,
    ContentTypeRaw,
    ContentTypeBinary,
} ContentTypes;

// ---------------------------------------------------------------------------------------------------

@protocol SproutWebServiceAuthDelegate <NSObject>

- (void)authenticationNeeded:(void (^)(NSError *error))completion;

@end

// ---------------------------------------------------------------------------------------------------

@protocol SproutWebServiceDelegate <NSObject>

- (void)completedSuccess:(id)responseObject;
- (void)completedFailure:(NSError*)error;

@end

// ---------------------------------------------------------------------------------------------------

@interface SproutWebService : NSObject <SproutWebServiceDelegate>

typedef void (^ SproutServiceCallBack)(NSError *error, SproutWebService* service);
@property (strong, nonatomic) SproutServiceCallBack serviceCallBack;

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSDictionary *parameters;
@property (strong, nonatomic) NSDictionary *headers;
@property (nonatomic) ContentTypes contentType;
@property (strong, nonatomic) NSString *serviceTag;
@property (nonatomic) BOOL oauthEnabled;
@property (nonatomic) BOOL fakeService;

@property (strong, nonatomic) NSManagedObjectContext *moc;

- (void)start;

- (NSString*)encode64String:(NSString*)value;

// Sync Helper Methods

- (NSDateFormatter*)dateFormatter;
- (BOOL)isNull:(NSObject*)obj;
- (NSString*)stringForKey:(NSString*)key inDict:(NSDictionary*)dictionary;
- (NSNumber*)numberForKey:(NSString*)key inDict:(NSDictionary*)dictionary;
- (NSDecimalNumber*)decimalForKey:(NSString*)key inDict:(NSDictionary*)dictionary;
- (NSNumber*)boolForKey:(NSString*)key inDict:(NSDictionary*)dictionary;
- (NSDate*)dateForKey:(NSString*)key inDict:(NSDictionary*)dictionary;

@end
