//
//  Coin.h
//  Silverhound
//
//  Created by ejd on 3/18/15.
//  Copyright (c) 2015 devinney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Coin : NSManagedObject

@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * denomination;
@property (nonatomic, retain) NSDecimalNumber * diameterMM;
@property (nonatomic, retain) NSNumber * endYear;
@property (nonatomic, retain) NSDecimalNumber * fineWeightAgGrams;
@property (nonatomic, retain) NSDecimalNumber * massGrams;
@property (nonatomic, retain) NSData * obverseImage;
@property (nonatomic, retain) NSNumber * ordinal;
@property (nonatomic, retain) NSDecimalNumber * percentAg;
@property (nonatomic, retain) NSData * reverseImage;
@property (nonatomic, retain) NSNumber * startYear;
@property (nonatomic, retain) NSString * synonyms;
@property (nonatomic, retain) NSDecimalNumber * fineWeightAuGrams;
@property (nonatomic, retain) NSDecimalNumber * percentAu;
@property (nonatomic, retain) NSString * nation;
@property (nonatomic, retain) NSString * notes;

@end
