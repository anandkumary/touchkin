//
//  TKPassCodeView.m
//  TouchKin
//
//  Created by Anand kumar on 7/22/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKPassCodeView.h"
#import "TKPassCodeField.h"

@interface TKPassCodeView ()<TKPassCodeFieldDelegate>

@property (nonatomic, strong) TKPassCodeField *passCode;

@end

@implementation TKPassCodeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializePassCode];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializePassCode];
    }
    return self;
}

-(void) initializePassCode {
    
    TKPassCodeField *passcodeField = [[TKPassCodeField alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 172)];
    passcodeField.delegate = self;
    passcodeField.keyboardType = UIKeyboardTypeNumberPad;
    passcodeField.maximumLength = 4;
    [passcodeField addTarget:self action:@selector(passcodeControlEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self addSubview:passcodeField];
    
    [self setNeedsLayout];
    
    [passcodeField becomeFirstResponder];
    
}

- (BOOL)passcodeField:(TKPassCodeField *)aPasscodeField shouldInsertText:(NSString *)aText {
    
    return YES;
}

/**
 * Ask the delegate that whether passcode can be deleted.
 * If you want to accept deleting passcode, return YES.
 */
- (BOOL)passcodeFieldShouldDeleteBackward:(TKPassCodeField *)aPasscodeField {
    
    return YES;
    
}

#pragma mark - Actions

- (void)passcodeControlEditingChanged:(TKPassCodeField *)sender
{
    if(sender.passcode.length == sender.maximumLength){
       
        if([self.delegate respondsToSelector:@selector(passcode:didTextEntered:) ]){
            [self.delegate passcode:self didTextEntered:sender.passcode];
        }
    }
}


@end
