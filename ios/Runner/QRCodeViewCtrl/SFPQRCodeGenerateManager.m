#import "SFPQRCodeGenerateManager.h"

#import "SFPMacro.h"

static inline UIImage *generateQRCodeWithData(NSData *data) {
    if (!data) {
        return nil;
    }
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    if (!qrFilter) {
        DMLog(@"Error: Could not load filter");
        return nil;
    }
    // L 7% , M 15% , Q 25% , H 30%
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    [qrFilter setValue:data forKey:@"inputMessage"];
    CIImage *aCIImage = [qrFilter valueForKey:@"outputImage"];
    if (!aCIImage) {
        return nil;
    }
    CGImageRef imageRef = [[CIContext contextWithOptions:nil] createCGImage:aCIImage fromRect:aCIImage.extent];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
    CFRelease(imageRef);
    return image;
}

@implementation SFPQRCodeGenerateManager

+ (void)load {
    DMLog(@"");
}

+ (void)initialize {
    DMLog(@"");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        char data[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 0};
        generateQRCodeWithData([NSData dataWithBytes:data length:sizeof(data)]);
    });
}

+ (UIImage *)generateWithDefaultQRCodeData:(NSData *)data imageViewWidth:(CGFloat)imageViewWidth {
    UIImage *image = generateQRCodeWithData(data);
    if (!image) {
        return nil;
    }
    CGSize destSize = CGSizeMake(imageViewWidth, imageViewWidth);
    return [self resizeImageWithoutInterpolation:image size:destSize];
}

+ (UIImage *)generateWithDefaultQRCodeData:(NSData *)data imageViewWidth:(CGFloat)imageViewWidth icon:(UIImage *)icon {
    UIImage *image = [self generateWithDefaultQRCodeData:data imageViewWidth:imageViewWidth];
    if (!image) {
        return nil;
    }
    CGFloat iconWidth = icon.size.width;
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGFloat x = (image.size.width - iconWidth) * 0.5;
    CGFloat y = (image.size.height - iconWidth) * 0.5;
    [icon drawInRect:CGRectMake( x,  y, iconWidth,  iconWidth)];
    UIImage *newImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)resizeImageWithoutInterpolation:(UIImage *)sourceImage size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationNone);
    [sourceImage drawInRect:(CGRect){.size = size}];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)imageWithCIImage: (CIImage *)aCIImage orientation: (UIImageOrientation) anOrientation {
    if (!aCIImage) return nil;
    
    CGImageRef imageRef = [[CIContext contextWithOptions:nil] createCGImage:aCIImage fromRect:aCIImage.extent];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:anOrientation];
    CFRelease(imageRef);
    
    return image;
}


+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


+ (UIImage *)generateWithLogoQRCodeData:(NSData *)data logoImageName:(NSString *)logoImageName logoScaleToSuperView:(CGFloat)logoScaleToSuperView {
    if (!data) {
        return nil;
    }
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setDefaults];
    
    NSData *qrImageData = data;
    
    [filter setValue:qrImageData forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    UIImage *start_image = [UIImage imageWithCIImage:outputImage];
    
    UIGraphicsBeginImageContext(start_image.size);
    
    [start_image drawInRect:CGRectMake(0, 0, start_image.size.width, start_image.size.height)];
    
    NSString *icon_imageName = logoImageName;
    UIImage *icon_image = [UIImage imageNamed:icon_imageName];
    CGFloat icon_imageW = start_image.size.width * logoScaleToSuperView;
    CGFloat icon_imageH = start_image.size.height * logoScaleToSuperView;
    CGFloat icon_imageX = (start_image.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (start_image.size.height - icon_imageH) * 0.5;
    
    [icon_image drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    
    UIImage *final_image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return final_image;
}


+ (UIImage *)generateWithColorQRCodeData:(NSData *)data backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor {
    if (!data) {
        return nil;
    }
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setDefaults];
    
    NSData *qrImageData = data;
    
    [filter setValue:qrImageData forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(9, 9)];
    
    CIFilter * color_filter = [CIFilter filterWithName:@"CIFalseColor"];
    
    [color_filter setDefaults];
    
    [color_filter setValue:outputImage forKey:@"inputImage"];
    
    [color_filter setValue:backgroundColor forKey:@"inputColor0"];
    [color_filter setValue:mainColor forKey:@"inputColor1"];
    
    CIImage *colorImage = [color_filter outputImage];
    
    return [UIImage imageWithCIImage:colorImage];
}


@end

