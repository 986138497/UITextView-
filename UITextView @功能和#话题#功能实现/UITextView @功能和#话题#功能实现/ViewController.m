//
//  ViewController.m
//  UITextView @功能和#话题#功能实现
//
//  Created by lei on 2018/4/20.
//  Copyright © 2018年 lei. All rights reserved.
//

#import "ViewController.h"
#import "YYKit.h"
@interface ViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, assign) BOOL isInputEmoticon;
/// 改变Range
@property (assign, nonatomic) NSRange changeRange;
/// 是否改变
@property (assign, nonatomic) BOOL isChanged;
/// 光标位置
@property (assign, nonatomic) NSInteger cursorLocation;

/// 改变Range
@property (assign, nonatomic) NSRange changeRanges;
/// 是否改变
@property (assign, nonatomic) BOOL isChangeds;
/// 光标位置
@property (assign, nonatomic) NSInteger cursorLocations;
@property (strong, nonatomic) NSMutableArray *topicArray;
@property (strong, nonatomic) NSMutableArray *AtArray;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    self.topicArray = [NSMutableArray array];
    self.AtArray = [NSMutableArray array];
    [self _initTextView];
    [self _navView];
    [_textView becomeFirstResponder];
    
    
    /*
     功能:
     
        #话题#和@功能实现,  yykit 这个大神写的不错,但是不能整体删除,整体删除我看了新浪微博和今日头条,新浪微博虽然实现了#话题#和@功能,但是不能整体删除,导致了用户删除后再添加#话题#会出现正则匹配不正确的现象,大家可以看看,今天头条的是整体绑定和整体删除
     
     // 思路
          1:文字颜色(#话题#和@功能的颜色, 和普通字体颜色)  ,2:绑定(#话题#和@功能 整体绑定) 3:删除(#话题#和@功能整体删除)  4:(上传)
     
     
     //实现
        百度了一下,基本上很少,还是使用了谷歌,然后参照别人的思想和内容进行填充,站在巨人的肩膀上是好的,也不用大规模造轮子
     
     
     //上传
     1:整个 textView 的文本内容当做 content
     2:用数组来存 id 并上传给服务
     @[
         @{@"name":@"#话题#",@"id":@"1"},
         @{@"name":@"#话题#",@"id":@"1"},
         @{@"name":@"#话题#",@"id":@"1"}
     ]
     3:通过MLEmojiLabel 显示  或者 yylabel 来显示,
     4:解析:   通过MLEmojiLabel 得到话题内容(text) 去遍历服务器给的
     对象  @{
                 @{@"name":@"#话题#",@"id":@"1"},
                 @{@"name":@"#话题#",@"id":@"1"},
                 @{@"name":@"#话题#",@"id":@"1"}
         }
     
     得到 id 去请求
     
     到此,爬坑结束(泪崩)
     
    
     */
    
    
    
    
    
}



