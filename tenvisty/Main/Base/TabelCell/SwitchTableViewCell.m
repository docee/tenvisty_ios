//
//  SwitchTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 17/12/5.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "SwitchTableViewCell.h"

@interface SwitchTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_width_leftImg;

@property (weak, nonatomic) IBOutlet UILabel *leftLabTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightLabLoading;
@property (weak, nonatomic) IBOutlet UISwitch *rightSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@end


@implementation SwitchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.constraint_width_leftImg.constant = 0;
    [self.rightSwitch addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventTouchUpInside];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setLeftImage:(NSString*)imageName{
    if(imageName == nil){
        [self.leftImg setHidden:YES];
         self.constraint_width_leftImg.constant = 0;
    }
    else{
        [self.leftImg setHidden:NO];
        [self.leftImg setImage:[UIImage imageNamed:imageName]];
        self.constraint_width_leftImg.constant = 30;
    }
}

-(void)setCellModel:(ListImgTableViewCellModel *)cellModel{
    [super setCellModel:cellModel];
    [self refreshCell];
}

-(void)refreshCell{
    [super refreshCell];
    if(self.cellModel){
        _leftLabTitle.text = self.cellModel.titleText;
        _rightLabLoading.text = LOCALSTR(@"loading...");
        [_rightLabLoading setHidden:self.cellModel.titleValue != nil];
        [_rightSwitch setEnabled:self.cellModel.titleValue != nil];
        [_rightSwitch setOn:[self.cellModel.titleValue isEqualToString:@"1"]];
        [self setLeftImage:self.cellModel.titleImgName];
    }
}

-(void)clickSwitch:(UISwitch*)sender{
    if(self.cellModel && self.cellModel.delegate && [self.cellModel.delegate respondsToSelector:@selector(ListImgTableViewCellModel:didClickSwitch:)]){
        [self.cellModel.delegate ListImgTableViewCellModel:self.cellModel didClickSwitch:sender];
    }
}

@end
