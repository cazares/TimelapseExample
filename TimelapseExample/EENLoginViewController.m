//
//  EENLoginViewController.m
//  TimelapseExample
//
//  Created by Miguel Cazares on 5/27/14.
//  Copyright (c) 2014 EagleEye Networks. All rights reserved.
//

#import "EENLoginViewController.h"
#import "EENAPI.h"
#import "EENTimelapseViewController.h"
#import "EENAppDelegate.h"
#import "UIView+Constraints.h"
#import "EENTextField.h"

@interface EENLoginViewController ()

@property (nonatomic, strong) EENTextField *emailTextField;
@property (nonatomic, strong) EENTextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) EENTimelapseViewController *timelapseViewController;

@end

@implementation EENLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.emailTextField = [[EENTextField alloc] initWithDelegate:self placeholder:@"Email"];
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:self.emailTextField];
    
    self.passwordTextField = [[EENTextField alloc] initWithDelegate:self placeholder:@"Password"];
    self.passwordTextField.secureTextEntry = YES;
    [self.view addSubview:self.passwordTextField];
    
    self.loginButton = [[UIButton alloc] init];
    NSAttributedString *loginButtonTitle =
        [[NSAttributedString alloc] initWithString:@"Login"
                                        attributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor] }];
    [self.loginButton setAttributedTitle:loginButtonTitle forState:UIControlStateNormal];
    self.loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.loginButton.backgroundColor = [UIColor grayColor];
    self.loginButton.layer.cornerRadius = kCornerRadius;
    [self.loginButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    NSDictionary *views = @{ @"email": self.emailTextField,
                             @"password": self.passwordTextField,
                             @"login": self.loginButton };
    [self.view lhs_addConstraints:@"V:|-50-[email(50)]-[password(50)]-[login(50)]" metrics:nil views:views];
    [self.view lhs_centerHorizontallyForView:self.emailTextField width:300];
    [self.view lhs_centerHorizontallyForView:self.passwordTextField width:300];
    [self.view lhs_centerHorizontallyForView:self.loginButton width:300];
    self.timelapseViewController = [[EENTimelapseViewController alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.loginButton.enabled = YES;
}

- (void)authorizeWithToken:(NSString *)token {
    [[EENAPI client] authorizeUserWithToken:token
                                    success:^(id user) {
                                        NSLog(@"successfully authorized");
                                        [self.navigationController pushViewController:self.timelapseViewController
                                                                             animated:YES];
                                    }
                                    failure:^(NSError *error) {
                                        NSLog(@"%@", error);
                                        self.loginButton.enabled = YES;
                                    }];
}

- (void)loginButtonPressed {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    self.loginButton.enabled = NO;
    [[EENAPI client] authenticateWithUsername:self.emailTextField.text
                                     password:self.passwordTextField.text
                                      success:^(NSString *token) {
                                          NSLog(@"successfully authenticated");
                                          [self authorizeWithToken:token];
                                      }
                                      failure:^(NSError *error) {
                                          NSLog(@"%@", error);
                                          self.loginButton.enabled = YES;
                                      }];
}

@end
