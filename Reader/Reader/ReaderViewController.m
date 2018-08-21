//
//  ReaderViewController.m
//  Reader
//
//  Created by 陈欢 on 2018/8/9.
//  Copyright © 2018年 Matcha00. All rights reserved.
//

#import "ReaderViewController.h"
#import "ReaderModel.h"
@interface ReaderViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@end

@implementation ReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveClick:(UIButton *)sender {
    
    
    //self.editModel.readerTitle = self.titleTextField.text;
    
    //[self.editModel updateToDB];
    
    
    
    if (self.titleTextField.text.length > 0) {
        
        ReaderModel *addModel = [[ReaderModel alloc]init];
        
        addModel.urlReader = _urlR;
        addModel.readerTitle = self.titleTextField.text;
        
        [addModel saveToDB];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updataTable" object:nil];
        
        UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleLight];
        
        [impactLight impactOccurred];
        
        
    }
    
    
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"updataTable" object:nil];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(readerViewControllerDidClickedDismissButton:)]) {
        [self.delegate readerViewControllerDidClickedDismissButton:self];
    }
    
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
