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

static CGFloat kCornerRadius = 10.0f;

@interface EENLoginViewController ()

@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) EENTimelapseViewController *timelapseViewController;

@end

@implementation EENLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    self.emailTextField = [[UITextField alloc] init];
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [self setUpTextField:self.emailTextField placeholder:@"Email"];
    [self.view addSubview:self.emailTextField];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.secureTextEntry = YES;
    [self setUpTextField:self.passwordTextField placeholder:@"Password"];
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
    [self addConstraints:@"V:|-50-[email(50)]-[password(50)]-[login(50)]" metrics:nil views:views];
    [self centerHorizontallyForView:self.emailTextField width:300];
    [self centerHorizontallyForView:self.passwordTextField width:300];
    [self centerHorizontallyForView:self.loginButton width:300];
    self.timelapseViewController = [[EENTimelapseViewController alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.loginButton.enabled = YES;
}

- (NSArray *)addConstraints:(NSString *)constraint metrics:(NSDictionary *)metrics views:(NSDictionary *)views {
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:metrics views:views];
    [self.view addConstraints:constraints];
    return constraints;
}

- (NSArray *)centerHorizontallyForView:(UIView *)view width:(CGFloat)width {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self.view addConstraint:constraint];
    NSMutableArray *constraints = [@[constraint] mutableCopy];
    if (width > 0) {
        [constraints addObjectsFromArray:[self addConstraints:@"H:|-(>=1)-[view(width)]-(>=1)-|"
                                                      metrics:@{@"width": @(width)} views:@{@"view": view}]];
    }
    return constraints;
}

- (void)setUpTextField:(UITextField *)textField placeholder:(NSString *)placeholder {
    textField.delegate = self;
    textField.placeholder = placeholder;
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.cornerRadius = kCornerRadius;
    textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
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
