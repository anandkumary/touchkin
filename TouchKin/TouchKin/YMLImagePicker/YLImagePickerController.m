//
//  YLImagePickerController.m
//  MLImagePicker
//
//  Created by Anand Kumar on 28/05/14.
//  Copyright (c) 2014 Anand Kumar. All rights reserved.
//

#import "YLImagePickerController.h"
#import "YLImageEditorVC.h"

#define ORIGINAL_MAX_WIDTH 640.0f


@interface YLImagePickerController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,YLImageEditorVCDelegate>
{
    UIImagePickerController *imgPicker;
}
@end

@implementation YLImagePickerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (void)initialize
{
    if (self == [YLImagePickerController class]) {
      

    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imgPicker  = [[UIImagePickerController alloc]init];
    imgPicker.delegate = self;
    imgPicker.sourceType = _sourceType;
    imgPicker.allowsEditing = NO;
    
    [imgPicker didMoveToParentViewController:self];
    [self addChildViewController:imgPicker];
    
    [self.view addSubview:imgPicker.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    imgPicker = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    portraitImg = [self imageByScalingToMaxSize:portraitImg];
    

    // present the cropper view controller
    YLImageEditorVC *imgCropperVC = [[YLImageEditorVC alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
    imgCropperVC.delegate = self;
    
    [self.navigationController pushViewController:imgCropperVC animated:YES];

    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:NO completion:^() {
        
        if(self.delegate && [self.delegate conformsToProtocol:@protocol(YLImagePickerDelegate)]){
            
            [self.delegate YLImagePickerControllerDidCancel:self];
            
           
        }
    }];
    
}


+(BOOL)isSourceTypeAvailable:(UIImagePickerControllerSourceType)sourceType{
    
    return [UIImagePickerController isSourceTypeAvailable:sourceType];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)imageCropper:(YLImageEditorVC *)cropperViewController didFinished:(UIImage *)editedImage{
    
   // [imgPicker dismissViewControllerAnimated:NO completion:nil];
    
    if(self.delegate && [self.delegate conformsToProtocol:@protocol(YLImagePickerDelegate)]){
        
        [self.delegate YLImagePickerController:self didFinishPickingImage:editedImage];
        
    }

}
- (void)imageCropperDidCancel:(YLImageEditorVC *)cropperViewController{
  
   // [imgPicker dismissViewControllerAnimated:NO completion:nil];
    if(self.delegate && [self.delegate conformsToProtocol:@protocol(YLImagePickerDelegate)]){
        
        [self.delegate YLImagePickerControllerDidCancel:self];
        
    }

}

@end
