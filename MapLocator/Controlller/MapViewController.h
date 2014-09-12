//
//  MapViewController.h
//  MapLocator
//
//  Created by lojsk on 29/07/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ImageChanger.h"
#import "DragableView.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
#import "CustomAnnotation.h"
#import <CoreLocation/CoreLocation.h>
#import "APAddressBook.h"
#import "APContact.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "CoreData+MagicalRecord.h"
#import "AutocompleteTable.h"
#import "MessageTable.h"


@interface MapViewController : UIViewController<MKMapViewDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, UIScrollViewDelegate> {
    MKAnnotationView *lastPin;
    MKAnnotationView *selectedPin;
    
    CLLocationManager *locationManager;
    CLLocationCoordinate2D middlePoint;
    
    NSMutableArray *newSpots;
    NSMutableArray *allSpots;
    NSMutableArray *spotHist;
    
    SPGooglePlacesAutocompleteQuery *query;
    
    BOOL is_load;
    BOOL is_not_first;
    double lastTimestamp;
    BOOL list_is_hidden;
    
    int currentOnMap;
    
    AutocompleteTable *autoTable;
    MessageTable *messageTable;
    
    CAGradientLayer *maskLayer;
}
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (weak, nonatomic) IBOutlet UIView *myPinView;
@property (weak, nonatomic) IBOutlet UIView *myPinColor;
@property (weak, nonatomic) IBOutlet UILabel *myPinText;
@property (weak, nonatomic) IBOutlet DragableView *dragHist;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *MessageView;
@property (weak, nonatomic) IBOutlet UIView *NewMessageHeader;
@property (weak, nonatomic) IBOutlet UITextField *myDetailsInput;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarInput;
@property (weak, nonatomic) IBOutlet UITableView *mySearchTable;
@property (weak, nonatomic) IBOutlet UITableView *myHistTable;
@property (weak, nonatomic) IBOutlet UIView *myHistListView;

@property (weak, nonatomic) IBOutlet UIView *messageHeader;
@property (weak, nonatomic) IBOutlet UIButton *messageBack;
@property (weak, nonatomic) IBOutlet UILabel *messageUserLabel;
@property (weak, nonatomic) IBOutlet UITableView *myMessageTable;
@property (weak, nonatomic) IBOutlet MKMapView *myTestMap;

+ (UIImage *) imageWithView:(UIView *)view;
-(void)selectSearch:(id)thePlace;
@end
