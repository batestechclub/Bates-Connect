//
//  ListOfCategoriesViewController.m
//  Bates Connect
//
//  Created by Khoi Tuan Nguyen and Tim Chamberlin on 05/01/2014.
//  Copyright (c) 2014 Bates Tech Club. All rights reserved.
//

#import "ListOfCategoriesViewController.h"
#import "EventsViewController.h"


@interface ListOfCategoriesViewController ()
@end

@implementation ListOfCategoriesViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //NSLog(@"prepareForSegue: %@", segue.identifier);
    if([segue.identifier isEqualToString:@"allSeg"])
    {
        [segue.destinationViewController setUrlText:@"https://events.bates.edu/MasterCalendar/RSSFeeds.aspx?data=mL1noRCrG1I%2fLTuo7OuVK0Xc%2bQzHvOBRvVyfCrcXKiA%3d"];
        [segue.destinationViewController setCategoryTitle:@"All"];
    }
    else if ([segue.identifier isEqualToString:@"acadSeg"])
    {
        [segue.destinationViewController setUrlText:@"https://events.bates.edu/MasterCalendar/RSSFeeds.aspx?data=rWVImWG4wi1iC5u2UcXAOb8FAG2a07ELl0dalOR1a1E%3d"];
        [segue.destinationViewController setCategoryTitle:@"Academics"];
    }
    else if ([segue.identifier isEqualToString:@"activSeg"])
    {
        [segue.destinationViewController setUrlText:@"https://events.bates.edu/MasterCalendar/RSSFeeds.aspx?data=OiNeXA6LJItp%2bLkkMsbi4wEeKjDIEyUQtbeKsA7Mwd0%3d"];
        [segue.destinationViewController setCategoryTitle:@"Activities"];
        
    }
    else if ([segue.identifier isEqualToString:@"artSeg"])
    {
        [segue.destinationViewController setUrlText:@"https://events.bates.edu/MasterCalendar/RSSFeeds.aspx?data=hhAbVFpDFO7OxcTcYlM9LqoreXryCsIt"];
        [segue.destinationViewController setCategoryTitle:@"Arts"];

    }
    else if ([segue.identifier isEqualToString:@"athleSeg"])
    {
        [segue.destinationViewController setUrlText:@"https://events.bates.edu/MasterCalendar/RSSFeeds.aspx?data=HwqQnFd0XZw2ELTJ3w4YjTzo%2fo2OuzFkwDN7%2bEDRtTQ%3d"];
        [segue.destinationViewController setCategoryTitle:@"Athletics"];
    }
    
    //The following segues are used for the building hours
    
    else if ([segue.identifier isEqualToString:@"athleticBuildings"])
    {
        [segue.destinationViewController setUrlText:@"http://athletics.bates.edu/building-hours/"];
        [segue.destinationViewController setCategoryTitle:@"Athletic Buildings"];
    }
    
    else if ([segue.identifier isEqualToString:@"summer"])
    {
        [segue.destinationViewController setUrlText:@"http://www.bates.edu/access/building-hours/summer-hours/"];
        [segue.destinationViewController setCategoryTitle:@"Summer"];
    }
    
    else if ([segue.identifier isEqualToString:@"semester"])
    {
        [segue.destinationViewController setUrlText:@"http://www.bates.edu/access/building-hours/semester-building-hours/"];
        [segue.destinationViewController setCategoryTitle:@"In Semester"];
    }
    
    else if ([segue.identifier isEqualToString:@"octFebBreak"])
    {
        [segue.destinationViewController setUrlText:@"http://www.bates.edu/access/building-hours/break-building-hours/"];
        [segue.destinationViewController setCategoryTitle:@"Oct/Feb Break"];
    }
    
    else if ([segue.identifier isEqualToString:@"decAprBreak"])
    {
        [segue.destinationViewController setUrlText:@"http://www.bates.edu/access/building-hours/between-semester-building-hours/"];
        [segue.destinationViewController setCategoryTitle:@"Dec/Apr Break"];
    }

}



@end
