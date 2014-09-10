//
//  RightMenuViewController.h
//  MapLocator
//
//  Created by lojsk on 30/07/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData+MagicalRecord.h"

@interface RightMenuViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *spotHist;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
