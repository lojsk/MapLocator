//
//  MapViewController.m
//  MapLocator
//
//  Created by lojsk on 29/07/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import "MapViewController.h"
#import "SWRevealViewController.h"
#import "PhoneBookViewController.h"
#import "CustomAnnotation.h"
#import "UIColor+Hex.h"
#import "SPGooglePlacesAutocompletePlace.h"
#import "RightCustomTableViewCell.h"
#import "ListenerViewController.h"

#import "UserData.h"
#import "MapData.h"
#import "PointData.h"

#define MINIMUM_VISIBLE_LATITUDE 0.01
#define MAP_PADDING 1.5

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [MagicalRecord setupAutoMigratingCoreDataStack];
    }
    return self;
}

@synthesize myMapView, myPinView, myPinColor, myPinText, dragHist, MessageView, NewMessageHeader, myDetailsInput, searchBarInput, mySearchTable, myHistTable, myHistListView, messageBack, messageHeader, messageUserLabel, myMessageTable, myTestMap;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentOnMap = 0;
    
    myMapView.showsUserLocation = YES;
    myMapView.delegate = self;
    
    myDetailsInput.delegate = self;
    
    // hist
    dragHist.layer.cornerRadius = 15;
    dragHist.layer.masksToBounds = YES;
    
    // uitableview autocomplete
    autoTable = [[AutocompleteTable alloc] initWithController:self];
    autoTable.delegate = self;
    mySearchTable.delegate = autoTable;
    mySearchTable.dataSource = autoTable;
    
    // uitableview hist
    myHistTable.delegate = self;
    myHistTable.dataSource = self;
    
    // uitableview message
    messageTable = [[MessageTable alloc] init];
    messageTable.delegate = self;
    myMessageTable.delegate = messageTable;
    myMessageTable.dataSource = messageTable;
    
    // uisearchbar
    searchBarInput.delegate = self;
    
    [self detectTap];
    
    // Set the gesture
    [dragHist addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    newSpots = [[NSMutableArray alloc] init];
    allSpots = [[NSMutableArray alloc] init];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"appModel"];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"login"]) {
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    } else {
        [self startLocator];
        [self loadMyLocalMapFrom];
        
        [myHistTable reloadData];
        
        [self loadMyMap];
        is_load = YES;
    }
    
}

- (void) viewDidAppear:(BOOL)animated {
    if(!is_load) {
        [self startLocator];
        [self loadMyLocalMapFrom];
        [myHistTable reloadData];
        
        [self loadMyMap];
        is_load = YES;

    }
}

-(void)setCurrentPosition {
    if(((double)myMapView.userLocation.location.coordinate.latitude) ==  0.0f)
        return;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(myMapView.userLocation.location.coordinate, 1000, 1000);
    MKCoordinateRegion adjustedRegion = [myMapView regionThatFits:viewRegion];
    [myMapView setRegion:adjustedRegion animated:YES];
    is_not_first = YES;
    list_is_hidden = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"bookSegue"]) {
        PhoneBookViewController *vc = [segue destinationViewController];
        vc.msg = myDetailsInput.text;
        vc.points = [[NSMutableArray alloc] init];
        for(MKPointAnnotation *a in newSpots) {
           [vc.points addObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:a.coordinate.latitude], [NSNumber numberWithFloat:a.coordinate.longitude], a.title, nil]];
        }
    }
    
    if ([[segue identifier] isEqualToString:@"listenSegue"]) {
        ListenerViewController *vc = [segue destinationViewController];
        vc.delegate = self;
    }
}

