//
//  Scorecard.m
//  scoreboard
//
//  Created by Jim Campagno on 6/14/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "Scorecard.h"
#import <Masonry.h>
#import "SBHeartScene.h"
#import "SBStarScene.h"


@interface Scorecard ()


@property (nonatomic) BOOL firstTimeThrough;

@end


static const NSTimeInterval kLengthOfHeartScene = 0.7;
static const NSTimeInterval kLengthOfStarScene = 0.7;



@implementation Scorecard

#pragma mark - Initializing the Scorecard object

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
        [self setupPickerViewsDelegateAndDataSource];
        
        self.monsterName.numberOfLines = 1;
        self.monsterName.adjustsFontSizeToFitWidth = YES;
        self.monsterName.lineBreakMode = NSLineBreakByClipping;
        
        self.playerName.numberOfLines = 1;
        self.playerName.adjustsFontSizeToFitWidth = YES;
        self.playerName.lineBreakMode = NSLineBreakByClipping;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
        [self setupPickerViewsDelegateAndDataSource];
        
        self.monsterName.numberOfLines = 1;
        self.monsterName.adjustsFontSizeToFitWidth = YES;
        self.monsterName.lineBreakMode = NSLineBreakByClipping;
        
        self.playerName.numberOfLines = 1;
        self.playerName.adjustsFontSizeToFitWidth = YES;
        self.playerName.lineBreakMode = NSLineBreakByClipping;
    }
    return self;
}

- (void)commonInit {
    _customSBConstraints = [[NSMutableArray alloc] init];
    _firstTimeThrough = YES;
    [self setupHealthAndVictoryPoints];
    [[NSBundle mainBundle] loadNibNamed:@"Scorecard"
                                  owner:self
                                options:nil];
    
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.view];
    
    self.heartView = [SCNView new];
    self.heartView.scene = [SCNScene new];
    self.heartView.scene.physicsWorld.contactDelegate = self;
    self.heartView.backgroundColor = [UIColor clearColor];
    [self.heartContainerView addSubview:self.heartView];
    
    [self.heartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.and.bottom.equalTo(self.heartContainerView);
    }];
    
    
    self.starView = [SCNView new];
    self.starView.scene = [SCNScene new];
    self.starView.scene.physicsWorld.contactDelegate = self;
    self.starView.backgroundColor = [UIColor clearColor];
    [self.starContainerView addSubview:self.starView];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.and.bottom.equalTo(self.starContainerView);
    }];
    
    [self setNeedsUpdateConstraints];
    
    
//
//    self.starParticleView.allowsTransparency = YES;
//    self.starParticleView.backgroundColor = [UIColor clearColor];
//    self.starScene = [SBStarScene sceneWithSize:self.starParticleView.bounds.size];
//    self.starScene.scaleMode = SKSceneScaleModeAspectFill;
//    [self.starParticleView presentScene:self.starScene];
//    [self.starScene runStars];
//    [self.starScene pauseStars];
}

- (void)updateConstraints {
    UIView *view = self.view;
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    [self.customSBConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"H:|[view]|" options:0 metrics:nil views:views]];
    [self.customSBConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[view]|" options:0 metrics:nil views:views]];
    [self addConstraints:self.customSBConstraints];
    [super updateConstraints];
}

- (void)setupHealthAndVictoryPoints {
    NSMutableArray *hp = [[NSMutableArray alloc] init];
    NSMutableArray *vp = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0 ; i < 21 ; i++) {
        if (i > 12) {
            [vp addObject:@(i)];
        } else {
            [vp addObject:@(i)];
            [hp addObject:@(i)];
        }
    }
    _health = [hp copy];
    _victoryPoints = [vp copy];
}

- (void)setupPickerViewsDelegateAndDataSource {
    self.topPicker.delegate = self;
    self.bottomPicker.delegate = self;
    self.topPicker.dataSource = self;
    self.bottomPicker.dataSource = self;
}

