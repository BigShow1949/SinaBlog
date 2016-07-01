//
//  YFStatus.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-29.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFStatus.h"
#import "YFPicUrl.h"
#import "MJExtension.h"
#import "NSDate+Extension.h"
#import "YFUser.h"
#import "YFTextPart.h"
#import "RegexKitLite.h"

#define YFStatusTextFont [UIFont systemFontOfSize:16]


@implementation YFStatus


- (NSDictionary *)objectClassInArray
{
    return @{@"pic_urls" : [YFPicUrl class]};
}

#warning 来源不会变化所以只需要获取到数据后截取一次即可
- (void)setSource:(NSString *)source
{
    if (source.length) {
        // source == <a href="http://weibo.com/" rel="nofollow">微博 weibo.com</a>
        // _source == 微博 weibo.com
        // 正则表达式
        // 截取字符串
        NSUInteger loc = [source rangeOfString:@">"].location + 1;
        //    NSUInteger len = [source rangeOfString:@"<" options:NSBackwardsSearch].location - loc;
        NSUInteger len = [source rangeOfString:@"</"].location - loc;
        source = [source substringWithRange:NSMakeRange(loc, len)];
    } else {
        source = @"新浪微博";
    }
    _source = [@"来自 " stringByAppendingString:source];
    //    YFLog(@"setSource--- %@", _source);
}

- (NSString *)created_at
{
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    // created_at(NSString) --> NSDate
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss z yyyy";
    // 设置时间所属的区域
#warning 如果是真机环境, 需要设置locale, 说明时间所属的区域
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    // 微博的发布时间
    NSDate *date = [fmt dateFromString:_created_at];
    
    // 当前时间
    NSDate *now = [NSDate date];
    
    if (date.isThisYear) { // 今年
        if (date.isToday) { // 今天
            NSDateComponents *cmps = [date componentsToDate:now];
            
            if (cmps.hour >= 1) { // 至少1个小时前
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1分钟~59分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟以内
                return @"刚刚";
            }
        } else if (date.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:date];
        } else { // 今年的其它天
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:date];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:date];
    }
}
/**
 1.今年
 1> 今天
 * 1分钟内 : 刚刚
 * 1小时内 : x分钟前
 * 其它 : x小时前
 
 2> 昨天
 昨天 09:08
 
 3> 其它
 12-11 08:07
 
 2.非今年
 2012-09-07 07:45
 */

//+ (instancetype)statusWithDict:(NSDictionary *)dict
//{
//    YFStatus *status = [[self alloc] init];
//    // 微博文字
//    status.text = dict[@"text"];
//    // 微博来源
//    status.source = dict[@"source"];
//    // 微博时间
//    status.created_at = dict[@"created_at"];
//    
//    // 微博用户
//    status.user = [YFUser userWithDict:dict[@"user"]];
//    
//    return status;
//}


- (void)setText:(NSString *)text
{
    _text = [text copy];
    
    // 保存处理完的带属性的字符串
    self.attributedText = [self attributedStringWithText:_text];
    //    NSLog(@"---------------");
    
}

- (void)setRetweeted_status:(YFStatus *)retweeted_status
{
    _retweeted_status = retweeted_status;
    // 拼接用户昵称
    NSString *newStr = [NSString stringWithFormat:@"@%@:%@", _retweeted_status.user.name, _retweeted_status.text];
    // 有转发微博, 需要生成转发微博带属性的字符串
    self.retweetedAttributedText = [self attributedStringWithText:newStr];
}

/**
 *  根据普通字符串生成带属性的字符串
 *
 *  @param text 普通字符串
 *
 *  @return 带属性的字符串
 */