- (void)startLocator {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
   // if(!is_not_first)
       // [self setCurrentPosition];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)detectTap {
    /*
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    tgr.numberOfTapsRequired = 2;
    tgr.numberOfTouchesRequired = 1;
    tgr.delegate = self;
    tgr.cancelsTouchesInView = NO;
    [myMapView addGestureRecognizer:tgr]; */
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    longPress.delegate = self;
    longPress.minimumPressDuration = 0.1f;
    [myMapView addGestureRecognizer:longPress];
    
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
   // if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
     //   return;
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:myMapView];
    CLLocationCoordinate2D touchMapCoordinate = [myMapView convertPoint:touchPoint toCoordinateFromView:myMapView];
    middlePoint = [myMapView convertPoint:CGPointMake(touchPoint.x, touchPoint.y+150) toCoordinateFromView:myMapView];
    
    MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
    pa.coordinate = touchMapCoordinate;
    pa.title = [self addressLocationWithLat:touchMapCoordinate.latitude andLng:touchMapCoordinate.longitude];
    [myMapView addAnnotation:pa];
    
    // add to array
    [newSpots addObject:pa];
    

    [UIView animateWithDuration:0.6
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         myMapView.centerCoordinate = middlePoint;
                         
                         [MessageView setHidden:NO];
                         [NewMessageHeader setHidden:NO];
                         
                         [dragHist setHidden:YES];
                         
                     }
                     completion:^(BOOL finished){

                            [myDetailsInput becomeFirstResponder];
                         
                     }];
}

- (void)handleRemoveGesture:(UIGestureRecognizer *)gestureRecognizer {

}


#pragma mark - to UIImage
- (UIImage *) imageWithView:(UIView *)view withColor:(UIColor*)color andText:(NSString*)text {
    myPinText.text = text;
    myPinColor.backgroundColor = color;
    
    view.layer.cornerRadius = 80;
    view.layer.masksToBounds = YES;
    view.backgroundColor=[UIColor clearColor];
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *newImage = [ImageChanger replaceColor:[UIColor blackColor] inImage:img withTolerance:1.0f];
    newImage = [ImageChanger imageWithImage:newImage scaledToSize:CGSizeMake(40, 40)];
    return [ImageChanger imageByApplyingAlpha:1.0 andImage:newImage];
}



#pragma mark - MKMap
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return  YES;
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
    if(annotation != myMapView.userLocation) {
        if([annotation isKindOfClass:[CustomAnnotation class]]) {
            CustomAnnotation *customView = (CustomAnnotation *)annotation;
            MKAnnotationView *pinView = [myMapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
            pinView = customView.annotationView;
            /*
            if(pinView == nil) {
                
            } else {
                pinView.annotation = annotation;
            }*/
            
            lastPin = pinView;
            return pinView;
        }
    }
    else {
        [myMapView.userLocation setTitle:@"I am here"];
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    //id myAnnotation = [mapView.annotations objectAtIndex:[mapView.annotations count]-1];
   // [mapView selectAnnotation:lastPin.annotation animated:YES];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    // open message
    if(view.annotation != myMapView.userLocation) {
        CustomAnnotation *annotation = view.annotation;
        if([annotation.pinID intValue] != -1)
            [self openMessageView:[spotHist objectAtIndex:[annotation.pinID intValue]]];
    }
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {

}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    if(list_is_hidden) {
        list_is_hidden = NO;
        [UIView animateWithDuration:0.6
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frameRect = myHistListView.frame;
                         frameRect.origin.y += frameRect.size.height;
                         myHistListView.frame = frameRect;
                     }
                     completion:^(BOOL finished){
                         
                        
                         
                     }];
    }
    
}

- (IBAction)openHistList:(id)sender {
    if(!list_is_hidden) {
        list_is_hidden = YES;
        [UIView animateWithDuration:0.6
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect frameRect = myHistListView.frame;
                             frameRect.origin.y -= frameRect.size.height;
                             myHistListView.frame = frameRect;
                         }
                         completion:^(BOOL finished){
                             
                             
                             
                         }];
    }
}

- (IBAction)cancelSendingNewMap:(id)sender {
    [myMapView removeAnnotations:newSpots];
    
    newSpots = [[NSMutableArray alloc] init];
    
    [MessageView setHidden:YES];
    [NewMessageHeader setHidden:YES];
    [myDetailsInput resignFirstResponder];
    selectedPin = nil;
     
    [dragHist setHidden:NO];
}


