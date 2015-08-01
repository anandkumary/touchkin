//
//  SendTouchViewController.m
//  touchkinapp
//
//  Created by Shankar K on 16/04/15.
//  Copyright (c) 2015 touchKin. All rights reserved.
//

#import "SendTouchViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface SendTouchViewController ()
{
    NSInteger OCount;
    NSDictionary *callDict;
    UIView *CameraView;
    NSMutableArray *buttonHolderArray;
    UITextField *textField;
    UIView *keyboardView;
    NSString *sessionToken;
}
@end

@implementation SendTouchViewController
@synthesize imageView,gobackImageView,gobackView,imagePickerController,bCount,startbutton,stillImage,stillImageOutput;
@synthesize optionView,camOption,startButton,startButPressed,PreviewLayer,gobackLabel,videoURL;
@synthesize player,keepprivateimageView,sendaTouchView ,VideoView,buttonplayVideo;
@synthesize avlayer;
@synthesize sessionQueue;
@synthesize cam_swap;
@synthesize scrollViewSaT;
@synthesize hiddenScrollViewSaT;
@synthesize dict;
@synthesize imagedict;
@synthesize user_NameDict;
@synthesize aButton;
@synthesize aImage;
@synthesize textView;
@synthesize user_selectedArray;
@synthesize imageButton;
@synthesize activity_indicator;
@synthesize block_user;
@synthesize add_commentLabel;
@synthesize inputAccView;
@synthesize btnDone;


- (void)viewDidLoad {
    [super viewDidLoad];

    //----------------------------------------------------------------------------------------------
    
    //data fetcher
    dict = [[NSMutableArray alloc]init];
    user_NameDict = [[NSMutableArray alloc]init];
    imagedict = [[NSMutableDictionary alloc]init];
    user_selectedArray = [[NSMutableArray alloc]init];
    //---------------------------------------------------------------------------------------------
    [startButton setBackgroundColor:[UIColor redColor]];
    [startButton setImage:[UIImage imageNamed:@"vcamera.png"] forState:UIControlStateNormal];
   buttonHolderArray = [[NSMutableArray alloc] init];
    imageButton = [[NSMutableArray alloc] init];
    self.block_user.hidden = YES;
    self.add_commentLabel.hidden = YES;
    self.activity_indicator.hidden = YES;
    self.buttonplayVideo.hidden = YES;
    self.imageView.hidden = YES;
    self.gobackImageView.hidden = YES;
    self.gobackView.hidden = YES;
    self.bCount = 0;
    self.optionView.hidden = YES;
    self.startButton.hidden = NO;
    self.cam_swap.hidden = NO;
    self.camOption.hidden = NO;
    self.sendaTouchView.hidden = YES;
    self.VideoView.hidden = YES;
    self.hiddenScrollViewSaT.hidden = YES;
    self.textView.hidden = YES;
    self.textView.delegate = self;
    [self registerForKeyboardNotifications];
    self.aImage.hidden = YES;
    self.aImage.image = [UIImage imageNamed:@"select.png"];
    [self createInputAccessoryView];
    [textView setInputAccessoryView:inputAccView];
    
    
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
    
}

-(void)viewDidAppear:(BOOL)animated{
    
   
    
    NSLog(@"Display the preview layer");
    CGRect layerRect = [[[self view] layer] bounds];
    [PreviewLayer setFrame:CGRectMake(0, 0 , self.view.frame.size.width, 300)];
    //[PreviewLayer setBounds:layerRect];
    [PreviewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
    
    //[[[self view] layer] addSublayer:[[self CaptureManager] previewLayer]];
    //We use this instead so it goes on a layer behind our UI controls (avoids us having to manually bring each control to the front):
    
    CameraView = [[UIView alloc] init];
    [[self view] addSubview:CameraView];
    [self.view sendSubviewToBack:CameraView];
    [[CameraView layer] addSublayer:PreviewLayer];
    
    //----- START THE CAPTURE SESSION RUNNING -----
    [CaptureSession startRunning];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImageToPhotoAlbum) name:kImageCapturedSuccessfully object:nil];

}

