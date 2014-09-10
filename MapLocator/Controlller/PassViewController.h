//
//  PassViewController.h
//  MapLocator
//
//  Created by lojsk on 14/08/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "NKOColorPickerView.h"

@interface PassViewController : UIViewController<UITextFieldDelegate> {
    NKOColorPickerView *colorPicker;
    BOOL is_edit;
}
@property (weak, nonatomic) IBOutlet UITextField *passInput;
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UIView *profileView;
@end
