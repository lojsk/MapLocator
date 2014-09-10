//
//  MessageCustomTableViewCell.h
//  MapLocator
//
//  Created by lojsk on 19/08/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgText;

@end
