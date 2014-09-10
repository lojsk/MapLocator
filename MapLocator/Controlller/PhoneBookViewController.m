//
//  PhoneBookViewController.m
//  MapLocator
//
//  Created by lojsk on 05/08/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import "PhoneBookViewController.h"
#import "BookCustomTableViewCell.h"
#import "SplitCustomTableViewCell.h"
#import "UIColor+Hex.h"

#import "UserData.h"
#import "MapData.h"
#import "PointData.h"

@interface PhoneBookViewController ()

@end

@implementation PhoneBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@synthesize myTableView, mySearch, myPersonList, points, msg;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myTableView.delegate = self;
    myTableView.dataSource = self;
    mySearch.delegate = self;
    
    contactArray = [[NSMutableArray alloc] init];
    resultArray = [[NSMutableArray alloc] init];
    
    myPersonList.delegate = self;
    [myPersonList becomeFirstResponder];
    
    [self getPhoneBook];
    
    // prestavi to v app open
}

-(void) getAppUser {
    PFQuery *query = [PFQuery queryWithClassName:@"GameScore"];
    [query whereKey:@"arrayKey" containsAllObjectsInArray:@[@2, @3, @4]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
        } else {
            
        }
    }];
}


-(void) getPhoneBook {
    NSArray *users = [UserData MR_findAll];
    friends = [[NSMutableArray alloc] init];
    APAddressBook *addressBook = [[APAddressBook alloc] init];
    [addressBook loadContacts:^(NSArray *contacts, NSError *error)
     {
         int i = 0;
         // hide activity
         if (!error) {
             // do something with contacts array
             contactArray = [[NSMutableArray alloc] initWithArray:contacts];
             for(APContact *contact in contacts) {
                 if((!contact.firstName && !contact.lastName) || [contact.phones count] == 0) {
                     [contactArray removeObject:contact];
                     continue;
                 }
                 for(UserData *user in users) {
                     if ([user.phone rangeOfString:[contact.phones objectAtIndex:0]].location != NSNotFound) {
                         [contactArray removeObject:contact];
                         NSLog(@"%@", contact.firstName);
                     }
                     if(i == 0)
                         [friends addObject:user];
                 }
                 i++;
             }
             
             resultArray = [contactArray copy];
             [myTableView reloadData];
         } else {
             // show error
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView
// myTableCategory datasource and delegate method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return [friends count];
    return [resultArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

// add data to cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"BookCell";
    BookCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[BookCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:cellIdentifier];
    }
    
    NSArray *phoneNumbers = [((APContact*)[resultArray objectAtIndex:indexPath.row]) phones];
    NSString *firstName = [((APContact*)[resultArray objectAtIndex:indexPath.row]) firstName];
    NSString *lastName = [((APContact*)[resultArray objectAtIndex:indexPath.row]) lastName];
    NSString *logoName = @"";
    if(lastName) {
        if(firstName) {
            logoName = [NSString stringWithFormat:@"%@%@",[firstName substringToIndex:1], [lastName substringToIndex:1]];
        } else {
            logoName = [lastName substringToIndex:2];
            firstName = @"";
        }
    } else {
        if(firstName) {
            logoName = [firstName substringToIndex:2];
        } else {
            firstName = @"";
        }
        lastName = @"";
    }
    
    // Initialization code
    cell.LogoView.layer.cornerRadius = 20;
    cell.LogoView.layer.masksToBounds = YES;
    
    if(indexPath.section != 0) {
        cell.LogoView.backgroundColor = [UIColor grayColor];
        cell.LogoName.text = logoName;
        cell.textName.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    
        if([phoneNumbers count] > 0)
            cell.lastDate.text = [phoneNumbers objectAtIndex:0];
    } else {
        UserData *user = [friends objectAtIndex:indexPath.row];
        cell.LogoView.backgroundColor = [UIColor colorWithCSS:user.color];
        cell.LogoName.text = user.name;
        cell.textName.text = user.name;
        
        
        if([phoneNumbers count] > 0)
            cell.lastDate.text = user.phone;
    }
    
    return cell;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [myPersonList resignFirstResponder];
}

// deselect row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BookCustomTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    myPersonList.text = [NSString stringWithFormat:@"%@, %@",myPersonList.text, cell.textName.text];
    to = cell.lastDate.text;
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self onlyMacthPhoneBook:[searchBar.text lowercaseString]];
}


-(void) onlyMacthPhoneBook:(NSString*)searchString {
    if([searchString isEqualToString:@""]) {
        resultArray = [contactArray copy];
        [myTableView reloadData];
        return;
    }
    
    resultArray = [[NSMutableArray alloc] init];
    for(APContact *contact in contactArray) {
        if ([[[NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName] lowercaseString] rangeOfString:searchString].location != NSNotFound) {
            [resultArray addObject:contact];
        }
    }
    [myTableView reloadData];
}


- (IBAction)backButtonDown:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)didEditingSearch:(id)sender {
    [self onlyMacthPhoneBook:[myPersonList.text lowercaseString]];
}

- (IBAction)sendButton:(id)sender {
    [to stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(![to hasPrefix:@"+"]) {
        to = [NSString stringWithFormat:@"+386%@", to]; // TODO: prefix of your selected country
    }
    [PFCloud callFunctionInBackground:@"map"
                       withParameters:@{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"from": [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"], @"to": to, @"points": points, @"msg": msg}
                                block:^(NSArray *result, NSError *error) {
                                    if (!error) {
                                        [[NSUserDefaults standardUserDefaults] setObject:[result objectAtIndex:0] forKey:@"token"];
                                        NSLog(@"%@", result);
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                    }
                                }];
    
    /*
     Parse.Cloud.run('map', {token: readCookie("token"), from: readCookie("phone"), to: toVal, points: points, msg: msgVal}, {
     success: function(result) {
     // result is 'Hello world!'
     alert(result);
     },
     error: function(error) {
     alert(error.message);
     }
     });
     */
}

@end
