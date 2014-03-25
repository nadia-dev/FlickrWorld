//
//  ImageScrollViewController.m
//  ImageScroll
//
//  Created by Evgenii Neumerzhitckii on 19/05/13.
//  Copyright (c) 2013 Evgenii Neumerzhitckii. All rights reserved.
//

#import "ImageScrollViewController.h"
#import "UIImageView+AFNetworking.h"
#import <FontAwesomeKit.h>
#import <MPColorTools.h>
#import "InfoViewController.h"
#import "FlickrDataStore.h"


@interface ImageScrollViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (strong, nonatomic) IBOutlet UIButton *infoButton;

@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) FlickrDataStore *dataStore;

@end

@implementation ImageScrollViewController

- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *circleColor = MP_RGB(255, 102, 102);
    
    FAKFontAwesome *infoIcon = [FAKFontAwesome infoCircleIconWithSize:30];
    UIImage *infoImage = [infoIcon imageWithSize:CGSizeMake(30, 30)];
    [self.infoButton setTintColor:circleColor];
    [self.infoButton setImage:infoImage forState:UIControlStateNormal];
    [self.view bringSubviewToFront:self.infoButton];
    
    
    
    FAKFontAwesome *globe = [FAKFontAwesome globeIconWithSize:30];
    UIImage *globeImage = [globe imageWithSize:CGSizeMake(30, 30)];
    [self.backButton setTintColor:circleColor];
    [self.backButton setImage:globeImage forState:UIControlStateNormal];
    [self.view bringSubviewToFront:self.backButton];
    
    [self.view bringSubviewToFront:self.spinner];
    
}


- (void) viewWillAppear:(BOOL)animated

{
    
    [super viewWillAppear:animated];
    
    
    
    self.scrollView.delegate = self;
    
//    self.imageView.image = [UIImage imageNamed:@"wallabi.jpg"];
    
    [self updateZoom];
    
    if (!self.imageView.image) {
        
        [self.spinner startAnimating];
        
        NSURL *url = [NSURL URLWithString:self.photo.largeImageLink];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        
        [self.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            self.imageView.image = image;
            
            [self.spinner stopAnimating];
            
            [self updateZoom];
            
            self.photo.lastViewed = [NSDate date];
            
            [self.dataStore saveContext]; //test that?
            
            
        } failure:nil];
        
        
        
    }

}

// Update zoom scale and constraints
// It will also animate because willAnimateRotationToInterfaceOrientation
// is called from within an animation block
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    
    [self updateZoom];
    
    // A hack needed for small images to animate properly on orientation change
    if (self.scrollView.zoomScale == 1) self.scrollView.zoomScale = 1.0001;
}

- (void) scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self updateConstraints];
}

- (void) updateConstraints {
    
    float imageWidth = self.imageView.image.size.width;
    float imageHeight = self.imageView.image.size.height;
    
    float viewWidth = self.view.bounds.size.width;
    float viewHeight = self.view.bounds.size.height;
    
    // center image if it is smaller than screen
    float hPadding = (viewWidth - self.scrollView.zoomScale * imageWidth) / 2;
    if (hPadding < 0) hPadding = 0;
    
    float vPadding = (viewHeight - self.scrollView.zoomScale * imageHeight) / 2;
    if (vPadding < 0) vPadding = 0;
    
    self.constraintLeft.constant = hPadding;
    self.constraintRight.constant = hPadding;
    
    self.constraintTop.constant = vPadding;
    self.constraintBottom.constant = vPadding;
}

// Zoom to show as much image as possible unless image is smaller than screen
- (void) updateZoom
{
    float minZoom = MIN(self.view.bounds.size.width / self.imageView.image.size.width,
                        self.view.bounds.size.height / self.imageView.image.size.height);
    
    if (minZoom > 1) minZoom = 1;
    
    self.scrollView.minimumZoomScale = minZoom;
    
    
    self.scrollView.zoomScale = minZoom;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


//- (void)saveImage:(UIImage *)image
//{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    NSMutableArray *recentImages = [[NSMutableArray alloc] initWithArray: [defaults objectForKey:@"recentImages"]];
//    
//    NSLog(@"%lu", [recentImages count]);
//    
//    if ([recentImages count] < 5) {
//        
//        [recentImages addObject:UIImagePNGRepresentation(image)];
//        
//    } else {
//        
//        [recentImages removeObjectAtIndex:0];
//        
//        [recentImages addObject:UIImagePNGRepresentation(image)];
//    }
//    
//    [defaults setObject:recentImages forKey:@"recentImages"];
//    
//    //    NSLog(@"%@", recentImages);
//    
//    [defaults synchronize];
//}


@end
