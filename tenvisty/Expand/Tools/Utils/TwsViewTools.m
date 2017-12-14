//
//  TwsViewTools.m
//  tenvisty
//
//  Created by Tenvis on 2017/12/14.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "TwsViewTools.h"

@implementation TwsViewTools

+(void)setButtonContentCenter:(UIButton *) btn
{
    CGSize imgViewSize,titleSize,btnSize;
    UIEdgeInsets imageViewEdge,titleEdge;
    CGFloat heightSpace = 45.0f;
    
    //设置按钮内边距
    imgViewSize = btn.imageView.bounds.size;
    titleSize = btn.titleLabel.bounds.size;
    btnSize = btn.bounds.size;
    
    imageViewEdge = UIEdgeInsetsMake(heightSpace,0.0, btnSize.height -imgViewSize.height - heightSpace, - titleSize.width);
    [btn setImageEdgeInsets:imageViewEdge];
    titleEdge = UIEdgeInsetsMake(imgViewSize.height +heightSpace - 30.0f, - imgViewSize.width, 0.0, 0.0);
    [btn setTitleEdgeInsets:titleEdge];
}
@end
