//
//  AppDelegate.h
//  Silverhound
//
//  Created by ejd on 3/12/15.
//  Copyright (c) 2015 devinney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

