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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadRSSFeed];
}

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

#pragma mark -
#pragma mark Support methods

- (void) loadRSSFeed {
    self.feedRecord = [rssDB getFeedRow:self.feedID];
    NSURLRequest *rssURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[feedRecord objectForKey:@"url"]]];
    self.rssConnection = [[[NSURLConnection alloc] initWithRequest:rssURLRequest delegate:self] autorelease];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSAssert(self.rssConnection != nil, @"Could not create URL connection.");
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // NSLog(@"%s %@", __FUNCTION__, [response MIMEType]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (!rssData) rssData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // NSLog(@"%s (length: %d)", __FUNCTION__, [data length]);
    [self.rssData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // NSLog(@"%s", __FUNCTION__);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    self.rssConnection = nil;
    
    // Spawn a thread to parse the RSS feed so that the UI is not blocked while parsing.
    // IMPORTANT! - Don't access UIKit objects on secondary threads.
    NSLog(@"have data: %d bytes", [rssData length]);
    //[NSThread detachNewThreadSelector:@selector(parseRSSData:) toTarget:self withObject:rssData];
    
    // rssData will be retained by the thread until parseRSSData: has finished executing, so we no longer need
    // a reference to it in the main thread.
    self.rssData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // NSLog(@"%s", __FUNCTION__);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([error code] == kCFURLErrorNotConnectedToInternet) {
        // if we can identify the error, we can present a more precise message to the user.
        NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:NSLocalizedString(@"No Connection Error", @"Not connected to the Internet.")
                                    forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:userInfo];
        [self handleError:noConnectionError];
    } else {
        // otherwise handle the error generically
        [self handleError:error];
    }
    self.rssConnection = nil;
}


#pragma mark -
#pragma mark Error handling

- (void)handleError:(NSError *)error {
    // NSLog(@"%s", __FUNCTION__);
    // NSLog(@"error is %@, %@", error, [error domain]);
    NSString *errorMessage = [error localizedDescription];
    
    // errors in NSXMLParserErrorDomain >= 10 are harmless parsing errors
    if ([error domain] == NSXMLParserErrorDomain && [error code] >= 10) {
        alertMessage(@"Cannot parse feed: %@", errorMessage);  // tell the user why parsing is stopped
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error" message:errorMessage delegate:nil
                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)errorAlert:(NSString *) message {
    // NSLog(@"%s", __FUNCTION__);
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"RSS Error" message:message delegate:nil
                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    [self dismissModalViewControllerAnimated:YES];
}

@end
