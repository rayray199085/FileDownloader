//
//  ViewController.m
//  HTTP13
//
//  Created by Stephen Cao on 13/3/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

#import "ViewController.h"
#import "SCProgressBar.h"
#import "SCFileDownloaderManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet SCProgressBar *progressBar;
@property(nonatomic,strong)SCFileDownloaderManager *manager;
- (IBAction)pauseProcess:(id)sender;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.progressBar setTitle:@"0.00%" forState:UIControlStateNormal];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.manager = [SCFileDownloaderManager defaultManager];
    [self.manager downloadWithUrlString:@"http://192.168.0.2/FzpIcwYMelRRXFM=.mp4" WithProcess:^(float percentage) {
        self.progressBar.process = percentage;
    } andWithSucess:^(NSString * _Nonnull urlStr) {
        NSLog(@"Successful! %@",urlStr);
    } andWithError:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


- (IBAction)pauseProcess:(id)sender {
    [self.manager pauseDownloadProcessWithUrlStr:@"http://192.168.0.2/FzpIcwYMelRRXFM=.mp4"];
}
@end

