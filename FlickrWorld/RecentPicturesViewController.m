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
#import "ImageScrollViewController.h"


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
    NSSortDescriptor *desc = [NSSortDescriptor sortDescriptorWithKey:@"lastViewed" ascending:NO];
    NSArray *descriptors = @[desc];
    fetchRequest.sortDescriptors = descriptors;
    NSPredicate *pr = [NSPredicate predicateWithFormat:@"lastViewed != %@", nil];
    fetchRequest.predicate = pr;
    
    self.photos = [self.dataStore.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    [self.collectionView reloadData];
    
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
    
    imageView.backgroundColor = [UIColor blackColor];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    imageView.clipsToBounds = YES;
    
    imageView.image = nil;
    
    Photo *photo = [self.photos objectAtIndex:indexPath.row];
    
    UIImage *thumbnail = [UIImage imageWithData:photo.thumbnailImage];
    
    imageView.image = thumbnail;
    
    [cell addSubview:imageView]; //do not use addSubview, subclass the cell instead
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    ImageScrollViewController *imageVC = (ImageScrollViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"image"];

    NSArray *indexes = [self.collectionView indexPathsForSelectedItems];
    
    NSIndexPath *ip = indexes[0];
    
    Photo *photo = [self.photos objectAtIndex:ip.row];
    
    imageVC.photo = photo;
    
    [self.navigationController presentViewController:imageVC animated:YES completion:nil];
}

@end
