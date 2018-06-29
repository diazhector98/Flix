//
//  MoviesViewController.m
//  Flix
//
//  Created by Hector Diaz on 6/27/18.
//  Copyright © 2018 Hector Diaz. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
    self.tableView.delegate = self;
    [self.activityIndicator startAnimating];
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents: UIControlEventValueChanged];    
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
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
                
                [self fetchMovies];
                
            }];
            
            [alert addAction: cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            self.movies = dataDictionary[@"results"];
            
            [self.tableView reloadData];
        }
        
        [self.refreshControl endRefreshing];
        
        [self.activityIndicator stopAnimating];
    }];
    [task resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.movies.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell" forIndexPath : indexPath];
    
    UIView *backgroundView = [[UIView alloc] init];
    
    backgroundView.backgroundColor = UIColor.redColor;
    
    cell.selectedBackgroundView = backgroundView;
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    NSString *title = movie[@"title"];
    
    NSString *synopsis = movie[@"overview"];
    
    NSString *baseUrl = @"https://image.tmdb.org/t/p/w500";
    
    NSString *posterUrlString = movie[@"poster_path"];
    
    NSString *fullPosterUrlString = [baseUrl stringByAppendingString:posterUrlString];
    
    NSURL *posterUrl = [NSURL URLWithString:fullPosterUrlString];
    
    cell.posterImageView.image = nil;
    
    [cell.posterImageView setImageWithURL:posterUrl];
    
    cell.titleLabel.text = title;
    
    cell.synopsisLabel.text = synopsis;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell" forIndexPath : indexPath];
    
    cell.titleLabel.textColor = [UIColor blueColor ];
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UITableViewCell *tappedCell = sender;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    DetailViewController *detailsViewController = [segue destinationViewController];
    
    detailsViewController.movie = movie;
    
    
    
}

@end
