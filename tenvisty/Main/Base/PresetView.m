//
//  PresetView.m
//  tenvisty
//
//  Created by Tenvis on 2018/2/9.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "PresetView.h"

@interface PresetView()<PresetViewDelegate>{
    
}

@property (nonatomic, weak) IBOutlet PresetContentView *contentView;
@end

@implementation PresetView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:@"PresetView" owner:self options:nil];
    self.contentView.delegate = self;
    self.frame = self.contentView.frame;
    [self addSubview:self.contentView];
}

- (void)PresetContentView:(PresetContentView *)view didClickButton:(UIButton*)btn type:(NSInteger)btnType point:(NSInteger)point{
    if(self.delegate && [self.delegate respondsToSelector:@selector(PresetContentView:didClickButton:type:point:)]){
        [self.delegate PresetContentView:view didClickButton:btn type:btnType point:point];
    }
}

@end
