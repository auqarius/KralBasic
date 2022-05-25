//
//  HBDate.m
//  Habbit
//
//  Created by Kral on 2018/8/15.
//  Copyright © 2018 Kral. All rights reserved.
//

#import "HBDate.h"
#include <time.h>

@implementation HBDate

+ (NSDate *)dateFromString:(NSString *)dateString {
    time_t t;
    struct tm tm;
    const char *formatterString = [@"%Y-%m-%d %H:%M:%S" cStringUsingEncoding:NSASCIIStringEncoding];
    strptime([dateString cStringUsingEncoding:NSUTF8StringEncoding], formatterString, &tm);
    tm.tm_isdst = -1;
    t = mktime(&tm);
    NSDate *result = [NSDate dateWithTimeIntervalSince1970:t + [[NSTimeZone localTimeZone] secondsFromGMT]];
    
    return result;
}

+ (NSString *)stringFrom:(NSDate *)date formatter:(NSString *)formatter {
    struct tm *timeinfo;
    char buffer[80];
    const char *formatterString = [formatter cStringUsingEncoding:NSASCIIStringEncoding];
    time_t rawtime = [date timeIntervalSince1970] - [[NSTimeZone localTimeZone] secondsFromGMT];
    timeinfo = localtime(&rawtime);
    strftime(buffer, 80, formatterString, timeinfo);
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

@end
