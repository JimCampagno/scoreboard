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
                            andUser:(SBUser *)user
                 andCompletionBlock:(void (^)(BOOL))block {
    
    [ref runTransactionBlock:^FTransactionResult *(FMutableData *currentData) {
    
        NSArray *newRoom = @[ @{ @"name": user.name,
                                 @"monster": user.monster,
                                 @"hp": user.hp,
                                 @"vp": user.vp } ];
        
        [[currentData childDataByAppendingPath:[SBConstants randomRoomNumber]] setValue:newRoom];
        
        return [FTransactionResult successWithValue:currentData];
    }];
    
    
    
    [FirebaseAPIclient createGameOnFirebaseWithRef:nil
                                           andUser:nil
                                andCompletionBlock:^(BOOL success) {
                                    
                                    
                                    if (success)
                                
                                    //code here
                                }];
}


@end
