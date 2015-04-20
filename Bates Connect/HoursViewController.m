//
//  HoursViewController.m
//  Bates Connect
//
//  Created by Tim on 2/15/15.
//  Copyright (c) 2015 Bates Tech Club. All rights reserved.
//

#import "HoursViewController.h"

@interface HoursViewController ()

@end

@implementation HoursViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //set up the title on the navigation bar
    
    [_hoursIndicator startAnimating];
    
    [_webView setDelegate:self];
    
    if(_categoryTitle!=NULL)
    {
        self.navigationItem.title=_categoryTitle;
    }
    
    NSURL *url = [NSURL URLWithString:_urlText];
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
    [_webView loadRequest:requestObj];
    
    _webView.scalesPageToFit=YES;
    [_webView setScalesPageToFit:true];
}

- (void)webViewDidStartLoad:(UIWebView *)hoursView {
    //NSLog(@"Page started loading");
}

- (void)webView:(UIWebView *)hoursView didFailLoadWithError:(NSError *)error {
    //NSLog(@"Page stopped loading with error");
    [_hoursIndicator stopAnimating];
    [_errorMessage setHidden:false];
}


- (void)webViewDidFinishLoad:(UIWebView *)hoursView {
    //NSLog(@"Page finished loading");
    
    [_hoursIndicator stopAnimating];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