- (void)scanButtonPressed {
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }

    NSLog(@"about to request a capture from: %@", [self stillImageOutput]);

    [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:videoConnection
                                                         completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
                                                             
                                                             CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
                                                             if (exifAttachments) {
                                                                 NSLog(@"attachements: %@", exifAttachments);
                                                             } else {
                                                                 NSLog(@"no attachments");
                                                             }
                                                        
                                                             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                                                             
                                                             UIImage *image = [[UIImage alloc] initWithData:imageData];
                                                            
                                                             [self setStillImage:image];
                                                             
                                                         }];
    [CaptureSession stopRunning];
    
    CameraView.hidden = YES;
    imageView.image = nil;
    imageView.image =stillImage;
    imageView.hidden = NO;
    sendaTouchView.hidden = NO;
    camOption.hidden = YES;
    startButton.hidden = YES;
    gobackLabel.text = @"Discard images";

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    WeAreRecording = NO;
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
- (IBAction)CameraToggleButtonPressed:(id)sender
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
    optionView.hidden = YES;
    startButton.hidden = NO;
//    camOption.hidden = NO;
    cam_swap.hidden = NO;

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



//********** START STOP RECORDING BUTTON **********
- (IBAction)StartStopButtonPressed:(id)sender
{
           if (!WeAreRecording)
        {
            //----- START RECORDING -----
            NSLog(@"START RECORDING");
            [startButton setImage:[UIImage imageNamed:@"recstop.png"] forState:UIControlStateNormal];

            WeAreRecording = YES;
    
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
           

            [startButton setImage:[UIImage imageNamed:@"vcamera.png"] forState:UIControlStateNormal];

            [MovieFileOutput stopRecording];
        }
}


- (void)saveImageToPhotoAlbum
{
    UIImageWriteToSavedPhotosAlbum([self stillImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else {
        
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
        
        videoURL = outputFileURL;
        NSLog(@"%@",videoURL);
        VideoView.hidden = NO;
        
//---------------- Add Video Preview in view ---------------------------------

        self.player = [AVPlayer playerWithURL:videoURL];
        
        avlayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        avlayer.frame = CGRectMake(0, 0, self.view.frame.size.width,self.VideoView.frame.size.height);
        
        [self.VideoView.layer addSublayer:avlayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[player currentItem]];
        
        self.imageView.hidden = NO;
        CameraView.hidden = YES;
        self.buttonplayVideo.hidden = NO;
      
        //camOption.hidden = YES;
        self.startButton.hidden = YES;
        self.cam_swap.hidden = YES;
        self.hiddenScrollViewSaT.hidden = NO;
        [self scrollingMenu];
        self.textView.hidden = NO;
        self.add_commentLabel.hidden = NO;
        self.optionView.hidden = YES;
        self.sendaTouchView.hidden = NO;

        gobackLabel.text = @"Discard Video";
        
        [CaptureSession stopRunning];
        
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

-(void)scrollingMenu{
    
    
    CGFloat xValue = 10;
    CGRect rect = CGRectMake(xValue, 5, 75, 75);
    CGRect rect1 = CGRectMake(xValue, 80, 70, 20);
    dict =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] ;
    imagedict=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_images"];
    user_NameDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_name"];
    
    for (int i = 0; i<[dict count]; i++)
    {
        aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aButton setBackgroundColor:[UIColor blackColor]];
        [aButton setFrame:rect];
        NSData *data = [imagedict objectForKey:[dict objectAtIndex:i]];
        [aButton setBackgroundImage:[UIImage imageWithData:data]
                           forState:UIControlStateNormal];
        aButton.layer.cornerRadius = 37.5;
        aButton.layer.borderWidth = 3.0;
        aButton.clipsToBounds = YES;
        aButton.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        aButton.tag = i;
        aButton.showsTouchWhenHighlighted = YES;
        [aButton addTarget:self action:@selector(scrollButton:) forControlEvents:UIControlEventTouchUpInside];
        [buttonHolderArray addObject:aButton];
        [scrollViewSaT addSubview:aButton];
        
        UILabel *a_label = [[UILabel alloc]initWithFrame:rect1];
        [a_label setTag:i];
        [a_label setText:[user_NameDict objectAtIndex:i]];
        [a_label setFont:[UIFont systemFontOfSize:11]];
        [a_label setTextColor:[UIColor blackColor]  ];
        [a_label setTextAlignment:NSTextAlignmentCenter];

        CGRect rect2 = CGRectMake(xValue+59, 60, 15, 15);
        aImage = [[UIImageView alloc]initWithFrame:rect2];
        [aImage setTag:i];
        //[aImage setImage:[UIImage imageNamed:@"select.png"]];
        //aImage.hidden = YES;
        [imageButton addObject:aImage];
        [scrollViewSaT addSubview:aImage];
        xValue = xValue + 100;
        rect = CGRectMake(xValue, 5, 75, 75);
        rect1 = CGRectMake(xValue, 80, 70, 20);
       
        [scrollViewSaT setContentSize:CGSizeMake(xValue + 160 , scrollViewSaT.frame.size.height)];
    }
    [self.scrollViewSaT reloadInputViews];
    [scrollViewSaT setShowsHorizontalScrollIndicator:NO];
}

-(IBAction)scrollButton:(id)sender{
    
    UIButton *temp=(UIButton*)sender;
    
    NSString *str   = [NSString stringWithFormat:@"%ld", (long)[temp tag]];
    NSLog(@"%@",str);
    
    if([temp tag] < [dict count]){
        NSInteger cool;
        cool = [str integerValue];
        if ([sender isSelected]) {
            [sender setSelected: NO];
            
            UIButton *button = [buttonHolderArray objectAtIndex:[temp tag]];
            UIImageView *image = [imageButton objectAtIndex:[temp tag]];
            image.hidden = YES;
            button.layer.borderColor = [[UIColor lightGrayColor]CGColor];
            NSString *user_id = [NSString stringWithFormat:@"%@",[dict objectAtIndex:[temp tag]]];
            if ([user_selectedArray containsObject:user_id]) {
                NSLog(@"object exist");
                [user_selectedArray removeObject:user_id];
            }
            
        } else {
            
            [sender setSelected: YES];
               UIButton *button = [buttonHolderArray objectAtIndex:[temp tag]];
                button.layer.borderColor = [[UIColor orangeColor]CGColor];
            [user_selectedArray addObject:[dict objectAtIndex:[temp tag]]];
            UIImageView *image = [imageButton objectAtIndex:[temp tag]];
            image.image = [UIImage imageNamed:@"select.png"];
            image.hidden = NO;




        }
        
    }
    NSLog(@"array%@",user_selectedArray);
    
}



- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    [player pause];
    buttonplayVideo.hidden = NO;
}

//********** VIEW DID UNLOAD **********
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    CaptureSession = nil;
    MovieFileOutput = nil;
    VideoInputDevice = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)buttonPressed{
    bCount = 1;
}