# pragma mark Keyboard
- (void)keyboardWillShown:(NSNotification*)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.28];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    CGRect frameRect = MessageView.frame;
    frameRect.origin.y -= 216;
    MessageView.frame = frameRect;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.28];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    CGRect frameRect = MessageView.frame;
    frameRect.origin.y += 216;
    MessageView.frame = frameRect;
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

/* transfer to send */
- (IBAction)SendMap:(id)sender {

    
    for(id<MKAnnotation> location in myMapView.annotations) {
        if(location != myMapView.userLocation) {
            PFObject *map = [PFObject objectWithClassName:@"Map"];
            map[@"from"] = @"JM";
            map[@"to"] = @"TM";
            map[@"lat"] = [NSNumber numberWithDouble:location.coordinate.latitude];
            map[@"lng"] = [NSNumber numberWithDouble:location.coordinate.longitude];
            map[@"timestamp"] = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
            map[@"title"] = location.title;
            map[@"street"] = location.subtitle;
            [map saveInBackground];
        }
    }
}


/*
- (IBAction)deleteSelected:(id)sender {
    [myMapView removeAnnotations:[myMapView selectedAnnotations]];
} 
 */


-(NSString*)addressLocationWithLat:(double)lat andLng:(double)lng {
    NSError *error = nil;
    NSString *lookUpString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f", lat, lng];
   // NSLog(@"%@", lookUpString);
    NSData *jsonResponse = [NSData dataWithContentsOfURL:[NSURL URLWithString:lookUpString]];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    
    @try {
        return [[[jsonDict objectForKey:@"results"] objectAtIndex:0] objectForKey:@"formatted_address"];
    }
    @catch (NSException * e) {
        return @"no title";
    }
}
-(void)loadMyLocalMapFrom {
    NSLog(@"count after: %d", [[MapData MR_findAll] count]);
    
    spotHist = [UserData MR_findAllSortedBy:@"last_timestamp" ascending:NO];
    [myHistTable reloadData];
    
    
    
    NSMutableArray *maps = [[NSMutableArray alloc] init];
    int i = 0;
    for(UserData *user in spotHist) {
        NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
        NSArray *sorted = [user.userMap sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
        MapData *map = [sorted objectAtIndex:0];
        for(PointData *point in map.mapPoint) {
            CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([point.lat doubleValue], [point.lng doubleValue]);
            UIImage *img = [self imageWithView:myPinView withColor:[UIColor colorWithCSS:user.color] andText:user.name];
            
            CustomAnnotation *pin = [[CustomAnnotation alloc] initWithCoordinates:coor placeName:point.street image:img andID:i];
            [myMapView addAnnotation:pin];
        }
        if(i < 4)
            [maps addObject:map];
        i++;
    }
    
    [self getRegionParameters:maps];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

-(void)loadMyMap {
    lastTimestamp = 0.0f;
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"timestamp"]);
    [PFCloud callFunctionInBackground:@"mymap"
                       withParameters:@{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"phone": [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"], @"timestamp": [[NSUserDefaults standardUserDefaults] objectForKey:@"timestamp"]}
                                block:^(NSArray *result, NSError *error) {
                                    if (!error) {
                                        NSLog(@"count: %d", [result count]);
                                       // [[NSUserDefaults standardUserDefaults] setObject:[result objectAtIndex:0] forKey:@"token"];
                                        for(PFObject *map in result) {
                                            MapData *mapData = [MapData MR_createEntity];
                                            mapData.from_to = [NSNumber numberWithInt:0];
                                            
                                            PFObject *from = map[@"from"];
                                            if([from[@"phone"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]]) {
                                                from = map[@"to"];
                                                mapData.from_to = [NSNumber numberWithInt:1]; // 0 = to, 1 = from
                                            }
  
                                            mapData.msg = map[@"msg"];
                                            mapData.timestamp = [NSNumber numberWithDouble:[map.updatedAt timeIntervalSince1970]];;
                                            
                                            if(lastTimestamp < [map.updatedAt timeIntervalSince1970]) {
                                                lastTimestamp = [map.updatedAt timeIntervalSince1970];
                                            }
                                            
                                            // detect user
                                            NSArray *users = [UserData MR_findByAttribute:@"phone" withValue:from[@"phone"] andOrderBy:@"phone" ascending:YES];
                                            BOOL isUser = NO;
                                            for(UserData *user in users) {
                                                //NSLog(@"user: %@", user.phone);
                                                isUser = YES;
                                                if([user.timestamp doubleValue] < [from[@"lastChange"] timeIntervalSince1970]) {
                                                    user.phone = from[@"phone"];
                                                    user.name = from[@"name"];
                                                    user.color = from[@"color"];
                                                    user.timestamp = [NSNumber numberWithDouble:[from[@"lastChange"] timeIntervalSince1970]];
                                                    //NSLog(@"update user: %@", user.phone);
                                                }
                                                
                                                if([user.last_timestamp doubleValue] < [mapData.timestamp doubleValue])
                                                    user.last_timestamp = mapData.timestamp;
                                                
                                                mapData.mapUser = user;
                                                [self saveContext];
                                            }
                                            if(!isUser) {
                                                UserData *newUser = [UserData MR_createEntity];
                                                newUser.phone = from[@"phone"];
                                                newUser.name = from[@"name"];
                                                newUser.color = from[@"color"];
                                                newUser.timestamp = [NSNumber numberWithDouble:[from[@"lastChange"] timeIntervalSince1970]];
                                                mapData.mapUser = newUser;
                                                
                                                if([newUser.last_timestamp doubleValue] < [mapData.timestamp doubleValue])
                                                    newUser.last_timestamp = mapData.timestamp;
                                                
                                                [self saveContext];
                                            }
                                            
                                            for(NSArray *point in map[@"points"]) {
                                                PointData *pointData = [PointData MR_createEntity];
                                                pointData.lat = [point objectAtIndex:0];
                                                pointData.lng = [point objectAtIndex:1];
                                                pointData.street = [point objectAtIndex:2];
                                                
                                                [mapData addMapPointObject:pointData];
                                                
                                            }
                                            [self saveContext];
                                            
                                            spotHist = [UserData MR_findAllSortedBy:@"last_timestamp" ascending:NO];
                                            [myHistTable reloadData];
                                            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:lastTimestamp] forKey:@"timestamp"];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                            
                                            
                                        }
                                        
                                        [self loadMyLocalMapFrom];
                                    }
                                }];
}


