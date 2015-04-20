//
//  DetailViewController.h
//  Bates Connect
//
//  Created by Khoi Tuan Nguyen and Tim Chamberlin on 05/01/2014.
//  Copyright (c) 2014 Bates Tech Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsViewController.h"

@interface DetailViewController : UIViewController

@property (weak, nonatomic)          NSString *storyTitle;
@property (weak, nonatomic)          NSString *storyDescription;
@property (weak, nonatomic)          NSString *storyAuthor;
@property (weak, nonatomic)          NSString *storyCategory;
@property (weak, nonatomic)          NSString *storyPubDate;
@property (weak, nonatomic)          NSString *storyLink;

@property (strong, nonatomic) IBOutlet UILabel *textTitle;
@property (strong, nonatomic) IBOutlet UITextView *textDescription;
@property (strong, nonatomic) IBOutlet UITextField *textAuthor;
@property (strong, nonatomic) IBOutlet UITextField *textCategory;
@property (strong, nonatomic) IBOutlet UITextView *textPubDate;
@property (strong, nonatomic) IBOutlet UITextField *textLink;
@end
