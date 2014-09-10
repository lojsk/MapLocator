//
//  LoginViewController.m
//  PageViewDemo
//
//  Created by lojsk on 01/07/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "LoginViewController.h"
#import <CommonCrypto/CommonHMAC.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@synthesize prefixNumberField, phoneNumberField, codeNumberField, registerButton, verificyButton, resendSMSButton, formattedNumber;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [phoneNumberField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)firstStepAuditification:(id)sender {
    // Call any number of times
    NSString *numberString = [NSString stringWithFormat:@"%@%@",prefixNumberField.text, phoneNumberField.text];
    if(numberString.length <= 5)
        return;
    
    formattedNumber = numberString;
    formattedNumber = [formattedNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // show input for code
    NSLog(@"%@", formattedNumber);
    [PFCloud callFunctionInBackground:@"send"
                       withParameters:@{@"number": formattedNumber}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        NSLog(@"%@", result);
                                        // result is @"Hello world!"
                                    }
                                }];
    [[NSUserDefaults standardUserDefaults] setObject:formattedNumber forKey:@"phone"];
    
}

@end
