//
//  SliderTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 2018/2/6.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "SliderTableViewCell.h"
@interface SliderTableViewCell(){
    
}
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_leftImg;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UISlider *rightSlider;
@end

@implementation SliderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.constraint_width_leftImg.constant = 0;
    [_rightSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [_rightSlider addTarget:self action:@selector(sliderEnd:) forControlEvents:UIControlEventTouchUpInside];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(NSString*)title{
    return _leftLabel.text;
}


-(NSString*)value{
    return FORMAT(@"%f",_rightSlider.value);
}


-(void) setLeftImage:(NSString*)imageName{
    if(imageName != nil){
        [self.leftImg setHidden:NO];
        [self.leftImg setImage:[UIImage imageNamed:imageName]];
        self.constraint_width_leftImg.constant = 30;
    }
    else{
        [self.leftImg setHidden:YES];
        self.constraint_width_leftImg.constant = 0;
    }
}


-(void)setCellModel:(ListImgTableViewCellModel *)cellModel{
    [super setCellModel:cellModel];
    [self refreshCell];
}

-(void)refreshCell{
    [super refreshCell];
    if(self.cellModel){
        if(self.cellModel.showValue && self.cellModel.titleValue == nil){
            _rightLabel.text = @"1";
        }
        else{
            _rightLabel.text = self.cellModel.titleValue;
        }
        _leftLabel.text = self.cellModel.titleText;
        _rightSlider.value = [self.cellModel.titleValue intValue];
        _rightSlider.maximumValue = self.cellModel.maxValue;
        _rightSlider.minimumValue = self.cellModel.minValue;
        _leftLabel.text = self.cellModel.titleText;
        [self setLeftImage:self.cellModel.titleImgName];
    }
}


-(void)sliderEnd:(UISlider*)sender{
    if(self.cellModel && self.cellModel.delegate && [self.cellModel.delegate respondsToSelector:@selector(ListImgTableViewCellModel:didEndSliderChanging:)]){
        [self.cellModel.delegate ListImgTableViewCellModel:self.cellModel didEndSliderChanging:sender];
    }
}

-(void)sliderChanged:(UISlider*)sender{
    NSString *text = FORMAT(@"%d",(int)sender.value);
    _rightLabel.text = text;
    self.cellModel.titleValue = text;
}

@end
