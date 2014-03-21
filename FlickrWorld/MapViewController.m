//
//  MapViewController.m
//  FlickrWorld
//
//  Created by Nadia Yudina on 3/21/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import "MapViewController.h"
#import "FlickrDataStore.h"
#import "Place+Methods.h"

@interface MapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) FlickrDataStore *dataStore;

@end

@implementation MapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataStore = [FlickrDataStore sharedDataStore];
	self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeHybrid;
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Place"];
    NSArray *places = [self.dataStore.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    
    MKCoordinateRegion region = MKCoordinateRegionMake(self.mapView.centerCoordinate, MKCoordinateSpanMake(180, 360));
    [self.mapView setRegion:region animated:YES];
    
    for (Place *place in places) {
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D myCoordinate;
        myCoordinate.latitude = [place.latutide floatValue];
        myCoordinate.longitude = [place.longitude floatValue];
        annotation.coordinate = myCoordinate;
        [self.mapView addAnnotation:annotation];
    }
    
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"MyLocation";
        
    MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
    } else {
        annotationView.annotation = annotation;
    }
    
    return annotationView;

}


@end
