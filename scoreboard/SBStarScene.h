//
//  SBStarScene.h
//  scoreboard
//
//  Created by James Campagno on 9/13/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface SBStarScene : SKScene
@property (nonatomic, strong) SKEmitterNode *star;


- (void)pauseStars;
- (void)runStars;
@end
