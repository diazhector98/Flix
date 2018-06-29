//
//  DetailViewController.m
//  Flix
//
//  Created by Hector Diaz on 6/27/18.
//  Copyright © 2018 Hector Diaz. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TrailerViewController.h"
#import "ReviewCell.h"


@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Change position of table view
    
    CGFloat offset = self.synopsisLabel.frame.size.width + 40;;
    
    CGRect frame = self.tableView.frame;
    
    frame.origin.x += offset;
    
    self.tableView.frame = frame;
    
    //Check if it's starred
    
    if([self isStarred]){
        
        UIImage *btnImage = [UIImage imageNamed:@"starFill"];
        [self.starButton setImage:btnImage forState:UIControlStateNormal];
        
    } else {
        UIImage *btnImage = [UIImage imageNamed:@"starClear"];
        [self.starButton setImage:btnImage forState:UIControlStateNormal];
    }

    
    //NSMutableArray
    
    self.stringReviews = [[NSMutableArray alloc] init ];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchReviews];
    
    
    //Images
    NSString *baseUrl = @"https://image.tmdb.org/t/p/w500";
    
    NSString *posterUrlString = self.movie[@"poster_path"];
    
    NSString *fullPosterUrlString = [baseUrl stringByAppendingString:posterUrlString];
    
    NSURL *posterUrl = [NSURL URLWithString:fullPosterUrlString];
    
    [self.movieImageView setImageWithURL:posterUrl];
    
    NSString *coverUrlString = self.movie[@"backdrop_path"];
    
    NSString *fullCoverUrlString = [baseUrl stringByAppendingString:coverUrlString];
    
    NSURL *coverUrl = [NSURL URLWithString:fullCoverUrlString];
    
    [self.movieImageView setImageWithURL:posterUrl];
    
    [self.coverImageView setImageWithURL:coverUrl];
    
    //Labels
    
    self.nameLabel.text = self.movie[@"title"];
    self.bigTitleLabel.text = self.movie[@"title"];
    
    self.synopsisLabel.text = self.movie[@"overview"];
    
//    [self.nameLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    
//    Date
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
    formatter.dateFormat = @"yyyy-MM-dd";

    NSString *rawDateString = [NSString stringWithFormat:@"%@", self.movie[@"release_date"]];
    
    NSDate *date = [formatter dateFromString:rawDateString];
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSString *finalDateString = [dateFormatter stringFromDate:date];
    
    self.dateLabel.text = finalDateString;
    
    //Popularity
    
    double vote_average = [self.movie[@"vote_average"] doubleValue];
    
    self.averageLabel.text = [NSString stringWithFormat:@"%.1f", vote_average];
    
    
    if(vote_average <= 5){
        
        self.averageLabel.textColor = UIColor.redColor;
        
    } else if (vote_average < 8){
        
        self.averageLabel.textColor = [UIColor colorWithRed:0.96 green:0.80 blue:0.26 alpha:1.0];
        
    } else {
        
        self.averageLabel.textColor = UIColor.greenColor;
        
    }
    
    [self.synopsisLabel sizeToFit];
    
    CGFloat maxHeight = self.synopsisLabel.frame.origin.y + self.synopsisLabel.frame.size.height + 30;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, maxHeight);
    
    
}

-(void) fetchReviews{
    
    NSString *movieId = [NSString stringWithFormat:@"%@", self.movie[@"id"]];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",@"https://api.themoviedb.org/3/movie/", movieId, @"/reviews?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1"];
    
    NSURL *url = [NSURL URLWithString:urlString];
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
            
            self.reviews = dataDictionary[@"results"];
            
            for(NSDictionary *review in dataDictionary[@"results"]){
                
                NSString *stringReview = [NSString stringWithFormat:@"%@", review[@"content"] ];
                
                [self.stringReviews addObject:stringReview];
                
                [self.tableView reloadData];

            }
            
            
            [self.tableView reloadData];
            
        }
        
       
    }];
    [task resume];
    
    
}

//Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 100;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.reviews.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell" forIndexPath:indexPath];
    
    NSString *reviewString = [NSString stringWithFormat:@"%@", self.stringReviews[indexPath.row]];
    
    cell.reviewLabel.text = reviewString;
    
    return cell;
    
    
}

