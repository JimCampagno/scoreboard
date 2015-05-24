//
//  SBUILabelHelper.m
//  scoreboard
//
//  Created by Jim Campagno on 5/24/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "SBUILabelHelper.h"

@implementation SBUILabelHelper

+ (void)setupBorderOfLabelsWithArrayOfLabels:(NSArray *)labels {
    for (UILabel *label in labels) {
        label.layer.borderWidth = 3.0;
        label.layer.borderColor = [UIColor blueColor].CGColor;
    }
}

@end