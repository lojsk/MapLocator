//
//  DetailViewController.h
//  MapLocator
//
//  Created by lojsk on 29/07/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
