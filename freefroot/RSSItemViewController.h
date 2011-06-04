//
//  RSSItemViewController.h
//  freefroot
//
//  Created by Ashley Ramsey on 5/06/11.
//  Copyright 2011 ashramsey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSDB.h"

@interface RSSItemViewController : UITableViewController <NSXMLParserDelegate> {
    RSSDB *rssDB;
    NSNumber *feedID;
    NSDictionary *feedRecord;
    NSDictionary *itemRecord;
    NSArray *itemRowIDs;
    
    // Connection properties
    NSURLConnection *rssConnection;
    NSMutableData *rssData;
}

@property (nonatomic, retain) RSSDB *rssDB;
@property (nonatomic, retain) NSNumber *feedID;
@property (nonatomic, retain) NSDictionary *feedRecord;
@property (nonatomic, retain) NSDictionary *itemRecord;
@property (nonatomic, retain) NSArray *itemRowIDs;

@property (nonatomic, retain) NSURLConnection *rssConnection;
@property (nonatomic, retain) NSMutableData *rssData;

@end
