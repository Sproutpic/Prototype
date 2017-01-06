//
//  Timeline+CoreDataClass.m
//  Sprout
//
//  Created by Jeff Morris on 10/22/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "Timeline+CoreDataClass.h"
#import "Project+CoreDataClass.h"
#import "CoreDataAccessKit.h"
#import "DataObjects.h"
#import "TimelineWebService.h"
#import "SyncQueue.h"

#define NORMAL_SIZE     450.0
#define THUMBNAIL_SIZE  150.0

@implementation Timeline

# pragma mark Private

- (UIImage*)tempImage
{
    return [UIImage imageNamed:@"logo-white"];
}

- (NSString*)basePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (NSString*)localPathToImage
{
    if ([self localURL]) {
        NSString *basePath = [self basePath];
        NSString *localPath = [basePath stringByAppendingPathComponent:[self localURL]];
        return localPath;
    }
    return nil;
}

- (NSString*)localThumbnailPathToImage
{
    if ([self localThumbnailURL]) {
        NSString *basePath = [self basePath];
        NSString *localPath = [basePath stringByAppendingPathComponent:[self localThumbnailURL]];
        return localPath;
    }
    return nil;
}

- (NSString*)saveImage:(UIImage*)img withName:(NSString*)name
{
    if (img && name) {
        NSString *basePath = [self basePath];
        NSString *localPath = [basePath stringByAppendingPathComponent:name];
        if ([UIImagePNGRepresentation(img) writeToFile:localPath atomically:YES]) {
            return name;
        }
    }
    return nil;
}

- (UIImage *)imageWithImage:(UIImage *)img convertToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToWidth:(float)i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

# pragma mark Timeline

+ (Timeline*)createNewTimelineWithServerURL:(NSString*)serverURL forProject:(Project*)project withMOC:(NSManagedObjectContext*)moc
{
    Timeline *timeline = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Timeline class])
                                                       inManagedObjectContext:moc];
    [timeline setServerURL:serverURL];
    [timeline setOrder:@([[project timelinesArraySorted] count]+1)];
    [timeline setProject:project];
    [project addTimelinesObject:timeline];
    [timeline setCreated:[NSDate date]];
    return timeline;
}

+ (Timeline*)findByUUID:(NSString*)uuid
                withMOC:(NSManagedObjectContext*)moc
{
    Timeline *timeline = nil;
    if (uuid && moc) {
        timeline = (Timeline*)[[CoreDataAccessKit sharedInstance] findAnObject:NSStringFromClass([Timeline class])
                                                                  forPredicate:[NSPredicate predicateWithFormat:@"uuid = %@",uuid]
                                                                      withSort:nil
                                                                         inMOC:moc];
    }
    return timeline;
}

- (NSString*)saveImage:(UIImage*)img
{
    if (img) {
        img = [self imageWithImage:img scaledToWidth:NORMAL_SIZE];
    }
    return [self saveImage:img withName:[NSString stringWithFormat:@"timeline-%@.png",[[NSUUID UUID] UUIDString]]];
}

- (NSString*)saveThumbnailImage:(UIImage*)img
{
    if (img) {
        img = [self imageWithImage:img scaledToWidth:THUMBNAIL_SIZE];
    }
    return [self saveImage:img withName:[NSString stringWithFormat:@"timeline-sm-%@.png",[[NSUUID UUID] UUIDString]]];
}

- (void)loadImageRemotely
{
    if ([self serverURL] && ![[SyncQueue manager] isServiceTagQueued:[self uuid]]) {
        [[SyncQueue manager] addService:[TimelineWebService loadTimelineImage:self withCallback:nil]];
    }
    
//    if ([self serverURL]) {
//        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
//            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self serverURL]]]];
//            if (img) {
//                NSString *imageName = [self saveImage:img];
//                NSString *thumbnailImgName = [self saveThumbnailImage:img];
//                if (imageName && thumbnailImgName) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSDate *now = [NSDate date];
//                        [self setLocalURL:imageName];
//                        [self setLocalThumbnailURL:thumbnailImgName];
//                        [self setLastModified:now];
//                        [[self project] setLastModified:now];
//                        [self save];
//                        NSLog(@"Saved new image - %@",imageName);
//                    });
//                } else {
//                    NSLog(@"Issue trying to save image");
//                }
//            }
//        });
//    }
}

- (NSURL*)URLToLocalImage
{
    NSURL *url = nil;
    NSString *localPath = [self localPathToImage];
    if (localPath) {
        url = [NSURL URLWithString:localPath];
    }
    return url;
}


- (NSData*)imageData
{
    NSString *localFile = [self localPathToImage];
    if (localFile) {
        return [NSData dataWithContentsOfFile:localFile];
    }
    return nil;
}

- (UIImage*)image
{
    NSString *localFile = [self localPathToImage];
    if (localFile) {
        return [UIImage imageWithContentsOfFile:localFile];
    } else {
        [self loadImageRemotely];
    }
    return nil;
}

- (UIImage*)imageOrTempImage
{
    UIImage *image = [self image];
    return (image) ? image : [self tempImage];
}

- (UIImage*)imageThumbnail
{
    NSString *localFile = [self localThumbnailPathToImage];
    if (localFile) {
        return [UIImage imageWithContentsOfFile:localFile];
    } else {
        return [self image];
    }
}

- (UIImage*)imageThumbnailOrTempImage
{
    UIImage *image = [self imageThumbnail];
    return (image) ? image : [self tempImage];
}

- (void)deleteLocalImages
{
    if ([self localURL]) {
        NSString *localURL = [self localPathToImage];
        NSError *error = nil;
        if (localURL) {
            [[NSFileManager defaultManager] removeItemAtPath:localURL error:&error];
        }
        localURL = [self localThumbnailPathToImage];
        if (localURL) {
            [[NSFileManager defaultManager] removeItemAtPath:localURL error:&error];
        }
    }
}

- (NSNumber*)serverPictureOrder
{
    return @([[[self project] timelinesArraySortedOldestToNewest] indexOfObject:self]+1);
}

# pragma mark NSManagedObject

- (void)awakeFromFetch
{
    [super awakeFromFetch];
    if (![self uuid]) {
        [self setUuid:[[NSUUID UUID] UUIDString]];
        [self save];
    }
}

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    NSDate *now = [NSDate date];
    [self setCreated:now];
    [self setLastModified:now];
    [self setUuid:[[NSUUID UUID] UUIDString]];
}

- (void)prepareForDeletion
{
    [self deleteLocalImages];
}

@end
