//
//  AppDelegate.m
//  scoreboard
//
//  Created by Jim Campagno on 5/24/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "SBSetupViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    _initalStoryboard = self.window.rootViewController.storyboard;
    
    self.initalStoryboard = sb;
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    

    NSLog(@"");
    NSLog(@"applicationWillResignActive has been called");
    NSLog(@"");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"");
    NSLog(@"applicationDidEnterBackground has been called");
    NSLog(@"");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"");
    NSLog(@"applicationWillEnterForeground has been called");
    NSLog(@"");

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"sklf jsadlkfj asldkfj");
    NSLog(@"We're ACTIVE!!");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)resetWindowToInitialView {
    
    NSLog(@"%ld", self.window.subviews.count);
    NSLog(@"\n\n\n RESET HAPPENED!!!");
    for (UIView* view in self.window.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSLog(@"%ld", self.window.subviews.count);

    
    SBSetupViewController* initialScene = [self.initalStoryboard instantiateInitialViewController];
    self.window.rootViewController = initialScene;
}

//- (void)resetApp {
//    NSLog(@"resetApp has been called!");
//    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    SBSetupViewController *vc = [sb instantiateInitialViewController];
//    
////    UIWindow *window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
////    [UIView transitionFromView:window.rootViewController.view
////                        toView:vc.view
////                      duration:0.65f
////                       options:UIViewAnimationOptionTransitionCrossDissolve // transition animation
////                    completion:^(BOOL finished){
////                        window.rootViewController = vc;
////                    }];
//    
//    
//    
//    for (id view in self.window.subviews) {
//        if ([view respondsToSelector:@selector(removeFromSuperview)]) {
//            [view removeFromSuperview];
//        }
//    }
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = vc;
//    [self.window makeKeyAndVisible];
//}

@end
