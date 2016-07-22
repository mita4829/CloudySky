//
//  dailyCell.h
//  Cloudy Sky
//
//  Created by Michael Tang on 7/8/16.
//  Copyright © 2016 Michael Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dailyCell : UICollectionViewCell

@property (nonatomic,weak) IBOutlet UILabel *day;

@property (nonatomic,weak) IBOutlet UIImageView *logo;
@property (nonatomic,weak) IBOutlet UILabel *high;
@property (nonatomic,weak) IBOutlet UILabel *low;

@end
