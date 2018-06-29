//
//  TrailerViewController.m
//  Flix
//
//  Created by Hector Diaz on 6/28/18.
//  Copyright © 2018 Hector Diaz. All rights reserved.
//

#import "TrailerViewController.h"

@interface TrailerViewController ()

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Fetch Videos from movie
    
    
    NSString *ide = self.movie[@"id"];
    
    NSString *movieId = [NSString stringWithFormat:@"%@", ide];
    
    NSLog(@"%@",movieId);
    
    //https://api.themoviedb.org/3/movie/260513/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US
    
    NSString *baseStringUrl = @"https://api.themoviedb.org/3/movie/";
    
    NSString *baseStringUrlWithId = [baseStringUrl stringByAppendingString:movieId];
    
    NSString *urlString = [baseStringUrlWithId stringByAppendingString:@"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US"];
    
    
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
            
            
            NSDictionary *results = dataDictionary[@"results"];
            
            BOOL foundYoutube = NO;
            
            for(NSDictionary *trailer in results){
                
                if(!foundYoutube){
                    
                    NSString *key = [NSString stringWithFormat:@"%@", trailer[@"key"]];
                    
                    NSString *baseYoutubeUrl = @"https://www.youtube.com/watch?v=";
                    
                    NSString *youtubeString = [baseYoutubeUrl stringByAppendingString:key];
                    
                    NSLog(youtubeString);
                    
                    foundYoutube = YES;
                    
                    NSURL *url = [NSURL URLWithString:youtubeString];
                    
                    // Place the URL in a URL Request.
                    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                         timeoutInterval:10.0];
                    // Load Request into WebView.
                    [self.webView loadRequest:request];
                    
                }
                
            }
            
         
            
        }
        
        
    }];
    [task resume];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
