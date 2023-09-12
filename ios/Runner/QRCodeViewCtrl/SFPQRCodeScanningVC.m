
#import "SFPQRCodeScanningVC.h"

#import <YYCategories/YYCategories.h>
#import <Photos/PHPhotoLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SFPQRCodeScanView.h"
#include "qr_pack.h"
#import "SFPHelper.h"
#import "SFPBaseNavigationController.h"
#import "AppTheme.h"

@import AVFoundation;


@interface SFPQRCodeScanningVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) SFPQRCodeScanView *scanRectView;

@property (nonatomic, strong) UIButton *flashlightBtn;
@property (nonatomic, strong) UIButton *imgBtn;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) UIView *trackView;
@property (nonatomic, strong) UIView *percentView;

@property (nonatomic, assign) CGFloat percent;
@property (nonatomic, assign) NSInteger curIndex;
@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) BOOL isFirstApplyOrientation;

@property (nonatomic, strong) SFPQRCodeScanConfig *config;

@property (nonatomic, assign) BOOL isCanUseCamera;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;


@end

@implementation SFPQRCodeScanningVC {
    CGAffineTransform _captureSizeTransform;
}

+ (SFPQRCodeScanningVC *)showQRCodeScanVCWithConfig:(SFPQRCodeScanConfig *)config {
    SFPQRCodeScanningVC *vc = [[SFPQRCodeScanningVC alloc] initWithNibName:nil bundle:nil];
    vc.config = config;
    vc.hidesBottomBarWhenPushed = YES;
    if ([config.fromViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController *)config.fromViewController;
        [navVC pushViewController:vc animated:YES];
    } else if (config.showNavBar) {
        SFPBaseNavigationController *navVC = [[SFPBaseNavigationController alloc] initWithRootViewController:vc];
        navVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [config.fromViewController presentViewController:navVC animated:YES completion:NULL];
    } else {
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [config.fromViewController presentViewController:vc animated:YES completion:NULL];
    }
    return vc;
}

#pragma mark - View Controller Methods


- (instancetype)initWithConfig:(SFPQRCodeScanConfig *)config {
    self = [super initWithNibName:nil bundle:nil];
    if (!self) {
        return nil;
    }
    
    _config = config;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat navigationBarAndStatusBarHeight = navigationBarHeight + statusBarHeight;
    
    CGRect bounds = self.view.bounds;
    bounds.size.height -= navigationBarAndStatusBarHeight;
    DMLog(@"statusBarHeight:%f navigationBarHeight:%f", statusBarHeight, navigationBarHeight);
    
    self.scanRectView = [[SFPQRCodeScanView alloc] initWithFrame:bounds showGuideTips:self.config.showGuideTips];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        [self.view.layer addSublayer:self.previewLayer];
    }
    self.device = device;
    
    if (self.config.showGuideTips && self.config.guideTips) {
        self.scanRectView.guideTipsLabel.text = self.config.guideTips;
    }
    if (self.config.showProgress) {
        self.trackView = [[UIView alloc] initWithFrame:CGRectZero];
        self.trackView.backgroundColor = [SFPColor colorWithString:@"#D8D8D8" opacity:1.0];
        [self.scanRectView addSubview:self.trackView];
        self.trackView.hidden = YES;
        
        self.percentView = [[UIView alloc] initWithFrame:CGRectZero];
        self.percentView.hidden = YES;
        self.percentView.backgroundColor = [SFPColor greenTextColor];
        [self.scanRectView addSubview:self.percentView];
    }
    @weakify(self);
    [self.scanRectView setScanContectRectDidChangeBlock:^{
        @strongify(self);
        DMLog(@"scan rect did change:%@", NSStringFromCGRect(self.scanRectView.scanContentRect));
        self.trackView.frame = ({
            CGRect frame = self.trackView.frame;
            CGFloat width = self.scanRectView.scanContentRect.size.width / 2;
            frame.size.width = width;
            frame.size.height = 6;
            frame.origin.y = CGRectGetMinY(self.scanRectView.scanContentRect) - 20;
            frame.origin.x = self.scanRectView.scanContentRect.origin.x + width / 2;
            frame;
        });
        self.trackView.layer.cornerRadius = self.trackView.height / 2;
        self.percentView.frame = ({
            CGRect frame = self.trackView.frame;
            frame.size.width = 0;
            frame;
        });
        self.percentView.layer.cornerRadius = self.trackView.layer.cornerRadius;
    }];
    [self.view addSubview:self.scanRectView];
//    [self.view addSubview:self.flashlightBtn];
//    [self.view addSubview:self.imgBtn];
    self.view.userInteractionEnabled = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}

