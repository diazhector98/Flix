//
//  MovieGridViewController.m
//  Flix
//
//  Created by Hector Diaz on 6/27/18.
//  Copyright © 2018 Hector Diaz. All rights reserved.
//

#import "MovieGridViewController.h"
#import "MovieCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"


@interface MovieGridViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSArray *filteredMovies;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;



@end

@implementation MovieGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.searchBar.delegate = self;
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 20;
    
    CGFloat insetTop = 10;
    
    CGFloat insetLeft = 10;
    
    CGFloat insetRight = 10;
    
    CGFloat insetBottom = 10;
    layout.sectionInset =  UIEdgeInsetsMake(insetTop, insetLeft, insetBottom, insetRight);
    
    CGFloat postersPerLine = 2;
    
    CGFloat width = (self.collectionView.frame.size.width - 20 * postersPerLine) / postersPerLine;
    
    CGFloat height = width * 1.5;
    
    layout.itemSize = CGSizeMake(width, height);
    
    [self fetchMovies];

}

-(void) fetchMovies {
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"Internet connection appears to be offline" preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Try Again" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
            }];
            
            [alert addAction: cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

            self.movies = dataDictionary[@"results"];
            
            self.filteredMovies = self.movies;
            
            [self.collectionView reloadData];
        }
        
       
    }];
    [task resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.filteredMovies.count;
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.filteredMovies[indexPath.item];
    
    NSString *baseUrl = @"https://image.tmdb.org/t/p/w500";
    
    NSString *posterUrlString = movie[@"poster_path"];
    
    NSString *fullPosterUrlString = [baseUrl stringByAppendingString:posterUrlString];
    
    NSURL *posterUrl = [NSURL URLWithString:fullPosterUrlString];
    
    NSLog(@"%@", posterUrl);
    
    cell.moviePosterImage.image = nil;
    
    [cell.moviePosterImage setImageWithURL:posterUrl];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        cell.moviePosterImage.alpha = 1.0;
        
    }];
    
    return cell;
    
}

//Search bar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if(searchText.length != 0){
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[cd] %@", searchText];
        
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
        
    } else{
        
        self.filteredMovies = self.movies;
        
    }
    
    [self.collectionView reloadData];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    self.searchBar.showsCancelButton = YES;
    
    [self.collectionView reloadData];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    
    [self.collectionView reloadData];

    
}
 
 #pragma mark - Navigation
 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UICollectionViewCell *tappedCell = sender;
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    
    DetailViewController *detailsViewController = [segue destinationViewController];
    
    detailsViewController.movie = movie;

 }




@end
