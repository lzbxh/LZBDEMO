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
            self.topSpace = 0;
            self.leftSpace = 0;
            self.bottomSpace = 0;
            self.rightSpace = 0;
        }else if (self.imgWHScale < viewWHScale) {  //左右留白
            self.topSpace = self.bottomSpace = 0;
//            if (self.minZoom >= 1) {                //图片实际大小比view大
//                self.leftSpace = self.rightSpace = (size.width - imgSize.width / self.minZoom) * 0.5;
//            }else {                                 //图片实际大小比view小
                self.leftSpace = self.rightSpace = (size.width - imgSize.width / self.minZoom) * 0.5;
//            }
        }else {                                     //上下留白
            self.leftSpace = self.rightSpace = 0;
            self.topSpace = self.bottomSpace = (size.height - imgSize.height / self.minZoom) * 0.5;
        }
        
    }
    return self;
}

@end
