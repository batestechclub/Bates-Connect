//
//  EventsViewController.h
//  Bates Connect
//
//  Created by Khoi Tuan Nguyen on 05/01/14.
//  Copyright (c) 2013 Bates Programming Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface EventsViewController : UIViewController <NSXMLParserDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic)          NSString *urlText;
@property NSString *categoryTitle;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *eventsLoading;



@end
