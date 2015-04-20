//
//  MasterViewController.m
//  Bates Connect
//
//  Created by Khoi Tuan Nguyen and Tim Chamberlin on 05/01/2014.
//  Copyright (c) 2014 Bates Tech Club. All rights reserved.
//

#import "EventsViewController.h"
#import "ListOfCategoriesViewController.h"
#import "DetailViewController.h"

@interface EventsViewController () {
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *description;
    NSMutableString *author;
    NSMutableString *category;
    NSMutableString *pubDate;
    NSMutableString *link;
    NSString *element;
    NSURL *url;
}
@end

@implementation EventsViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void) setUrlText:(NSString *)urlText
{
    _urlText = urlText;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    feeds = [[NSMutableArray alloc] init];
    
    url = [NSURL URLWithString: _urlText];
    
    //set up the title on the navigation bar
    if(_categoryTitle!=NULL)
    {
        self.navigationItem.title=_categoryTitle;
    }
    
    // TableView clear background
    [self.tableView setBackgroundView:nil];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    //[_eventsLoading startAnimating];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return feeds.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // Set up the cell
    int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
    NSString *cellLabel = [[feeds objectAtIndex: storyIndex] objectForKey: @"title"];
    NSString *cellLabelDate =[[feeds objectAtIndex: storyIndex] objectForKey: @"pubDate"];
    //Fix Error of v1.0.1 when click on Academic category, the app crashes because the array is empty    
    if(cellLabelDate.length>11)
    {
        cellLabelDate = [cellLabelDate substringToIndex:11];
    }
    
    //NSLog(@"The link to %@ is: %@", cellLabel, cellLabel2);
    cell.textLabel.text = cellLabel;
    cell.detailTextLabel.text = cellLabelDate;
    cell.backgroundColor = [UIColor clearColor];
    [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica Neue" size:16.0]];
    [[cell textLabel] setTextColor:[UIColor whiteColor]];
  
    /*
    // Don't display financial aid session events
    if([cellLabel isEqualToString:(@"Admission and Financial Aid Information Session")]){
        //remove the specified events
        [feeds removeObjectAtIndex:indexPath.row];
        //reload tableview
        [self.tableView reloadData];
    }
    */
    return cell;
}

// Cell height

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    //NSLog(@"found file and started parsing");
}



- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %li )", (long)[parseError code]];
    NSLog(@"error parsing XML: %@", errorString);
    UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if ([element isEqualToString:@"item"]) {
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        description = [[NSMutableString alloc] init];
        author = [[NSMutableString alloc] init];
        category = [[NSMutableString alloc] init];
        pubDate = [[NSMutableString alloc] init];
        link = [[NSMutableString alloc] init];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    //Check for element name "item"
    if ([elementName isEqualToString:@"item"]) {
        
        [item setObject:title forKey:@"title"];
        [item setObject:description forKey:@"description"];
        [item setObject:author forKey:@"author"];
        [item setObject:category forKey:@"category"];
        [item setObject:pubDate forKey: @"pubDate"];
        [item setObject:link forKey:@"link"];
        
        [feeds addObject:[item copy]];
        
    }
    

}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {

    if ([element isEqualToString:@"title"])
    {
        if([title isEqualToString:(@"Admission and Financial Aid Information Session")]){
            NSLog(@"Admissions entry");
        }
            
        [title appendString:string];
        //NSLog(@"This is the title: %@", string);
    }
    else if ([element isEqualToString:@"description"])
    {
        [description appendString:string];
        //NSLog(@"This is the DESCRIPTION: %@", string);
    }
    else if ([element isEqualToString:@"author"])
    {
        [author appendString:string];
        //NSLog(@"This is the AUTHOR: %@", string);
    }
    else if ([element isEqualToString:@"category"])
    {
        [category appendString:string];
        //NSLog(@"This is the CATEGORY: %@", string);
    }
    else if ([element isEqualToString:@"pubDate"])
    {
        [pubDate appendString:string];
        //NSLog(@"This is the PUBDATE: %@", string);
    }
    else if ([element isEqualToString:@"link"])
    {
        [link appendString:string];
        //NSLog(@"This is the LINK: %@", string);
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [self.tableView reloadData];
    [_eventsLoading stopAnimating];
    
}



//This happens before didSelectRowAtIndexPath
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        id story = feeds[indexPath.row];
        //Setting up the next screen's details
        [[segue destinationViewController] setStoryTitle:[story objectForKey:@"title"]];
        [[segue destinationViewController] setStoryDescription:[story objectForKey:@"description"]];
        [[segue destinationViewController] setStoryAuthor:[story objectForKey:@"author"]];
        [[segue destinationViewController] setStoryCategory:[story objectForKey:@"category"]];
        [[segue destinationViewController] setStoryPubDate:[story objectForKey:@"pubDate"]];
        [[segue destinationViewController] setStoryLink:[story objectForKey:@"link"]];

    }
    //NSLog(@"Moving to the next screen.");
}

@end
