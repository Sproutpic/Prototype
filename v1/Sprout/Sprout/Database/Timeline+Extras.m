//
//  Timeline.m
//  Sprout
//
//  Created by Jeff Morris on 10/22/16.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "DataObjects.h"
#import "UIImageView+WebCache.h"
#import "CoreDataAccessKit.h"

#define NORMAL_SIZE     450.0
#define THUMBNAIL_SIZE  150.0

@implementation Timeline (Extras)

# pragma mark Private

+ (UIImage*)tempImage
{
    return [UIImage imageNamed:@"logo-white"];
}

# pragma mark NSManagedObject

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    NSDate *now = [NSDate date];
    [self setCreated:now];
    [self setLastModified:now];
}

+ (NSString*)basePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (NSString*)localPathToImage:(Timeline*)timeline
{
    if ([timeline localURL]) {
        NSString *basePath = [Timeline basePath];
        NSString *localPath = [basePath stringByAppendingPathComponent:[timeline localURL]];
        return localPath;
    }
    return nil;
}

+ (NSString*)localThumbnailPathToImage:(Timeline*)timeline
{
    if ([timeline localThumbnailURL]) {
        NSString *basePath = [Timeline basePath];
        NSString *localPath = [basePath stringByAppendingPathComponent:[timeline localThumbnailURL]];
        return localPath;
    }
    return nil;
}

+ (NSString*)saveImage:(UIImage*)img withName:(NSString*)name
{
    if (img && name) {
        NSString *basePath = [Timeline basePath];
        NSString *localPath = [basePath stringByAppendingPathComponent:name];
        if ([UIImagePNGRepresentation(img) writeToFile:localPath atomically:YES]) {
            return name;
        }
    }
    return nil;
}

+ (UIImage *)imageWithImage:(UIImage *)img convertToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToWidth:(float)i_width
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
    [timeline setOrder:@([[Project timelinesArraySorted:project] count]+1)];
    [timeline setProject:project];
    [project addTimelinesObject:timeline];
    [timeline setCreated:[NSDate date]];
    return timeline;
}

+ (NSString*)saveImage:(UIImage*)img
{
    if (img) {
        img = [Timeline imageWithImage:img scaledToWidth:NORMAL_SIZE];
    }
    return [Timeline saveImage:img withName:[NSString stringWithFormat:@"timeline-%@.png",[[NSUUID UUID] UUIDString]]];
}

+ (NSString*)saveThumbnailImage:(UIImage*)img
{
    if (img) {
        img = [Timeline imageWithImage:img scaledToWidth:THUMBNAIL_SIZE];
    }
    return [Timeline saveImage:img withName:[NSString stringWithFormat:@"timeline-sm-%@.png",[[NSUUID UUID] UUIDString]]];
}

+ (UIImage*)image:(Timeline*)timeline
{
    NSString *localFile = [Timeline localPathToImage:timeline];
    if (localFile) {
        return [UIImage imageWithContentsOfFile:localFile];
    } else if ([timeline serverURL]) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSManagedObjectContext *moc = [[CoreDataAccessKit sharedInstance] createNewManagedObjectContextwithName:@"ImageDL" andConcurrency:NSPrivateQueueConcurrencyType];
            Timeline *tl = (Timeline*)[[CoreDataAccessKit sharedInstance] findAnObject:NSStringFromClass([Timeline class])
                                                                          forPredicate:[NSPredicate predicateWithFormat:@"self = %@",timeline]
                                                                              withSort:nil inMOC:moc];
            if (tl) {
                UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[tl serverURL]]]];
                if (img) {
                    NSString *imageName = [Timeline saveImage:img];
                    NSString *thumbnailImgName = [Timeline saveThumbnailImage:img];
                    if (imageName && thumbnailImgName) {
                        dispatch_main_sync_safe(^{
                            NSDate *now = [NSDate date];
                            [tl setLocalURL:imageName];
                            [tl setLocalThumbnailURL:thumbnailImgName];
                            [tl setLastModified:now];
                            [[tl project] setLastModified:now];
                            [tl save];
                            NSLog(@"Saved new image - %@",imageName);
                        })
                    } else {
                        NSLog(@"Issue trying to save image");
                    }
                }
            }
        });
    }
    return nil;
}

+ (UIImage*)imageOrTempImage:(Timeline*)timeline
{
    UIImage *image = [Timeline image:timeline];
    return (image) ? image : [Timeline tempImage];
}

+ (UIImage*)imageThumbnail:(Timeline*)timeline
{
    NSString *localFile = [Timeline localThumbnailPathToImage:timeline];
    if (localFile) {
        return [UIImage imageWithContentsOfFile:localFile];
    } else {
        return [Timeline image:timeline];
    }
}

+ (UIImage*)imageThumbnailOrTempImage:(Timeline*)timeline
{
    UIImage *image = [Timeline imageThumbnail:timeline];
    return (image) ? image : [Timeline tempImage];
}

@end

