//
//  DownloadContentView.m
//  tenvisty
//
//  Created by Tenvis on 2018/2/13.
//  Copyright © 2018年 Tenvis. All rights reserved.
//

#import "DownloadContentView.h"

@interface DownloadContentView()
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labPercent;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *labDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@end

@implementation DownloadContentView
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setup];
}
-(void)setup{
    [_labTitle setText:FORMAT(@"%@ (%d/%d)",LOCALSTR(@"Downloading"),1,0)];
    [_labPercent setText:@"0%"];
    [_labDesc setText:LOCALSTR(@"Waiting...")];
    [_btnCancel setTitle:LOCALSTR(@"Cancel") forState:UIControlStateNormal];
}
- (IBAction)clickCancel:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(DownloadContentView:didClickButton:type:)]){
        [self.delegate DownloadContentView:self didClickButton:sender type:DOWNLOAD_BTN_CANCEL];
    }
}

-(void)setPercent:(int)per{
    _labPercent.text = FORMAT(@"%d%%",per);
    _progressBar.progress = per/100.0;
}
-(void)setAccFile:(int)index total:(int)total desc:(NSString*)desc{
    NSString *p = FORMAT(@"%d/%d",index+1,total);
    _labTitle.text = FORMAT(LOCALSTR(@"Downloading (%@)"),p);
    _labDesc.text = desc;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
