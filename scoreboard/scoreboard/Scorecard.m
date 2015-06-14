//
//  Scorecard.m
//  scoreboard
//
//  Created by Jim Campagno on 6/14/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "Scorecard.h"

@implementation Scorecard




//-(id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if(!self){
//        return nil;
//    }
//    
//    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
//                                  owner:self
//                                options:nil];
//    
//    [self addSubview:self.view];
//    
//    return self;
//}


-(instancetype)initWithFrame:(CGRect)frame
{
    
//    Scorecard *playerTwoStuff =[[Scorecard alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    CGRect thing = CGRectMake(0, 0, 183.0, 161.0);
    
    
    
    self = [super initWithFrame:thing];
    if(self) {
        [self commonInit];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self commonInit];
    }
    
    return self;
}

-(void)commonInit
{
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                  owner:self
                                options:nil];
    
    
    
    [self addSubview:_view];
    
}

@end
