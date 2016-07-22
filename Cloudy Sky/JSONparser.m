//
//  JSONparser.m
//  Cloudy Sky
//
//  Created by Michael Tang on 6/25/16.
//  Copyright © 2016 Michael Tang. All rights reserved.
//

#import "JSONparser.h"
#define API_KEY = @"";//Insert API key from Forecast
#define QUERY_PREFIX @"https://api.forecast.io/forecast/"+API_KEY+"/"

@implementation JSONparser

- (NSDictionary *)query:(float)lat :(float)lon{
    NSString *queryURL = [NSString stringWithFormat:@"%@%f,%f",QUERY_PREFIX,lat,lon];
    
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:queryURL] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;

    NSDictionary *results;
    if(jsonData){
        results = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    }else{
        results = nil;
    }
    
    if(error){
        NSLog(@"There was an error parsing JSON data: %@",[error localizedDescription]);
    }
    
    return results;
}

@end
