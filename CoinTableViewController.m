//
//  CoinTableViewController.m
//  Silverhound
//
//  Created by ejd on 3/12/15.
//  Copyright (c) 2015 devinney. All rights reserved.
//

#import "AppDelegate.h"

#import "CoinTableViewController.h"
#import "CoinTableViewCell.h"
#import "CountryHeaderViewCell.h"

@interface CoinTableViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation CoinTableViewController

- (IBAction)unwindToTableView:(UIStoryboardSegue *)unwindSegue
{
}


@synthesize navItem;

// segue ID when coin summary is tapped
static NSString *kShowCoinDetailSegueID = @"showCoinDetail";

- (void) updateQuoteTitle {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSNumberFormatter *oneShotNumberFormatter = [[NSNumberFormatter alloc] init];
    [oneShotNumberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    oneShotNumberFormatter.currencyCode = @"USD";
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [oneShotNumberFormatter setGroupingSeparator:groupingSeparator];
    [oneShotNumberFormatter setGroupingSize:3];
    [oneShotNumberFormatter setAlwaysShowsDecimalSeparator:NO];
    [oneShotNumberFormatter setUsesGroupingSeparator:YES];
    NSString *quoteString = [oneShotNumberFormatter stringFromNumber:[NSNumber numberWithFloat:appDelegate.lastSilverQuote]];
    
    NSDateFormatter *oneShotDateFormatter = [[NSDateFormatter alloc]init];
    [oneShotDateFormatter setDateFormat:@"dd MMM yyyy"];
    
    
    self.navItem.title = [NSString stringWithFormat:@"Silver %@/oz on %@",quoteString,[oneShotDateFormatter stringFromDate: appDelegate.lastSilverQuoteDate]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self updateQuoteTitle];
    
    
    NSError *error = nil;

    if (![[self fetchedResultsController] performFetch:&error]) {
        // !!!!
        // Replace this implementation with code to handle the error appropriately.
        //
        // abort() causes the application to generate a crash log and terminate. You should not use this 
        // function in a shipping application, although it may be useful during development. If it is not
        // possible to recover from the error, display an alert panel that instructs the user to quit 
        // the application by pressing the Home button.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.CTVController = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
#pragma mark - Table view data source methods

// The data source methods are handled primarily by the fetch results controller
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        
    NSInteger count = [[self.fetchedResultsController sections] count];
    return count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier = @"Header";
    CountryHeaderViewCell *header = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *sectionTitle = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    header.countryLabel.text = sectionTitle;
    
 //   Coin *coin = [self.fetchedResultsController objectAtIndexPath:section];

    UIImage *image = [UIImage imageNamed: [NSString stringWithFormat:@"%@.png", sectionTitle]];
    header.flagImageView.image = image;
    
    return header;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSInteger numRows = [sectionInfo numberOfObjects];
    return numRows;
}

// Customize the appearance of table view cells.
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell
    Coin *coin = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CoinTableViewCell *ctvCell = (CoinTableViewCell *)cell;
    ctvCell.coin = coin;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    // Display the country names as section headings.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];

    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the managed object.
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - UITableViewDelegate



#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    // Set up the fetched results controller if needed.
    if (_fetchedResultsController == nil) {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Coin" inManagedObjectContext:_managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortCountryDescriptor = [[NSSortDescriptor alloc] initWithKey:@"country" ascending:YES];
        NSSortDescriptor *sortOrdinalDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ordinal" ascending:YES];
        NSArray *sortDescriptors = @[sortCountryDescriptor,sortOrdinalDescriptor];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
                
        // Create and initialize the fetch results controller.
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"country" cacheName:@"Root"];
        _fetchedResultsController.delegate = self;

    }
    
    return _fetchedResultsController;
}

@end
