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
#import "FlickrAnnotation.h"
#import "ImageViewController.h"

@interface MapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) FlickrDataStore *dataStore;
@property (strong, nonatomic) Photo *photo;

@end

@implementation MapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataStore = [FlickrDataStore sharedDataStore];
	self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Place"];
    NSArray *places = [self.dataStore.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    
    MKCoordinateRegion region = MKCoordinateRegionMake(self.mapView.centerCoordinate, MKCoordinateSpanMake(180, 360));
    [self.mapView setRegion:region animated:YES];
    
    for (Place *place in places) {
        
        CLLocationCoordinate2D placeCoordinate;
        placeCoordinate.latitude = [place.latutide floatValue];
        placeCoordinate.longitude = [place.longitude floatValue];

        
        FlickrAnnotation *annotation = [[FlickrAnnotation alloc] initWithWithTitle:@"test" Location:placeCoordinate Photo:place.photo];   //add Photo object as a property here?
        
        [self.mapView addAnnotation:annotation];
    }
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[FlickrAnnotation class]]) {
        
        FlickrAnnotation *myLocation = (FlickrAnnotation *)annotation;
        
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"FlickrAnnotation"];
        
        if (annotationView == nil) {
            annotationView = myLocation.annotationView;
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    } else {
        return nil;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepare for segue");
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    FlickrAnnotation *annotation = view.annotation;
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ImageViewController *imageVC = (ImageViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"image"];
    
    imageVC.photo = annotation.photo;
    
//    imageVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

    [self presentViewController:imageVC animated:YES completion:^{
        nil;
    }];


}


@end
