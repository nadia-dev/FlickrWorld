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
#import "ImageScrollViewController.h"
#import <FontAwesomeKit.h>
#import <MPColorTools.h>



@interface MapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) FlickrDataStore *dataStore;
@property (strong, nonatomic) Photo *photo;

@property (strong, nonatomic) NSArray *selectedAnnotations;

@end

@implementation MapViewController

- (NSString *)createAnnotationTitle: (Place *)place
{
    if (place.locality) {
        return place.locality;
    } else if (place.region) {
        return place.region;
    } else {
        return place.country;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIColor *circleColor = [UIColor colorWithRed:0 green:0 blue:255 alpha:0.75];
    
    FAKFontAwesome *circle = [FAKFontAwesome circleIconWithSize:30];
    [circle addAttribute:NSForegroundColorAttributeName value:circleColor];   
    UIImage *circleImage = [circle imageWithSize:CGSizeMake(30, 30)];

    
    for (FlickrAnnotation *selectedAnotation in self.dataStore.selectedAnnotations) {
        
        MKAnnotationView *selectedAnnotationView = [self.mapView viewForAnnotation:selectedAnotation];
        
        selectedAnnotationView.image = circleImage;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataStore = [FlickrDataStore sharedDataStore];

	self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    
    FAKFontAwesome *globe = [FAKFontAwesome globeIconWithSize:20];
    UIImage *globeImage = [globe imageWithSize:CGSizeMake(20, 20)];
    
    FAKFontAwesome *repeat = [FAKFontAwesome repeatIconWithSize:20];
    UIImage *repeatImage = [repeat imageWithSize:CGSizeMake(20, 20)];
    
    
    
    UITabBarItem *world =  self.navigationController.tabBarController.tabBar.items[0];
    world.image = globeImage;
    world.title = @"World";
    UITabBarItem *recent =  self.navigationController.tabBarController.tabBar.items[1];
    recent.image = repeatImage;
    recent.title = @"Recent";
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Place"];
    NSArray *places = [self.dataStore.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    MKCoordinateRegion region = MKCoordinateRegionMake(self.mapView.centerCoordinate, MKCoordinateSpanMake(180, 360));
    [self.mapView setRegion:region animated:YES];
    
    for (Place *place in places) {
        
        CLLocationCoordinate2D placeCoordinate;
        placeCoordinate.latitude = [place.latutide floatValue];
        placeCoordinate.longitude = [place.longitude floatValue];

        NSString *annotationTitle = [self createAnnotationTitle:place];
        
        FlickrAnnotation *annotation = [[FlickrAnnotation alloc] initWithWithTitle:annotationTitle Location:placeCoordinate Photo:place.photo];
        
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


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    FlickrAnnotation *annotation = view.annotation;

    [self.dataStore.selectedAnnotations addObject:annotation];
    
    [self.mapView deselectAnnotation:annotation animated:YES];

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    
    ImageScrollViewController *imageVC = (ImageScrollViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"image"];
    
    imageVC.photo = annotation.photo;
    
    [self.navigationController presentViewController:imageVC animated:YES completion:nil];

}


@end
