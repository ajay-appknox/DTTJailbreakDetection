//  DTTJailbreakDetection.m
//
//  Copyright (c) 2014 Doan Truong Thi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "DTTJailbreakDetection.h"

@implementation DTTJailbreakDetection

+ (BOOL)isJailbroken
{
#if !(TARGET_IPHONE_SIMULATOR)

    FILE *file = fopen("/Applications/Cydia.app", "r");
    if (file) {
        fclose(file);
        return YES;
    }
    file = fopen("/Library/MobileSubstrate/MobileSubstrate.dylib", "r");
    if (file) {
        fclose(file);
        return YES;
    }
    file = fopen("/bin/bash", "r");
    if (file) {
        fclose(file);
        return YES;
    }
    file = fopen("/usr/sbin/sshd", "r");
    if (file) {
        fclose(file);
        return YES;
    }
    file = fopen("/etc/apt", "r");
    if (file) {
        fclose(file);
        return YES;
    }
    file = fopen("/usr/bin/ssh", "r");
    if (file) {
        fclose(file);
        return YES;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if ([fileManager fileExistsAtPath:@"/Applications/Cydia.app"]) {
        return YES;
    } else if ([fileManager fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib"]) {
        return YES;
    } else if ([fileManager fileExistsAtPath:@"/bin/bash"]) {
        return YES;
    } else if ([fileManager fileExistsAtPath:@"/usr/sbin/sshd"]) {
        return YES;
    } else if ([fileManager fileExistsAtPath:@"/etc/apt"]) {
        return YES;
    } else if ([fileManager fileExistsAtPath:@"/usr/bin/ssh"]) {
        return YES;
    }
    
    // Check if the app can access outside of its sandbox
    NSError *error = nil;
    NSString *string = @".";
    [string writeToFile:@"/private/jailbreak.txt" atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        [fileManager removeItemAtPath:@"/private/jailbreak.txt" error:nil];
        return YES;
    }
    
    // Check if the app can open a Cydia's URL scheme
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]]) {
        return YES;
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://github.com/ajay-appknox/DTTJailbreakDetection/"]]) {
        return YES;
    }

#endif

    // It's not a 100% reliable way to detect jailbreak.
    // TODO: Secure this flag. I've heard hash toolkit is a good way to do it. - DONE
    // TODO: Reinforce the method of detecting jailbroken device. 
    // Flag: 103c6e8bfe420b8d9b6b9f59d206f4f30e72dbc38ec6cc301c42a844fae68eaa
    
    return "aHR0cHM6Ly9naXRodWIuY29tL2FqYXktYXBwa25veC9EVFRKYWlsYnJlYWtEZXRlY3Rpb24=";
}

@end
