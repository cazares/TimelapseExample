//
//  EENTextField.m
//  TimelapseExample
//
//  Created by Miguel Cazares on 5/27/14.
//  Copyright (c) 2014 EagleEye Networks. All rights reserved.
//

#import "EENTextField.h"
#import "EENAppDelegate.h"

@implementation EENTextField

- (instancetype)initWithDelegate:(id<UITextFieldDelegate>)delegate
                     placeholder:(NSString *)placeholder {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.placeholder = placeholder;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = kCornerRadius;
        self.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    return self;
}

@end
