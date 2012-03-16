//
//  IRISAppDelegate.m
//  iGrab
//
//  Created by Jean-Baptiste Peraldi on 10/22/11.
//  Copyright (c) 2011 djayb6. All rights reserved.
//
//  Copy files (some are Siri-related and others are useless) in ~/Documents folder of iGrab.
//
//  Do not try to copy the whole filesystem, you could make your iDevice angry.

#import "IRISAppDelegate.h"

#define DIRECTORY_TO_LIST @"/private/var"

#define DRIVER @"/System/Library/Extensions/"

#define PATH1 @"/System/Library/PrivateFrameworks/AssistantServices.framework/"

#define PATH2 @"/System/Library/PrivateFrameworks/AssistantUI.framework/"

#define PATH3 @"/System/Library/Assistant/"

#define PATH4 @"/System/Library/CoreServices/SpringBoard.app/"

#define PATH5 @"/System/Library/UserEventPlugins/AssistantUEA.plugin/"

#define PATH6 @"/System/Library/PreferenceBundles/Assistant.bundle/"

#define PATH7 @"/Applications/Preferences.app/"

#define PATH8 @"/System/Library/CoreServices/VoiceOverTouch.app/"

#define PATH9 @"/System/Library/LaunchDaemons/"

#define PATH10 @"/System/Library/LinguisticData/"

#define PATH11 @"/System/Library/LocationBundles/"

#define DOCUMENTS [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define FM [NSFileManager defaultManager]

#define LIST_DIRECTORY

#define COPY_FILES

#define I_WANT_THE_DYLD
    

    
@implementation IRISAppDelegate
    
@synthesize window = _window;
    
- (void)dealloc
    {
        [_window release];
        [super dealloc];
    }
    
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
    
        
        self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
        // Override point for customization after application launch.
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
#ifdef LIST_DIRECTORY
        
        NSDirectoryEnumerator *directoryEnum = [FM enumeratorAtPath:DIRECTORY_TO_LIST];
        NSString *logPath = [DOCUMENTS stringByAppendingPathComponent:@"Directory_Content.log"];
        
        freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
        
        NSLog(@"Created by Djayb6 - 2011\n\n\n");
        NSString *file;
        for (file in directoryEnum) 
            {
            NSLog(@"%@\n\n",file);
            }
        
        UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:@"Hit Home Button to Exit" message:@"Files listed !" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [anAlert show];
        [anAlert release];
#endif
        
        
#ifdef COPY_FILES
        
        
        NSArray *arrayOfDirectories = [NSArray arrayWithObjects:DRIVER, PATH1, PATH2, PATH3, PATH4, PATH5, PATH6, PATH7, PATH8, PATH9, PATH10, PATH11, nil];
        NSMutableArray *arrayOfFiles = [self scanDirectories:arrayOfDirectories];
        NSEnumerator *filesEnum = [arrayOfFiles objectEnumerator];
        
        NSString *thePath;
        
        for (thePath in filesEnum) 
            {   
                NSError *error1=nil;
                
                NSString *destFile = [thePath stringByReplacingOccurrencesOfString:@"/" withString:@"#<"];
                NSString *destPath = [DOCUMENTS stringByAppendingPathComponent:destFile];
                [FM copyItemAtPath:thePath toPath:destPath error:&error1];
                
                if (error1) 
                    {
                    NSLog(@"%@", error1);
                    }
            
            }
        
        NSError *error2=nil;
        
        #ifdef I_WANT_THE_DYLD
        
        [FM copyItemAtPath:@"/System/Library/Caches/com.apple.dyld/dyld_shared_cache_armv7" toPath:[DOCUMENTS stringByAppendingPathComponent:@"dyld_shared_cache_armv7"] error:&error2];
        
        #endif
        
        self.window.backgroundColor = [UIColor whiteColor];
        
        if (error2) {
            NSLog(@"%@", error2);
            self.window.backgroundColor = [UIColor redColor];
            
            UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"ERROR: Please remove the app from the SpringBoard and run it again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [anAlert show];
            [anAlert release];
                    }
        
        else {
        

        UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:@"Hit Home Button to Exit" message:@"Done with the files. Download them through XCode and use SiriHelper to sort them." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [anAlert show];
        [anAlert release];
            }
#endif
            return YES;
    }
    
    
- (NSMutableArray *)scanDirectories:(NSArray *)arrayOfDirectories
    {
        
        NSMutableArray *arrayOfFiles= [[NSMutableArray alloc] init];
        NSEnumerator *directoriesEnum = [arrayOfDirectories objectEnumerator];
        NSString *directoryToScan;
        
        for (directoryToScan in directoriesEnum) 
            {
        
    
                NSURL *URLOfDirectoryToScan = [NSURL fileURLWithPath:directoryToScan];
                NSDirectoryEnumerator *filesEnum = [FM enumeratorAtURL:URLOfDirectoryToScan
                                                          includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLNameKey,NSURLIsDirectoryKey,nil] options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                        errorHandler:nil];
                for (NSURL *theURL in filesEnum) 
                    {
                        NSNumber *isDirectory;
                        [theURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
                
                        if (![isDirectory boolValue])
                            {
                                NSString *filePath= [theURL path];
                                [arrayOfFiles addObject:filePath];
                            }
                    }
    }
        
    return [arrayOfFiles autorelease];
    
 
}  
   

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
