//
//  Scorecard.m
//  scoreboard
//
//  Created by Jim Campagno on 6/14/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "Scorecard.h"

@implementation Scorecard


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _customSBConstraints = [[NSMutableArray alloc] init];
    
//    UIView *view = nil;
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"Scorecard"
                                                     owner:self
                                                   options:nil];
//    for (id object in objects) {
//        if ([object isKindOfClass:[UIView class]]) {
//            view = object;
//            break;
//        }
//    }
//    
//    if (view != nil) {
//        _containerView = view;
//        view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self addSubview:view];
//        [self setNeedsUpdateConstraints];
//    }
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.view];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
//    if (self.containerView != nil) {
        UIView *view = self.view;
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        
        [self.customSBConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"H:|[view]|" options:0 metrics:nil views:views]];
        [self.customSBConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[view]|" options:0 metrics:nil views:views]];
        
        [self addConstraints:self.customSBConstraints];
//    }
    
    [super updateConstraints];
}
@end
