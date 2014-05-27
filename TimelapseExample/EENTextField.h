//
//  EENTextField.h
//  TimelapseExample
//
//  Created by Miguel Cazares on 5/27/14.
//  Copyright (c) 2014 EagleEye Networks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EENTextField : UITextField

- (instancetype)initWithDelegate:(id<UITextFieldDelegate>)delegate
                     placeholder:(NSString *)placeholder;

@end
