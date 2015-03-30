//
//  AppDelegate.m
//  Silverhound
//
//  Created by ejd on 3/12/15.
//  Copyright (c) 2015 devinney. All rights reserved.
//

#import "AppDelegate.h"
#import "CoinTableViewController.h"
#import "Coin.h"

NSString *kLastSilverQuoteDateSetting = @"lastSilverQuoteDate";
NSString *kLastSilverQuoteSetting = @"lastSilverQuote";


@interface AppDelegate ()

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSMutableString *currentParsedCharacterData;
@property (nonatomic) BOOL _accumulatingParsedCharacterData;

@end

@implementation AppDelegate

@synthesize _accumulatingParsedCharacterData;
@synthesize currentParsedCharacterData;
@synthesize silverQuoteData;
@synthesize silverQuote;

@synthesize lastSilverQuote;

@synthesize managedObjectModel=_managedObjectModel, managedObjectContext=_managedObjectContext, persistentStoreCoordinator=_persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // pass down our managedObjectContext to our table view controller
    
    UINavigationController *uinavcontroller = (UINavigationController *)self.window.rootViewController;
    CoinTableViewController *coinTVC = (CoinTableViewController *)uinavcontroller.topViewController;
    coinTVC.managedObjectContext = self.managedObjectContext;

    [self updateSpotSilver];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - prefs

- (void)setupByPreferences
{
    // register default values for prefs that have not yet been set
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSDate dateWithTimeIntervalSinceReferenceDate:0], kLastSilverQuoteDateSetting,
                                 [NSDecimalNumber zero], kLastSilverQuoteSetting,
                                 nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
    // if there was a saved quote, retrieve and use
    self.lastSilverQuoteDate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastSilverQuoteDateSetting];
    NSString *savedSilverQuote = [[NSUserDefaults standardUserDefaults] objectForKey:kLastSilverQuoteSetting];
    
    self.lastSilverQuote = [savedSilverQuote floatValue];
}


- (void)savePreferences
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.2f", self.lastSilverQuote] forKey:kLastSilverQuoteSetting];
    [[NSUserDefaults standardUserDefaults] setObject:self.lastSilverQuoteDate forKey:kLastSilverQuoteDateSetting];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - scrap price api calls

// free historical: https://www.quandl.com/api/v1/datasets/OFDP/SILVER_5.xml
// free, end of day XML: http://services.packetizer.com/spotprices/
-(void)updateSpotSilver
{
    self.silverQuoteData = NULL;
    self.silverQuote = 0.0;
    self.currentParsedCharacterData = [[NSMutableString alloc] init];
    [self setupByPreferences];
    [self getSilverQuote];
}

#pragma mark - NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    

    if ([elementName isEqualToString:@"silver"]) {
        _accumulatingParsedCharacterData = YES;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"silver"]) {
        self.silverQuote = [self.currentParsedCharacterData doubleValue];
    }
    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    _accumulatingParsedCharacterData = NO;
}

/**
 This method is called by the parser when it find parsed character data ("PCDATA") in an element. The parser is not guaranteed to deliver all of the parsed character data for an element in a single invocation, so it is necessary to accumulate character data until the end of the element is reached.
 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (_accumulatingParsedCharacterData) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        //
        [self.currentParsedCharacterData appendString:string];
    }
}


#pragma mark HTTP utilities
-(void)getSilverQuote
{
//    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];

    NSURL *url = [NSURL URLWithString:@"http://services.packetizer.com/spotprices/"];
    
    //    url = [url URLByAppendingPathComponent:@"?"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [request addValue:@"application/ecmascript" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/xml" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error){
            // got it!
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            self.silverQuoteData = [data copy];

            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.silverQuoteData];
            [parser setDelegate:self];
            [parser parse];
            [self savePreferences];
          //  if (self.customNavBar)
          //      [self.customNavBar setNeedsDisplay];
            if (self.CTVController) [self.CTVController.tableView reloadData];

        } else {
            // process error
//***
            self.lastSilverQuote = 6.66;
            if (self.CTVController) [self.CTVController.tableView reloadData];
            if (self.customNavBar) {
                [self.customNavBar updateQuoteTitle];
                [self.customNavBar setNeedsDisplay];
           //     [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
            }
// ***
            UIAlertView *cantContactServer = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Can't update spot price. Please check network settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [cantContactServer show];
        }
    }];
    [postDataTask resume];
}


#pragma mark - Core Data stack

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.devinney.CD_dummy" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Silverhound" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Silverhound.sqlite"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ur-Silverhound" ofType:@"sqlite"]];
        
        NSError* err = nil;
        
        if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err]) {
            NSLog(@"Oops, could copy preloaded data");
        }
    }
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext{
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



@end
