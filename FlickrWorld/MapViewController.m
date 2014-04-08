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
#import "UIColor+Pallete.h"
#import "FlickrAPIClient.h"



@interface MapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIView *blackVIew;

@property (strong, nonatomic) FlickrDataStore *dataStore;
@property (strong, nonatomic) Photo *photo;

@property (strong, nonatomic) NSArray *selectedAnnotations;
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NSMutableArray *annotatedPlaces;//prevent from adding one annotation to map more than once
@property (strong, nonatomic) IBOutlet UIButton *refreshButton;

@end



@implementation MapViewController

- (IBAction)refreshButtonPressed:(id)sender {
    
}


- (void)createImageForRefreshButtonWithColor: (UIColor *)color
{
    FAKFontAwesome *refreshIcon = [FAKFontAwesome refreshIconWithSize:30];
    UIImage *refreshImage = [refreshIcon imageWithSize:CGSizeMake(30, 30)];
    [self.refreshButton setTintColor:color];
    [self.refreshButton setImage:refreshImage forState:UIControlStateNormal];
    [self.view bringSubviewToFront:self.refreshButton];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self changeColorForSelectedAnnotation];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.annotatedPlaces = [[NSMutableArray alloc]init];
    
    self.dataStore = [FlickrDataStore sharedDataStore];
    
    [self.view bringSubviewToFront:self.blackVIew];

	self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    
    [self createImageForRefreshButtonWithColor:[UIColor pink]];
    
    [self.spinner startAnimating];
    
    [self createTabBarItems];
    
    [self createMapRegion];
    
    [self.dataStore fetchDataWithCompletion:^{
        [self fetchAndShowPlaces];
    }];
  
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    [self.spinner stopAnimating];
    
    [self.view sendSubviewToBack:self.blackVIew];
}

- (void)createMapRegion
{
    MKCoordinateRegion region = MKCoordinateRegionMake(self.mapView.centerCoordinate, MKCoordinateSpanMake(180, 360));
    [self.mapView setRegion:region animated:YES];
}

- (void)createTabBarItems
{
    FAKFontAwesome *globe = [FAKFontAwesome globeIconWithSize:20];
    UIImage *globeImage = [globe imageWithSize:CGSizeMake(20, 20)];
    
    FAKFontAwesome *repeat = [FAKFontAwesome clockOIconWithSize:20];
    UIImage *repeatImage = [repeat imageWithSize:CGSizeMake(20, 20)];
    
    UITabBarItem *world =  self.navigationController.tabBarController.tabBar.items[0];
    world.image = globeImage;
    world.title = @"World";
    UITabBarItem *recent =  self.navigationController.tabBarController.tabBar.items[1];
    recent.image = repeatImage;
    recent.title = @"Recent";
}


- (void)fetchAndShowPlaces
{
    //fetching from Core Data to populate the map view with annotations
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Place"];
    NSArray *places = [self.dataStore.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    //NSMutableArray *annots = [[NSMutableArray alloc]init];
    
    for (Place *place in places) {
        
        if (place.photo.mediumImageLink) { //in there will be broken link
        
            if (![self.annotatedPlaces containsObject:place]) {
            
                [self.annotatedPlaces addObject:place];
                
                CLLocationCoordinate2D placeCoordinate;
                placeCoordinate.latitude = [place.latutide floatValue];
                placeCoordinate.longitude = [place.longitude floatValue];
                
                NSString *annotationTitle = [self createAnnotationTitle:place];
                
                FlickrAnnotation *annotation = [[FlickrAnnotation alloc] initWithWithTitle:annotationTitle Location:placeCoordinate Photo:place.photo];

                
                [self.mapView addAnnotation:annotation];
            }
        }
    }
    
    NSLog(@"Places: %d, annotations: %d", [places count], [self.mapView.annotations count]);
}



#pragma mark - Change Annotation Methods

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


- (void)changeColorForSelectedAnnotation
{
    UIColor *circleColor = [UIColor blueTransparent];
    
    FAKFontAwesome *circle = [FAKFontAwesome circleIconWithSize:30];
    [circle addAttribute:NSForegroundColorAttributeName value:circleColor];
    UIImage *circleImage = [circle imageWithSize:CGSizeMake(30, 30)];
    
    
    for (FlickrAnnotation *selectedAnotation in self.dataStore.selectedAnnotations) {
        
        MKAnnotationView *selectedAnnotationView = [self.mapView viewForAnnotation:selectedAnotation];
        
//        selectedAnnotationView.image = nil;
        selectedAnnotationView.image = circleImage;
    }
}

#pragma mark - MapView delegate methods

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
