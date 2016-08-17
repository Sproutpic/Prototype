//
//  FTPCreateManager.h
//  Sprout
//
//  Created by LLDM 0038 on 16/08/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import <CFNetwork/CFNetwork.h>

@protocol CreateFTPDirectoryDelegate;
@interface FTPCreateManager : NSObject <NSStreamDelegate>{
    NSOutputStream *networkStream;
}

- (void)startCreate:(NSString *)urlString andDirName:(NSString *)dirName;
@property (nonatomic, strong) id<CreateFTPDirectoryDelegate> createDelegate;

@end

@protocol CreateFTPDirectoryDelegate <NSObject>

- (void)didCreateSuccess;
- (void)didCreateFailed;

@end
