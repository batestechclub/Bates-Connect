//
//  DetailViewController.m
//  Bates Connect
//
//  Created by Khoi Tuan Nguyen and Tim Chamberlin on 05/01/2014.
//  Copyright (c) 2014 Bates Tech Club. All rights reserved.
//

#import "DetailViewController.h"
#import "EventsViewController.h"



@implementation DetailViewController


#pragma mark - Managing the detail item

- (void)viewDidLoad {
    [super viewDidLoad];

    //NSLog(@"Moving to story screen with link %@", _storyLink);
    [self textTitle].text=_storyTitle;
    [self textDescription].text=_storyDescription;
    [self textAuthor].text=_storyAuthor;
    [self textCategory].text=_storyCategory;
    
    //fix the pubDate
    [self textPubDate].text=[self fixPubDate];
    
    [self textLink].text=_storyLink;
    //NSLog(@"End setting up the story screen");
    
}

//Remove the GMT time from the pubDate
-(NSString *) fixPubDate
{
    NSString *fixedPubDate;
    //NSScanner *sc = [NSScanner scannerWithString:_storyPubDate];
    //[sc scanUpToString:@" GMT" intoString: &fixedPubDate];
    
    fixedPubDate = [_storyPubDate substringToIndex:16];
    return fixedPubDate;
    
}

@end