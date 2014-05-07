
#import "ImageScrollViewController.h"
#import "UIImageView+AFNetworking.h"
#import <FontAwesomeKit.h>
#import "UIColor+Pallete.h"
#import "FlickrDataStore.h"
#import "FlickrAPIClient.h"



@interface ImageScrollViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (strong, nonatomic) IBOutlet UIButton *infoButton;

@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) IBOutlet UIButton *actionButton;

@property (strong, nonatomic) FlickrAPIClient *apiClient;

@property (strong, nonatomic) FlickrDataStore *dataStore;

@end

@implementation ImageScrollViewController


- (void) viewWillAppear:(BOOL)animated

{
    [super viewWillAppear:animated];
    
    self.apiClient = [[FlickrAPIClient alloc]init];
    
    self.dataStore = [FlickrDataStore sharedDataStore];
    
    self.scrollView.delegate = self;
    
    [self fetchImages];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createImageForInfoButtonWithColor:[UIColor pink]];
    [self createImageForGlobeButtonWithColor:[UIColor pink]];
    [self createImageForActionButtonWithColor:[UIColor pink]];
    
    [self.view bringSubviewToFront:self.spinner];
    
}

- (BOOL)prefersStatusBarHidden {
    return  YES;
}



- (IBAction)actionButtonPressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Send email", @"Send message", nil];
    [actionSheet showInView:self.view];
}


- (IBAction)infoButtonPressed:(id)sender
{
    if ([self.view.subviews lastObject] == self.infoView) {
        
        [self.view sendSubviewToBack:self.infoView];
    } else {
        
        self.infoView.backgroundColor = [UIColor blackTransparent];
        [self.view bringSubviewToFront:self.infoView];
        [self.infoLabel sizeToFit];
        [self putTextToLabel];
    }
}

- (void)putTextToLabel
{
    self.infoLabel.text = [NSString stringWithFormat:@"%@\nby: %@", self.photo.title, self.photo.master];
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.dataStore saveContext];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.imageView cancelImageRequestOperation];
    
}


- (void)createImageForInfoButtonWithColor: (UIColor *)color
{
    
    FAKIonIcons *infoIcon = [FAKIonIcons ios7InformationOutlineIconWithSize:50];
    //FAKFontAwesome *infoIcon = [FAKFontAwesome infoIconWithSize:50];
    UIImage *infoImage = [infoIcon imageWithSize:CGSizeMake(50, 50)];
    [self.infoButton setTintColor:color];
    [self.infoButton setImage:infoImage forState:UIControlStateNormal];
    [self.view bringSubviewToFront:self.infoButton];
}


- (void)createImageForActionButtonWithColor: (UIColor *)color
{
    
    FAKIonIcons *actionIcon = [FAKIonIcons ios7EmailOutlineIconWithSize:50];
    //FAKFontAwesome *infoIcon = [FAKFontAwesome infoIconWithSize:50];
    UIImage *infoImage = [actionIcon imageWithSize:CGSizeMake(50, 50)];
    [self.actionButton setTintColor:color];
    [self.actionButton setImage:infoImage forState:UIControlStateNormal];
    [self.view bringSubviewToFront:self.actionButton];
}


- (void)createImageForGlobeButtonWithColor: (UIColor *)color
{
    FAKIonIcons *globe = [FAKIonIcons ios7WorldOutlineIconWithSize:50];
    //FAKFontAwesome *globe = [FAKFontAwesome globeIconWithSize:50];
    UIImage *globeImage = [globe imageWithSize:CGSizeMake(50, 50)];
    [self.backButton setTintColor:color];
    [self.backButton setImage:globeImage forState:UIControlStateNormal];
    [self.view bringSubviewToFront:self.backButton];
}

- (void) fetchImages
{
    if (!self.imageView.image) {
        
        [self.spinner startAnimating];
        
        NSURL *urlForLarge = [NSURL URLWithString:self.photo.originalImageLink];
        NSURLRequest *requestForLarge = [NSURLRequest requestWithURL:urlForLarge];
        
        NSURL *urlForMedium = [NSURL URLWithString:self.photo.largeImageLink];
        NSURLRequest *requestForMedium = [NSURLRequest requestWithURL:urlForMedium];
        
        [self.imageView setImageWithURLRequest:requestForMedium
                              placeholderImage:nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            self.imageView.image = image;
            
            [self.spinner stopAnimating];
            
            [self updateConstraints];
            
            [self updateZoom];
            
            self.photo.lastViewed = [NSDate date];
            
            [self.dataStore saveContext];
                                           //don't upload original image for non-retina devices
                                           if (!IS_RETINA) {
                                               
                                               [self.imageView setImageWithURLRequest:requestForLarge
                                                                     placeholderImage:nil
                                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                  
                                                                                  self.imageView.image = nil;
                                                                                  
                                                                                  self.imageView.image = image;
                                                                                  
                                                                                  [self updateConstraints];
                                                                                  
                                                                                  [self updateZoom];
                                                                                  
                                                                              } failure:nil];

                                           }

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

#pragma mark - Sharing methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self email];
            break;
            
        case 1:
            [self message];
            
        default:
            break;
    }
}


-(void)email
{
    UIImage *UIImageToSend = self.imageView.image;
    
    NSString *emailTitle = @"Interesting photo from Flickr";
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"%@\nby: %@", self.photo.title, self.photo.master];
    // To address
    NSArray *toRecipents = @[];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    NSData *data = UIImageJPEGRepresentation(UIImageToSend,1);
    
    
    [mc addAttachmentData:data  mimeType:@"image/jpeg" fileName:self.photo.title];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)message
{
    UIImage *UIImageToSend = self.imageView.image;
    
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[];
    NSString *message = [NSString stringWithFormat:@"Interesting photo from Flickr: %@\nby: %@", self.photo.title, self.photo.master];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    NSData *data = UIImageJPEGRepresentation(UIImageToSend,1);
    
    NSString *fileName = [NSString stringWithFormat:@"%@.png", self.photo.title];
    
    [messageController addAttachmentData:data typeIdentifier:@"image/jpeg" filename:fileName];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