- (IBAction)locationBegin:(id)sender {
    /*
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    // animation
    CGRect theSize = mySearchInside.frame;
    last = mySearchInside.frame.origin.y;
    theSize.origin.y = -11;
    mySearchInside.frame = theSize;
    [myLastSearchView setHidden:YES];
    [myAutocompleteView setHidden:NO];
    [UIView commitAnimations];
     */
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self NearChanged:nil];
    

}
- (IBAction)NearChanged:(id)sender {
    if([mySearchTable isHidden])
        [mySearchTable setHidden:NO];
       // [self locationBegin:self];
    
    query = [[SPGooglePlacesAutocompleteQuery alloc] init];
    query.input = searchBarInput.text;
    query.radius = 100.0;
    query.language = [[NSUserDefaults standardUserDefaults] valueForKey:@"kOCLanguageViewControllerLanguage"];
    //query.country = [Constants getCountry];
    query.types = SPPlaceTypeGeocode; // Only return geocoding (address) results.
    query.location = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(aTime) object:nil];
    [self performSelector:@selector(aTime) withObject:nil afterDelay:0.4];
}

-(void)aTime {
    //self.autoTable.noResults = NO;
    if([query.input isEqual:@""]) {
        autoTable.searchData = nil;
        [self.mySearchTable reloadData];
        return;
    }
    //self.autoTable.isLoading = YES;
    [mySearchTable reloadData];
    [query fetchPlaces:^(NSArray *places, NSError *error) {
        //self.autoTable.isLoading = NO;
        if (error) {
            //isLatLng = NO;
            //self.autoTable.noResults = YES;
            [mySearchTable reloadData];
        } else {
            //isLatLng = YES;
            autoTable.searchData = places;
            [mySearchTable reloadData];
        }
    }];
}

