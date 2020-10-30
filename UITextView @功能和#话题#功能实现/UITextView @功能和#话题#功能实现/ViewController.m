//
//  ViewController.m
//  UITextView @功能和#话题#功能实现
//
//  Created by lei on 2018/4/20.
//  Copyright © 2018年 lei. All rights reserved.
//

#import "ViewController.h"
#import "HPGrowingTextView.h"

#define IsEquallString(_Str1,_Str2)  [_Str1 isEqualToString:_Str2]

@interface ViewController() <HPGrowingTextViewDelegate>
@property (nonatomic,strong) HPGrowingTextView *growingTextView;;//文字

@property (assign, nonatomic)NSInteger showType; //0 普通文字  1 语音 2 视频和图片 3 链接
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initContentView];
}



- (void)_initContentView{
    //文字
    self.growingTextView = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(0,100, self.view.frame.size.width, 200)];
    self.growingTextView.minHeight = 200;
    self.growingTextView.delegate = self;
    self.growingTextView.textColor = [UIColor blackColor];
    self.growingTextView.font = [UIFont systemFontOfSize:16];
    self.growingTextView.minNumberOfLines = 1;
    self.growingTextView.maxNumberOfLines = 10;
    self.growingTextView.animateHeightChange = NO;
    self.growingTextView.placeholder = @"写点什么和大家分享一下?";
//    self.growingTextView.placeholderColor = UIColorHex(B0B0B0);
    self.growingTextView.returnKeyType = UIReturnKeySend;
    self.growingTextView.enablesReturnKeyAutomatically = YES;
    self.growingTextView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.growingTextView];
    
    
    UIButton *at = [[UIButton alloc] initWithFrame:CGRectMake(15, 200, 60, 50)];
    [at setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [at setTitle:@"@文字" forState:UIControlStateNormal];
    [at addTarget:self action:@selector(atClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:at];
    
    UIButton *topic = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 50, 50)];
    [topic setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [topic setTitle:@"话题" forState:UIControlStateNormal];
    [topic addTarget:self action:@selector(topicClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topic];
    
}

- (void)atClick{
    NSArray *atArray = @[@"@姚晨 ", @"@陈坤 ", @"@赵薇 ", @"@Angelababy " , @"@TimCook ", @"@我的印象笔记 "];
    NSString *atString = atArray[arc4random_uniform((u_int32_t)atArray.count)];
    
    [self.growingTextView.internalTextView unmarkText];
    NSInteger index = self.growingTextView.text.length;
    UITextView *textView = self.growingTextView.internalTextView;
    NSString *insertString = atString;
    NSMutableString *string = [NSMutableString stringWithString:textView.text];
    [string insertString:insertString atIndex:index];
    self.growingTextView.text = string;
    [self.growingTextView becomeFirstResponder];
    textView.selectedRange = NSMakeRange(index + insertString.length, 0);
}

- (void)topicClick{
    NSArray *topic = @[@"#冰雪奇缘[电影]# ", @"#Let It Go[音乐]# ", @"#纸牌屋[图书]# ", @"#北京·理想国际大厦[地点]# " , @"#腾讯控股 kh00700[股票]# ", @"#WWDC# "];
    NSString *topicString = topic[arc4random_uniform((u_int32_t)topic.count)];
    
    [self.growingTextView.internalTextView unmarkText];
    NSInteger index = self.growingTextView.text.length;
    UITextView *textView = self.growingTextView.internalTextView;
    NSString *insertString = topicString;
    NSMutableString *string = [NSMutableString stringWithString:textView.text];
    [string insertString:insertString atIndex:index];
    self.growingTextView.text = string;
    [self.growingTextView becomeFirstResponder];
    textView.selectedRange = NSMakeRange(index + insertString.length, 0);
}

#pragma mark - UITextViewDelegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    if (height <= 114) {
        height = 114;
    }
    //更新growingTextView的高度
}
- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self.growingTextView resignFirstResponder];
    return YES;
}
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""])
    {
        //删除表情
        if(_growingTextView.text&&_growingTextView.text.length) {
            NSString *lastStr = [_growingTextView.text substringFromIndex:_growingTextView.text.length-1];
            if (IsEquallString(lastStr, @"]") && _growingTextView.text.length > 2) {
                NSInteger index = - 1;
                for (NSInteger i = _growingTextView.text.length - 1; i >= 0; i--) {
                    NSString *str = [_growingTextView.text substringWithRange:NSMakeRange(i, 1)];
                    if (IsEquallString(str, @"[")) {
                        index = i;
                        break;
                    }
                }
                if (index >= 0) {
                    _growingTextView.text = [_growingTextView.text substringToIndex:index];
                } else {
                    _growingTextView.text = [_growingTextView.text substringToIndex:_growingTextView.text.length-1];
                }
                return NO;
            }
            
        }
        //删除@
        NSRange selectRange = growingTextView.selectedRange;
        if (selectRange.length > 0)
        {
            //用户长按选择文本时不处理
            return YES;
        }
        // 判断删除的是一个@中间的字符就整体删除
        NSMutableString *string = [NSMutableString stringWithString:growingTextView.text];
        NSArray *matches = [self atAll];
        
        BOOL inAt = NO;
        NSInteger index = range.location;
        for (NSTextCheckingResult *match in matches)
        {
            NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
            if (NSLocationInRange(range.location, newRange))
            {
                
//                for (int i=0; i<self.AtArray.count; i++) {
//                    NSDictionary *dict = self.AtArray[i];
//                    if (IsEquallString(dict[@"name"], [string substringWithRange:match.range])) {
//                        [self.AtArray removeObjectAtIndex:i];
//                        break;
//                    }
//                }
                
                //删除本地保存的@对象或者话题对象
                
                inAt = YES;
                index = match.range.location;
                [string replaceCharactersInRange:match.range withString:@""];
                break;
            }
        }
        
        if (inAt)
        {
            growingTextView.text = string;
            growingTextView.selectedRange = NSMakeRange(index, 0);
            return NO;
        }
        
        NSArray *matches1 = [self topicAll];
        
        BOOL inTopic = NO;
        NSInteger index1 = range.location;
        for (NSTextCheckingResult *match1 in matches1)
        {
            NSRange newRange1 = NSMakeRange(match1.range.location +1, match1.range.length-1);
            if (NSLocationInRange(range.location, newRange1))
            {
//                NSLog(@"-%@-",[string substringWithRange:match1.range]);
//                for (int i=0; i<self.topicArray.count; i++) {
//                    NSDictionary *dict = self.topicArray[i];
//                    if (IsEquallString(dict[@"name"], [string substringWithRange:match1.range])) {
//                        [self.topicArray removeObjectAtIndex:i];
//                        break;
//                    }
//                }
//
//                NSLog(@"%@",self.topicArray);
                inTopic = YES;
                index1 = match1.range.location;
                [string replaceCharactersInRange:match1.range withString:@""];
                break;
            }
        }
        
        if (inTopic)
        {
            growingTextView.text = string;
            growingTextView.selectedRange = NSMakeRange(index1, 0);
            return NO;
        }
        
    }
    //判断是回车键就发送出去
    if ([text isEqualToString:@"\n"])
    {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    
    UITextRange *selectedRange = growingTextView.internalTextView.markedTextRange;
    NSString *newText = [growingTextView.internalTextView textInRange:selectedRange];
    if (newText.length < 1)
    {
        // 高亮输入框中的@
        UITextView *textView = self.growingTextView.internalTextView;
        NSRange range = textView.selectedRange;

        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:textView.text];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.string.length)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;// 字体的行间距
        [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.string.length)];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, string.string.length)];
        NSArray *matches = [self atAll];

        for (NSTextCheckingResult *match in matches)
        {
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(match.range.location, match.range.length-1)];
        }

        NSArray *matches1 = [self topicAll];
        for (NSTextCheckingResult *match1 in matches1)
        {
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(match1.range.location, match1.range.length-1)];
        }

        textView.attributedText = string;
        textView.selectedRange = range;
    }
    if (growingTextView.text.length<=0) {
        growingTextView.textColor = [UIColor blackColor];
    }
    
}

- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView
{
    // 光标不能点落在@词中间
    NSRange range = growingTextView.selectedRange;
    if (range.length > 0)
    {
        // 选择文本时可以
        return;
    }
    NSArray *matches = [self atAll];
    for (NSTextCheckingResult *match in matches)
    {
        NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
        if (NSLocationInRange(range.location, newRange))
        {
            growingTextView.internalTextView.selectedRange = NSMakeRange(match.range.location + match.range.length, 0);
            break;
        }
    }

    NSArray *matches1 = [self topicAll];

    for (NSTextCheckingResult *match1 in matches1)
    {
        NSRange newRange1 = NSMakeRange(match1.range.location+1, match1.range.length-1);
        if (NSLocationInRange(range.location, newRange1))
        {
            growingTextView.internalTextView.selectedRange = NSMakeRange(match1.range.location + match1.range.length, 0);
            break;
        }
    }
}

- (NSArray<NSTextCheckingResult *> *)atAll
{
    // 找到文本中所有的@
//    NSString *string = self.growingTextView.text;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@(...)+ "  options:NSRegularExpressionCaseInsensitive error:nil];
//    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
//    return matches;
    
    // 找到文本中所有的@
    //
    NSString *string = self.growingTextView.text;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@(.*?)+ "  options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    return matches;
    
    
}

- (NSArray<NSTextCheckingResult *> *)topicAll
{
    // 找到文本中所有的@
    NSString *string = self.growingTextView.text;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(.*?)#+ " options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    return matches;
}

/// 拼接
-(NSString *)jsonString:(NSArray *)dataArr{
    NSString *attring= [NSString string];
    if (dataArr.count>0) {
        NSMutableArray *atarr = [NSMutableArray array];
        for ( int i =0; i<dataArr.count; i++)
        {
            NSDictionary *dict = [dataArr objectAtIndex:i];
            [atarr addObject:dict[@"id"]];
            attring = [atarr componentsJoinedByString:@","];
        }
    }else{
        attring = @"";
    }
    return attring;
}

#pragma mark CKEmoticonInputViewDelegate
- (void)emoticonInputDidTapText:(NSString *)text {
    [self.growingTextView.internalTextView unmarkText];
    NSInteger index = self.growingTextView.text.length;
    index = self.growingTextView.selectedRange.location + self.growingTextView.selectedRange.length;
    UITextView *textView = self.growingTextView.internalTextView;
    NSString *insertString = text;
    NSMutableString *string = [NSMutableString stringWithString:textView.text];
    [string insertString:insertString atIndex:index];
    self.growingTextView.text = string;
    textView.selectedRange = NSMakeRange(index + insertString.length, 0);
//    [self growingTextViewDidChange:self.growingTextView];
//    [self.growingTextView scrollRangeToVisible:NSMakeRange(self.growingTextView.text.length, 1)];
}





@end