- (void)_initTextView {
    if (_textView) return;
    _textView = [UITextView new];
    if (kSystemVersion < 7) _textView.top = -64;
    _textView.size = CGSizeMake(self.view.width, self.view.height);
    _textView.textContainerInset = UIEdgeInsetsMake(12, 16, 12, 16);
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //    _textView.extraAccessoryViewHeight = kToolbarHeight;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.alwaysBounceVertical = YES;
    //    _textView.allowsCopyAttributedString = NO;
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.textColor = [UIColor blackColor];
    //    _textView.textParser = [WBStatusComposeTextParser new];
    _textView.delegate = self;
    _textView.inputAccessoryView = [UIView new];
    
    [self.view addSubview:_textView];
}
-(void)_navView{
    
    UIBarButtonItem *atButton = [[UIBarButtonItem alloc] initWithTitle:@"@功能" style:UIBarButtonItemStylePlain target:self action:@selector(atClick)];
    [atButton setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16],
                                     NSForegroundColorAttributeName : UIColorHex(4c4c4c)} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = atButton;
    
    UIBarButtonItem * topButton = [[UIBarButtonItem alloc] initWithTitle:@"#话题#" style:UIBarButtonItemStylePlain target:self action:@selector(topicClick)];
    [topButton setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16],
                                     NSForegroundColorAttributeName : UIColorHex(4c4c4c)} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = topButton;
    
}
-(void)atClick{
    NSArray *atArray = @[@"@姚晨", @"@陈坤", @"@赵薇", @"@Angelababy" , @"@TimCook", @"@我的印象笔记"];
    NSString *atString = [atArray randomObject];
    [self.AtArray addObject:@{@"name":atString,@"id":@"10"}];
    [self.textView insertText:atString];
    NSMutableAttributedString *tmpAString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    [tmpAString setAttributes:@{ NSForegroundColorAttributeName: UIColorHex(527ead), NSFontAttributeName: [UIFont systemFontOfSize:16] } range:NSMakeRange(self.textView.selectedRange.location - atString.length, atString.length)];
    self.textView.attributedText = tmpAString;
}
-(void)topicClick{
    NSArray *topic = @[@"#冰雪奇缘#", @"#Let It Go#", @"#纸牌屋#", @"#北京·理想国际大厦#" , @"#腾讯控股 kh00700#", @"#WWDC#"];
    NSString *topicString = [topic randomObject];
    
    [self.topicArray addObject:@{@"name":topicString,@"id":@"10"}];
    [self.textView insertText:topicString];
    NSMutableAttributedString *tmpAString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    [tmpAString setAttributes:@{ NSForegroundColorAttributeName: UIColorHex(527ead), NSFontAttributeName: [UIFont systemFontOfSize:16]} range:NSMakeRange(self.textView.selectedRange.location - topicString.length, topicString.length)];
    self.textView.attributedText = tmpAString;
}



