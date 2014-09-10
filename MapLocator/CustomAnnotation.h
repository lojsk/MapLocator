//
//  CustomAnnotation.h
//  MapLocator
//
//  Created by lojsk on 05/08/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotation : NSObject<MKAnnotation> {
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSNumber *pinID;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString*)placeName image:(UIImage*)img andID:(int)theID;
-(MKAnnotationView*)annotationView;

@end
