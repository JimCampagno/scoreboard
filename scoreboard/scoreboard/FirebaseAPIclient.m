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

+ (void)createRoomWithFirebaseReference:(Firebase *)ref {
    [[ref childByAppendingPath:FIREBASE_CHILD]
     runTransactionBlock:^FTransactionResult *(FMutableData *currentData) {
         
//         NSString *roomNumber = [@([SBConstants randomRoomNumber]) stringValue];
//         SBRoom *newRoom = [[SBRoom alloc] init];
//         
//         
//         NSDictionary *establishRoom = @{ @"test": newRoom };
//         [currentData setValue:establishRoom];
         
         
//         NSDictionary *storingCurrentData = currentData.value;
//         NSLog(@"Is this working %@", storingCurrentData);
//         
//         NSDictionary *jimbo = @{
//                                 @"name" : @"CUTE BOY",
//                                 @"coolness" : @"1000"
//                                 };
//         
//         NSDictionary *listOfMorons = @{ @"232323" : jimbo };
//         [currentData setValue:listOfMorons];
         
         return [FTransactionResult successWithValue:currentData];
     }];
}




@end
