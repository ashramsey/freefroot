//
//  RootViewController.h
//  freefroot
//
//  Created by Ashley Ramsey on 4/06/11.
//  Copyright 2011 ashramsey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSDB.h"

@interface RootViewController : UITableViewController {
    RSSDB *rssDB;
    NSArray *feedIDs;
}

@property (nonatomic, retain) RSSDB *rssDB;
@property (nonatomic, retain) NSArray *feedIDs;

- (NSArray *) loadFeedIDs;
- (NSArray *) loadFeedIDsIfEmpty;
- (RSSDB *) loadFeedDB;

@end
