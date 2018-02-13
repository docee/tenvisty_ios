//
//  ImageCollectionTableViewCell.h
//  tenvisty
//
//  Created by Tenvis on 17/12/7.
//  Copyright © 2017年 Tenvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectAll;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imgDownload;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionImages;
@end
