//
//  LoginViewController.h
//  PageViewDemo
//
//  Created by lojsk on 01/07/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginViewController : UIViewController {
}

@property (weak, nonatomic) NSString *formattedNumber;

@property (weak, nonatomic) IBOutlet UITextField *prefixNumberField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *codeNumberField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *verificyButton;
@property (weak, nonatomic) IBOutlet UIButton *resendSMSButton;

@end
