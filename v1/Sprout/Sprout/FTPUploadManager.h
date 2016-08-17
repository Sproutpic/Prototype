//
//  FTPUploadManager.h
//  Sprout
//
//  Created by LLDM 0038 on 16/08/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import <CFNetwork/CFNetwork.h>

@interface FTPUploadManager : NSObject <NSStreamDelegate>{
    NSOutputStream *networkStream;
    NSInputStream *fileStream;
    uint8_t *buffer;
    size_t bufferOffset;
    size_t bufferLimit;

}
- (void)startSend:(NSString *)filePath andDirectory:(NSString *)dirStr;
@end
