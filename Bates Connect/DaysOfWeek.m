//
//  DaysOfWeek.m
//  Bates Connect
//
//  Created by Khoi Tuan Nguyen and Tim Chamberlin on 05/01/2014.
//  Copyright (c) 2014 Bates Tech Club. All rights reserved.
//

#import "DaysOfWeek.h"
#import "MenuOfDay.h"
#import "ListOfCategoriesViewController.h"



@interface DaysOfWeek ()
{
    NSString *days[7]; //name of the days
    NSInteger start[7];
    NSInteger end[7];
    NSInteger pos;
    NSMutableArray *todayMenu;
    NSString *todayDate;
}
@end

@implementation DaysOfWeek

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
    [self setUpTheButtons];
    //Init memory space to the answer array
    _ans = [[NSMutableArray alloc] init];
    //load HTML to string
    [self loadDiningMenu];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setUpTheButtons
{
    //get the day of today
    NSDate *today = [NSDate date];
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat:@"EEEE"]; // day, like "Saturday"
    [myFormatter setDateFormat:@"c"]; // day number, like 7 for saturday
    
    int dayOfWeek = [[myFormatter stringFromDate:today] intValue] % 7;
    NSString *days[7]={@"Saturday",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday"};
    //[_day0 setTitle:days[dayOfWeek] forState:UIControlStateNormal];
    dayOfWeek = (dayOfWeek + 1) % 7;
    [_day1 setTitle:days[dayOfWeek] forState:UIControlStateNormal];
    dayOfWeek = (dayOfWeek + 1) % 7;
    [_day2 setTitle:days[dayOfWeek] forState:UIControlStateNormal];
    dayOfWeek = (dayOfWeek + 1) % 7;
    [_day3 setTitle:days[(int)dayOfWeek] forState:UIControlStateNormal];
    dayOfWeek = (dayOfWeek + 1) % 7;
    [_day4 setTitle:days[(int)dayOfWeek] forState:UIControlStateNormal];
    dayOfWeek = (dayOfWeek + 1) % 7;
    [_day5 setTitle:days[(int)dayOfWeek] forState:UIControlStateNormal];
    dayOfWeek = (dayOfWeek + 1) % 7;
    [_day6 setTitle:days[(int)dayOfWeek] forState:UIControlStateNormal];
    dayOfWeek = (dayOfWeek + 1) % 7;
}

//HTML to String
- (void) loadDiningMenu
{
    NSURL *menuURL = [NSURL URLWithString:@"https://www.bates.edu/dining/menu/"];
    //Read html file from URL as a String
    NSString *html = [NSString stringWithContentsOfURL:menuURL encoding:NSUTF8StringEncoding error:NULL];
    //Trim the End
    NSString *trimmedString;
    NSScanner *trimEnd = [NSScanner scannerWithString: html];
    [trimEnd scanUpToString:@"footer" intoString:&trimmedString];
    trimmedString = [self fixDecodeProblem:trimmedString];
    NSScanner *sc = [NSScanner scannerWithString:trimmedString];
    
    //Trim the beginning
    NSString *daySplit = @"<div class=\"menu-day\"><h3>";
    [sc scanUpToString:daySplit intoString: nil];
    //Scan for the day
    while (![sc isAtEnd])
    {
        //Skip the day separator tag
        [sc scanString:daySplit intoString:nil];
        
        //Declare string day which includes all the info needed for one day
        NSString *day;
        if ([sc scanUpToString:daySplit intoString:&day]) //the variable day needs a "&" sign because it is strong
        {
            //NSLog(@"-----------------------------------------------------------");
            [_ans addObject:@"------------------------------------------"];
            [self loadDay:day];
            pos++;
        }
    }
    end[6]=[_ans count];
    
    /*
    for (int i = 0; i<7; i++)
    {
        NSLog(days[i]);
        NSLog(@"%d",start[i]);
        NSLog(@"%d",end[i]);
    }
    NSLog(@"END");
    */
}

//load the content of day
- (void) loadDay:(NSString *)day
{
    NSString *mealSplit = @"<div class=\"menu-meal\"><h3>";
    NSString *dateSplit = @"<div class=\"menu-date\">";
    //String include the current day of today
    NSString *today;
    //Declare a new scanner for string day
    NSScanner *sc = [NSScanner scannerWithString:day];
    [sc scanUpToString:@"<" intoString:&today];
    
    
    NSString *todayDate;
    [sc scanUpToString:dateSplit intoString:nil];
    [sc scanString:dateSplit intoString:nil]; //skip the separator
    [sc scanUpToString:@"</div" intoString:&todayDate];
    //Printing out date
    //NSLog(@"%@, %@.",today,todayDate);
    
    //set up the variables for the 3 arrays days, start and end
    days[pos]=today;
    start[pos]=[_ans count];
    if(pos>0)
    {
        end[pos-1]=start[pos]-1;
    }
    //add to answer array
    [_ans addObject:[NSString stringWithFormat:@"%@, %@",today, todayDate]];
    
    //Stop right before the meal
    [sc scanUpToString:mealSplit intoString:nil];
    
    while (![sc isAtEnd])
    {
        //Skip the meal separator
        [sc scanString:mealSplit intoString:nil];
        NSString *meal;
        [sc scanUpToString:mealSplit intoString:&meal];
        //load meal
        [self loadMeal:meal];
    }
    
}

