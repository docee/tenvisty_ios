//
//  SyncTimeTableViewCell.m
//  tenvisty
//
//  Created by Tenvis on 2017/12/21.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import "SyncTimeTableViewCell.h"

@interface SyncTimeTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *labTime;

@end

@implementation SyncTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _labTime.text  = LOCALSTR(@"loading...");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString *)time{
    return _labTime.text;
}

-(void)setTime:(NSString *)time{
    if(time == nil){
        time = LOCALSTR(@"loading...");
    }
    _labTime.text = time;
}
@end
