//
//  SendTouchViewController.h
//  touchkinapp
//
//  Created by Shankar K on 16/04/15.
//  Copyright (c) 2015 touchKin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>

#import <AssetsLibrary/AssetsLibrary.h>		//<<Can delete if not storing videos to the photo library.  Delete the assetslibrary framework too requires this)

#define kImageCapturedSuccessfully @"imageCapturedSuccessfully"

#define CAPTURE_FRAMES_PER_SECOND		30


@interface SendTouchViewController : UIViewController<AVCaptureFileOutputRecordingDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    BOOL WeAreRecording;
    AVCaptureSession *CaptureSession;
    AVCaptureMovieFileOutput *MovieFileOutput;
    AVCaptureDeviceInput *VideoInputDevice;
}
@property (weak, nonatomic) IBOutlet UIView *VideoView;

@property (strong) AVPlayer *player;

@property (strong) AVPlayerLayer *avlayer;

@property (nonatomic) dispatch_queue_t sessionQueue;

@property NSInteger selectedButtontag;

- (IBAction)playvideo:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonplayVideo;

@property (strong, nonatomic) NSURL *videoURL;

@property (retain,nonatomic) AVCaptureVideoPreviewLayer *PreviewLayer;
@property (retain,nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, retain) UIImage *stillImage;

- (void) CameraSetOutputProperties;
- (AVCaptureDevice *) CameraWithPosition:(AVCaptureDevicePosition) Position;
- (IBAction)StartStopButtonPressed:(id)sender;
- (IBAction)CameraToggleButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *gobackLabel;

- (void)image:(UIImage *)image1 didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

@property (weak, nonatomic) IBOutlet UIButton *startButPressed;
@property (weak, nonatomic) IBOutlet UIView *optionView;
- (IBAction)videoButton:(id)sender;
- (IBAction)cameraButton:(id)sender;

@property (strong,nonatomic)UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UIButton *camOption;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property NSInteger bCount;
- (IBAction)nobutton:(id)sender;
- (IBAction)yesbutton:(id)sender;
- (IBAction)cameraOptions:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *startbutton;
- (IBAction)startButtonPressed:(id)sender;

@property (strong,nonatomic)NSMutableArray *user_selectedArray;

@property (weak, nonatomic) IBOutlet UILabel *add_commentLabel;

@property (weak, nonatomic) IBOutlet UIButton *cam_swap;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)goBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *gobackImageView;
@property (weak, nonatomic) IBOutlet UIView *gobackView;

- (IBAction)Sendimageorvideo:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *keepprivateimageView;

@property (weak, nonatomic) IBOutlet UIView *sendaTouchView;

@property (weak, nonatomic) IBOutlet UIView *hiddenScrollViewSaT;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewSaT;

@property (strong,nonatomic) NSMutableArray *dict;
@property (strong,nonatomic) NSMutableArray *user_NameDict;

@property (strong,nonatomic) NSMutableDictionary *imagedict;

@property (strong,nonatomic) UIButton *aButton;

@property (strong,nonatomic) UIImageView *aImage;

@property (strong,nonatomic) NSMutableArray *imageButton;


@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIView *block_user;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_indicator;

@property (strong,nonatomic) UIView *inputAccView;

@property (strong,nonatomic) UIButton *btnDone;

@end
