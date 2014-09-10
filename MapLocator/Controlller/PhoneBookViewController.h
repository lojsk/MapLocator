//
//  PhoneBookViewController.h
//  MapLocator
//
//  Created by lojsk on 05/08/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APAddressBook.h"
#import "APContact.h"
#import <Parse/Parse.h>
#import "CoreData+MagicalRecord.h"


@interface PhoneBookViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITextFieldDelegate, UIScrollViewDelegate> {
    NSMutableArray *contactArray;
    NSMutableArray *resultArray;
    NSString *to;
    
    NSMutableArray *friends;
    
}

@property (weak, nonatomic) IBOutlet UITextField *myPersonList;
@property (weak, nonatomic) IBOutlet UIButton *myBackButton;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearch;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) NSMutableArray *points;
@property (strong, nonatomic) NSString *msg;
@end
