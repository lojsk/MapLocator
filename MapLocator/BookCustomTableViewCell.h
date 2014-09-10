//
//  BookCustomTableViewCell.h
//  MapLocator
//
//  Created by lojsk on 05/08/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookCustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *LogoView;
@property (weak, nonatomic) IBOutlet UILabel *LogoName;
@property (weak, nonatomic) IBOutlet UILabel *textName;
@property (weak, nonatomic) IBOutlet UILabel *lastDate;

@end
