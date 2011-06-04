//
//  RootViewController.m
//  freefroot
//
//  Created by Ashley Ramsey on 4/06/11.
//  Copyright 2011 ashramsey. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

@synthesize rssDB, feedIDs;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Freefroot";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadFeedIDs];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return YES;
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self loadFeedIDs];
    return [feedIDs count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell.
    
    NSDictionary * feedRow = [rssDB getFeedRow:[feedIDs objectAtIndex:indexPath.row]];
    [cell.textLabel setText:[feedRow objectForKey:@"title"]];
    [cell.detailTextLabel setText:[feedRow objectForKey:@"desc"]];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete)
 {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert)
 {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self loadFeedIDsIfEmpty];
    
    // clean up aged feed items from the database
    [rssDB deleteOldItems:[feedIDs objectAtIndex:indexPath.row]];
    
    // create the item view controller
    RSSItemViewController *itemViewController = [[RSSItemViewController alloc] initWithStyle:UITableViewStylePlain];
    itemViewController.rssDB = rssDB;
    itemViewController.feedID = [feedIDs objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:itemViewController animated:YES];
    [itemViewController release];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

// memory management

- (void)dealloc {
    // NSLog(@"%s", __FUNCTION__);
    [super dealloc];
    if (feedIDs) [feedIDs release];
    if (rssDB) [rssDB release];
}

#pragma mark -
#pragma mark Database methods

- (NSArray *) loadFeedIDs {
    // NSLog(@"%s", __FUNCTION__);
    if (!rssDB) [self loadFeedDB];
    feedIDs = [rssDB getFeedIDs];
    return feedIDs;
}

- (NSArray *) loadFeedIDsIfEmpty {
    // NSLog(@"%s", __FUNCTION__);
    if (!rssDB) [self loadFeedDB];
    if (!feedIDs || ![feedIDs count]) feedIDs = [rssDB getFeedIDs];
    return feedIDs;
}

- (RSSDB *) loadFeedDB {
    // NSLog(@"%s", __FUNCTION__);
    if (!rssDB) self.rssDB = [[RSSDB alloc] initWithRSSDBFilename:@"ffrss.db"];
    return rssDB;
}


@end
