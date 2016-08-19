//
//  ZBImageManager.m
//  LZBDEMO
//
//  Created by 刘智滨 on 16/8/19.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBImageManager.h"

@implementation ZBImageManager

-(instancetype)initWithImage:(UIImage *)img andViewSize:(CGSize)size {
    if (self = [super init]) {
        self.oriImg = img;
        CGSize imgSize = img.size;
        
        //图片相对于IV的缩放比例
        self.widthZoom = imgSize.width / size.width;
        self.heightZoom = imgSize.height / size.height;
        self.minZoom = self.widthZoom < self.heightZoom ? self.widthZoom : self.heightZoom;
        self.imgWHScale = imgSize.width / imgSize.height;

        //图片四边相对于view的空白区域，可能为0
        CGFloat viewWHScale = size.width / size.height;
        
        if (self.imgWHScale == viewWHScale) {       //刚好合适
            self.imgState = IMGSTATE_FIX;
            self.topSpace = 0;
            self.leftSpace = 0;
            self.bottomSpace = 0;
            self.rightSpace = 0;
        }else if (self.imgWHScale < viewWHScale) {  //左右留白
            self.topSpace = self.bottomSpace = 0;
            if (self.minZoom >= 1) {                //图片实际大小比view大
                self.imgState = IMGSTATE_LRSPACE_IMGBIG;
                self.leftSpace = self.rightSpace = (size.width - imgSize.width / self.minZoom) * 0.5;
            }else {                                 //图片实际大小比view小
                self.imgState = IMGSTATE_LRSPACE_IMGSMALL;
                self.leftSpace = self.rightSpace = (size.width - imgSize.width * self.minZoom) * 0.5;
            }
        }else {                                     //上下留白
            self.leftSpace = self.rightSpace = 0;
            if (self.minZoom >= 1) {
                self.imgState = IMGSTATE_TBSPACE_IMGBIG;
                self.topSpace = self.bottomSpace = (size.height - imgSize.height / self.minZoom) * 0.5;
            }else {
                self.imgState = IMGSTATE_TBSPACE_IMGSMALL;
                self.topSpace = self.bottomSpace = (size.height - imgSize.height * self.minZoom) * 0.5;
            }
        }
        
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"imgW:%f ,imgH:%f\n\
            TS:%f ,LS:%f ,BS:%f ,RS:%f\n\
            WZ:%f ,HZ:%f ,MZ:%f ,imgWHScale:%f" ,self.oriImg.size.width ,self.oriImg.size.height,\
            self.topSpace ,self.leftSpace ,self.bottomSpace ,self.rightSpace ,\
            self.widthZoom ,self.heightZoom ,self.minZoom ,self.imgWHScale];
}

@end
