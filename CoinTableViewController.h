//
//  CoinTableViewController.h
//  Silverhound
//
//  Created by ejd on 3/12/15.
//  Copyright (c) 2015 devinney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoinTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;

- (IBAction)refresh:(UIRefreshControl *)sender;

@end
