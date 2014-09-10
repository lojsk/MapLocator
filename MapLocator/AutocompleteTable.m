//
//  AutocompleteTable.m
//  MapLocator
//
//  Created by lojsk on 17/08/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import "AutocompleteTable.h"
#import "SPGooglePlacesAutocompletePlace.h"

@implementation AutocompleteTable

- (id)initWithController:(id)theController {
    self = [super init];
    if (self) {
        controller = theController;
    }
    return self;
}

@synthesize searchData, delegate;

#pragma mark tableView
// myTableCategory datasource and delegate method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchData count];
}

// add data to cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"searchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [[searchData objectAtIndex:indexPath.row] name];
    return cell;
}

// deselect row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([delegate respondsToSelector:@selector(selectSearch:)]) {
        [delegate selectSearch:[searchData objectAtIndex:indexPath.row]];
    }
}

@end
