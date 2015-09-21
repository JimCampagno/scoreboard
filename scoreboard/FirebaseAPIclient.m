//
//  FirebaseAPIclient.m
//  scoreboard
//
//  Created by Jim Campagno on 5/25/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "FirebaseAPIclient.h"
#import "SBRoom.h"

@implementation FirebaseAPIclient

+ (void)createGameOnFirebaseWithRef:(Firebase *)ref
                               user:(SBUser *)user
                withCompletionBlock:(void (^)(BOOL success, NSString *digits))block
                   withFailureBlock:(void (^)(NSError *error))failureBlock {
    
    NSString *randomNumber = [SBConstants randomRoomNumber];
    
    
    [ref runTransactionBlock:^FTransactionResult *(FMutableData *currentData) {
        
        NSArray *newRoom = @[ @{ @"name": user.name,
                                 @"monster": user.monster,
                                 @"hp": user.hp,
                                 @"vp": user.vp } ];
        
        
        [[currentData childDataByAppendingPath:randomNumber] setValue:newRoom];
        
        return [FTransactionResult successWithValue:currentData];
        
    } andCompletionBlock:^(NSError *error, BOOL committed, FDataSnapshot *snapshot) {
        
        
        if (committed) {
            
            block(YES, randomNumber);
            
        } else {
            
            failureBlock(error);
        }
    }];
}

@end
