//
//  ReaderWebViewController.m
//  Reader
//
//  Created by 陈欢 on 2018/8/9.
//  Copyright © 2018年 Matcha00. All rights reserved.
//

#import "ReaderWebViewController.h"
#import "ReaderModel.h"
@interface ReaderWebViewController () <UIWebViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *readerWebView;
//总长度
@property (nonatomic, assign) CGFloat totalLengh;

//偏移量

@property (nonatomic, assign) CGFloat offsetY;


@end

@implementation ReaderWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSURL *readerUrl = [NSURL URLWithString:self.urlWeb];
    
    NSURLRequest *readerRequest = [NSURLRequest requestWithURL:readerUrl];
    self.readerWebView.delegate = self;
    [self.readerWebView loadRequest:readerRequest];
    
    
    self.readerWebView.scrollView.bounces = NO;
    
    
    
    [self.readerWebView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionInitial context:nil];
    
    [self.readerWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionInitial context:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark scrollview kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        self.offsetY = self.readerWebView.scrollView.contentOffset.y;
    }
    
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        
        CGFloat sizeHeight = self.readerWebView.scrollView.contentSize.height;
        
        NSLog(@"cccccccc%f", sizeHeight);
        
    }
}

#pragma mark webview delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.totalLengh = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"]floatValue];
    CGFloat sizeHeight = webView.scrollView.contentSize.height;
    
    NSLog(@"-------%f", sizeHeight);

    if (self.showModel.offsetVolume > 0) {
        self.readerWebView.scrollView.contentOffset = CGPointMake(0, self.showModel.offsetVolume);
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

#pragma mark view lifeCycle

- (void)dealloc
{
    [self.readerWebView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    
    [self.readerWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

#pragma mark privter

- (IBAction)saveReadLoad:(UIButton *)sender {
    
    self.showModel.offsetVolume = self.offsetY;
    self.showModel.plan = self.offsetY / (self.totalLengh - [UIScreen mainScreen].bounds.size.height) * 100;
    
    
    [self.showModel updateToDB];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updataTable" object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
