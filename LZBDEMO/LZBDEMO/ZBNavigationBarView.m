//
//  ZBNavigationBarView.m
//  LZBDEMO
//
//  Created by 伙伴行 on 16/8/12.
//  Copyright © 2016年 伙伴行. All rights reserved.
//

#import "ZBNavigationBarView.h"

@interface ZBNavigationBarView()

@property(nonatomic,strong)UIView *leftView;

@property(nonatomic,strong)UIView *rightView;

@property(nonatomic,strong)UIView *titleView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(strong ,nonatomic)UIView *line;

@end

@implementation ZBNavigationBarView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self drawLine];
    }
    return self;
}

- (void)drawLine
{
    self.line = [[UIView alloc]initWithFrame:CGRectMake(0, Content_Y-0.5, ZBSCREENWIDTH, 0.5)];
    self.line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.line];
}

-(void)isDisShadowLine:(BOOL)isDis {
    self.line.hidden = !isDis;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
}

-(void)setTitle:(NSString *)string{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, NavigationBarWidth-20, 44)];
    _titleLabel.text = string;
    _titleLabel.font = NavigationBarTitleFont;
    //    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textColor = NavigationTitleTextColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    if (_titleView) {
        [_titleView removeFromSuperview];
        _titleView = nil;
    }
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, NavigationBarWidth, NavigationBarHeight-20)];
    [self adjustTitleFrame];
    [_titleView addSubview:_titleLabel];
    [self addSubview:_titleView];
}

-(void)setTitleWithAttributedString:(NSAttributedString*)string;
{
    [self setTitle:@""];
    
    self.titleLabel.attributedText = string;
}

-(void)setLeftButton:(UIButton *)button{
    if (_leftView) {
        [_leftView removeFromSuperview];
        _leftView = nil;
    }
    _leftView = button;
    if (_leftView) {
        CGRect rect = button.frame;
        rect.origin.x = 10;
        rect.origin.y = 20+rect.origin.y;
        _leftView.frame = rect;
        [self addSubview:_leftView];
        
        [self adjustTitleFrame];
    }
}

-(void)setRightButton:(UIButton *)button{
    if (_rightView) {
        [_rightView removeFromSuperview];
        _rightView = nil;
    }
    
    _rightView = button;
    if (_rightView) {
        CGRect rect = _rightView.frame;
        rect.origin.y = 20+rect.origin.y;
        rect.origin.x = NavigationBarWidth-rect.size.width-10;
        _rightView.frame = rect;
        
        [self addSubview:_rightView];
        
        [self adjustTitleFrame];
    }
}

-(UIButton *)getRightButton
{
    return (UIButton *)_rightView;
}

-(void)setLeftView:(UIView *)view{
    if (_leftView) {
        [_leftView removeFromSuperview];
        _leftView = nil;
    }
    
    _leftView = view;
    
    if (_leftView) {
        CGRect rect = _leftView.frame;
        rect.origin.y = rect.origin.y+20;
        _leftView.frame = rect;
        [self addSubview:_leftView];
        
        [self adjustTitleFrame];
    }
}

-(void)setRightView:(UIView *)view{
    if (_rightView) {
        [_rightView removeFromSuperview];
        _rightView = nil;
    }
    
    _rightView = view;
    if (_rightView) {
        CGRect rect = _rightView.frame;
        rect.origin.y = rect.origin.y+20;
        rect.origin.x = NavigationBarWidth-rect.size.width;
        _rightView.frame = rect;
        [self addSubview:_rightView];
        
        [self adjustTitleFrame];
    }
    
}

-(void)setTitleView:(UIView *)view{
    if (_titleView) {
        [_titleView removeFromSuperview];
        _titleView = nil;
    }
    
    _titleView = view;
    if (_titleView) {
        CGRect rect = _titleView.frame;
//#warning 待验证 原语句 rect.origin.y +=20;
        rect.origin.y +=20;
        rect.origin.x = (NavigationBarWidth-rect.size.width)/2;
        _titleView.frame = rect;
        [self addSubview:_titleView];
        
        [self adjustTitleFrame];
    }
}

-(UIView *)getTitleView
{
    return _titleView;
}

-(void)adjustTitleFrame{
    if (_titleView) {
        CGRect titleLabelRect = _titleLabel.frame;
        CGRect titleViewRect = _titleView.frame;
        CGSize titleSize = sizeWithText(_titleLabel.text, @{NSFontAttributeName:NavigationBarTitleFont }, CGSizeMake(200, 0));
        
        if (_titleLabel) {
            
            if (_leftView&&!_rightView) {
                if (titleSize.width < NavigationBarWidth-(_leftView.frame.origin.x+_leftView.frame.size.width)) {
                    titleViewRect.size.width = NavigationBarWidth- 2*_leftView.frame.size.width;
                    titleViewRect.origin.x = (NavigationBarWidth-titleViewRect.size.width)/2;
                    titleLabelRect.size.width = titleSize.width <= titleViewRect.size.width ? titleSize.width : titleViewRect.size.width;
                    titleLabelRect.origin.x = (titleViewRect.size.width-titleLabelRect.size.width)/2;
                }
            }else if (!_leftView&&_rightView){
                if (titleSize.width<_rightView.frame.origin.x) {
                    titleViewRect.size.width = NavigationBarWidth-2*_rightView.frame.size.width;
                    titleViewRect.origin.x = (NavigationBarWidth-titleViewRect.size.width)/2;
                    titleLabelRect.size.width = titleSize.width;
                    titleLabelRect.origin.x = (titleViewRect.size.width-titleLabelRect.size.width)/2;
                }else{
                    
                }
            }else if (_leftView&&_rightView){
                float leftWidth = _leftView.frame.size.width;
                float rightWidth = _rightView.frame.size.width;
                float width = MAX(leftWidth, rightWidth);
                if (titleSize.width < NavigationBarWidth-2*width) {
                    titleViewRect.size.width = NavigationBarWidth-2*width;
                    titleViewRect.origin.x = (NavigationBarWidth-titleViewRect.size.width)/2;
                    titleLabelRect.size.width = titleSize.width;
                    titleLabelRect.origin.x = (titleViewRect.size.width-titleLabelRect.size.width)/2;
                }else{
                    titleViewRect.size.width = NavigationBarWidth - _leftView.frame.size.width-_rightView.frame.size.width;
                    titleViewRect.origin.x = _leftView.frame.size.width;
                    titleLabelRect.size.width = titleViewRect.size.width;
                    titleLabelRect.origin.x = 0;
                }
            }
        }else{
            if (_leftView&&_rightView) {
                float leftWidth = _leftView.frame.size.width;
                float rightWidth = _rightView.frame.size.width;
                float width = MAX(leftWidth, rightWidth);
                if (titleViewRect.size.width < NavigationBarWidth-2*width){
                    
                }else{
                    titleViewRect.size.width = NavigationBarWidth-_leftView.frame.size.width-_rightView.frame.size.width;
                    titleViewRect.origin.x = _leftView.frame.size.width;
                }
            }
        }
        
        _titleView.frame = titleViewRect;
        _titleLabel.frame = titleLabelRect;
    }
    
    [_titleLabel setNeedsDisplay];
    [_titleView setNeedsDisplay];
}

//-(void)setSepetorLineHidden:(BOOL)hidden
//{
//    [_blurView setLineViewHidden:hidden];
//}

@end
