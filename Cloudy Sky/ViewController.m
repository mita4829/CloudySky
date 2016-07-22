//
//  ViewController.m
//  Cloudy Sky
//
//  Created by Michael Tang on 6/23/16.
//  Copyright © 2016 Michael Tang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *one;
@property (weak, nonatomic) IBOutlet UIView *two;
@property (weak, nonatomic) IBOutlet UIView *three;
@property (weak, nonatomic) IBOutlet UIView *four;
@property (weak, nonatomic) IBOutlet UIView *five;
@property (weak, nonatomic) IBOutlet UIView *six;
@property (weak, nonatomic) IBOutlet UIView *seven;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (weak, nonatomic) IBOutlet UICollectionView *hourlyCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *dailyCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *oneCurrentTemp;
@property (weak, nonatomic) IBOutlet UILabel *oneCondition;
@property (weak, nonatomic) IBOutlet UILabel *oneHighLow;
@property (weak, nonatomic) IBOutlet UILabel *oneCity;

@property (strong, nonatomic) NSArray *hourlyCells;


@end

@implementation ViewController

CLLocationManager *locationManager;


- (void)viewDidLoad {
    [super viewDidLoad];
    //[self requestUserLocation];
    CLLocation*location = [[CLLocation alloc]init];
    [self JSONHTTPRequest:39.896182 :-104.981147 :location ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self adjustFontSize];
}
- (void)requestUserLocation{
    //allocate a location Manager object
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    
    //Set accuracy for best location
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //request user's permission for location
    [locationManager requestWhenInUseAuthorization];
    
    //retrieve location
    [locationManager startUpdatingLocation];
    return;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Unable to get location at this time %@",error.description);
    [locationManager stopUpdatingLocation];
    //Alert view telling user to allow location services
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //get last location
    CLLocation *lastLocation = [locations lastObject];
    [locationManager stopUpdatingLocation];
    
    //Call API with lat and long
    [self JSONHTTPRequest:lastLocation.coordinate.latitude :lastLocation.coordinate.longitude:lastLocation];
    return;
}

- (void)JSONHTTPRequest:(float)lat :(float)lon :(CLLocation*)location{
    //Create instance of JSONparser and query the API with lat and long
    JSONparser *token = [[JSONparser alloc] init];
    
    
    NSDictionary *results = [[NSDictionary alloc] initWithDictionary:[token query:lat :lon]];
    [self loadWeatherDataFromJSON:results :location];
}

- (NSString* )UNIXtoDate:(double)unix{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:unix];
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"HH"];
    NSString *dateString = [formatter stringFromDate:date];
    NSInteger hour = [dateString intValue];
   
    NSString *formatted;
    
    if(hour > 12){
        hour = hour - 12;
        formatted = [[NSString alloc] initWithFormat:@"%ldPM",(long)hour];
    }else if(hour < 12 && hour != 0){
        formatted = [[NSString alloc] initWithFormat:@"%ldAM",hour];
    }else if(hour == 12){
        formatted = @"12PM";
    }
    else{
        formatted = @"12AM";
    }
    
    
    return formatted;
}


- (void)loadWeatherDataFromJSON: (NSDictionary*)results :(CLLocation*)location{
    //Begin loading cell 1
    NSDictionary *currently = results[@"currently"];
    NSDictionary *daily = results[@"daily"];
    NSArray *hourly = results[@"hourly"][@"data"];
    
    self.oneCurrentTemp.text = [NSString stringWithFormat:@"%dº",[(NSNumber*)results[@"currently"][@"apparentTemperature"] intValue]];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    //convert last location which is in format of Lat & Long to city, state
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       if(error){
                           NSLog(@"Error while getting current location: %@",error);
                           return;
                       }
                       
                       //Convert lat&long to city,state
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       //state = placemark.administrativeArea;
                       NSString * city = placemark.locality;
                       self.oneCity.text = city;
    }];
    
    self.oneCondition.text = currently[@"summary"];
    NSString *high = [NSString stringWithFormat:@"%d",[(NSNumber*) daily[@"data"][0][@"apparentTemperatureMax"] intValue]];
    NSString *low = [NSString stringWithFormat:@"%d", [(NSNumber*) daily[@"data"][0][@"apparentTemperatureMin"] intValue]];
    self.oneHighLow.text = [NSString stringWithFormat:@"H: %@    L: %@",high,low];
    
    //set hourly weather
    self.hourlyCells = [[NSArray alloc] initWithArray:hourly];
    [self.hourlyCollectionView reloadData];
}

- (void)adjustFontSize{
    NSString *fontType = @"HelveticaNeue-Light";
    NSUInteger height = self.one.frame.size.height;
    
    [self.oneCurrentTemp setFont:[UIFont fontWithName:fontType size:height  * 1.25]];
    [self.oneCondition setFont:[UIFont fontWithName:fontType size: height * 0.45]];
    [self.oneHighLow setFont:[UIFont fontWithName:fontType size:height * 0.45]];
    [self.oneCity setFont:[UIFont fontWithName:fontType size:height * 0.45]];
    
    self.hourlyCollectionView.backgroundColor = [UIColor clearColor];
    self.dailyCollectionView.backgroundColor = [UIColor clearColor];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //get 12 hours in advances of weather
    return 25;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    hourlyCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if(collectionView == self.hourlyCollectionView){
        cell.time.text = [self UNIXtoDate:[(NSNumber*)self.hourlyCells[[indexPath row]][@"time"] doubleValue]];
    
        NSString *perceptionProbabilityString = self.hourlyCells[[indexPath row]][@"precipProbability"];
        NSNumber *perceptionProbability = [[NSNumber alloc] initWithFloat:[perceptionProbabilityString floatValue]];
        NSString *pc;
        if([perceptionProbability floatValue] >= 0.3){
            pc = [[NSString alloc]initWithFormat:@"%.0f%%",[perceptionProbability floatValue] * 100];
        }else{
            pc = @"";
        }
        cell.precipitationChance.text = pc;
    
        cell.logo.contentMode = UIViewContentModeScaleAspectFit;
        
        NSString* apparentTemp = [[NSString alloc]initWithFormat:@"%.0fº",[self.hourlyCells[[indexPath row]]    [@"apparentTemperature"] floatValue]];
        cell.temp.text = apparentTemp;
    }else if (collectionView == self.dailyCollectionView){
        cell.logo.contentMode = UIViewContentModeScaleAspectFit;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float width = [[UIScreen mainScreen] bounds].size.width;
    float cellWidth = (width)/5.5;
    float cellHeight = self.two.frame.size.height;
    CGSize cellSize = CGSizeMake(cellWidth,cellHeight);
    return cellSize;
}
@end