-(void)selectSearch:(id)thePlace {
    SPGooglePlacesAutocompletePlace *place = thePlace;
    [mySearchTable setHidden:YES];
    searchBarInput.text = place.name;
    [searchBarInput resignFirstResponder];
    
    if (place) {
        [place resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
            //NSLog(@"Placemark: %@", );
            [UIView animateWithDuration:0.6
                                  delay:0.0
                                options: UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 myMapView.centerCoordinate = placemark.location.coordinate;
                             }
                             completion:^(BOOL finished){
                                 
                                 
                             }];
        }];
    }
}

#pragma mark tableView
// myTableCategory datasource and delegate method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [spotHist count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

// add data to cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"RightCell";
    
    RightCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[RightCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:cellIdentifier];
    }
    
    UserData *user = [spotHist objectAtIndex:indexPath.row];
    // Initialization code
    cell.myLogoView.layer.cornerRadius = 30;
    cell.myLogoView.layer.masksToBounds = YES;
    
    cell.myLogoView.backgroundColor = [UIColor colorWithCSS:user.color];
    cell.myLogoLabel.text = user.name;
    cell.nameLabel.text = user.name;
    for(MapData *map in user.userMap) {
        cell.subLabel.text = map.msg; // need sort metod to get last one
    }
    
    return cell;
}

// deselect row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // open message
    [self openMessageView:[spotHist objectAtIndex:indexPath.row]];
   // [self.revealViewController rightRevealToggle:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
}

- (IBAction)closeMessageView:(id)sender {
    [myMapView removeAnnotations:[myMapView annotations]];
    [self loadMyLocalMapFrom];
    
    [messageHeader setHidden:YES];
    [myMessageTable setHidden:YES];
}

