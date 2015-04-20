//
//  HoursViewController.h
//  Bates Connect
//
//  Created by Tim on 2/15/15.
//  Copyright (c) 2015 Bates Tech Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HoursViewController : UIViewController

@property (weak, nonatomic) NSString *urlText;
@property NSString *categoryTitle;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *hoursIndicator;

@property (strong, nonatomic) IBOutlet UILabel *errorMessage;

@end
