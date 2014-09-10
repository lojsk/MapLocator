//
//  AutocompleteTable.h
//  MapLocator
//
//  Created by lojsk on 17/08/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPGooglePlacesAutocompleteQuery.h"

@protocol SecondDelegate <NSObject>
@optional
-(void)selectSearch:(id)thePlace;
@required
@end

@interface AutocompleteTable : NSObject<UITableViewDataSource, UITableViewDelegate> {
    UIViewController *controller;
    SPGooglePlacesAutocompleteQuery *query;
}

@property (strong, nonatomic) NSArray *searchData;
@property (nonatomic, retain) id<SecondDelegate> delegate;

- (id)initWithController:(id)theController;
@end
