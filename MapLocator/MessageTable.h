//
//  MessageTable.h
//  MapLocator
//
//  Created by lojsk on 19/08/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SecondDelegate <NSObject>
@optional
-(void)focusCell:(id)thePlace;
@required
@end

@interface MessageTable : NSObject<UITableViewDataSource, UITableViewDelegate> {
    int numberCounter;
}

@property (strong, nonatomic) NSArray *messageData;
@property (strong, nonatomic) UIColor *messageColor;
@property (nonatomic, retain) id<SecondDelegate> delegate;

@end
