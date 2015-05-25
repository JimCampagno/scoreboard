//
//  FirebaseAPIclient.h
//  scoreboard
//
//  Created by Jim Campagno on 5/25/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
#import "SBConstants.h"

@interface FirebaseAPIclient : NSObject

+ (void)instantiateBaseFirebaseURLWithFirebaseObject:(Firebase *)firebaseRef;

@end
