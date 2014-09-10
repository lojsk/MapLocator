//
//  UserData.h
//  MapLocator
//
//  Created by lojsk on 19/08/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MapData;

@interface UserData : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSNumber *last_timestamp;
@property (nonatomic, retain) NSSet *userMap;
@end

@interface UserData (CoreDataGeneratedAccessors)

- (void)addUserMapObject:(MapData *)value;
- (void)removeUserMapObject:(MapData *)value;
- (void)addUserMap:(NSSet *)values;
- (void)removeUserMap:(NSSet *)values;

@end
