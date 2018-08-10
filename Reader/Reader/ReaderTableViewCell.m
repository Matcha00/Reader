//
//  ReaderTableViewCell.m
//  Reader
//
//  Created by 陈欢 on 2018/8/9.
//  Copyright © 2018年 Matcha00. All rights reserved.
//

#import "ReaderTableViewCell.h"
#import "ReaderModel.h"
@interface ReaderTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UILabel *planLabel;

@end
@implementation ReaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithRed:59/255 green:110/255 blue:237/255 alpha:1];//[UIColor colorWithRed:17/255 green:142/255 blue:255/255 alpha:1];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    
    //    self.layer.masksToBounds = YES;
    self.layer.shadowPath   =    CGPathCreateWithRect(self.bounds, NULL);
    self.layer.shadowColor = [UIColor redColor].CGColor;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ReaderModel *)model
{
    _model = model;
    
    self.titleLabel.text = model.readerTitle;
    self.urlLabel.text = model.urlReader;
    
    self.planLabel.text = @"";
    
    if (model.plan == 0) {
        self.planLabel.text = @"未阅读";
    } else if (model.plan == 100) {
        self.planLabel.text = @"已完成";
    } else {
        self.planLabel.text = [NSString stringWithFormat:@"已阅读%lu%@", (unsigned long)model.plan,@"%"];
    }
    
    //self.planLabel.text = [NSString stringWithFormat:@"已阅读%lu", (unsigned long)model.plan];
}

- (void)setFrame:(CGRect)frame
{
    
    
    frame.origin.x += 20;
    
    frame.origin.y += 20;
    
    frame.size.width -= 40;
    frame.size.height -= 20;
    
    [super setFrame:frame];
}

@end
