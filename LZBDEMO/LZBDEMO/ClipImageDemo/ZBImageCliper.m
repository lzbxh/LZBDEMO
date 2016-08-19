//
//  ZBImageCliper.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/18.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBImageCliper.h"
#import "ZBImageManager.h"

@interface ZBImageCliper ()<UIScrollViewDelegate> {
    CGFloat _viewWHScale;
    CGSize _viewSize;
    CGFloat _currentScale;
}

@property(strong ,nonatomic)UIScrollView   *imgScrollView;
@property(strong ,nonatomic)UIImageView    *selectImgIV;
@property(strong ,nonatomic)ZBImageManager *imgMgr;

@end

@implementation ZBImageCliper

lazyLoad(UIScrollView, imgScrollView)
lazyLoad(UIImageView, selectImgIV)

-(instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ZBSCREENWIDTH, ZBSCREENWIDTH * 9.0 / 16.0);       //比例-16 : 9
        [self initUI];
    }
    return self;
}

-(void)initUI {
    self.imgScrollView.frame = self.frame;
    self.imgScrollView.minimumZoomScale = 1.0f;
    self.imgScrollView.maximumZoomScale = 20.0f;
    self.imgScrollView.delegate = self;
    self.imgScrollView.userInteractionEnabled = YES;
    self.imgScrollView.showsVerticalScrollIndicator = NO;
    self.imgScrollView.showsHorizontalScrollIndicator = NO;
    self.imgScrollView.bounces = NO;
    
    self.selectImgIV.frame = self.frame;
    UIImage *image = GETIMAGEWITHNAME(@"2");
    image = [self fixOrientation:image];
    self.selectImgIV.image = image;
    self.selectImgIV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imgScrollView];
    [self.imgScrollView addSubview:self.selectImgIV];
    
    //初始化管理器
    self.imgMgr = [[ZBImageManager alloc]initWithImage:image andViewSize:self.frame.size];
    LOG(@"imgInfo:%@" ,self.imgMgr.description);
    _viewWHScale = self.frame.size.width / self.frame.size.height;
    _viewSize = self.frame.size;
    
    _currentScale = 1.0;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.selectImgIV;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    _currentScale = scale;
//    LOG(@"offsetX:%f ,offsetY:%f" ,self.imgScrollView.contentOffset.x ,self.imgScrollView.contentOffset.y);
//    LOG(@"%f ,%f" ,self.selectImgIV.frame.size.width ,self.selectImgIV.frame.size.height);
}

-(UIImage *)clipImage {
    
    if (self.selectImgIV.image == nil) {
        LOG(@"没有图片可以截图");
        return nil;
    }
    
    //切图
    CGPoint scrollViewOffset = self.imgScrollView.contentOffset;
    //当前情况下缩放比例
    CGRect clipRect = CGRectZero;
    
    switch (self.imgMgr.imgState) {
        case IMGSTATE_FIX:
        {
            LOG(@"比例合适");
            clipRect = CGRectMake(scrollViewOffset.x / _currentScale, scrollViewOffset.y / _currentScale, _viewSize.width / _currentScale, _viewSize.height / _currentScale);
            break;
        }
        case IMGSTATE_LRSPACE_IMGBIG:
        {
            LOG(@"左右留边，图片较大");
            break;
        }
        case IMGSTATE_LRSPACE_IMGSMALL:
        {
            LOG(@"左右留边，图片较小");
            break;
        }
        case IMGSTATE_TBSPACE_IMGBIG:
        {
            LOG(@"上下留边，图片较大");
            break;
        }
        case IMGSTATE_TBSPACE_IMGSMALL:
        {
            LOG(@"上下留边，图片较小");
            //上下留边，y始终从0切起,做个效果不让图片留白切出
            clipRect = CGRectMake(scrollViewOffset.x / _currentScale, 0, _viewSize.width * self.imgMgr.minZoom, _viewSize.height * self.imgMgr.minZoom);
            break;
        }
        default:
            break;
    }

    CGImageRef imageRef = CGImageCreateWithImageInRect(self.selectImgIV.image.CGImage, clipRect);
    UIImage *clipImage = [[UIImage alloc]initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return clipImage;
    
    
//    CGPoint scrollViewOffset = self.imgScrollView.contentOffset;
//    CGSize  imgSize =  self.selectImgIV.image.size;
//    
//    //得到当前IV的width和图片的比例
//
//    CGFloat zoom = 1;
//    
//    LOG(@"widthZoom:%f ,heightZoom:%f" ,self.imgMgr.widthZoom ,self.imgMgr.heightZoom);
//
//    CGFloat currentZoom = self.selectImgIV.frame.size.width / self.frame.size.width;
//    
//    CGRect rec = CGRectZero;
//    if (imgWHScale == viewWHScale) {        //1.图片的比例与scrollview一样
//        LOG(@"正好一样");
//        zoom = self.selectImgIV.frame.size.width / imgSize.width;
//        rec = CGRectMake(scrollViewOffset.x / zoom, scrollViewOffset.y / zoom, self.midsize.width / zoom, self.midsize.height / zoom);
//    }else if (imgWHScale < viewWHScale) {   //2.左右留边
//        LOG(@"左右留边");
//        CGFloat LRSpace = (self.frame.size.width - imgSize.width / minZoom) / 2.0f;
//        CGFloat clipXOffset = scrollViewOffset.x / minZoom - LRSpace;
//        rec = CGRectMake(clipXOffset >= 0 ? clipXOffset : 0, scrollViewOffset.y / minZoom, self.midsize.width / minZoom, self.midsize.height / minZoom);
//    }else {                                 //3.上下留边
//        LOG(@"上下留边");
//        CGFloat TBSpace = 0;
//        if (minZoom >= 1) {     //图片较小
//            TBSpace = (self.frame.size.height - imgSize.height * minZoom) / 2.0f;       //原始比例下的上下空白
//            CGFloat clipYOffset = scrollViewOffset.y / currentZoom - TBSpace * currentZoom;
//            rec = CGRectMake(scrollViewOffset.x / minZoom, clipYOffset > 0 ? clipYOffset / currentZoom : 0, self.midsize.width / minZoom, self.midsize.height / minZoom);
//        }else {                 //图片较大
//            TBSpace = (self.frame.size.height - imgSize.height / minZoom) / 2.0f;
//            CGFloat clipYOffset = scrollViewOffset.y / minZoom - TBSpace;
//            rec = CGRectMake(scrollViewOffset.x / minZoom, clipYOffset >= 0 ? clipYOffset : 0, self.midsize.width / minZoom, self.midsize.height / minZoom);
//        }
//    }
//    
//    CGImageRef imageRef = CGImageCreateWithImageInRect(self.selectImgIV.image.CGImage, rec);
//    UIImage *clipImage = [[UIImage alloc]initWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//    return clipImage;
    
    
    
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




