#pragma mark - UIPickerview Delegate/Datasource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView isEqual:_topPicker]) {
        return [self.victoryPoints count];
    } else {
        return [self.health count];
    }
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView
             attributedTitleForRow:(NSInteger)row
                      forComponent:(NSInteger)component {
    if ([pickerView isEqual:_topPicker]) {
        NSString *vpString = [NSString stringWithFormat:@"%@", [self.victoryPoints[row] stringValue]];
        NSAttributedString *attVPString = [[NSAttributedString alloc] initWithString:vpString
                                                                          attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attVPString;
    } else {
        NSString *hpString = [NSString stringWithFormat:@"%@", [self.health[row] stringValue]];
        NSAttributedString *attHPString = [[NSAttributedString alloc] initWithString:hpString
                                                                          attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attHPString;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (void)updateScorecardWithInfoFromUser:(SBUser *)user {
    if (self.hidden == YES) {
        self.hidden = NO;
    }
    
    self.monsterImage.image = user.monsterImage;
    self.playerName.text = user.name;
    self.monsterName.text = user.monster;

    NSInteger currentHealthFromPickerView = [self.bottomPicker selectedRowInComponent:0];
    NSInteger currentVictoryFromPickerView = [self.topPicker selectedRowInComponent:0];
    
    [self.bottomPicker selectRow:[user.hp integerValue] inComponent:0 animated:YES];
    [self.topPicker selectRow:[user.vp integerValue] inComponent:0 animated:YES];
    
    
    if ((currentHealthFromPickerView != [user.hp integerValue]) && !self.firstTimeThrough) {
        
    
        
        SCNParticleSystem *new = [SCNParticleSystem particleSystemNamed:@"Confetti" inDirectory:nil];
        
        [self.heartView.scene.rootNode addParticleSystem:new];
        
    }
    
    if ((currentVictoryFromPickerView != [user.vp integerValue]) && !self.firstTimeThrough) {
        
        SCNParticleSystem *new = [SCNParticleSystem particleSystemNamed:@"Starfetti" inDirectory:nil];
        
        [self.starView.scene.rootNode addParticleSystem:new];
        
    }
    self.firstTimeThrough = NO;
}

- (void)pauseHeartTimer {
//    [self.heartScene pauseHearts];
}

- (void)pauseStarTimer {
//    [self.starScene pauseStars];
}

-(void)physicsWorld:(SCNPhysicsWorld *)world didUpdateContact:(SCNPhysicsContact *)contact {
    
    NSLog(@"didUpdateContact got called.");
    
//    SCNParticleSystem *particleSystem = [SCNParticleSystem particleSystemNamed:@"HeartParticle" inDirectory:nil];
//    SCNNode *systemNode = [SCNNode new];
//    
//    [systemNode addParticleSystem:particleSystem];
//    systemNode.position = SCNVector3Make(0.0, 0.0, 0.0);
//    //sceneView.scene.rootNode.addChildNode(systemNode)
    
    
    
    
//    NSString *emitterPath = [[NSBundle mainBundle] pathForResource:kHeartParticle ofType:@"sks"];
//    
//    self.heart = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
//    self.heart.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height/2);
//    self.heart.name = @"particleHeart";
//    self.heart.targetNode = self.scene;
//    [self addChild:self.heart];
    
    
    
    
}

//func physicsWorld(world: SCNPhysicsWorld, didUpdateContact contact: SCNPhysicsContact) {
//    if (contact.nodeA == sphere1 || contact.nodeA == sphere2) && (contact.nodeB == sphere1 || contact.nodeB == sphere2) {
//        let particleSystem = SCNParticleSystem(named: "Explosion", inDirectory: nil)
//        let systemNode = SCNNode()
//        systemNode.addParticleSystem(particleSystem)
//        systemNode.position = contact.nodeA.position
//        sceneView.scene?.rootNode.addChildNode(systemNode)
//        
//        contact.nodeA.removeFromParentNode()
//        contact.nodeB.removeFromParentNode()
//    }
//}


- (void)installTheHeartScene {
    
    
    
//    NSLog(@"installTheHeartScene has been called!");
//    
//    SKView *heartParticleView = [[SKView alloc] init];
//    
//    [self.heartContainerView addSubview:heartParticleView];
//    
//    [heartParticleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.and.bottom.and.right.and.left.equalTo(self.heartContainerView);
//        
//    }];
//    
//    
//    
//    heartParticleView.allowsTransparency = YES;
//    heartParticleView.ignoresSiblingOrder = NO;
//    heartParticleView.backgroundColor = [UIColor clearColor];
//    self.heartScene = [SBHeartScene sceneWithSize:self.heartContainerView.bounds.size];
//    self.heartScene.scaleMode = SKSceneScaleModeAspectFill;
//    [heartParticleView presentScene:self.heartScene];
//    
//    [self.heartScene runHearts];
//    [self.heartScene pauseHearts];
}

@end
