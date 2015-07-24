//
//  YLImagePickerController.h
//  MLImagePicker
//
//  Created by Anand Kumar on 28/05/14.
//  Copyright (c) 2014 Anand Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLImagePickerController;

typedef NS_ENUM(NSInteger, YLImagePickerControllerOverlayType) {
    YLImagePickerControllerSquareOverlay,
    YLImagePickerControllerCircleOverlay,
};

typedef NS_ENUM(NSInteger, YLImagePickerControllerDimensions) {
    YLImagePickerControllerNoneDimension,
    YLImagePickerControllerSquareSmallDimension,
    YLImagePickerControllerSquareMediumDimension,
    YLImagePickerControllerSquareLargeDimension,
    YLImagePickerControllerCircleSmallDimension,
    YLImagePickerControllerCircleMediumDimension,
    YLImagePickerControllerCircleLargeDimension
};

@protocol YLImagePickerDelegate <NSObject>

- (void)YLImagePickerControllerDidCancel:(YLImagePickerController *)picker;

- (void)YLImagePickerController:(YLImagePickerController *)picker didFinishPickingImage:(UIImage *)image ;

@end

@interface YLImagePickerController : UIViewController

@property (nonatomic, assign) BOOL allowCustomEditing;
@property (nonatomic) UIImagePickerControllerSourceType sourceType;
@property (nonatomic) YLImagePickerControllerOverlayType overlayType;
@property (nonatomic) YLImagePickerControllerDimensions dimensionType;
@property (nonatomic) BOOL allowEditing;
@property (nonatomic) BOOL showCameraControls;
@property (nonatomic, assign)id<YLImagePickerDelegate>delegate;

@property(nonatomic,retain) UIView   *cameraOverlayView ;
@property(nonatomic) CGAffineTransform cameraViewTransform;

+(BOOL)isSourceTypeAvailable:(UIImagePickerControllerSourceType)sourceType;


@end
