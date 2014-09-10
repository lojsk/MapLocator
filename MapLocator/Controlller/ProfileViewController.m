//
//  ProfileViewController.m
//  MapLocator
//
//  Created by lojsk on 16/08/14.
//  Copyright (c) 2014 lojsk. All rights reserved.
//

#import "ProfileViewController.h"
#import "NKOColorPickerView.h"
#import "UIColor+Hex.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

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
    
    profileView.layer.cornerRadius = 80;
    profileView.layer.masksToBounds = YES;

    CGFloat hue = ( arc4random() % 256 / 256.0 ); // 0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0, away from black
    UIColor *randomColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    profileView.backgroundColor = randomColor;
    
    // Do any additional setup after loading the view.
    NKOColorPickerView *colorPicker = [[NKOColorPickerView alloc] initWithFrame:CGRectMake(0, 64, 320, 230) color:randomColor andDidChangeColorBlock:^(UIColor *color){
        profileView.backgroundColor = color;
    }];
    
    //Add color picker to your view
    [self.view addSubview:colorPicker];
    
    [nameInput becomeFirstResponder];
    nameInput.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[profileView.backgroundColor cssString] forKey:@"color"];
        NSLog(@"%@", [profileView.backgroundColor cssString]);
        [PFCloud callFunctionInBackground:@"profile"
                           withParameters:@{@"phone": [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"color":  [profileView.backgroundColor cssString], @"name": nameInput.text}
                                    block:^(NSArray *result, NSError *error) {
                                        if (!error) {
                                            [[NSUserDefaults standardUserDefaults] setObject:[result objectAtIndex:0] forKey:@"token"];
                                            
                                        }
                                    }];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                             withString:[string uppercaseStringWithLocale:[NSLocale currentLocale]]];
    return NO;
}


@end
