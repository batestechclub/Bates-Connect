//
//  MainVC.m
//  Bates Connect
//
//  Created by Tim Chamberlin on 9/17/14.
//  Copyright (c) 2014 Bates Tech Club. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// Method makes the status bar content white (time, battery, etc.).
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath
{
    NSString *identifier;
    switch (indexPath.row) {
        case 0:
            identifier = @"diningSegue";
            break;
        case 1:
            identifier = @"eventsSegue";
            break;
//        case 2:
//            identifier = @"hoursSegue";
//            break;
        case 3:
            identifier = @"mingleSegue";
            
            break;
            
    }
    return identifier;
}

- (void)configureLeftMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame.origin = (CGPoint){0,0};
    frame.size = (CGSize){30,30};
    button.frame = frame;
    
    [button setImage:[UIImage imageNamed:@"menuBar.png"] forState:UIControlStateNormal];
}

- (CGFloat)leftMenuWidth
{
    return 200;
}

- (void) configureSlideLayer:(CALayer *)layer
{
    layer.shadowColor = nil;
    layer.shadowOpacity = 0;
    layer.shadowRadius = 0;
}


@end
