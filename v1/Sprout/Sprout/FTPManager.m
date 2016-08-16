//
//  FTPManager.m
//  Sprout
//
//  Created by LLDM 0038 on 16/08/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "FTPManager.h"

@implementation FTPManager
- (void)listDirectories{
    option = @"list";
    _listDir = [[WRRequestListDirectory alloc] init];
    
    _listDir.path = @"";
    
    [self setListCreds];
    
    [_listDir start];
}
- (void)createDirectory:(NSString *)path{
    option = @"create";
    _createDir = [[WRRequestCreateDirectory alloc] init];
    
    _createDir.path = [NSString stringWithFormat:@"/Sprouts/crowElmo/"];
    NSLog(@"path:%@",_createDir.path);
    [self setCreateCreds];
    
    //we start the request
    [_createDir start];
    
}
- (void)setListCreds{
    _listDir.hostname = @"104.197.93.149";
    _listDir.username = @"info";
    _listDir.password = @"a2Di;m&rf9{^F:X";
}
- (void)setCreateCreds{
    _createDir.hostname = @"104.197.93.149";
    _createDir.username = @"info";
    _createDir.password = @"a2Di;m&rf9{^F:X";
    _createDir.passive = NO;
}
-(void) requestCompleted:(WRRequest *) request{
    if ([option isEqualToString:@"list"]) {
        //called after 'request' is completed successfully
        NSLog(@"%@ completed!", request);
        
        //we cast the request to list request
        WRRequestListDirectory * listDir = (WRRequestListDirectory *)request;
        
        //we print each of the files name
        for (NSDictionary * file in listDir.filesInfo) {
            NSLog(@"%@", [file objectForKey:(id)kCFFTPResourceName]);
        }
    } else if ([option isEqualToString:@"create"]){
        NSLog(@"%@ completed!", request);
    }
}

-(void) requestFailed:(WRRequest *) request{
    NSLog(@"Error: %@", request.error.message);
}
@end