//Segmented Control

- (IBAction)controlChanged:(id)sender {
    
    CGFloat offset = self.synopsisLabel.frame.size.width + 40;;

    if(self.segmentedControl.selectedSegmentIndex == 1){
        
        [UIView animateWithDuration:1 animations:^{
        
            //Change position of label
            CGRect rectLabel = self.synopsisLabel.frame;
            
            rectLabel.origin.x -= offset;
            
            self.synopsisLabel.frame = rectLabel;
            
            //Change position of tableview

            CGRect rectTable = self.tableView.frame;
            
            rectTable.origin.x -= offset;
            
            self.tableView.frame = rectTable;
            
            
        }];
        
    } else {
        
        [UIView animateWithDuration:1 animations:^{
            
            //Change position of label
            CGRect rectLabel = self.synopsisLabel.frame;
            
            rectLabel.origin.x += offset;
            
            self.synopsisLabel.frame = rectLabel;
            
            //Change position of tableview
            
            CGRect rectTable = self.tableView.frame;
            
            rectTable.origin.x += offset;
            
            self.tableView.frame = rectTable;
            
            
        }];
        
        
    }
    
    
    
}

- (BOOL) isStarred {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *movieIdArray = [defaults arrayForKey:@"movieId_array"];
    
    NSLog(@"%@", movieIdArray);
    
    NSString *movieId = self.movie[@"id"];
    
    NSLog(@"%@", movieId);

    
    if([movieIdArray containsObject:movieId]){
        
        return true;
        
    }
    
    return false;
}

//Starring

- (IBAction)starTapped:(id)sender {
    
    
    if([self isStarred ]) {
        
        [self unstarMovie ];
        
    } else {
        [self starMovie];
    }

}

-(void) starMovie {
    
    NSLog(@"Starred");

    NSString *movieId = self.movie[@"id"];
    
    //Get array and convert it to mutable array
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *movieIdArray = [defaults arrayForKey:@"movieId_array"];
    
    NSLog(@"%@", movieIdArray);
    
    NSMutableArray *mutableMovieArray = [[NSMutableArray alloc ] initWithArray:movieIdArray];
    
    //Add string id to mutable array
    [mutableMovieArray addObject: movieId];
    
    NSLog(@"%@", mutableMovieArray);
    
    //Convert mutable array to array and store it to nsuserdefaults
    
    NSArray *newMovieIdArray = [mutableMovieArray copy];
    
    [defaults setObject:newMovieIdArray forKey:@"movieId_array"];
    
    [defaults synchronize];
    
    UIImage *btnImage = [UIImage imageNamed:@"starFill"];
    
    [self.starButton setImage:btnImage forState:UIControlStateNormal];
    
}

-(void) unstarMovie {
    
    NSLog(@"Unstarred");
    
    NSString *movieId = self.movie[@"id"];
    
    //Get array and convert it to mutable array
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *movieIdArray = [defaults arrayForKey:@"movieId_array"];
    
    NSLog(@"%@", movieIdArray);
    
    NSMutableArray *mutableMovieArray = [[NSMutableArray alloc ] initWithArray:movieIdArray];
    
    NSMutableArray *arrayWithoutMovie = [[NSMutableArray alloc] init];
    
    //Go through the movie array and add it to the new array if it is not the movie
    
    for(NSString *object in movieIdArray){
        
        NSString *objectId = [NSString stringWithFormat:@"%@", object];
        
        NSLog(objectId);
        
        if(object != movieId) {
            
            [arrayWithoutMovie addObject:object];
            
        }
        
    }
    
    NSLog(@"%@", arrayWithoutMovie);
    
    //Convert mutable array to array and store it to nsuserdefaults
    
    NSArray *newMovieIdArray = [arrayWithoutMovie copy];
    
    [defaults setObject:newMovieIdArray forKey:@"movieId_array"];
    
    [defaults synchronize];
    
    
    UIImage *btnImage = [UIImage imageNamed:@"starClear"];
    
    [self.starButton setImage:btnImage forState:UIControlStateNormal];

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    TrailerViewController *trailerViewController = [segue destinationViewController];
    
    trailerViewController.movie = self.movie;
    
    
}


@end
