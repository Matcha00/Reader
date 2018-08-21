//
//  ViewController.m
//  Reader
//
//  Created by 陈欢 on 2018/8/9.
//  Copyright © 2018年 Matcha00. All rights reserved.
//

#import "ViewController.h"
#import <LKDBHelper.h>
#import "ReaderModel.h"
#import "ReaderTableViewCell.h"
#import "ReaderViewController.h"
#import "ReaderWebViewController.h"
#import "BouncePresentAnimation.h"
#import "NormalDismissAnimation.h"
#import "SwipeUpInteractiveTransition.h"
#import "LoadingHUD.h"
@interface ViewController () <UITableViewDelegate,UITableViewDataSource,ReaderViewControllerDelegate,UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UITableView *readerTableView;
@property (nonatomic, strong) NSMutableArray *readerMutableArray;
@property (nonatomic, copy) NSString *pbString;
@property (nonatomic, strong) BouncePresentAnimation *presentAnimation;
@property (nonatomic, strong) NormalDismissAnimation *dismissAnimation;
@property (nonatomic, strong) SwipeUpInteractiveTransition *transitionController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LoadingHUD showHUD];
    _presentAnimation = [BouncePresentAnimation new];
    _dismissAnimation = [NormalDismissAnimation new];
    _transitionController = [SwipeUpInteractiveTransition new];
    
    self.readerTableView.delegate = self;
    self.readerTableView.dataSource = self;
    self.readerTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.readerMutableArray = [ReaderModel searchWithWhere:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.readerTableView reloadData];
            [LoadingHUD dismissHUD];
        });
    });
    
    [self.readerTableView registerNib:[UINib nibWithNibName:@"ReaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"ReaderTableViewCell"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refanceTable) name:@"updataTable" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testPb) name:UIPasteboardChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testPb) name:UIApplicationDidBecomeActiveNotification object:nil];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)testPb
{
    NSLog(@"------------");
    
    
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    
    NSLog(@"%@", pb.string);
    
    if (pb.string) {
        
        
        self.pbString = pb.string;
        
        if ([pb.string hasPrefix:@"http"] || [pb.string hasPrefix:@"https"]) {
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.frame = CGRectMake(0, 0, 100, 400);
//            [button setTitle:pb.string forState:UIControlStateNormal];
//            //[button setTintColor:[UIColor redColor]];
//            button.backgroundColor = [UIColor blackColor];
//            [button addTarget:self action:@selector(openSaveVc) forControlEvents:UIControlEventTouchUpInside];
//            //[[UIApplication sharedApplication].keyWindow addSubview:button];
//            //[self.view insertSubview:button aboveSubview:self.readerTableView];
//            [self.view addSubview:button];
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Reader WHERE urlReader='%@'", pb.string];
            if ([ReaderModel searchWithSQL:sql].count == 0) {
                
                UIAlertController *alertSaveUrl = [UIAlertController alertControllerWithTitle:@"是否保存文字" message:pb.string preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    ReaderViewController *vc = [[ReaderViewController alloc]init];
                    vc.transitioningDelegate = self;
                    vc.delegate = self;
                    [self.transitionController wireToViewController:vc];
                    vc.urlR = self.pbString;
                    
                    [self presentViewController:vc animated:YES completion:nil];
                    
                }];
                [okAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
                
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                
                [alertSaveUrl addAction:cancelAction];
                [alertSaveUrl addAction:okAction];
                
                [self presentViewController:alertSaveUrl animated:YES completion:nil];
                
            }
            
            
        }
        
        
        
        
        
    }
}

- (void)refanceTable
{
    self.readerMutableArray = [ReaderModel searchWithWhere:nil];
    [self.readerTableView reloadData];
}

- (void)openSaveVc
{
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview delegate dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.readerMutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReaderTableViewCell"];
    
    if (!cell) {
        cell = [[ReaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReaderTableViewCell"];
    }
    
    cell.model = self.readerMutableArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReaderModel *model = self.readerMutableArray[indexPath.row];
    
    ReaderWebViewController *webVc = [[ReaderWebViewController alloc]init];
    webVc.urlWeb = model.urlReader;
    webVc.showModel = model;
    [self presentViewController:webVc animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleNone;
//}
//
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    ReaderModel *moveModel = self.readerMutableArray[sourceIndexPath.row];
    [self.readerMutableArray removeObject:moveModel];
    [self.readerMutableArray insertObject:moveModel atIndex:destinationIndexPath.row];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *del = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

        ReaderModel *delModel = self.readerMutableArray[indexPath.row];
        [delModel deleteToDB];
        [self.readerMutableArray removeObjectAtIndex:indexPath.row];
        [self.readerTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    }];
    
    return @[del];
}
//- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIContextualAction *test = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"del" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
//
//    }];
//
//
//    UISwipeActionsConfiguration *swCon = [UISwipeActionsConfiguration configurationWithActions:@[test]];
//
//    return swCon;
//}
//
//- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIContextualAction *test = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"del" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
//
//    }];
//
//
//    UISwipeActionsConfiguration *swCon = [UISwipeActionsConfiguration configurationWithActions:@[test]];
//
//    return swCon;
//}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"updataTable" object:nil];
}

#pragma mark lazy

- (NSMutableArray *)readerMutableArray
{
    if (!_readerMutableArray) {
        _readerMutableArray = [[NSMutableArray alloc]init];
    }
    
    return _readerMutableArray;
}


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.presentAnimation;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.dismissAnimation;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.transitionController.interacting ? self.transitionController : nil;
}

- (void)readerViewControllerDidClickedDismissButton:(ReaderViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