- (IBAction)goBack:(id)sender {
  
    if (bCount == 0) {
            gobackImageView.hidden = NO;
            gobackView.hidden = NO;
            [self buttonPressed];

    }else if(bCount == 1){
        bCount = 0;
        gobackImageView.hidden = YES;
        gobackView.hidden = YES;
        
    }

}

- (IBAction)nobutton:(id)sender {
    [self goBack:self];
}

- (IBAction)yesbutton:(id)sender {
    
    if ([gobackLabel.text isEqualToString:@"Go Back?"]) {
        
       [self performSegueWithIdentifier:@"GoBack" sender:self];
        
    }else if ([gobackLabel.text isEqualToString:@"Discard Video"]){
        CameraView.hidden = NO;
        [CaptureSession startRunning];
        imageView.hidden = YES;
        [player pause];
        [avlayer removeFromSuperlayer];
        VideoView.hidden = YES;
        buttonplayVideo.hidden = YES;
        
       // camOption.hidden = NO;
        
        hiddenScrollViewSaT.hidden = YES;
        textView.hidden = YES;
        add_commentLabel.hidden =YES;
        startButton.hidden = NO;
        cam_swap.hidden = NO;
        sendaTouchView.hidden = YES;
        gobackLabel.text = @"Go Back?";
        self.textView.text = @"";
        [textView resignFirstResponder];
        [user_selectedArray removeAllObjects];
        [buttonHolderArray removeAllObjects];
        [imageButton removeAllObjects];
        [self.scrollViewSaT reloadInputViews];
        
        [self goBack:self];

    }else if ([gobackLabel.text isEqualToString:@"Discard images"]){
        CameraView.hidden = NO;
        [CaptureSession startRunning];
        imageView.hidden = YES;
        sendaTouchView.hidden = YES;
       // camOption.hidden = NO;
        startButton.hidden = NO;
        imageView.hidden = NO;
        gobackLabel.text = @"Go Back?";
        [self goBack:self];

    }
 }

- (IBAction)cameraOptions:(id)sender {
    
    if(bCount == 1){
        bCount = 0;
        gobackImageView.hidden = YES;
        gobackView.hidden = YES;
    }
    //camOption.hidden = YES;
    startButton.hidden = YES;
    optionView.backgroundColor = [UIColor clearColor];
    optionView.hidden = NO;
    
}

