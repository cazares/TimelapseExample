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
    [self.view addSubview:self.cameraPicker];
    
    self.cameraButton = [[UIButton alloc] init];
    [self setupButton:self.cameraButton title:[EENAPI client].cameraIDList[0]];
    [self.cameraButton addTarget:self action:@selector(cameraButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cameraButton];
    
    self.startTimePicker = [[UIDatePicker alloc] init];
    self.startTimePicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.startTimePicker.backgroundColor = [UIColor whiteColor];
    self.startTimePicker.hidden = YES;
    self.startTimePicker.date = [NSDate date];
    [self.startTimePicker addTarget:self action:@selector(setStartFromPicker)
                   forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.startTimePicker];
    
    self.startButton = [[UIButton alloc] init];
    [self setupButton:self.startButton title:[self.fullDateFormatter stringFromDate:self.startTimePicker.date]];
    [self.startButton addTarget:self action:@selector(startButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startButton];
    
    self.endTimePicker = [[UIDatePicker alloc] init];
    self.endTimePicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.endTimePicker.backgroundColor = [UIColor whiteColor];
    self.endTimePicker.hidden = YES;
    self.endTimePicker.date = [NSDate date];
    [self.endTimePicker addTarget:self action:@selector(setEndFromPicker)
                 forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.endTimePicker];
    
    self.endButton = [[UIButton alloc] init];
    [self setupButton:self.endButton title:[self.fullDateFormatter stringFromDate:self.endTimePicker.date]];
    [self.endButton addTarget:self action:@selector(endButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.endButton];
    
    self.stepTextField = [[EENTextField alloc] initWithDelegate:self placeholder:@"Step between frames"];
    self.stepTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:self.stepTextField];
    
    NSDictionary *views = @{ @"cameraPicker": self.cameraPicker,
                             @"cameraButton": self.cameraButton,
                             @"startPicker": self.startTimePicker,
                             @"startButton": self.startButton,
                             @"endPicker": self.endTimePicker,
                             @"endButton": self.endButton,
                             @"stepTextField": self.stepTextField };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.stepTextField.text = @"1";
    NSArray *cameraIDList = [EENAPI client].cameraIDList;
    [self setupButton:self.cameraButton title:cameraIDList[0]];
}

- (void)setupButton:(UIButton *)button title:(NSString *)title {
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = [UIColor grayColor];
    button.layer.cornerRadius = kCornerRadius;
    NSAttributedString *attributedTitle =
    [[NSAttributedString alloc] initWithString:title
                                    attributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor] }];
    [button setAttributedTitle:attributedTitle forState:UIControlStateNormal];
}

- (void)cameraButtonPressed {
    self.cameraPicker.hidden = !self.cameraPicker.hidden;
    self.startTimePicker.hidden = YES;
    self.endTimePicker.hidden = YES;
}

- (void)startButtonPressed {
    self.cameraPicker.hidden = YES;
    self.startTimePicker.hidden = !self.startTimePicker.hidden;
    self.endTimePicker.hidden = YES;
}

- (void)endButtonPressed {
    self.cameraPicker.hidden = YES;
    self.startTimePicker.hidden = YES;
    self.endTimePicker.hidden = !self.endTimePicker.hidden;
}

- (void)setStartFromPicker {
    self.startButton.titleLabel.text = [self.fullDateFormatter stringFromDate:self.startTimePicker.date];
}

- (void)setEndFromPicker {
    self.endButton.titleLabel.text = [self.fullDateFormatter stringFromDate:self.endTimePicker.date];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [EENAPI client].cameraIDList.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [EENAPI client].cameraIDList[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.cameraButton.titleLabel.text = [EENAPI client].cameraIDList[row];
}

@end