-(void)openMessageView:(UserData*)theUser {
    [myMapView removeAnnotations:[myMapView annotations]];
    
    NSMutableArray *maps = [[NSMutableArray alloc] init];
    int i = 1;
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    NSArray *sorted = [theUser.userMap sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
    for(MapData *map in sorted) {
        [maps addObject:map];
        
        NSString *color;
        if([map.from_to intValue] == 0)
            color = theUser.color;
        else
            color = [[NSUserDefaults standardUserDefaults] objectForKey:@"color"];
        
        int j = 0;
        BOOL morePins = NO;
        if([map.mapPoint count] > 1)
            morePins = YES;
        for(PointData *point in map.mapPoint) {
            NSString *text = [NSString stringWithFormat:@"%d", i];
            if(morePins)
                text = [NSString stringWithFormat:@"%d%@", i, [NSString stringWithFormat:@"%c", 97+j]];
            
            CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([point.lat doubleValue], [point.lng doubleValue]);
            UIImage *img = [self imageWithView:myPinView withColor:[UIColor colorWithCSS:color] andText:text];
            
            CustomAnnotation *pin = [[CustomAnnotation alloc] initWithCoordinates:coor placeName:point.street image:img andID:-1];
            [myMapView addAnnotation:pin];
            j++;
        }
        i++;
    }
    
    [self getRegionParameters:maps];
    
    messageUserLabel.text = theUser.name;
    
    messageTable.messageColor = [UIColor colorWithCSS:theUser.color];
    messageTable.messageData = maps;
    [myMessageTable reloadData];
    [messageHeader setHidden:NO];
    [myMessageTable setHidden:NO];
}

-(void)openChirpView:(NSString*)theChirpCode {
    [PFCloud callFunctionInBackground:@"mychirp"
                       withParameters:@{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"phone": [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"], @"chirp": theChirpCode}
                                block:^(NSArray *result, NSError *error) {
                                    if (!error) {
                                        for(PFObject *map in result) {
                                            MapData *mapData = [MapData MR_createEntity];
                                            mapData.from_to = [NSNumber numberWithInt:1];
                                            
                                            mapData.msg = map[@"msg"];
                                            mapData.timestamp = [NSNumber numberWithDouble:[map.updatedAt timeIntervalSince1970]];;
                                            
 
                                            // detect user
                                            NSArray *users = [UserData MR_findByAttribute:@"phone" withValue:@"chirp" andOrderBy:@"phone" ascending:YES];
                                            BOOL isUser = NO;
                                            for(UserData *user in users) {
                                                mapData.mapUser = user;
                                                isUser = YES;
                                            }
                                            if(!isUser) {
                                                UserData *newUser = [UserData MR_createEntity];
                                                newUser.phone = @"chirp";
                                                newUser.name = @"chirp";
                                                newUser.color = @"#000000";
                                                newUser.timestamp = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
                                                mapData.mapUser = newUser;
                                                
                                                [self saveContext];
                                            }
                                            
                                            for(NSArray *point in map[@"points"]) {
                                                PointData *pointData = [PointData MR_createEntity];
                                                pointData.lat = [point objectAtIndex:0];
                                                pointData.lng = [point objectAtIndex:1];
                                                pointData.street = [point objectAtIndex:2];
                                                
                                                [mapData addMapPointObject:pointData];
                                                
                                            }
                                            [self saveContext];
                                            
                                            spotHist = [UserData MR_findAllSortedBy:@"last_timestamp" ascending:NO];
                                            [myHistTable reloadData];
                                        }
                                        
                                        
                                    }
                                }];
}

-(void)focusCell:(MapData*)map {
    [self getRegionParameters:[[NSArray alloc] initWithObjects:map, nil]];
}

-(void)getRegionParameters:(NSArray*)maps {
    if([maps count] == 0)
        return;
    
    double minLatitude = DBL_MAX, maxLatitude = DBL_MIN, minLongitude = DBL_MAX, maxLongitude = DBL_MIN;
    for(MapData *map in maps) {
        for(PointData *point in map.mapPoint) {
            if(minLatitude > [point.lat doubleValue])
                minLatitude = [point.lat doubleValue];
            if(minLongitude > [point.lng doubleValue])
                minLongitude = [point.lng doubleValue];
            if(maxLatitude < [point.lat doubleValue])
                maxLatitude = [point.lat doubleValue];
            if(maxLongitude < [point.lng doubleValue])
                maxLongitude = [point.lng doubleValue];
        }
    }
    
    MKCoordinateRegion region;
    
    region.span.latitudeDelta = (maxLatitude - minLatitude) * MAP_PADDING;
    
    region.span.latitudeDelta = (region.span.latitudeDelta < MINIMUM_VISIBLE_LATITUDE)
    ? MINIMUM_VISIBLE_LATITUDE
    : region.span.latitudeDelta;
    
    region.span.longitudeDelta = (maxLongitude - minLongitude) * MAP_PADDING;
    
    region.center.latitude = maxLatitude;
    region.center.longitude = (minLongitude + maxLongitude) / 2;
    
    
    MKCoordinateRegion scaledRegion = [myMapView regionThatFits:region];
    NSLog(@"%f, %f", scaledRegion.center.latitude, scaledRegion.center.longitude);
    
    region.center.latitude = scaledRegion.center.latitude - scaledRegion.span.latitudeDelta/4;
    
    scaledRegion = [myMapView regionThatFits:region];
    //scaledRegion.span.latitudeDelta = scaledRegion.span.latitudeDelta*2;
    
    
   /* NSLog(@"%f, %f", myMapView.centerCoordinate.latitude, myMapView.centerCoordinate.longitude);
    CGPoint point = [myMapView convertCoordinate:scaledRegion.center toPointToView:myMapView];
    point.y += 100;
    scaledRegion.center = [myMapView convertPoint:point toCoordinateFromView:myMapView];
*/
    
    list_is_hidden = NO;
    [myMapView setRegion:scaledRegion animated:YES];

    list_is_hidden = YES;
}

- (void)moveCenterByOffset:(CGPoint)offset from:(CLLocationCoordinate2D)coordinate
{

}

- (void)saveContext {
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"You successfully saved your context.");
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
}

@end