- (IBAction)startButtonPressed:(id)sender {
    
    if(bCount == 1){
        bCount = 0;
        gobackImageView.hidden = YES;
        gobackView.hidden = YES;
    }
    
    if([self.startButPressed.imageView.image  isEqual: [UIImage imageNamed:@"cameraimage.png"]])
    {
        [self scanButtonPressed];
        
    }else if([self.startButPressed.imageView.image  isEqual: [UIImage imageNamed:@"vcamera.png"]])
    {   cam_swap.hidden = YES;
        ;
        [self StartStopButtonPressed:self];
        
    }else if([self.startButPressed.imageView.image  isEqual: [UIImage imageNamed:@"recstop.png"]]){
        [self StartStopButtonPressed:self];
    }
}

- (IBAction)videoButton:(id)sender {
    if(bCount == 1){
        bCount = 0;
        gobackImageView.hidden = YES;
        gobackView.hidden = YES;
    }
    camOption.hidden = NO;
    startButton.hidden = NO;
    optionView.hidden = YES;
    cam_swap.hidden = NO;
    [startButton setImage:[UIImage imageNamed:@"vcamera.png"] forState:UIControlStateNormal];
}

- (IBAction)cameraButton:(id)sender {
    camOption.hidden = NO;
    startButton.hidden = NO;
    optionView.hidden = YES;
     [startButton setImage:[UIImage imageNamed:@"cameraimage.png"] forState:UIControlStateNormal];
    if(bCount == 1){
        bCount = 0;
        gobackImageView.hidden = YES;
        gobackView.hidden = YES;
    }
}

- (IBAction)Sendimageorvideo:(id)sender {

    if ([user_selectedArray count] != 0 && ![textView.text isEqualToString:@""]) {
        CameraView.hidden = NO;
        [CaptureSession startRunning];
        imageView.hidden = YES;
        [player pause];
        [avlayer removeFromSuperlayer];
        VideoView.hidden = YES;
        buttonplayVideo.hidden = YES;
        // camOption.hidden = NO;
        hiddenScrollViewSaT.hidden = YES;
        textView.hidden = YES;
        add_commentLabel.hidden = YES;
        startButton.hidden = NO;
        cam_swap.hidden = NO;
        sendaTouchView.hidden = YES;
        gobackLabel.text = @"Go Back?";
        self.textView.text = @"";
        textField.text = @"";
        [textView resignFirstResponder];
        [user_selectedArray removeAllObjects];
        [buttonHolderArray removeAllObjects];
        [imageButton removeAllObjects];
        [self.scrollViewSaT reloadInputViews];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Enter comment and select the person" message:@"Select the person whom you want to share the video" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];

    }
    
}



-(IBAction)removeuserBlock:(id)sender
{
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView1
{
    add_commentLabel.hidden = YES;
    [self textFieldDidBeginEditing:textField];

}
-(void)createInputAccessoryView
{
    
    inputAccView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 100)];
    [inputAccView setBackgroundColor:[UIColor whiteColor]];
    btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(self.view.frame.size.width - 60, 15.0f, 50.0f, 30.0f)];
    [btnDone setTitle:@"OK" forState:UIControlStateNormal];
    [btnDone setBackgroundColor:[UIColor blueColor]];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(textViewShouldEndEditing:) forControlEvents:UIControlEventTouchUpInside];
    CGRect frame = CGRectMake(0, 20, self.view.frame.size.width - 70 , 70);
    textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.textColor = [UIColor whiteColor];
    textField.font = [UIFont systemFontOfSize:15.0];
    textField.placeholder = @"add comment";
    [textField setKeyboardAppearance:UIKeyboardAppearanceDark];
    textField.delegate = self;
    [textField addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEnd];
    textField.backgroundColor = [UIColor lightGrayColor];
    textField.autoresizesSubviews = YES;
    textField.text = NSLineBreakByWordWrapping;
    textField.text = @"";
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [inputAccView addSubview:textField];
    [inputAccView addSubview:btnDone];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField1{
    self.textView.text = textField.text;
    NSLog(@"%@",textView.text);
    [textField1 resignFirstResponder];
    [self.textView resignFirstResponder];
    //textField.text = @"";
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField1
{

    [textField1 becomeFirstResponder];
    [self.textView resignFirstResponder];

}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    [self.textView resignFirstResponder];
    [textField resignFirstResponder];
    return YES;
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];

}

- (IBAction)playvideo:(id)sender {
    [self.player play];
    buttonplayVideo.hidden=YES;
}

- (void)registerForKeyboardNotifications
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}


-(void)keyboardWillShow:(NSNotification *)note{
    
}

@end
