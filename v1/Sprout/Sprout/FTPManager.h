//
//  FTPManager.h
//  Sprout
//
//  Created by LLDM 0038 on 16/08/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WhiteRaccoon.h"
#import <CFNetwork/CFNetwork.h>

@interface FTPManager : NSObject{
    NSString *option;
}
@property (strong,nonatomic)WRRequestListDirectory * listDir;
@property (strong,nonatomic)WRRequestCreateDirectory * createDir;
- (void)createDirectory:(NSString *)path;
- (void)listDirectories;
@end
