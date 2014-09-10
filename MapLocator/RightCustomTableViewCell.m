//
//  RightCustomTableViewCell.m
//  MapLocator
//
//  Created by lojsk on 30/07/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import "RightCustomTableViewCell.h"

@implementation RightCustomTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
    }
    return self;
}

@synthesize myLogoView;

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
