//
//  HBDate.h
//  Habbit
//
//  Created by Kral on 2018/8/15.
//  Copyright © 2018 Kral. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBDate : NSObject

/**
 字符串转日期，完全按照日期来转，传什么转什么

 @param dateString 日期字符串
 @return 日期
 */
+ (NSDate *)dateFromString:(NSString *)dateString;

/**
 日期转字符串（0 时区日期）

 @param date 日期
 @param formatter 输出格式
 @return 字符串
 */
+ (NSString *)stringFrom:(NSDate*)date formatter:(NSString *)formatter;

@end

NS_ASSUME_NONNULL_END
