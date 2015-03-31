//
//  AppDelegate.h
//  Silverhound
//
//  Created by ejd on 3/12/15.
//  Copyright (c) 2015 devinney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CustomNavigationBar.h"
#import "CoinTableViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSURLConnectionDataDelegate, NSXMLParserDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSData *silverQuoteData;

@property (strong, nonatomic) NSDate *lastSilverQuoteDate;
@property (nonatomic) float lastSilverQuote;

@property (strong, nonatomic)CustomNavigationBar *customNavBar;
@property (strong, nonatomic)CoinTableViewController *CTVController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

