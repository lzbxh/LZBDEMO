//
//  ZBImageCliper.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/18.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBImageCliper.h"

@interface ZBImageCliper ()<UIScrollViewDelegate>

@property(strong ,nonatomic)UIScrollView *imgScrollView;
@property(strong ,nonatomic)UIImageView  *selectImgIV;
@property(assign ,nonatomic)CGSize midsize;

@end

@implementation ZBImageCliper

lazyLoad(UIScrollView, imgScrollView)
lazyLoad(UIImageView, selectImgIV)

-(instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ZBSCREENWIDTH, ZBSCREENWIDTH * 9 / 16);       //比例-16 : 9
        [self initUI];
        self.midsize = self.frame.size;
    }
    return self;
}

-(void)initUI {
    self.imgScrollView.frame = self.frame;
    self.imgScrollView.minimumZoomScale = 1.0f;
    self.imgScrollView.maximumZoomScale = 10.0f;
    self.imgScrollView.delegate = self;
    self.imgScrollView.userInteractionEnabled = YES;
    self.imgScrollView.showsVerticalScrollIndicator = NO;
    self.imgScrollView.showsHorizontalScrollIndicator = NO;
    self.imgScrollView.bounces = NO;
    
    self.selectImgIV.frame = self.frame;
    self.selectImgIV.image = GETIMAGEWITHNAME(@"2");
    self.selectImgIV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imgScrollView];
    [self.imgScrollView addSubview:self.selectImgIV];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.selectImgIV;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    LOG(@"offsetX:%f ,offsetY:%f" ,self.imgScrollView.contentOffset.x ,self.imgScrollView.contentOffset.y);
    LOG(@"%f ,%f" ,self.selectImgIV.frame.size.width ,self.selectImgIV.frame.size.height);
}

-(UIImage *)clipImage {
    if (self.selectImgIV.image == nil) {
        LOG(@"没有图片可以截图");
        return nil;
    }
    CGPoint scrollViewOffset = self.imgScrollView.contentOffset;
    CGSize  imgSize =  self.selectImgIV.image.size;
    
    //得到当前IV的width和图片的比例
    CGFloat widthZoom = self.selectImgIV.frame.size.width / imgSize.width;
    CGFloat heightZoom = self.selectImgIV.frame.size.height / imgSize.height;
    CGFloat zoom = widthZoom > heightZoom ? heightZoom : widthZoom;
    LOG(@"widthZoom:%f ,heightZoom:%f" ,widthZoom ,heightZoom);

    
    CGFloat imgWHScale = imgSize.width / imgSize.height;
    CGFloat viewWHScale = self.frame.size.width / self.frame.size.height;
    
    if (imgWHScale == viewWHScale) {        //1.图片的比例与scrollview一样
        LOG(@"正好一样");
    }else if (imgWHScale < viewWHScale) {   //2.左右留边
        LOG(@"左右留边");
    }else {                                 //3.上下留边
        LOG(@"上下留边");
    }
    
    return nil;
    
    
    
//    if (zoom > 1) {
//        zoom = 1;
//    }
    
//    CGRect rec = CGRectMake(scrollViewOffset.x / widthZoom, scrollViewOffset.y / widthZoom, self.midsize.width / widthZoom, self.midsize.height / widthZoom);
//    CGImageRef imageRef = CGImageCreateWithImageInRect(self.selectImgIV.image.CGImage, rec);
//    UIImage *clipImage = [[UIImage alloc]initWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//    return clipImage;
}

//修改拍摄照片的水平度不然会旋转90度
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}



@end




















