//
//  JSONparser.h
//  Cloudy Sky
//
//  Created by Michael Tang on 6/25/16.
//  Copyright © 2016 Michael Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONparser : NSObject

- (NSDictionary *)query:(float)lat :(float)lon;

@end
