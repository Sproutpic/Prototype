//
//  FTPUploadManager.m
//  Sprout
//
//  Created by LLDM 0038 on 16/08/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "FTPUploadManager.h"

enum {
    kSendBufferSize = 2048
};

@implementation FTPUploadManager {
    uint8_t _buffer[kSendBufferSize];
}

#pragma mark * Status management

// These methods are used by the core transfer code to update the UI.

- (void)sendDidStart
{
//    self.statusLabel.text = @"Sending";
//    self.cancelButton.enabled = YES;
//    [self.activityIndicator startAnimating];
    NSLog(@"Sending");
    [[NetworkManager sharedInstance] didStartNetworkOperation];
}

- (void)updateStatus:(NSString *)statusString
{
    assert(statusString != nil);
//    self.statusLabel.text = statusString;
    NSLog(@"FTP Upload: %@", statusString);
}

- (void)sendDidStopWithStatus:(NSString *)statusString
{
    if (statusString == nil) {
        statusString = @"Put succeeded";
    }
//    self.statusLabel.text = statusString;
//    self.cancelButton.enabled = NO;
//    [self.activityIndicator stopAnimating];
    
    NSLog(@"%@", statusString);
    [[NetworkManager sharedInstance] didStopNetworkOperation];
}

#pragma mark * Core transfer code

// This is the code that actually does the networking.

// Because buffer is declared as an array, you have to use a custom getter.
// A synthesised getter doesn't compile.

- (uint8_t *)buffer
{
    return self->_buffer;
}

- (BOOL)isSending
{
    return (networkStream != nil);
}

