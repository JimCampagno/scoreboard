//
//  Scorecard.m
//  scoreboard
//
//  Created by Jim Campagno on 6/14/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "Scorecard.h"

@implementation Scorecard

#pragma mark - Initializing the Scorecard object

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
        [self setupPickerViewsDelegateAndDataSource];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self setupPickerViewsDelegateAndDataSource];
        

    }
    return self;
}

- (void)commonInit {
        
    _customSBConstraints = [[NSMutableArray alloc] init];
    
    [self setupHealthAndVictoryPoints];
    
    [[NSBundle mainBundle] loadNibNamed:@"Scorecard"
                                  owner:self
                                options:nil];

    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.view];
    [self setNeedsUpdateConstraints];
    

    
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

#pragma mark - Setting up the object with names and image

- (void)setupScorecardWithMonsterName:(NSString *)monsterName
                           playerName:(NSString *)playerName
                         monsterImage:(UIImage *)image {
    
    _monsterName.text = monsterName;
    _playerName.text = playerName;
    _monsterImage.image = image;
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

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    
    if ([pickerView isEqual:_topPicker]) {
        
        return [NSString stringWithFormat:@"%@", [self.victoryPoints[row] stringValue]];
    } else {
        
        return [NSString stringWithFormat:@"%@", [self.health[row] stringValue]];

    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {

    return 40;
}




@end
