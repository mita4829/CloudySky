//
//  hourlyCellTableViewCell.h
//  Cloudy Sky
//
//  Created by Michael Tang on 6/26/16.
//  Copyright © 2016 Michael Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface hourlyCellCollectionViewCell : UICollectionViewCell

@property (nonatomic,weak) IBOutlet UILabel *time;
@property (nonatomic,weak) IBOutlet UILabel *precipitationChance;
@property (nonatomic,weak) IBOutlet UIImageView *logo;
@property (nonatomic,weak) IBOutlet UILabel *temp;

@end
