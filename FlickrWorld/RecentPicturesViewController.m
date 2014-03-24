//
//  RecentPicturesViewController.m
//  TopPlaces
//
//  Created by Nadia Yudina on 3/11/14.
//  Copyright (c) 2014 Nadia Yudina. All rights reserved.
//

#import "RecentPicturesViewController.h"
#import "ImageScrollViewController.h"

@interface RecentPicturesViewController ()

@property (strong, nonatomic) NSArray *images;

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
    
    self.images = [[NSArray alloc]init];
    
    UIImage *image1 = [UIImage imageNamed:@"wallabi.jpg"];
    UIImage *image2 = [UIImage imageNamed:@"wallabi.jpg"];
    UIImage *image3 = [UIImage imageNamed:@"wallabi.jpg"];
    
    self.images = @[image1, image2, image3];
    
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
    return [self.images count];
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
    
    imageView.image = [self.images objectAtIndex:indexPath.row];
    
    [cell addSubview:imageView];
    //do not use addSubview, subclass the cell instead
    return cell;
}



@end
