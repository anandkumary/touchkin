//
//  TKPassCodeField.m
//  TouchKin
//
//  Created by Anand kumar on 7/22/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKPassCodeField.h"

@interface TKPassCodeField ()

@property (strong, nonatomic) NSMutableString       *mutablePasscode;
@property (strong, nonatomic) NSRegularExpression   *nonDigitRegularExpression;

@end

@implementation TKPassCodeField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize
{
    _maximumLength = 4;
    _dotSize = CGSizeMake(18.0f, 19.0f);
    _dotSpacing = 10.0f;
    _lineHeight = 3.0f;
    _dotColor = [UIColor colorWithRed:(92.0/255.0) green:(94.0/255.0) blue:(94.0/255.0) alpha:1.0];
    
    self.backgroundColor = [UIColor clearColor];
    
    _mutablePasscode = [[NSMutableString alloc] initWithCapacity:4];
    
    [self addTarget:self action:@selector(didTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSRegularExpression *)nonDigitRegularExpression
{
    if (nil == _nonDigitRegularExpression) {
        _nonDigitRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"[^0-9]+" options:0 error:nil];
    }
    return _nonDigitRegularExpression;
}

- (NSString *)passcode
{
    return self.mutablePasscode;
}

- (void)setPasscode:(NSString *)passcode
{
    if (passcode) {
        if (passcode.length > self.maximumLength) {
            passcode = [passcode substringWithRange:NSMakeRange(0, self.maximumLength)];
        }
        self.mutablePasscode = [NSMutableString stringWithString:passcode];
    } else {
        self.mutablePasscode = [NSMutableString string];
    }
    
    [self setNeedsDisplay];
}

#pragma mark - UIKeyInput

- (BOOL)hasText
{
    return (self.mutablePasscode.length > 0);
}

- (void)insertText:(NSString *)text
{
    if (self.enabled == NO) {
        return;
    }
    
    if (self.keyboardType == UIKeyboardTypeNumberPad) {
        text = [self.nonDigitRegularExpression stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, text.length) withTemplate:@""];
    }
    
    if (text.length == 0) {
        return;
    }
    
    NSInteger newLength = self.mutablePasscode.length + text.length;
    if (newLength > self.maximumLength) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(passcodeField:shouldInsertText:)]) {
        if (NO == [self.delegate passcodeField:self shouldInsertText:text]) {
            return;
        }
    }
    
    [self.mutablePasscode appendString:text];
    
    [self setNeedsDisplay];
    
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
}

- (void)deleteBackward
{
    if (self.enabled == NO) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(passcodeFieldShouldDeleteBackward:)]) {
        if (NO == [self.delegate passcodeFieldShouldDeleteBackward:self]) {
            return;
        }
    }
    
    if (self.mutablePasscode.length == 0) {
        return;
    }
    
    [self.mutablePasscode deleteCharactersInRange:NSMakeRange(self.mutablePasscode.length - 1, 1)];
    
    [self setNeedsDisplay];
    
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
}

- (UITextAutocapitalizationType)autocapitalizationType
{
    return UITextAutocapitalizationTypeNone;
}

- (UITextAutocorrectionType)autocorrectionType
{
    return UITextAutocorrectionTypeNo;
}

- (UITextSpellCheckingType)spellCheckingType
{
    return UITextSpellCheckingTypeNo;
}

- (BOOL)enablesReturnKeyAutomatically
{
    return YES;
}

- (UIKeyboardAppearance)keyboardAppearance
{
    return UIKeyboardAppearanceDefault;
}

- (UIReturnKeyType)returnKeyType
{
    return UIReturnKeyDone;
}

- (BOOL)isSecureTextEntry
{
    return YES;
}

#pragma mark - UIView

- (CGSize)contentSize
{
    return CGSizeMake(self.maximumLength * _dotSize.width + (self.maximumLength - 1) * _dotSpacing,
                      _dotSize.height);
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGSize contentSize = [self contentSize];
    
    CGPoint origin = CGPointMake(floorf((self.frame.size.width - contentSize.width) * 0.5f),
                                 floorf((self.frame.size.height - contentSize.height) * 0.5f));
    CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, self.dotColor.CGColor);
        
        for (NSUInteger i = 0; i < self.maximumLength; i++) {
            
            if (i < self.mutablePasscode.length) {
                // draw circle
                CGRect circleFrame = CGRectMake(origin.x, origin.y, self.dotSize.width, self.dotSize.height);
                
                UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
                UIColor *textColor = [UIColor colorWithRed:(92.0/255.0) green:(94.0/255.0) blue:(94.0/255.0) alpha:1.0];
                
                NSDictionary *stringAttrs = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,textColor,NSForegroundColorAttributeName, nil];
                
                NSString *drawString = [self.mutablePasscode substringWithRange:NSMakeRange(i, 1)];
                
                [drawString drawInRect:circleFrame withAttributes:stringAttrs];
                
                //CGContextFillEllipseInRect(context, circleFrame);
            } else {
                // draw line
                CGRect lineFrame = CGRectMake(origin.x, origin.y + floorf((self.dotSize.height - self.lineHeight) * 0.5f),
                                              self.dotSize.width, self.lineHeight);
                CGContextFillRect(context, lineFrame);
            }
            
            origin.x += (self.dotSize.width + self.dotSpacing);
        }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return [self contentSize];
}

#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - Actions

- (void)didTouchUpInside:(id)sender
{
    [self becomeFirstResponder];
}


@end
