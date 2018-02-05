//
//  SelectItemDetailTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 2018/2/5.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "SelectItemDetailTableViewCell.h"

@interface SelectItemDetailTableViewCell(){
    
}
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labDesc;
@property (weak, nonatomic) IBOutlet UIImageView *imgSelect;
@property (weak, nonatomic) IBOutlet UILabel *labDetailDesc;

@end



@implementation SelectItemDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setSelect:(Boolean)selected{
    if(selected){
        [self.imgSelect setHidden:NO];
    }
    else{
        [self.imgSelect setHidden:YES];
    }
}

-(void)setCellModel:(ListImgTableViewCellModel *)cellModel{
    [super setCellModel:cellModel];
    [self refreshCell];
}

-(void)refreshCell{
    [super refreshCell];
    if(self.cellModel){
        _labTitle.text = self.cellModel.titleText;
        _labDesc.text = self.cellModel.desc;
        _labDetailDesc.text = self.cellModel.descDetail;
         [self.imgSelect setHidden:self.cellModel.titleValue == nil];
    }
}

@end
