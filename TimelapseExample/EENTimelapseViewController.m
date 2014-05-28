//
//  EENTimelapseViewController.m
//  TimelapseExample
//
//  Created by Miguel Cazares on 5/27/14.
//  Copyright (c) 2014 EagleEye Networks. All rights reserved.
//

#import "EENTimelapseViewController.h"
#import "EENAppDelegate.h"
#import "EENAPI.h"
#import "EENTextField.h"
#import "UIView+Constraints.h"

@interface EENTimelapseViewController ()

@property (nonatomic, strong) UIPickerView *cameraPicker;
@property (nonatomic, strong) UIButton *cameraButton;

@property (nonatomic, strong) UIDatePicker *startTimePicker;
@property (nonatomic, strong) UIButton *startButton;

@property (nonatomic, strong) UIDatePicker *endTimePicker;
@property (nonatomic, strong) UIButton *endButton;

@property (nonatomic, strong) EENTextField *stepTextField;
@property (nonatomic, strong) NSDateFormatter *fullDateFormatter;

@end

@implementation EENTimelapseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fullDateFormatter = [[NSDateFormatter alloc] init];
    self.fullDateFormatter.dateFormat = @"MM/dd/yy hh:mm:ss a";
    
    self.cameraPicker = [[UIPickerView alloc] init];
    self.cameraPicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.cameraPicker.delegate = self;
    self.cameraPicker.dataSource = self;
    self.cameraPicker.backgroundColor = [UIColor whiteColor];
    self.cameraPicker.hidden = YES;
    
    self.cameraButton = [[UIButton alloc] init];
    [self setupButton:self.cameraButton title:@""];
    [self.cameraButton addTarget:self action:@selector(cameraButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cameraButton];
    
    self.startTimePicker = [[UIDatePicker alloc] init];
    self.startTimePicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.startTimePicker.backgroundColor = [UIColor whiteColor];
    self.startTimePicker.hidden = YES;
    self.startTimePicker.date = [NSDate date];
    [self.startTimePicker addTarget:self action:@selector(setStartFromPicker) forControlEvents:UIControlEventValueChanged];
    [self.startTimePicker addTarget:self action:@selector(hideAllPickers) forControlEvents:UIControlEventTouchUpOutside];
    
    self.startButton = [[UIButton alloc] init];
    [self setupButton:self.startButton title:[self.fullDateFormatter stringFromDate:self.startTimePicker.date]];
    [self.startButton addTarget:self action:@selector(startButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startButton];
    
    self.endTimePicker = [[UIDatePicker alloc] init];
    self.endTimePicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.endTimePicker.backgroundColor = [UIColor whiteColor];
    self.endTimePicker.hidden = YES;
    self.endTimePicker.date = [NSDate date];
    [self.endTimePicker addTarget:self action:@selector(setEndFromPicker) forControlEvents:UIControlEventValueChanged];
    [self.endTimePicker addTarget:self action:@selector(hideAllPickers) forControlEvents:UIControlEventTouchUpOutside];
    
    self.endButton = [[UIButton alloc] init];
    [self setupButton:self.endButton title:[self.fullDateFormatter stringFromDate:self.endTimePicker.date]];
    [self.endButton addTarget:self action:@selector(endButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.endButton];
    
    self.stepTextField = [[EENTextField alloc] initWithDelegate:self placeholder:@"Step between frames"];
    self.stepTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:self.stepTextField];
    [self.view addSubview:self.cameraPicker];
    [self.view addSubview:self.startTimePicker];
    [self.view addSubview:self.endTimePicker];
    
    NSDictionary *views = @{ @"cameraPicker": self.cameraPicker,
                             @"cameraButton": self.cameraButton,
                             @"startPicker": self.startTimePicker,
                             @"startButton": self.startButton,
                             @"endPicker": self.endTimePicker,
                             @"endButton": self.endButton,
                             @"stepTextField": self.stepTextField };
    CGFloat buttonWidth = 300.0f;
    CGFloat buttonHeight = 50.0f;
    CGFloat pickerWidth = 320.0f;
    NSDictionary *metrics = @{ @"buttonHeight": @(buttonHeight),
                               @"pickerHeight": @(280) };
    [self.view lhs_addConstraints:@"V:|-(100)-[cameraButton(buttonHeight)]-[startButton(buttonHeight)]-[endButton(buttonHeight)]-[stepTextField(buttonHeight)]" metrics:metrics views:views];
    [self.view lhs_centerHorizontallyForView:self.cameraButton width:buttonWidth];
    [self.view lhs_centerHorizontallyForView:self.startButton width:buttonWidth];
    [self.view lhs_centerHorizontallyForView:self.endButton width:buttonWidth];
    [self.view lhs_centerHorizontallyForView:self.stepTextField width:buttonWidth];
    
    [self.view lhs_addConstraints:@"V:|[cameraPicker(pickerHeight)]" metrics:metrics views:views];
    [self.view lhs_addConstraints:@"V:|[startPicker(pickerHeight)]" metrics:metrics views:views];
    [self.view lhs_addConstraints:@"V:|[endPicker(pickerHeight)]" metrics:metrics views:views];
    [self.view lhs_centerHorizontallyForView:self.cameraPicker width:pickerWidth];
    [self.view lhs_centerHorizontallyForView:self.startTimePicker width:pickerWidth];
    [self.view lhs_centerHorizontallyForView:self.endTimePicker width:pickerWidth];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.stepTextField.text = @"1";
    [self setStartFromPicker];
    [self setEndFromPicker];
    [[EENAPI client] getDeviceListWithSuccess:^{
        NSArray *cameraNameList = [EENAPI client].cameraNameList;
        if (cameraNameList.count > 0) {
            [self setTitle:cameraNameList[0] forButton:self.cameraButton];
            [self.cameraPicker reloadAllComponents];
        }
    }
    failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)setTitle:(NSString *)title forButton:(UIButton *)button {
    NSAttributedString *attributedTitle =
    [[NSAttributedString alloc] initWithString:title
                                    attributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor] }];
    [button setAttributedTitle:attributedTitle forState:UIControlStateNormal];
}

- (void)setupButton:(UIButton *)button title:(NSString *)title {
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = [UIColor grayColor];
    button.layer.cornerRadius = kCornerRadius;
    [self setTitle:title forButton:button];
}

- (void)cameraButtonPressed {
    [self hideAllPickers];
    self.cameraPicker.hidden = !self.cameraPicker.hidden;
}

- (void)startButtonPressed {
    [self hideAllPickers];
    self.startTimePicker.hidden = !self.startTimePicker.hidden;
}

- (void)endButtonPressed {
    [self hideAllPickers];
    self.endTimePicker.hidden = !self.endTimePicker.hidden;
}

- (void)setStartFromPicker {
    [self setTitle:[self.fullDateFormatter stringFromDate:self.startTimePicker.date] forButton:self.startButton];
    self.startTimePicker.hidden = YES;
}

- (void)setEndFromPicker {
    [self setTitle:[self.fullDateFormatter stringFromDate:self.endTimePicker.date] forButton:self.endButton];
    self.endTimePicker.hidden = YES;
}

- (void)hideAllPickers {
    self.cameraPicker.hidden = YES;
    self.startTimePicker.hidden = YES;
    self.endTimePicker.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self hideAllPickers];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self hideAllPickers];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [EENAPI client].cameraNameList.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [EENAPI client].cameraNameList[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.cameraButton.titleLabel.text = [EENAPI client].cameraNameList[row];
}

@end
