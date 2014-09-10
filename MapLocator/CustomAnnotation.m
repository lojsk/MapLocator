//
//  CustomAnnotation.m
//  MapLocator
//
//  Created by lojsk on 05/08/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString*)placeName image:(UIImage*)img andID:(int)theID {
    self = [super init];
    if (self != nil) {
        coordinate = location;
        title = placeName;
        if(!title || [title isEqualToString:@""])
            title = @" ";
        pinID = [NSNumber numberWithInt:theID];
        image = img;
    }
    return self;
}

@synthesize coordinate, subtitle, title, image, pinID;

- (NSString *)title {
    return title;
}

- (NSString *)subtitle {
    return subtitle;
}

-(MKAnnotationView*)annotationView {
    MKAnnotationView *pinView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"CustomAnnotation"];
    
    //pinView.pinColor = MKPinAnnotationColorGreen;
    pinView.canShowCallout = YES;
    //pinView.animatesDrop = YES;
    pinView.image = image;
    
    /*
     UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRemoveGesture:)];
     tgr.numberOfTapsRequired = 2;
     tgr.numberOfTouchesRequired = 1;
     tgr.delegate = self;
     tgr.cancelsTouchesInView = NO;
     [pinView addGestureRecognizer:tgr];
     */
    
    return pinView;
}
@end

