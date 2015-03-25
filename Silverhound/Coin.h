//
//  Coin.h
//  Silverhound
//
//  Created by ejd on 3/20/15.
//  Copyright (c) 2015 devinney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Coin : NSManagedObject

@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * denomination;
@property (nonatomic, retain) NSNumber * diameter_mm;
@property (nonatomic, retain) NSNumber * endYear;
@property (nonatomic, retain) NSNumber * fineweightAg_g;
@property (nonatomic, retain) NSNumber * fineweightAu_g;
@property (nonatomic, retain) NSNumber * mass_g;
@property (nonatomic, retain) NSString * nation;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSData * obverseImage;
@property (nonatomic, retain) NSNumber * ordinal;
@property (nonatomic, retain) NSNumber * percentAg;
@property (nonatomic, retain) NSNumber * percentAu;
@property (nonatomic, retain) NSData * reverseImage;
@property (nonatomic, retain) NSNumber * startYear;
@property (nonatomic, retain) NSString * synonyms;

@end
