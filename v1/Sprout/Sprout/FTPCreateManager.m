//
//  FTPCreateManager.m
//  Sprout
//
//  Created by LLDM 0038 on 16/08/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "FTPCreateManager.h"

@implementation FTPCreateManager

@synthesize createDelegate;

- (void)startCreate:(NSString *)urlString andDirName:(NSString *)dirName {
    NSLog(@"ENTER HERE");
    BOOL success;
    NSURL *url;
    NSString *userName = [NSString stringWithFormat:@"info"];
    NSString *password = [NSString stringWithFormat:@"a2Di;m&rf9{^F:X"];
    
    assert(networkStream == nil);      // don't tap create twice in a row!
    
    // First get and check the URL.
    
    url = [[NetworkManager sharedInstance] smartURLForString:urlString];
    success = (url != nil);
    
    if (success) {
        // Add the directory name to the end of the URL to form the final URL
        // that we're going to create.  CFURLCreateCopyAppendingPathComponent will
        // percent encode (as UTF-8) any wacking characters, which is the right thing
        // to do in the absence of application-specific knowledge about the encoding
        // expected by the server.
        
        url = CFBridgingRelease( CFURLCreateCopyAppendingPathComponent(NULL, (__bridge CFURLRef) url, (__bridge CFStringRef) dirName, true) );
        success = (url != nil);
    }
    
    // If the URL is bogus, let the user know.  Otherwise kick off the connection.
    
    if ( ! success) {
        NSLog(@"INVALID URL");
    } else {
        
        // Open a CFFTPStream for the URL.
        
        networkStream = CFBridgingRelease( CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url) );
        assert(networkStream != nil);
        
        if ([userName length] != 0) {
            success = [networkStream setProperty:userName forKey:(id)kCFStreamPropertyFTPUserName];
            assert(success);
            success = [networkStream setProperty:password forKey:(id)kCFStreamPropertyFTPPassword];
            assert(success);
        }
        
        networkStream.delegate = self;
        [networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [networkStream open];
        
        // Tell the UI we're creating.
        
        [self createDidStart];
    }
}

- (void)createDidStart{
    NSLog(@"CREATING");
    [[NetworkManager sharedInstance] didStartNetworkOperation];
}

- (void)updateStatus:(NSString *)statusString
{
    assert(statusString != nil);
    NSLog(@"CREATE FTP: %@", statusString);
}

- (void)createDidStopWithStatus:(NSString *)statusString
{
    if (statusString == nil) {
        statusString = @"Create succeeded";
    }
    
    NSLog(@"%@", statusString);
    [[NetworkManager sharedInstance] didStopNetworkOperation];
    
    [createDelegate didCreateSuccess];
}

- (void)stopCreateWithStatus:(NSString *)statusString
{
    if (networkStream != nil) {
        [networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        networkStream.delegate = nil;
        [networkStream close];
        NSLog(@"NETWORK STREAM CLOSED");
        networkStream = nil;
    }
    [self createDidStopWithStatus:statusString];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
// An NSStream delegate callback that's called when events happen on our
// network stream.
{
#pragma unused(aStream)
    assert(aStream == networkStream);
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            [self updateStatus:@"Opened connection"];
            // Despite what it says in the documentation <rdar://problem/7163693>,
            // you should wait for the NSStreamEventEndEncountered event to see
            // if the directory was created successfully.  If you shut the stream
            // down now, you miss any errors coming back from the server in response
            // to the MKD command.
            //
            // [self stopCreateWithStatus:nil];
        } break;
        case NSStreamEventHasBytesAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventHasSpaceAvailable: {
            assert(NO);
        } break;
        case NSStreamEventErrorOccurred: {
            CFStreamError   err;
            
            // -streamError does not return a useful error domain value, so we
            // get the old school CFStreamError and check it.
            
            err = CFWriteStreamGetError( (__bridge CFWriteStreamRef) networkStream );
            if (err.domain == kCFStreamErrorDomainFTP) {
                [self stopCreateWithStatus:[NSString stringWithFormat:@"FTP error %d", (int) err.error]];
            } else {
                [self stopCreateWithStatus:@"Stream open error"];
            }
        } break;
        case NSStreamEventEndEncountered: {
            [self stopCreateWithStatus:nil];
        } break;
        default: {
            assert(NO);
        } break;
    }
}

@end
