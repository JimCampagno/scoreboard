//
//  SBHeartScene.m
//  scoreboard
//
//  Created by James Campagno on 9/12/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "SBHeartScene.h"

@interface SBHeartScene ()


@end


static NSString* const kHeartParticle = @"HeartParticle";
static const CGFloat kHeartParticleBirthRate = 15.0;


@implementation SBHeartScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [UIColor clearColor];
        NSString *emitterPath = [[NSBundle mainBundle] pathForResource:kHeartParticle ofType:@"sks"];
        
        [self.heart setZPosition:0];

        self.heart = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
        self.heart.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height/2);
        self.heart.name = @"particleHeart";
        self.heart.targetNode = self.scene;
        [self addChild:self.heart];
    }
    return self;
}

- (void)pauseHearts {
    [self.heart setParticleBirthRate:0.0f];
}

- (void)runHearts {
    [self.heart setParticleBirthRate:kHeartParticleBirthRate];
}

@end
