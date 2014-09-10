//
//  MessageTable.m
//  MapLocator
//
//  Created by lojsk on 19/08/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import "MessageTable.h"
#import "MessageCustomTableViewCell.h"
#import "UIColor+Hex.h"

#import "MapData.h"

@implementation MessageTable

@synthesize delegate, messageData, messageColor;

#pragma mark tableView
// myTableCategory datasource and delegate method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [messageData count];
}

// add data to cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MapData *map = [messageData objectAtIndex:indexPath.row];
    
    NSString *cellIdentifier = @"MsgLeftCell";
    if([map.from_to doubleValue] == 1) {
        cellIdentifier = @"MsgRightCell";
    }
    MessageCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[MessageCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    cell.msgText.text = map.msg;
    cell.tagView.layer.cornerRadius = 15;
    cell.tagView.layer.masksToBounds = YES;
    if([map.from_to intValue] == 0)
        cell.tagView.backgroundColor = messageColor;
    else
        cell.tagView.backgroundColor = [UIColor colorWithCSS:[[NSUserDefaults standardUserDefaults] objectForKey:@"color"]];
    
    cell.tagLabel.text = [NSString stringWithFormat:@"%d", indexPath.row+1]; // wrong number when is on one number more points
    
  //  cell.textLabel.text = [[searchData objectAtIndex:indexPath.row] name];
    return cell;
}

// deselect row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   if([delegate respondsToSelector:@selector(focusCell:)]) {
        [delegate focusCell:[messageData objectAtIndex:indexPath.row]];
    }
}
/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
}*/


@end
