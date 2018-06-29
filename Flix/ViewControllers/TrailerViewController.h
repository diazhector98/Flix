//
//  TrailerViewController.h
//  Flix
//
//  Created by Hector Diaz on 6/28/18.
//  Copyright © 2018 Hector Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrailerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSDictionary *movie;


@end
