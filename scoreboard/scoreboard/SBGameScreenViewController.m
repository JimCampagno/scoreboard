//
//  SBGameScreenViewController.m
//  scoreboard
//
//  Created by James Campagno on 6/6/15.
//  Copyright (c) 2015 Gamesmith, LLC. All rights reserved.
//

#import "SBGameScreenViewController.h"

@interface SBGameScreenViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mainUserName;
@property (weak, nonatomic) IBOutlet UILabel *mainMonsterName;
@property (weak, nonatomic) IBOutlet UIImageView *mainMonsterImage;
@property (weak, nonatomic) IBOutlet UIView *mainMonsterView;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (strong, nonatomic) NSMutableArray *pickerData;

@end

@implementation SBGameScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    
    

//    CGFloat width = CGRectGetWidth(self.mainMonsterView.bounds);
//    CGFloat height = CGRectGetHeight(self.mainMonsterView.bounds);
    
   

    
//    NSLog(@"The width is : %f and the height is %f", width, height);
    
    
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    return [self.pickerData count];
}


- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.pickerData[row];
}


- (NSMutableArray *)pickerData {
    if (!_pickerData) {
        
        _pickerData = [[NSMutableArray alloc] init];
        _pickerData = [@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8"] mutableCopy];
    }
    
    return _pickerData;
}

-(void)viewDidAppear:(BOOL)animated {
    
    CGFloat width = CGRectGetWidth(self.mainMonsterView.bounds);
    CGFloat height = CGRectGetHeight(self.mainMonsterView.bounds);
//    NSLog(@"The width is : %f and the height is %f", width, height);
    UIImageView *dot =[[UIImageView alloc] initWithFrame:CGRectMake(0,height/6,height/1.5,height/1.5)];
    dot.backgroundColor = [UIColor blackColor];
    [self.mainMonsterView addSubview:dot];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, height/1.5, height/6)];
    label.backgroundColor = [UIColor blueColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.text = @"TOP";
    [self.mainMonsterView addSubview:label];
    
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height-(height/6), height/1.5, height/6)];
    bottomLabel.backgroundColor = [UIColor greenColor];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.textColor = [UIColor blackColor];
    bottomLabel.numberOfLines = 0;
    bottomLabel.text = @"BOTTOM";
    [self.mainMonsterView addSubview:bottomLabel];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
