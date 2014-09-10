//
//  RightCustomTableViewCell.h
//  MapLocator
//
//  Created by lojsk on 30/07/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightCustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *myLogoView;
@property (weak, nonatomic) IBOutlet UILabel *myLogoLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@end
