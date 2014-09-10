//
//  PassViewController.m
//  MapLocator
//
//  Created by lojsk on 14/08/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import "PassViewController.h"

@interface PassViewController ()

@end

@implementation PassViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@synthesize profileView, nameInput;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [passInput becomeFirstResponder];
    // Do any additional setup after loading the view.
    
    
    profileView.layer.cornerRadius = 80;
    profileView.layer.masksToBounds = YES;
    
    CGFloat hue = ( arc4random() % 256 / 256.0 ); // 0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0, away from black
    UIColor *randomColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    profileView.backgroundColor = randomColor;
    
    // Do any additional setup after loading the view.
    colorPicker = [[NKOColorPickerView alloc] initWithFrame:CGRectMake(0, 64, 320, 230) color:randomColor andDidChangeColorBlock:^(UIColor *color){
        profileView.backgroundColor = color;
    }];
    
    //Add color picker to your view
    //

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@synthesize passInput;

- (IBAction)doneButton:(id)sender {
    
    [PFCloud callFunctionInBackground:@"login"
                       withParameters:@{@"number": [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"], @"code": passInput.text}
                                block:^(NSArray *result, NSError *error) {
                                    if (!error) {
                                        NSLog(@"%@", [result objectAtIndex:0]);
                                        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"login"];
                                        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"timestamp"]) {
                                           [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"timestamp"];
                                        }
                                        [[NSUserDefaults standardUserDefaults] setObject:[result objectAtIndex:0] forKey:@"token"];
                                        // result is @"Hello world!"
                                    }
                                }];
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                             withString:[string uppercaseStringWithLocale:[NSLocale currentLocale]]];
    return NO;
}

- (IBAction)editProfileButton:(id)sender {
    if(is_edit) {
        is_edit = NO;
    } else {
        [self.view addSubview:colorPicker];
        [nameInput becomeFirstResponder];
        nameInput.delegate = self;
        is_edit = YES;
    }
}

@end
