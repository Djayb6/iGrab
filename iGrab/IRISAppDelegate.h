//
//  IRISAppDelegate.h
//  iGrab
//
//  Created by Jean-Baptiste Peraldi on 10/22/11.
//  Copyright (c) 2011 djayb6. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IRISAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(NSMutableArray *)scanDirectories:(NSArray *)arrayOfPaths;


@end
