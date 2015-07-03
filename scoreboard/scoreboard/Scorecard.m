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
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
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
        if (i > 10) {
            [vp addObject:@(i)];
        } else {
            [vp addObject:@(i)];
            [hp addObject:@(i)];
        }
    }
    
    _health = [hp copy];
    _victoryPoints = [vp copy];

    
    
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

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    
    
    return 1;
    
    
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    
    if ([pickerView isEqual:_topPicker]) {
        
        
    }
    
    
    
    return 10;
}

//- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//
//    [[pickerView.subviews objectAtIndex:1] setBackgroundColor:[UIColor blueColor]];
//    [[pickerView.subviews objectAtIndex:2] setBackgroundColor:[UIColor blueColor]];
//
//    return self.pickerData[row];
//}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    NSString *title = self.pickerData[row];
//    NSAttributedString *attTitle = [[NSAttributedString alloc] initWithString:title
//                                                                   attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
//
//    [[pickerView.subviews objectAtIndex:1] setBackgroundColor:[UIColor redColor]];
//    [[pickerView.subviews objectAtIndex:2] setBackgroundColor:[UIColor redColor]];
//
//    return attTitle;
//
//}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//
//    [[pickerView.subviews objectAtIndex:1] setBackgroundColor:[UIColor blueColor]];
//    [[pickerView.subviews objectAtIndex:2] setBackgroundColor:[UIColor blueColor]];
//
//
//}



@end
