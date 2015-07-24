//
//  YLImageEditorVC.h
//  MLImagePicker
//
//  Created by Anand Kumar on 29/05/14.
//  Copyright (c) 2014 Anand Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLImageEditorVC;


typedef NS_ENUM(NSInteger, YLImageEditiorOverlayType) {
    YLImageEditiorSquareOverlay,
    YLImageEditiorCircleOverlay,
};

@protocol YLImageEditorVCDelegate <NSObject>

- (void)imageCropper:(YLImageEditorVC *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(YLImageEditorVC *)cropperViewController;

@end


@interface YLImageEditorVC : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<YLImageEditorVCDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;
@property (nonatomic)YLImageEditiorOverlayType overlayType;


- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
