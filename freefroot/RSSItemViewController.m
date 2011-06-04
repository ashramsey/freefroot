//
//  RSSItemViewController.m
//  freefroot
//
//  Created by Ashley Ramsey on 5/06/11.
//  Copyright 2011 ashramsey. All rights reserved.
//

#import "RSSItemViewController.h"


@implementation RSSItemViewController

@synthesize rssDB, feedID, feedRecord, itemRecord, itemRowIDs;
@synthesize rssConnection, rssData;

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.feedRecord = [rssDB getFeedRow:self.feedID];
    self.title = [feedRecord objectForKey:@"title"];
    self.tableView.rowHeight = 55.0;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.itemRowIDs = nil;
}

- (void)dealloc {
    [super dealloc];
    if(feedRecord) [feedRecord release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


@end
