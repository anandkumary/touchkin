//
//  TKCameraVC.m
//  TouchKin
//
//  Created by Anand kumar on 8/1/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKCameraVC.h"
#import <AVFoundation/AVFoundation.h>
#import "TKMessagePreviewVC.h"

@interface TKCameraVC ()<AVCaptureFileOutputRecordingDelegate>
{
    BOOL WeAreRecording;
    AVCaptureSession *CaptureSession;
    AVCaptureMovieFileOutput *MovieFileOutput;
    AVCaptureDeviceInput *VideoInputDevice;

}
@property (weak, nonatomic) IBOutlet UIView *videoLayer;
@property (weak, nonatomic) IBOutlet UIButton *startbtn;
@property (weak, nonatomic) IBOutlet UIButton *togglebtn;

//Using output video
@property (nonatomic, strong) UIView *outPutPreviewLayer;

@property (strong) NSURL *videoURL;
@property (retain,nonatomic) AVCaptureVideoPreviewLayer *PreviewLayer;
@property (retain,nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (retain,nonatomic) AVPlayer *player;
@property (retain,nonatomic) AVPlayerLayer *avlayer;


@end

@implementation TKCameraVC
@synthesize PreviewLayer;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self FirstLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)FirstLoad{
    
    //---------------------------------
    //----- SETUP CAPTURE SESSION -----
    //---------------------------------
    NSLog(@"Setting up capture session");
    CaptureSession = [[AVCaptureSession alloc] init];
    
    //----- ADD INPUTS -----
    NSLog(@"Adding video input");
    [self addStillImageOutput];
    
    //ADD VIDEO INPUT
    AVCaptureDevice *VideoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (VideoDevice)
    {
        NSError *error;
        VideoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:VideoDevice error:&error];
        if (!error)
        {
            if ([CaptureSession canAddInput:VideoInputDevice])
                [CaptureSession addInput:VideoInputDevice];
            else
                NSLog(@"Couldn't add video input");
        }
        else
        {
            NSLog(@"Couldn't create video input");
        }
    }
    else
    {
        NSLog(@"Couldn't create video capture device");
    }
    
    //ADD AUDIO INPUT
    NSLog(@"Adding audio input");
    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error = nil;
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
    if (audioInput)
    {
        [CaptureSession addInput:audioInput];
    }
    
    //----- ADD OUTPUTS -----
    
    //ADD VIDEO PREVIEW LAYER
    
    NSLog(@"Adding video preview layer");
    [self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:CaptureSession] ];
    
    [[self PreviewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //ADD MOVIE FILE OUTPUT
    
    NSLog(@"Adding movie file output");
    
    MovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    Float64 TotalSeconds = 300;			//Total seconds
    int32_t preferredTimeScale = 30;	//Frames per second
    CMTime maxDuration = CMTimeMakeWithSeconds(TotalSeconds, preferredTimeScale);	//<<SET MAX DURATION
    MovieFileOutput.maxRecordedDuration = maxDuration;
    
    MovieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024;						//<<SET MIN FREE SPACE IN BYTES FOR RECORDING TO CONTINUE ON A VOLUME
    
    if ([CaptureSession canAddOutput:MovieFileOutput])
        [CaptureSession addOutput:MovieFileOutput];
    
    //SET THE CONNECTION PROPERTIES (output properties)
    [self CameraSetOutputProperties];			//(We call a method as it also has to be done after changing camera)
    
    
    //----- SET THE IMAGE QUALITY / RESOLUTION -----
    //Options:
    //	AVCaptureSessionPresetHigh - Highest recording quality (varies per device)
    //	AVCaptureSessionPresetMedium - Suitable for WiFi sharing (actual values may change)
    //	AVCaptureSessionPresetLow - Suitable for 3G sharing (actual values may change)
    //	AVCaptureSessionPreset640x480 - 640x480 VGA (check its supported before setting it)
    //	AVCaptureSessionPreset1280x720 - 1280x720 720p HD (check its supported before setting it)
    //	AVCaptureSessionPresetPhoto - Full photo resolution (not supported for video output)
    
    NSLog(@"Setting image quality");
    [CaptureSession setSessionPreset:AVCaptureSessionPresetMedium];
    if ([CaptureSession canSetSessionPreset:AVCaptureSessionPreset640x480])		//Check size based configs are supported before setting them
        [CaptureSession setSessionPreset:AVCaptureSessionPreset640x480];
    
    //----- DISPLAY THE PREVIEW LAYER -----
    //Display it full screen under out view controller existing controls
    NSLog(@"Display the preview layer");
    
    CGRect layerRect = [[[self view] layer] bounds];
    [PreviewLayer setFrame:CGRectMake(0, 0 , self.view.frame.size.width, 300)];
    //[PreviewLayer setBounds:layerRect];
    [PreviewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
    
    //[[[self view] layer] addSublayer:[[self CaptureManager] previewLayer]];
    //We use this instead so it goes on a layer behind our UI controls (avoids us having to manually bring each control to the front):
    
    [self.videoLayer.layer addSublayer:PreviewLayer];
    
    //----- START THE CAPTURE SESSION RUNNING -----
    [CaptureSession startRunning];
    
}

- (void)addStillImageOutput
{
    [self setStillImageOutput:[[AVCaptureStillImageOutput alloc] init] ];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [[self stillImageOutput] setOutputSettings:outputSettings];
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    [CaptureSession addOutput:[self stillImageOutput]];
}



//********** CAMERA SET OUTPUT PROPERTIES **********
- (void) CameraSetOutputProperties
{
    //SET THE CONNECTION PROPERTIES (output properties)
    AVCaptureConnection *CaptureConnection = [MovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    
    //Set landscape (if required)
    if ([CaptureConnection isVideoOrientationSupported])
    {
        AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationPortrait;		//<<<<<SET VIDEO ORIENTATION IF LANDSCAPE
        [CaptureConnection setVideoOrientation:orientation];
    }
    
    //Set frame rate (if requried)
    //    CMTimeShow(CaptureConnection.videoMinFrameDuration);
    //    CMTimeShow(CaptureConnection.videoMaxFrameDuration);
    //
    //    if (CaptureConnection.supportsVideoMinFrameDuration)
    //        CaptureConnection.videoMinFrameDuration = CMTimeMake(1, CAPTURE_FRAMES_PER_SECOND);
    //    if (CaptureConnection.supportsVideoMaxFrameDuration)
    //        CaptureConnection.videoMaxFrameDuration = CMTimeMake(1, CAPTURE_FRAMES_PER_SECOND);
    //
    //    CMTimeShow(CaptureConnection.videoMinFrameDuration);
    //    CMTimeShow(CaptureConnection.videoMaxFrameDuration);
    
}

//********** GET CAMERA IN SPECIFIED POSITION IF IT EXISTS **********
- (AVCaptureDevice *) CameraWithPosition:(AVCaptureDevicePosition) Position
{
    NSArray *Devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *Device in Devices)
    {
        if ([Device position] == Position)
        {
            return Device;
        }
    }
    return nil;
}

//********** CAMERA TOGGLE **********
- (void)CameraToggle
{
    if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1)		//Only do if device has multiple cameras
    {
        NSLog(@"Toggle camera");
        NSError *error;
        //AVCaptureDeviceInput *videoInput = [self videoInput];
        AVCaptureDeviceInput *NewVideoInput;
        AVCaptureDevicePosition position = [[VideoInputDevice device] position];
        if (position == AVCaptureDevicePositionBack)
        {
            NewVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self CameraWithPosition:AVCaptureDevicePositionFront] error:&error];
        }
        else if (position == AVCaptureDevicePositionFront)
        {
            NewVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self CameraWithPosition:AVCaptureDevicePositionBack] error:&error];
        }
        
        if (NewVideoInput != nil)
        {
            [CaptureSession beginConfiguration];		//We can now change the inputs and output configuration.  Use commitConfiguration to end
            [CaptureSession removeInput:VideoInputDevice];
            if ([CaptureSession canAddInput:NewVideoInput])
            {
                [CaptureSession addInput:NewVideoInput];
                VideoInputDevice = NewVideoInput;
            }
            else
            {
                [CaptureSession addInput:VideoInputDevice];
            }
            
            //Set the connection properties again
            [self CameraSetOutputProperties];
            
            [CaptureSession commitConfiguration];
        }
    }
    
}



