//
//  MessageCustomTableViewCell.m
//  MapLocator
//
//  Created by lojsk on 19/08/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import "MessageCustomTableViewCell.h"

@implementation MessageCustomTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
