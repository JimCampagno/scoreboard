//
//  SBStarScene.m
//  scoreboard
//
//  Created by James Campagno on 9/13/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "SBStarScene.h"

@interface SBStarScene ()

@property (nonatomic, strong) SKEmitterNode *star;

@end


static NSString* const kStarParticle = @"StarParticle";
static CGFloat const kStarParticleBirthRate = 15.0;


@implementation SBStarScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [UIColor clearColor];
        NSString *emitterPath = [[NSBundle mainBundle] pathForResource:kStarParticle ofType:@"sks"];
        self.star = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
        self.star.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height/2);
        self.star.name = @"particleHeart";
        self.star.targetNode = self.scene;
        [self addChild:self.star];
    }
    return self;
}

- (void)pauseStars {
    [self.star setParticleBirthRate:0.0f];
}

- (void)runStars {
    [self.star setParticleBirthRate:kStarParticleBirthRate];
}

@end
