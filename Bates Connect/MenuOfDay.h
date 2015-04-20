//
//  MenuOfDay.h
//  Bates Connect
//
//  Created by Khoi Tuan Nguyen and Tim Chamberlin on 05/01/2014.
//  Copyright (c) 2014 Bates Tech Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuOfDay : UIViewController

@property NSMutableArray *menu;
@property NSMutableArray *sections;
@property NSString *todayDate;
@property NSString *header;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end