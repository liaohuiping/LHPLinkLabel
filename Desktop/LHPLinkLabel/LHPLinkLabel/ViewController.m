//
//  ViewController.m
//  LHPLinkLabel
//
//  Created by lhp on 2018/5/7.
//  Copyright © 2018年 lhp. All rights reserved.
//

#import "ViewController.h"
#import "LhpLinkLabel.h"

@interface ViewController ()<LhpLinkLabelDelegate>

@property (nonatomic,strong)LhpLinkLabel *label;
@property(nonatomic, strong)NSArray* matches;
@property (nonatomic,copy)NSString *labelString;
@property(nonatomic, strong)NSMutableAttributedString *attributedText;
@property(nonatomic, strong)NSMutableArray *arr;

@end

@implementation ViewController

-(LhpLinkLabel *)label{
    if (!_label) {
        _label = [[LhpLinkLabel alloc]initWithFrame:CGRectMake(20, 40, 375, 400)];
        _label.delegate = self;
        _labelString = @"跳转百度https://www.baidu.com简书http://www.jianshu.com生成链接https://blog.csdn.net/GuoFengIOS/article/details/51690015";
        _label.text = _labelString;
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = [UIColor redColor];
        _label.numberOfLines = 0;
    }
    return _label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.label];
    
    NSError *error;
    //可以识别url的正则表达式
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,3})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    self.matches = [regex matchesInString:self.label.text options:0 range:NSMakeRange(0, self.label.text.length)];
    [self highlightLinksWithIndex:NSNotFound];
    
}
//获取查找字符串在母串中的NSRange
- (NSArray *)rangesOfString:(NSString *)searchString inString:(NSString *)str {
    
    NSMutableArray *results = [NSMutableArray array];
    
    NSRange searchRange = NSMakeRange(0, [str length]);
    
    NSRange range;
    
    while ((range = [str rangeOfString:searchString options:0 range:searchRange]).location != NSNotFound) {
        
        [results addObject:[NSValue valueWithRange:range]];
        
        searchRange = NSMakeRange(NSMaxRange(range), [str length] - NSMaxRange(range));
        
    }
    
    return results;
}
- (BOOL)label:(LhpLinkLabel *)label didBeginTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
    
    [self highlightLinksWithIndex:charIndex];
    return YES;
}

- (BOOL)label:(LhpLinkLabel *)label didMoveTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
    
    [self highlightLinksWithIndex:charIndex];
    return YES;
}

- (BOOL)label:(LhpLinkLabel *)label didEndTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
    
    [self highlightLinksWithIndex:NSNotFound];

    NSMutableArray *arrayM = [self handleAttributedStringData];
    for(NSValue *value in arrayM)
    {
        NSInteger index = [arrayM indexOfObject:value];
        NSRange range = [value rangeValue];
        if ([self isIndex:charIndex inRange:range]) {
            
            [self showMessage:[NSString stringWithFormat:@"%@",NSStringFromRange(range)]];
            
            NSURL *url = [NSURL URLWithString:self.arr[index]];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionsSourceApplicationKey:@YES} completionHandler:nil];
            }
            break;
        }
    }
    
    return YES;
}

- (BOOL)label:(LhpLinkLabel *)label didCancelTouch:(UITouch *)touch {
    
    [self highlightLinksWithIndex:NSNotFound];
    return YES;
}

#pragma mark -

- (BOOL)isIndex:(CFIndex)index inRange:(NSRange)range {
    return index > range.location && index < range.location+range.length;
}

- (void)highlightLinksWithIndex:(CFIndex)index {
    
    NSMutableArray *arrayM = [self handleAttributedStringData];
    for(NSValue *value in arrayM)
    {
        NSRange range = [value rangeValue];
        [self.attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
        [self.attributedText addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    }
    NSMutableAttributedString *s = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    self.label.attributedText = s;
}
#pragma mark - 对数据的处理
- (NSMutableArray *)handleAttributedStringData{
    self.arr = [[NSMutableArray alloc]init];
    NSArray *rangeArr = [[NSMutableArray alloc]init];
    
    for (NSTextCheckingResult *match in self.matches)
    {
        NSString *substringForMatch;
        substringForMatch = [self.labelString substringWithRange:match.range];
        [self.arr addObject:substringForMatch];
        
    }
    NSString *subStr = self.labelString;
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSString *str in self.arr)
    {
        subStr = [subStr  stringByReplacingOccurrencesOfString:str withString:str];
        rangeArr = [self rangesOfString: str inString:subStr];
        
        [arrayM addObject:[rangeArr firstObject]];
    }
    
    //计算大小
    UIFont *font = [UIFont systemFontOfSize:15];
    self.attributedText=[[NSMutableAttributedString alloc]initWithString:subStr attributes:@{NSFontAttributeName :font,NSForegroundColorAttributeName:[UIColor redColor]}];
    return arrayM;
}

- (void)showMessage:(NSString *)string{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"tips" message:string preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:action];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}
@end