//********** DID FINISH RECORDING TO OUTPUT FILE AT URL **********
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections
                error:(NSError *)error
{
    
    NSLog(@"didFinishRecordingToOutputFileAtURL - enter");
    
    BOOL RecordedSuccessfully = YES;
    if ([error code] != noErr)
    {
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
        {
            RecordedSuccessfully = [value boolValue];
        }
    }
    if (RecordedSuccessfully)
    {
        //----- RECORDED SUCESSFULLY -----
        NSLog(@"didFinishRecordingToOutputFileAtURL - success");
        // ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        self.videoURL = outputFileURL;
        NSLog(@"%@",self.videoURL);
        
        //---------------- Add Video Preview in view ---------------------------------
        
        self.player = [AVPlayer playerWithURL:self.videoURL];
        
        self.avlayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        self.avlayer.frame = CGRectMake(0, 0, self.view.frame.size.width,self.videoLayer.frame.size.height);
        
        if(!self.outPutPreviewLayer){
            self.outPutPreviewLayer =[[UIView alloc] initWithFrame:self.view.bounds];
            
            self.outPutPreviewLayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
            
            [self.view addSubview:self.outPutPreviewLayer];
            [self.outPutPreviewLayer.layer addSublayer:self.avlayer];

        }
        
       // [self.player play];
        [self createOutPutPlayButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[self.player currentItem]];
        
        
        [CaptureSession stopRunning];
        
        //
        
        //
        //        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileURL])
        //        {
        //            NSLog(@"library");
        //        }
        //
        //            [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
        //                                        completionBlock:^(NSURL *assetURL, NSError *error)
        //             {
        //                 if (error)
        //                 {
        //
        //                 }
        //             }];
        //        }
        //        
        //        
        //    }
        
    }
}


