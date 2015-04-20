//
//  MenuOfDay.m
//  Bates Connect
//
//  Created by Khoi Tuan Nguyen and Tim Chamberlin on 05/01/2014.
//  Copyright (c) 2014 Bates Tech Club. All rights reserved.
//

#import "MenuOfDay.h"

@interface MenuOfDay ()

@end

@implementation MenuOfDay

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
    
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    //_tableView.delegate = self;
    //_tableView.dataSource = self;
    
    self.tableView.separatorColor = [UIColor clearColor];
    //set title
    self.navigationItem.title = _todayDate;
    
    // TableView clear background
    [self.tableView setBackgroundView:nil];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //NSLog(@"%f",_tableView.frame.size.width);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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


// Header setup

// Header formatting
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, tableView.frame.size.width, 45)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-70, 0, 435, 40)];
    // Get meal names
    NSMutableArray *temp = [_menu objectAtIndex:section];
    _header = [temp objectAtIndex:0];
    /* Section header is in 0th index... */
    [label setText:_header];   // Set label text to _header
    label.textAlignment = NSTextAlignmentCenter; // Align text center
    [label setTextColor:[UIColor whiteColor]];
    [headerView addSubview:label];   // add the label text to the created view
    headerView.backgroundColor = [UIColor colorWithRed:.949 green:.8 blue:.102 alpha:.8]; //background image
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    headerView.layer.cornerRadius = 0.0;
    headerView.layer.opaque = NO;

    
    
    return headerView;
}

// Header height

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

// Set number of sections in table view (number of meals)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //NSLog(@"%d this is the number of sections",_menu.count);
    //Return the number of sections
    return _menu.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Returns the number of items in each section
    //NSLog(@"%lu this is the number of ROWS",(unsigned long)[[_menu objectAtIndex:section] count]);
    return [[_menu objectAtIndex:section] count]-1;//minus the first line which is just the title
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellIdentifier = @"MyReuseIdentifier";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        [[cell textLabel] setNumberOfLines:0]; // unlimited number of lines
        [[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    
    // Set up the cell
    //need to account for section number and row number
    NSMutableArray *temp = [_menu objectAtIndex: indexPath.section];
    
    
    NSString *labelOfCell = (NSString *)[temp objectAtIndex:indexPath.row+1];//plus 1 to move 1 up because the first line is just the title
    cell.textLabel.text = labelOfCell;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.userInteractionEnabled = false;
    
    if ([labelOfCell length]>11)
    {
        //dish title
        if ([[labelOfCell substringToIndex:12] isEqualToString:@"            "])
        {
            [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
            [[cell textLabel] setTextColor:[UIColor whiteColor]];
            
        }
        //station title
        else if ([[labelOfCell substringToIndex:8] isEqualToString:@"        "])
        {
            cell.textLabel.text = [labelOfCell substringFromIndex:4];
            [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica Neue" size:20.0]];
            [[cell textLabel] setTextColor:[UIColor colorWithRed:.949 green:.8 blue:.102 alpha:1]];
            
        }
             
        
    }
    else
    {
        [[cell textLabel] setTextColor:[UIColor redColor]];
        [[cell textLabel] setFont:[UIFont systemFontOfSize: 14.0]];
    }
    
    
    return cell;
}


// Cell height

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    
}


@end