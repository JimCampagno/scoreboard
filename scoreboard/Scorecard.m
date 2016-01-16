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


@end


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
    self.firstTimeThrough = YES;
    self.unHidden = NO;
    _wasDisconnected = NO;
    [self setupHealthAndVictoryPoints];
    [[NSBundle mainBundle] loadNibNamed:@"Scorecard"
                                  owner:self
                                options:nil];
    
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.view];
    [self setNeedsUpdateConstraints];
    
}

- (void)createHeartAndStarViews {
    self.heartView = [SCNView new];
    self.heartView.scene = [SCNScene new];
    self.heartView.backgroundColor = [UIColor clearColor];
    [self.heartContainerView addSubview:self.heartView];
    
    [self.heartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.and.bottom.equalTo(self.heartContainerView);
    }];
    
    
    self.starView = [SCNView new];
    self.starView.scene = [SCNScene new];
    self.starView.backgroundColor = [UIColor clearColor];
    [self.starContainerView addSubview:self.starView];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.and.bottom.equalTo(self.starContainerView);
    }];
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
    
    NSLog(@"<<< update called for %@ >>> FirstTimeThrough: %@ WasDisconnected: %@", self.playerName.text,  @(self.firstTimeThrough), @(self.wasDisconnected));


    NSInteger currentHealthFromPickerView = [self.bottomPicker selectedRowInComponent:0];
    NSInteger currentVictoryFromPickerView = [self.topPicker selectedRowInComponent:0];
    
    [self.bottomPicker selectRow:[user.hp integerValue] inComponent:0 animated:YES];
    [self.topPicker selectRow:[user.vp integerValue] inComponent:0 animated:YES];
    
    
    
    if ((currentHealthFromPickerView != [user.hp integerValue]) && !self.firstTimeThrough && !self.wasDisconnected) {
        
        NSLog(@"Health Changed for %@, firstTimeThrough property is %@\n\n\n", self.playerName.text, @(self.firstTimeThrough));
        
        SCNParticleSystem *new = [SCNParticleSystem particleSystemNamed:@"Confetti" inDirectory:nil];
        [self.heartView.scene.rootNode addParticleSystem:new];
        
    }
    
    if ((currentVictoryFromPickerView != [user.vp integerValue]) && !self.firstTimeThrough && !self.wasDisconnected) {
        
        NSLog(@"Victory Points Changed for %@, firstTimeThrough property is %@\n\n\n", self.playerName.text, @(self.firstTimeThrough));

        
        SCNParticleSystem *new = [SCNParticleSystem particleSystemNamed:@"Starfetti" inDirectory:nil];
        [self.starView.scene.rootNode addParticleSystem:new];
        
    }
    
    if (!self.firstTimeThrough) {
        
        self.wasDisconnected = NO;
        NSLog(@"**just switched the wasDisconnectedSwitch for %@", self.playerName.text);
    }
    
    self.firstTimeThrough = NO;
    
    NSString *thing = self.firstTimeThrough ? @"YES" : @"NO";
    
    NSLog(@"*** FirstTimeThrough was just set to : %@ for user: %@", thing, self.playerName.text);
}

- (void)updateScorecardWithNoAnimationFromUser:(SBUser *)user {

    if (self.hidden == YES) {
        self.hidden = NO;
    }
    
    self.monsterImage.image = user.monsterImage;
    self.playerName.text = user.name;
    self.monsterName.text = user.monster;
        
    [self.bottomPicker selectRow:[user.hp integerValue] inComponent:0 animated:YES];
    [self.topPicker selectRow:[user.vp integerValue] inComponent:0 animated:YES];
    
    self.firstTimeThrough = NO;
}



@end
