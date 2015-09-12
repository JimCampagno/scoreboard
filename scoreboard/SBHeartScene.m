//
//  SBHeartScene.m
//  scoreboard
//
//  Created by James Campagno on 9/12/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "SBHeartScene.h"

static NSString* const kHeartParticle = @"HeartParticle";

@implementation SBHeartScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
       
        self.backgroundColor = [UIColor clearColor];
        NSString *emitterPath = [[NSBundle mainBundle] pathForResource:kHeartParticle ofType:@"sks"];
        SKEmitterNode *heart = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
        heart.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height/2);
        heart.name = @"particleHeart";
        heart.targetNode = self.scene;
        [self addChild:heart];
    }
    return self;
}

@end
