//
//  SBSetupViewController.h
//  scoreboard
//
//  Created by Jim Campagno on 5/24/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface SBSetupViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) Firebase *firebaseRef;

- (void)turnFireBaseOnline;

@end
