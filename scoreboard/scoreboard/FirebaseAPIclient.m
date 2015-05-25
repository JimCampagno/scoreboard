//
//  FirebaseAPIclient.m
//  scoreboard
//
//  Created by Jim Campagno on 5/25/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "FirebaseAPIclient.h"

@implementation FirebaseAPIclient

+ (void)instantiateBaseFirebaseURLWithFirebaseObject:(Firebase *)firebaseRef {
    
    firebaseRef = [[Firebase alloc] initWithUrl: FIREBASE_URL];
}



@end