- (NSMutableAttributedString *)attributedStringWithText:(NSString *)text
{
    // 利用正则表达式匹配所有的 用户昵称/话题/表情/URL
    // 匹配表情
    NSString *emotionPattern = @"\\[\\w+\\]"; //匹配以[开头 以]结尾的字符串, []之间只要是字母或数字或下划线或汉字就行, 并且可以重复1次或多次
    // 匹配发送微博的人
    NSString *atPattern = @"@\\w+:"; // ^以什么开头 $以什么结尾
    // 匹配话题
    NSString *topPattern = @"#\\w+#";
    // URL
    NSString *urlPattern = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?";
    
    // 可以使用|符号将多个规则连接在一起, 让正则表达表达式同时匹配多个规则
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@", emotionPattern, topPattern, atPattern, urlPattern];
    
    /*
    
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:NULL];
    // 数组中存储的是NSTextCheckingResult对象
    NSArray *results = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    // 创建一个带属性的字符串
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    for (int i = 0; i < results.count; i++) {
        NSTextCheckingResult *resut = results[i];
        //        NSLog(@"%@", [_text substringWithRange:resut.range]);
        // 设置特殊字符串高亮
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:resut.range];
    }
     
     return attributedStr;
    */
    
    // 定义数字记录字符串中所有的碎片
    NSMutableArray *specails = [NSMutableArray array];
    
    // 获取匹配的字符串
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        // 1.创建文本碎片对象
        YFTextPart *part = [[YFTextPart alloc] init];
        // 2.设置碎片对象的相关属性
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        part.specail = YES;
        
        if ([part.text hasPrefix:@"["] &&
            [part.text hasSuffix:@"]"]) {
            // 是表情
            part.emotion = YES;
        }
        // 3.将碎片保存到数组中
        [specails addObject:part];
    }];
    
    // 获取不匹配的字符串
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        // 1.创建文本碎片对象
        YFTextPart *part = [[YFTextPart alloc] init];
        // 2.设置碎片对象的相关属性
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        // 3.将碎片保存到数组中
        [specails addObject:part];
    }];
    
    // 无序
    //    NSLog(@"%@", specails);
    
    // 对数组进行排序
    // 回调方法每次会取出数组中的两个元素传递给我们
    // 注意:sortUsingComparator默认是按照升序排序
    // 升序 12345
    // 降序 54321
    [specails sortUsingComparator:^NSComparisonResult(YFTextPart *obj1, YFTextPart *obj2) {
        // 告诉系统传入的两个对象哪个大即可
        if (obj1.range.location > obj2.range.location) {
            return NSOrderedDescending;
        }
        
        // 默认情况下直接告诉系统前面的比后面的小
        return  NSOrderedAscending;
    }];
    
    //    NSLog(@"%@", specails);
    
    // 通过数组中的碎片生成带属性的字符串
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    
    // 定义数字保存所有特殊字符串模型
    NSMutableArray *specialsParts = [NSMutableArray array];
    
    for (YFTextPart *part in specails) {
        
        NSMutableAttributedString *temp = nil;
        if (part.emotion) {
            // 当前碎片是表情
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            attachment.image = [UIImage imageNamed:@"default/d_aini"];
            temp = [NSAttributedString attributedStringWithAttachment:attachment];
            
        }else if (part.specail)
        {
            // 当前碎片是特殊字符串
            temp = [[NSMutableAttributedString alloc] initWithString:part.text attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
            
            // 添加特殊字符串模型到数组中, 方便以后使用
            [specialsParts addObject:part];
        }else
        {
            // 当前碎片是普通字符串
            temp = [[NSMutableAttributedString alloc] initWithString:part.text];
        }
        [str appendAttributedString:temp];
    }
    
#warning 如果想要通过属性字符串计算字符串的size, 在计算之前必须先设置字符串的字体大小, 如果不设置, 计算出来的值会不正确
    [str addAttribute:NSFontAttributeName value:YFStatusTextFont range:NSMakeRange(0, str.length)];
    
    // 将特殊字符串数组绑定到属性字符串
    [str addAttribute:@"specialsParts" value:specialsParts range:NSMakeRange(0, 1)];
    return str;
    
}


@end
