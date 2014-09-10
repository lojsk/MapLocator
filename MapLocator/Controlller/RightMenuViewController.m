//
//  RightMenuViewController.m
//  MapLocator
//
//  Created by lojsk on 30/07/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import "RightMenuViewController.h"
#import "RightCustomTableViewCell.h"
#import "SWRevealViewController.h"
#import "UIColor+Hex.h"

#import "UserData.h"
#import "MapData.h"
#import "PointData.h"


@interface RightMenuViewController ()

@end

@implementation RightMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myTableView.delegate = self;
    myTableView.dataSource = self;
    spotHist = [UserData MR_findAll];
    
    //myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [self loadMyLocalMap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@synthesize myTableView;

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
    
    [self.revealViewController rightRevealToggle:nil];
}

-(void)loadMyLocalMap {

}


@end