- (void)textViewDidChangeSelection:(UITextView *)textView {
    //话题
    NSArray *rangeArray = [self getTopicRangeArray:nil];
    BOOL inRange = NO;
    for (NSInteger i = 0; i < rangeArray.count; i++) {
        NSRange range = NSRangeFromString(rangeArray[i]);
        if (textView.selectedRange.location > range.location && textView.selectedRange.location < range.location + range.length) {
            inRange = YES;
            break;
        }
    }
    if (inRange) {
        textView.selectedRange = NSMakeRange(self.cursorLocation, textView.selectedRange.length);
        return;
    }
    self.cursorLocation = textView.selectedRange.location;
    
    //@功能
    NSArray *rangeArrays = [self getAtRangeArray:nil];
    BOOL inRanges = NO;
    for (NSInteger i = 0; i < rangeArrays.count; i++) {
        NSRange ranges = NSRangeFromString(rangeArrays[i]);
        if (textView.selectedRange.location > ranges.location && textView.selectedRange.location < ranges.location + ranges.length) {
            inRanges = YES;
            break;
        }
    }
    if (inRanges) {
        textView.selectedRange = NSMakeRange(self.cursorLocations, textView.selectedRange.length);
        return;
    }
    self.cursorLocations = textView.selectedRange.location;
}
- (void)textViewDidChange:(UITextView *)textView {
    //话题
    if (_isChanged) {
        NSMutableAttributedString *tmpAString = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
        [tmpAString setAttributes:@{ NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:16] } range:_changeRange];
        textView.attributedText = tmpAString;
        _isChanged = NO;
    }
    //@功能
    if (_isChangeds) {
        NSMutableAttributedString *tmpAStrings = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
        [tmpAStrings setAttributes:@{ NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:16] } range:_changeRanges];
        textView.attributedText = tmpAStrings;
        _isChangeds = NO;
    }
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""]) { // 删除
        //话题
        NSArray *rangeArray = [self getTopicRangeArray:nil];
        
        for (NSInteger i = 0; i < rangeArray.count; i++) {
            NSRange tmpRange = NSRangeFromString(rangeArray[i]);
            if ((range.location + range.length) == (tmpRange.location + tmpRange.length)) {
                if ([NSStringFromRange(tmpRange) isEqualToString:NSStringFromRange(textView.selectedRange)]) {
                    // 第二次点击删除按钮 删除
                    NSLog(@"打印前%@",self.topicArray);
                    [self.topicArray removeObjectAtIndex:rangeArray.count-1];
                    NSLog(@"打印后%@",self.topicArray);
                    return YES;
                } else {
                    // 第一次点击删除按钮 选中
                    textView.selectedRange = tmpRange;
                    return NO;
                }
            }
        }
        //@功能
        NSArray *rangeArrays = [self getAtRangeArray:nil];
        for (NSInteger i = 0; i < rangeArrays.count; i++) {
            NSRange tmpRanges = NSRangeFromString(rangeArrays[i]);
            if ((range.location + range.length) == (tmpRanges.location + tmpRanges.length)) {
                if ([NSStringFromRange(tmpRanges) isEqualToString:NSStringFromRange(textView.selectedRange)]) {
                    NSLog(@"打印前%@",self.AtArray);
                    [self.AtArray removeObjectAtIndex:rangeArrays.count-1];
                    NSLog(@"打印后%@",self.AtArray);
                    // 第二次点击删除按钮 删除
                    return YES;
                } else {
                    // 第一次点击删除按钮 选中
                    textView.selectedRange = tmpRanges;
                    return NO;
                }
            }
        }
        
    } else { // 增加
        //话题
        NSArray *rangeArray = [self getTopicRangeArray:nil];
        if ([rangeArray count]) {
            for (NSInteger i = 0; i < rangeArray.count; i++) {
                NSRange tmpRange = NSRangeFromString(rangeArray[i]);
                if ((range.location + range.length) == (tmpRange.location + tmpRange.length) || !range.location) {
                    _changeRange = NSMakeRange(range.location, text.length);
                    _isChanged = YES;
                    return YES;
                }
            }
        } else {
            // 话题在第一个删除后 重置text color
            if (!range.location) {
                _changeRange = NSMakeRange(range.location, text.length);
                _isChanged = YES;
                return YES;
            }
        }
        //@功能
        NSArray *rangeAtrray = [self getAtRangeArray:nil];
        if ([rangeAtrray count]) {
            for (NSInteger i = 0; i < rangeAtrray.count; i++) {
                NSRange tmpTRange = NSRangeFromString(rangeAtrray[i]);
                if ((range.location + range.length) == (tmpTRange.location + tmpTRange.length) || !range.location) {
                    _changeRanges = NSMakeRange(range.location, text.length);
                    _isChangeds = YES;
                    return YES;
                }
            }
        } else {
            // 话题在第一个删除后 重置text color
            if (!range.location) {
                _changeRanges = NSMakeRange(range.location, text.length);
                _isChangeds = YES;
                return YES;
            }
        }
        
        
    }
    return YES;
}
- (NSArray *)getTopicRangeArray:(NSAttributedString *)attributedString {
    NSAttributedString *traveAStr = attributedString ?: _textView.attributedText;
    __block NSMutableArray *rangeArray = [NSMutableArray array];
    static NSRegularExpression *iExpression;
    iExpression = iExpression ?: [NSRegularExpression regularExpressionWithPattern:@"#(.*?)#" options:0 error:NULL];
    [iExpression enumerateMatchesInString:traveAStr.string
                                  options:0
                                    range:NSMakeRange(0, traveAStr.string.length)
                               usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                   NSRange resultRange = result.range;
                                   NSDictionary *attributedDict = [traveAStr attributesAtIndex:resultRange.location effectiveRange:&resultRange];
                                   if ([attributedDict[NSForegroundColorAttributeName] isEqual:UIColorHex(527ead)]) {
                                       [rangeArray addObject:NSStringFromRange(result.range)];
                                   }
                               }];
    return rangeArray;
}
- (NSArray *)getAtRangeArray:(NSAttributedString *)attributedString {
    NSAttributedString *traveAStr = attributedString ?:_textView.attributedText;
    __block NSMutableArray *rangeArrays = [NSMutableArray array];
    static NSRegularExpression *iExpression;
    iExpression = iExpression ?: [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:0 error:NULL];
    [iExpression enumerateMatchesInString:traveAStr.string
                                  options:0
                                    range:NSMakeRange(0, traveAStr.string.length)
                               usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                   NSRange resultRange = result.range;
                                   NSDictionary *attributedDict = [traveAStr attributesAtIndex:resultRange.location effectiveRange:&resultRange];
                                   if ([attributedDict[NSForegroundColorAttributeName] isEqual:UIColorHex(527ead)]) {
                                       [rangeArrays addObject:NSStringFromRange(result.range)];
                                   }
                               }];
    return rangeArrays;
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