- (void)showAlertTips:(NSString *)tips {
    UIAlertController *viewController = [UIAlertController alertControllerWithTitle:NULL message:tips preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [viewController addAction:alertAction];
    [self presentViewController:viewController animated:YES completion:NULL];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (_isCanUseCamera) {
        [self startScan];
    }
    [self.view bringSubviewToFront:self.flashlightBtn];
    [self.view bringSubviewToFront:self.imgBtn];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(_isCanUseCamera){
        [self startScan];
    }
    else{
        if (self.config.iosCameraPermissionsTips.length>0) {
            [self showAlertTips:self.config.iosCameraPermissionsTips];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    DMLog(@"video authStatus:%@ permissions:%@", @(authStatus), self.config.iosCameraPermissionsTips);
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied || AVAuthorizationStatusNotDetermined){
        self.scanRectView.backgroundColor = [UIColor blackColor];
        self.scanRectView.contentView.backgroundColor = [UIColor blackColor];
        _isCanUseCamera = NO;
        self.flashlightBtn.hidden = YES;
        self.imgBtn.hidden = YES;
    } else {
        _isCanUseCamera = YES;
        BOOL isShowGuide = self.config.showGuideTips && self.config.guideTips;
        self.flashlightBtn.hidden = isShowGuide;
        self.imgBtn.hidden = isShowGuide;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopScan];
}

- (void)setupNavigationBar {
    if (self.config.title) {
        self.navigationItem.title = self.config.title;
    } else {
        self.navigationItem.title = @"SCAN";
    }
    UIImage * backImage = [[UIImage imageNamed:@"navi_back_arrow_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    item.tintColor = AppTheme.instance.mainText;
    self.navigationItem.leftBarButtonItem = item;

//    BOOL isShowGuide = self.config.showGuideTips && self.config.guideTips;
//    if(isShowGuide) {
//        UIImage * torch = [UIImage imageNamed:@"nav_torch"];
//        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:torch style:UIBarButtonItemStylePlain target:self action:@selector(flashlightBtnClicked)];
//        item.tintColor = AppTheme.instance.mainText;
//        self.navigationItem.rightBarButtonItem = item;
//    }
}

- (void)leftBarButtonItemAction:(id)sender {
    if (_cancelBlock) {
        self.cancelBlock();
    }
}

- (void)dealloc {
    [self stopScan];
    DMLog(@"view controller dealloc");
}

-(AVCaptureVideoPreviewLayer *)previewLayer{
    if(!_previewLayer){
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    return _previewLayer;
}


-(AVCaptureSession *)session{
    if(!_session) {
        _session = [[AVCaptureSession alloc] init];
        _session.sessionPreset = AVCaptureSessionPresetHigh;
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        CGFloat originX = CGRectGetMinX(self.scanRectView.contentView.frame) / self.view.bounds.size.width;
        CGFloat originY = CGRectGetMinY(self.scanRectView.contentView.frame) / self.view.bounds.size.height;
        CGFloat widthScale = (CGRectGetWidth(self.scanRectView.contentView.frame) - 2.f) / self.view.bounds.size.width;
        CGFloat heightScale = CGRectGetHeight(self.scanRectView.contentView.frame) / self.view.bounds.size.height;
        [output setRectOfInterest:CGRectMake(originY, originX, heightScale, widthScale)];
        
        if(input){
            [_session addInput:input];
            [_session addOutput:output];
            output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        }
    }
    return _session;
}

- (NSData *) decodeQRCodeByteData:(CIQRCodeDescriptor *)descritor {
    if (!descritor) {
        return nil;
    }
    NSData *payload = descritor.errorCorrectedPayload;
    const char *bytes = [payload bytes];
    int mode = (bytes[0] >> 4) & 0x0F;
    if (mode != 4) { // not byte mode
        return nil;
    }
    int cntBits = 0;
    if (descritor.symbolVersion >= 1 && descritor.symbolVersion <= 9) {
        cntBits = 8;
    } else {
        cntBits = 16;
    }
    int offset = cntBits / 4 + 1;
    NSString *hex = descritor.errorCorrectedPayload.hexString;
    NSString *cntHex = [hex substringWithRange:NSMakeRange(1, cntBits / 4)];
    cntHex = [NSString stringWithFormat:@"0x%@", cntHex];
    unsigned int outVal = 0;
    NSScanner* scanner = [NSScanner scannerWithString:cntHex];
    [scanner scanHexInt:&outVal];
    if (outVal <= 0) {
        return nil;
    }
    NSString *rawdata = [hex substringWithRange:NSMakeRange(offset, outVal * 2)];
    return  [NSData dataWithHexString:rawdata];
}

#pragma mark -------- AVCaptureMetadataOutputObjectsDelegate ---------

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count <= 0) {
        return;
    }
    AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
    if (![metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode]) {
        return;
    }
    BOOL commonQR = NO;
    CIQRCodeDescriptor *descritor = (CIQRCodeDescriptor *)metadataObject.descriptor;
    NSData *data = [self decodeQRCodeByteData:descritor];
    if (data) {
        int type = is_bin_qr_packet(data.bytes, data.length);
        if (type != 1 && type != 2) {
            data = nil;
        }
    }
    if (!data && metadataObject.stringValue != nil) {
        commonQR = YES;
        const char *utf8Str = [metadataObject.stringValue UTF8String];
        data = [NSData dataWithBytes:utf8Str length:strlen(utf8Str) + 1];
    }
    if (!data) {
        DMLog(@"paser CIQRCodeDescriptor data failed!");
        return;
    }
    if (!self.config.showProgress) {
        [self playVibrate];
        [self stopScan];
    }
    if (self.completeBlock) {
        self.completeBlock(self, commonQR, data);
    }
}

- (void)startScan {
    [self.scanRectView addTimer];
    if (!self.session.isRunning) {
        [self.session startRunning];
    }
}

- (void)stopScan {
    [self.scanRectView removeTimer];
    if (_session != NULL && _session.isRunning) {
        [_session stopRunning];
    }
}

- (void)updateIndex:(NSInteger)index total:(NSInteger)total {
    if (!self.config.showProgress) {
        return;
    }
    _curIndex = index;
    _total = total;
    if (_total <= 1) {
        self.percentView.hidden = YES;
        self.trackView.hidden = YES;
    }
    self.percentView.hidden = NO;
    self.trackView.hidden = NO;
    _percent = (CGFloat)_curIndex / _total;
    if (_percent > 1.0) {
        _percent = 1.0;
    }
    CGFloat width = self.trackView.width * _percent;
    self.percentView.width = width;
    self.scanRectView.progressLabel.attributedText = [SFPHelper progressAttrWithCur:index total:total];
}

- (void)playVibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma mark flashlight
-(void)flashlightBtnClicked{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if([device hasTorch]) {
        device.torchMode = device.torchMode==AVCaptureTorchModeOff ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
    }
    [device unlockForConfiguration];
}

#pragma mark select photo

-(void)imgBtnClicked{
    [self checkPhotoAccess];
}

-(void)checkPhotoAccess{
    
    if (@available(iOS 14, *)) {
        
        [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self dealWithPhotoAccessStatus:status];
            });
        }];
    }
    else {
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
          
            dispatch_async(dispatch_get_main_queue(), ^{
               
                [self dealWithPhotoAccessStatus:status];
            });
        }];
    }
}

