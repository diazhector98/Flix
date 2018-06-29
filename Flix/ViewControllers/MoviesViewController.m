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

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSArray *filteredMovies;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    
    self.searchBar.delegate = self;
    
//    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
//    
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        
    self.tableView.delegate = self;
    
    [self.activityIndicator startAnimating];
    
    
    [self handleMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(handleMovies) forControlEvents: UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
}

-(void) handleMovies {
    
    NSInteger index = [self.segmentedControl selectedSegmentIndex];
    
    NSLog(@"%i", index);
    
    NSArray *categories = @[@"now_playing", @"popular", @"top_rated"];
    
    [self fetchMovies:categories[index]];
    
    [self.tableView reloadData];
    
    
}

-(void) fetchMovies: (NSString *) category {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",@"https://api.themoviedb.org/3/movie/", category, @"?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];

    NSLog(urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"Internet connection appears to be offline" preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Try Again" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self fetchMovies: category];
                
            }];
            
            [alert addAction: cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            self.movies = dataDictionary[@"results"];
            
            self.filteredMovies = self.movies;
            
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
    
    return self.filteredMovies.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell" forIndexPath : indexPath];
    
    UIView *backgroundView = [[UIView alloc] init];
    
    backgroundView.backgroundColor = UIColor.redColor;
    
    cell.selectedBackgroundView = backgroundView;
    
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    
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

- (IBAction)changedCategory:(id)sender {
    
    self.movies = NULL;
    
    [self.tableView reloadData];
    
    [self handleMovies];
    
    
}

#pragma mark - Navigation


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
   
    if(searchText.length != 0){
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[cd] %@", searchText];
        
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
        
    } else{
        
        self.filteredMovies = self.movies;
        
    }
    
    [self.tableView reloadData];
    
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    self.searchBar.showsCancelButton = YES;
    
    [self.tableView reloadData];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    self.searchBar.showsCancelButton = NO;
    
    self.searchBar.text = @"";
    
    [self.searchBar resignFirstResponder];
    
    [self.tableView reloadData];
    
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UITableViewCell *tappedCell = sender;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    
    DetailViewController *detailsViewController = [segue destinationViewController];
    
    detailsViewController.movie = movie;
    
    
}

@end
