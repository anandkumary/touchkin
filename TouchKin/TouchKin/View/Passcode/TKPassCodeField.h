//
//  TKPassCodeField.h
//  TouchKin
//
//  Created by Anand kumar on 7/22/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TKPassCodeFieldDelegate;

@interface TKPassCodeField : UIControl<UIKeyInput>

@property (nonatomic, weak) id<TKPassCodeFieldDelegate> delegate;

@property (nonatomic, strong) NSString      *passcode;

// configurations
@property (nonatomic) NSUInteger            maximumLength;
@property (nonatomic) CGSize                dotSize;
@property (nonatomic) CGFloat           	lineHeight;
@property (nonatomic) CGFloat           	dotSpacing;
@property (nonatomic, strong) UIColor       *dotColor;

@property (nonatomic) UIKeyboardType        keyboardType;

@end

@protocol TKPassCodeFieldDelegate <NSObject>

@optional
/**
 * Ask the delegate that whether passcode field accepts text.
 * If you want to accept entering text, return YES.
 */
- (BOOL)passcodeField:(TKPassCodeField *)aPasscodeField shouldInsertText:(NSString *)aText;

/**
 * Ask the delegate that whether passcode can be deleted.
 * If you want to accept deleting passcode, return YES.
 */
- (BOOL)passcodeFieldShouldDeleteBackward:(TKPassCodeField *)aPasscodeField;

@end
