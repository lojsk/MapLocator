//
//  PointData.h
//  MapLocator
//
//  Created by lojsk on 16/08/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MapData;

@interface PointData : NSManagedObject

@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) MapData *pointMap;

@end
