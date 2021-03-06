//
//  LoginViewController.m
//  Quotes2.0
//
//  Created by Kyle Raney on 3/3/16.
//  Copyright © 2016 Kyle Raney. All rights reserved.
//

#import "LoginViewController.h"
#import "AppController.h"
#import "KRObjectManager.h"
#import "User.h"
#import "UserManager.h"
#import <RestKit/RestKit.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginButtonPressed:(id)sender {
    
    NSString *username = _usernameTextField.text;
    NSString *password = _passwordTextField.text;
    
    User *user = [[User alloc] init];
    [user setUsername:username];
    [user setPassword:password];
    
    AppController *sc = [AppController sharedController];
    [sc processLoginWithUser:user];

    if ([AppController sharedController].isAuthenticated) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (IBAction)loginButtonPressedEvent:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