-(void)dealWithPhotoAccessStatus:(PHAuthorizationStatus)status{
    if(status==PHAuthorizationStatusRestricted||status==PHAuthorizationStatusDenied){
        [self showCannotUsePhotosAlert:2];
    }
    else {
        
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        
        UIImage *image = info[UIImagePickerControllerEditedImage];
        if(!image){
            
            image = info[UIImagePickerControllerOriginalImage];
        }
        [self readQRCodeWithImage:image];
    }
}

-(void)readQRCodeWithImage:(UIImage *)image{
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    NSString *result = @"";
    if (features.count == 0) {
        [self showEmptyQRCodeAlert];
        return;
    }
    for (int index = 0; index < [features count]; index ++) {
        CIQRCodeFeature *feature = [features objectAtIndex:index];
        result = feature.messageString;
    }
    if(result.length==0){
        [self showEmptyQRCodeAlert];
        return;
    }
    
    const char *utf8Str = [result UTF8String];
    NSData *data = [NSData dataWithBytes:utf8Str length:strlen(utf8Str) + 1];
    if (self.completeBlock) {
        self.completeBlock(self, YES, data);
    }
    return;
}

-(void)showEmptyQRCodeAlert{
    
    NSString *message = self.config.scan_photo_error;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:self.config.ok style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showCannotUsePhotosAlert:(NSInteger)type{
    NSString *title = nil;
    NSString *message = self.config.no_photo_permission;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:self.config.ok style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)openPhotoAuth{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}


#pragma mark setter/getter

-(UIImagePickerController *)imagePicker{
    
    if(!_imagePicker){
        
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
        _imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    return _imagePicker;
}

@end