-(void) loadMeal:(NSString *)meal
{
    //Declare another new scanner
    NSScanner *sc = [NSScanner scannerWithString:meal];
    //Declare the current meal
    NSString *mealCurrent;
    
    [sc scanUpToString:@"</h3>" intoString:&mealCurrent];
    //Print the current meal
    //NSLog(@"    %@",mealCurrent);
    
    //add to answer
    [_ans addObject:[NSString stringWithFormat:@"    %@", mealCurrent]];
    
    //Declare STATION separator
    NSString *stationSplit = @"<div class=\"menu-station\">";
    //Stop right before the station
    [sc scanUpToString:stationSplit intoString:nil];
    while(![sc isAtEnd])
    {
        //Skip the separator tag
        [sc scanString:stationSplit intoString:nil];
        NSString *station;
        [sc scanUpToString:stationSplit intoString:&station];
        
        //load station
        [self loadStation:station];
    }
}

-(void) loadStation: (NSString *)station
{
    //Delcare another another new new scanner
    NSScanner *sc = [NSScanner scannerWithString:station];
    //Delcare current station
    NSString *stationCurrent;
    
    [sc scanUpToString:@"</div><div class=\"menu-list\"><ul>" intoString:&stationCurrent];
    //Print the current station
    //NSLog(@"        %@",stationCurrent);
    
    //add to answer array
    [_ans addObject:[NSString stringWithFormat:@"        %@", stationCurrent]];
    
    //Declare DISH separator
    NSString *dishSplit = @"<li>";
    NSString *dishStop = @"</li>";
    //NSLog(station);
    //Stop right before the dish
    [sc scanUpToString:dishSplit intoString:nil];
    
    while (![sc isAtEnd])
    {
        //Skip the DISH TAG
        [sc scanString:dishSplit intoString:nil];
        //Declare the dish name
        NSString *dishCurrent=@"";
        [sc scanUpToString:dishStop intoString:&dishCurrent];
        
        //NSLog(@"            %@",dishCurrent);
        
        //add to the answer array
        if ([dishCurrent length]>0)
        {
            [_ans addObject:[NSString stringWithFormat:@"            %@", dishCurrent]];
        }
        //Move the cursor to just before the next dish
        [sc scanUpToString:dishSplit intoString:nil];
    }
}

//fix the html to string decoding problem such as &amps or &#38
- (NSString *) fixDecodeProblem: (NSString *)input
{
    NSUInteger myLength = [input length];
    NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
    NSScanner *scanner = [NSScanner scannerWithString:input];
    NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];
    do
    {
        // Scan up to the next entity or the end of the string.
        NSString *nonEntityString;
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];
        }
        if ([scanner isAtEnd]) {
            goto finish;
        }
        // Scan either a HTML or numeric character entity reference.
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"& "];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL])
            [result appendString:@"<"];
        else if ([scanner scanString:@"&gt;" intoString:NULL])
            [result appendString:@">"];
        else if ([scanner scanString:@"&#" intoString:NULL]) {
            BOOL gotNumber;
            unsigned charCode;
            NSString *xForHex = @"";
            
            // Is it hex or decimal?
            if ([scanner scanString:@"x" intoString:&xForHex]) {
                gotNumber = [scanner scanHexInt:&charCode];
            }
            else {
                gotNumber = [scanner scanInt:(int*)&charCode];
            }
            
            if (gotNumber) {
                [result appendFormat:@"%C", (unichar)charCode];
                
                [scanner scanString:@";" intoString:NULL];
            }
            else {
                NSString *unknownEntity = @"";
                
                [scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];
                
                [result appendFormat:@"&#%@%@", xForHex, unknownEntity];

                //NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
                
            }
            
        }
        else {
            NSString *amp;
            
            [scanner scanString:@"&" intoString:&amp];  //an isolated & symbol
            [result appendString:amp];

        }
        
    }
    while (![scanner isAtEnd]);
    
    finish:
    return result;
    
}

-(void) setUpTodayMenu: (NSInteger) dayNumber
{
    //Init memory space to the today menu array
    todayMenu = [[NSMutableArray alloc] init];
    //the date of today
    todayDate = [_ans objectAtIndex:start[dayNumber]];
    //initialize section
    int sectionStart=start[dayNumber]+1;
    NSMutableArray *meal;
    meal = [[NSMutableArray alloc] init];
    
    //loop for to scan all items in the menu including days, meal, and dish
    for (int i=start[dayNumber]+1;i<end[dayNumber];i++)//range is correct
    {
        NSString *current = [_ans objectAtIndex:i];
       
        //if a new section is found
        if ((![[current substringToIndex:5] isEqualToString:@"     "]) && ([meal count]>0))
        {
            [todayMenu addObject:meal];
            //start a new section
            meal = [[NSMutableArray alloc] init];
        }
        [meal addObject:current];
    }
    [todayMenu addObject:meal];
    for (int i = 0;i<[todayMenu count];i++)
    {
        NSMutableArray *temp = [todayMenu objectAtIndex:i];
        /*
        for (int j =0 ;j<[temp count];j++)
        {
            NSLog([temp objectAtIndex:j]);
        }
        NSLog(@"************");
        */
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //NSLog(@"prepareForSegue: %@", segue.identifier);
    int daySelected = [[segue.identifier substringFromIndex:6] intValue];
    //NSLog(@"%d",daySelected);
    [self setUpTodayMenu:daySelected];
    [[segue destinationViewController] setMenu:todayMenu];
    NSScanner *sc = [NSScanner scannerWithString:todayDate];
    NSString *justTheDay;
    [sc scanUpToString:@"," intoString: &justTheDay];
    [[segue destinationViewController] setTodayDate:justTheDay];
}



@end
