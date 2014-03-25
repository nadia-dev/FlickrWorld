//
//  RecentPicturesViewController.m
//  TopPlaces
//
//  Created by Nadia Yudina on 3/11/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import "RecentPicturesViewController.h"
#import "ImageScrollViewController.h"
#import "FlickrDataStore.h"
#import "Photo+Methods.h"


@interface RecentPicturesViewController ()

@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) FlickrDataStore *dataStore;

@end

@implementation RecentPicturesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}


- (void) viewWillAppear:(BOOL)animated

{
    [super viewWillAppear:animated];
    
    self.dataStore = [FlickrDataStore sharedDataStore];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
    fetchRequest.fetchBatchSize = 20;
    NSSortDescriptor *desc = [NSSortDescriptor sortDescriptorWithKey:@"lastViewed" ascending:YES];
    NSArray *descriptors = @[desc];
    fetchRequest.sortDescriptors = descriptors;
    NSPredicate *pr = [NSPredicate predicateWithFormat:@"lastViewed != %@", nil];
    fetchRequest.predicate = pr;
    self.photos = [self.dataStore.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    

    
    
//    UIImage *image1 = [UIImage imageNamed:@"wallabi.jpg"];
//    UIImage *image2 = [UIImage imageNamed:@"wallabi.jpg"];
//    UIImage *image3 = [UIImage imageNamed:@"wallabi.jpg"];
//    
//    self.images = @[image1, image2, image3];
    
//    NSMutableArray *straightArray = [[NSMutableArray alloc]init];
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    NSArray *imageDatas = [defaults objectForKey:@"recentImages"];
//    
//    for (NSData *data in imageDatas) {
//        
//        UIImage* image = [UIImage imageWithData:data];
//        
//        [straightArray addObject:image];
//    }
//    
//    self.images = [[straightArray reverseObjectEnumerator] allObjects];
    
    [self.collectionView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,100,100)];
    
    imageView.backgroundColor = [UIColor darkGrayColor];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    imageView.clipsToBounds = YES;
    
    imageView.image = nil;
    
    Photo *photo = [self.photos objectAtIndex:indexPath.row];
    
    UIImage *thumbnail = [UIImage imageWithData:photo.thumbnailImage];
    
    imageView.image = thumbnail;
    
    [cell addSubview:imageView];
    //do not use addSubview, subclass the cell instead
    return cell;
}



@end