- (void)startSend:(NSString *)filePath andDirectory:(NSString *)dirStr{
    BOOL  success;
    NSURL *url;
    NSString *userName = [NSString stringWithFormat:@"info"];
    NSString *password = [NSString stringWithFormat:@"a2Di;m&rf9{^F:X"];
    
    filePath = [self convertPathName:filePath];
    NSLog(@"FTP Upload: %@",filePath);
    
    NSLog(@"REMOTE DIR: %@",dirStr);
    
    assert(filePath != nil);
    assert([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    assert( [filePath.pathExtension isEqual:@"png"] || [filePath.pathExtension isEqual:@"jpg"] );
    
    assert(networkStream == nil);      // don't tap send twice in a row!
    assert(fileStream == nil);         // ditto
    
    // First get and check the URL.
    
    url = [[NetworkManager sharedInstance] smartURLForString:dirStr];
    success = (url != nil);
    
    if (success) {
        // Add the last part of the file name to the end of the URL to form the final
        // URL that we're going to put to.
        
        url = CFBridgingRelease( CFURLCreateCopyAppendingPathComponent(NULL, (__bridge CFURLRef) url, (__bridge CFStringRef) [filePath lastPathComponent], false) );
        success = (url != nil);
    }
    
    // If the URL is bogus, let the user know.  Otherwise kick off the connection.
    
    if ( ! success) {
//        self.statusLabel.text = @"Invalid URL";
        NSLog(@"INVALID URL");
    } else {
        
        // Open a stream for the file we're going to send.  We do not open this stream;
        // NSURLConnection will do it for us.
        
        fileStream = [NSInputStream inputStreamWithFileAtPath:filePath];
        
        assert(fileStream != nil);
        
        [fileStream open];
        NSLog(@"file has bytes available %@", [fileStream hasBytesAvailable]?@"YES":@"NO");
        
        // Open a CFFTPStream for the URL.
        
        networkStream = CFBridgingRelease( CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url) );
        assert(networkStream != nil);
        
        if ([userName length] != 0) {
            success = [networkStream setProperty:userName forKey:(id)kCFStreamPropertyFTPUserName];
            assert(success);
            success = [networkStream setProperty:password forKey:(id)kCFStreamPropertyFTPPassword];
            assert(success);
            
            NSLog(@"Yep!");
        }
        
        networkStream.delegate = self;
        [networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [networkStream open];
        
        
        // Tell the UI we're sending.
        [self sendDidStart];
    }
}

- (void)stopSendWithStatus:(NSString *)statusString{
    if (networkStream != nil) {
        [networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        networkStream.delegate = nil;
        [networkStream close];
        networkStream = nil;
    }
    if (fileStream != nil) {
        [fileStream close];
        fileStream = nil;
    }
    [self sendDidStopWithStatus:statusString];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
// An NSStream delegate callback that's called when events happen on our
// network stream.
{
    NSLog(@"SA STREAM.....gwapo ko ");
#pragma unused(aStream)
    assert(aStream == networkStream);
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            NSLog(@"Opened stream");
            [self updateStatus:@"Opened connection"];
        } break;
        case NSStreamEventHasBytesAvailable: {
            NSLog(@"Stream has bytes available");
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventHasSpaceAvailable: {
            [self updateStatus:@"Sendinggg"];
            
//            // If we don't have any data buffered, go read the next chunk of data.
//            
//            if (bufferOffset == bufferLimit) {
//                NSLog(@"Upload check 1");
//                NSInteger   bytesRead;
//                
//                bytesRead = [fileStream read:buffer maxLength:kSendBufferSize];
//                NSLog(@"Upload check 2");
//                if (bytesRead == -1) {
//                    NSLog(@"Upload check 3");
//                    [self stopSendWithStatus:@"File read error"];
//                } else if (bytesRead == 0) {
//                    NSLog(@"Upload check 4");
//                    [self stopSendWithStatus:nil];
//                } else {
//                    NSLog(@"Upload check 5");
//                    bufferOffset = 0;
//                    bufferLimit  = bytesRead;
//                }
//            }
//            
//            // If we're not out of data completely, send the next chunk.
//            
//            NSLog(@"Upload check 6");
//            if (bufferOffset != bufferLimit) {
//                NSLog(@"Upload check 7");
//                
//                NSInteger   bytesWritten;
//                bytesWritten = [networkStream write:&buffer[bufferOffset] maxLength:bufferLimit - bufferOffset];
//                NSLog(@"Upload check 8");
//                assert(bytesWritten != 0);
//                if (bytesWritten == -1) {
//                    NSLog(@"Upload check 9");
//                    [self stopSendWithStatus:@"Network write error"];
//                } else {
//                    NSLog(@"Upload check 10");
//                    bufferOffset += bytesWritten;
//                }
//            }
            
            NSLog(@"Upload check 11");
        } break;
        case NSStreamEventErrorOccurred: {
            [self stopSendWithStatus:@"Stream open error"];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}

#pragma mark * Actions

//- (IBAction)sendAction:(UIView *)sender
//{
//    assert( [sender isKindOfClass:[UIView class]] );
//    
//    if ( ! self.isSending ) {
//        NSString *  filePath;
//        
//        // User the tag on the UIButton to determine which image to send.
//        
//        assert(sender.tag >= 0);
//        filePath = [[NetworkManager sharedInstance] pathForTestImage:(NSUInteger) sender.tag];
//        assert(filePath != nil);
//        
//        [self startSend:filePath];
//    }
//}


- (NSString*)convertPathName:(NSString*) orgPath
{
//    assert( [sender isKindOfClass:[UIView class]] );

//    if ( ! self.isSending ) {
        NSString *  filePath;

        // User the tag on the UIButton to determine which image to send.

//        assert(sender.tag >= 0);
        filePath = [[NetworkManager sharedInstance] pathForTestImage:orgPath];
        assert(filePath != nil);

//        [self startSend:filePath];
//    }
    
    return filePath;
}



//
//- (IBAction)cancelAction:(id)sender
//{
//#pragma unused(sender)
//    [self stopSendWithStatus:@"Cancelled"];
//}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//// A delegate method called by the URL text field when the editing is complete.
//// We save the current value of the field in our settings.
//{
//    NSString *  defaultsKey;
//    NSString *  newValue;
//    NSString *  oldValue;
//    
//    if (textField == self.urlText) {
//        defaultsKey = @"PutURLText";
//    } else if (textField == self.usernameText) {
//        defaultsKey = @"Username";
//    } else if (textField == self.passwordText) {
//        defaultsKey = @"Password";
//    } else {
//        assert(NO);
//        defaultsKey = nil;          // quieten warning
//    }
//    
//    newValue = textField.text;
//    oldValue = [[NSUserDefaults standardUserDefaults] stringForKey:defaultsKey];
//    
//    // Save the URL text if it's changed.
//    
//    assert(newValue != nil);        // what is UITextField thinking!?!
//    assert(oldValue != nil);        // because we registered a default
//    
//    if ( ! [newValue isEqual:oldValue] ) {
//        [[NSUserDefaults standardUserDefaults] setObject:newValue forKey:defaultsKey];
//    }
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//// A delegate method called by the URL text field when the user taps the Return
//// key.  We just dismiss the keyboard.
//{
//#pragma unused(textField)
//    assert( (textField == self.urlText) || (textField == self.usernameText) || (textField == self.passwordText) );
//    [textField resignFirstResponder];
//    return NO;
//}
//
//#pragma mark * View controller boilerplate
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    assert(self.urlText != nil);
//    assert(self.usernameText != nil);
//    assert(self.passwordText != nil);
//    assert(self.statusLabel != nil);
//    assert(self.activityIndicator != nil);
//    assert(self.cancelButton != nil);
//    
//    self.urlText.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"PutURLText"];
//    // The setup of usernameText and passwordText deferred to -viewWillAppear:
//    // because those values are shared by multiple tabs.
//    
//    self.activityIndicator.hidden = YES;
//    self.statusLabel.text = @"Tap a picture to start the put";
//    self.cancelButton.enabled = NO;
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.usernameText.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"Username"];
//    self.passwordText.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"Password"];
//}
//
//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    
//    self.urlText = nil;
//    self.usernameText = nil;
//    self.passwordText = nil;
//    self.statusLabel = nil;
//    self.activityIndicator = nil;
//    self.cancelButton = nil;
//}
//
//- (void)dealloc
//{
//    [self stopSendWithStatus:@"Stopped"];
//}

@end
