//
//  EENLoginViewController.m
//  TimelapseExample
//
//  Created by Miguel Cazares on 5/27/14.
//  Copyright (c) 2014 EagleEye Networks. All rights reserved.
//

#import "EENLoginViewController.h"

static CGFloat kCornerRadius = 10.0f;

@interface EENLoginViewController ()

@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

@end

@implementation EENLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    self.emailTextField = [[UITextField alloc] init];
    [self setUpTextField:self.emailTextField placeholder:@"Email"];
    [self.view addSubview:self.emailTextField];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.secureTextEntry = YES;
    [self setUpTextField:self.passwordTextField placeholder:@"Password"];
    [self.view addSubview:self.passwordTextField];
    
    UIButton *loginButton = [[UIButton alloc] init];
    NSAttributedString *loginButtonTitle =
        [[NSAttributedString alloc] initWithString:@"Login"
                                        attributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor] }];
    [loginButton setAttributedTitle:loginButtonTitle forState:UIControlStateNormal];
    loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    loginButton.backgroundColor = [UIColor grayColor];
    loginButton.layer.cornerRadius = kCornerRadius;
    [loginButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    NSDictionary *views = @{ @"email": self.emailTextField,
                             @"password": self.passwordTextField,
                             @"login": loginButton };
    [self addConstraints:@"V:|-50-[email(50)]-[password(50)]-[login(50)]" metrics:nil views:views];
    [self centerHorizontallyForView:self.emailTextField width:300];
    [self centerHorizontallyForView:self.passwordTextField width:300];
    [self centerHorizontallyForView:loginButton width:300];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
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
        [constraints addObjectsFromArray:[self addConstraints:@"H:|-(>=1)-[view(width)]-(>=1)-|" metrics:@{@"width": @(width)} views:@{@"view": view}]];
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
}

- (void)loginButtonPressed {
    
}

@end
