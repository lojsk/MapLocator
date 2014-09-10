//
//  MapData.h
//  MapLocator
//
//  Created by lojsk on 17/08/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PointData, UserData;

@interface MapData : NSManagedObject

@property (nonatomic, retain) NSNumber * from_to;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSSet *mapPoint;
@property (nonatomic, retain) UserData *mapUser;
@end

@interface MapData (CoreDataGeneratedAccessors)

- (void)addMapPointObject:(PointData *)value;
- (void)removeMapPointObject:(PointData *)value;
- (void)addMapPoint:(NSSet *)values;
- (void)removeMapPoint:(NSSet *)values;

@end
