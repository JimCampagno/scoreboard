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
#import "SBRoom.h"

@interface FirebaseAPIclient : NSObject

+ (void)createGameOnFirebaseWithRef:(Firebase *)ref
                               user:(SBUser *)user
                withCompletionBlock:(void (^)(BOOL success, NSString *digits))block
                   withFailureBlock:(void (^)(NSError *error))failureBlock;


@end