-(void) createOutPutPlayButton
{

    UIButton *DoneButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 350, 70, 25)];
    [DoneButton setTitle:@"Done" forState:UIControlStateNormal];
    [DoneButton addTarget:self action:@selector(doneCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.outPutPreviewLayer addSubview:DoneButton];

    
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 350, 70, 25)];
    [playButton setTitle:@"Play" forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playOutputVideoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.outPutPreviewLayer addSubview:playButton];
    
    
    UIButton *retakeButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 300, 50, 50)];
    [retakeButton setTitle:@"reTake" forState:UIControlStateNormal];
    [retakeButton addTarget:self action:@selector(recreateCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.outPutPreviewLayer addSubview:retakeButton];
}

-(void)playOutputVideoAction
{
    [self.player play];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    [self.player pause];
   

}

-(void)doneCamera {
    
    TKMessagePreviewVC *messageVc = [self.storyboard instantiateViewControllerWithIdentifier:@"TKMessagePreviewVC"];
    
    messageVc.videoURL = self.videoURL;
    
    [self addChildViewController:messageVc];
    [self.view addSubview:messageVc.view];
    [messageVc didMoveToParentViewController:self];
    
}


-(void)recreateCamera
{
    [self.outPutPreviewLayer removeFromSuperview];
    self.outPutPreviewLayer = nil;
    
    self.startbtn.selected = NO;
    WeAreRecording = NO;
    
    [CaptureSession startRunning];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)toggleButtonAction:(id)sender {
    
    [self CameraToggle];
    
}

- (IBAction)startButtonAction:(UIButton*)sender {
    
    if (!WeAreRecording)
    {
        //----- START RECORDING -----
        NSLog(@"START RECORDING");
        
        WeAreRecording = YES;
        sender.selected = YES;
        
        //Create temporary URL to record to
        NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
        NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:outputPath])
        {
            NSError *error;
            if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
            {
                //Error - handle if requried
            }
        }
        //Start recording
        
        [MovieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
        
    }
    else
    {
        //----- STOP RECORDING -----
        NSLog(@"STOP RECORDING");
        WeAreRecording = NO;
        sender.selected = NO;
        
        [MovieFileOutput stopRecording];
    }
    
}



@end
