//
//  DaysOfWeek.h
//  Bates Connect
//
//  Created by Khoi Tuan Nguyen and Tim Chamberlin on 05/01/2014.
//  Copyright (c) 2014 Bates Tech Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaysOfWeek : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *day0;
@property (strong, nonatomic) IBOutlet UIButton *day1;
@property (strong, nonatomic) IBOutlet UIButton *day2;
@property (strong, nonatomic) IBOutlet UIButton *day3;
@property (strong, nonatomic) IBOutlet UIButton *day4;
@property (strong, nonatomic) IBOutlet UIButton *day5;
@property (strong, nonatomic) IBOutlet UIButton *day6;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *diningIndicator;

//the html to string array
@property NSMutableArray *ans;

@end
