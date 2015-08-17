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

//- (NSString *)pickerView:(UIPickerView *)pickerView
//             titleForRow:(NSInteger)row
//            forComponent:(NSInteger)component {
//    
//    if ([pickerView isEqual:_topPicker]) {
//        
//        return [NSString stringWithFormat:@"%@", [self.victoryPoints[row] stringValue]];
//    } else {
//        
//        return [NSString stringWithFormat:@"%@", [self.health[row] stringValue]];
//        
//    }
//}

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
    
    [self.bottomPicker selectRow:[user.hp integerValue] inComponent:0 animated:YES];
    [self.topPicker selectRow:[user.vp integerValue] inComponent:0 animated:YES];
}





@end
