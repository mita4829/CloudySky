//
//  ViewController.h
//  Cloudy Sky
//
//  Created by Michael Tang on 6/23/16.
//  Copyright © 2016 Michael Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "hourlyCellCollectionViewCell.h"
#import "JSONparser.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

