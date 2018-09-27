//
//  GGLine.m
//  GGCharts
//
//  Created by _ | Durex on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGLine.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 增加线路径
 *
 * @param ref 路径结构体
 * @param line 直线结构体
 */
void GGPathAddLine(CGMutablePathRef ref, GGLine line)
{
    CGPathMoveToPoint(ref, NULL, line.start.x, line.start.y);
    CGPathAddLineToPoint(ref, NULL, line.end.x, line.end.y);
}

/**
 * 绘制折线
 *
 * @param ref 路径结构体
 * @param points 折线点
 * @param range 区间
 */
void GGPathAddRangePoints(CGMutablePathRef ref, CGPoint * points, NSRange range)
{
    BOOL isMovePoint = YES;
    
    NSUInteger size = NSMaxRange(range);
    
    for (NSInteger i = range.location; i < size; i++) {
        
        CGPoint point = points[i];
        
        if (CGPointEqualToPoint(point, CGPointMake(FLT_MIN, FLT_MIN))) {
            
            isMovePoint = YES;
            
            continue;
        }
        
        if (isMovePoint) {
            
            isMovePoint = NO;
            
            CGPathMoveToPoint(ref, NULL, point.x, point.y);
        }
        else {
            
            CGPathAddLineToPoint(ref, NULL, point.x, point.y);
        }
    }
}

/**
 * 绘制折线
 *
 * @param ref 路径结构体
 * @param points 折线点
 * @param size 折线大小
 */
void GGPathAddPoints(CGMutablePathRef ref, CGPoint * points, size_t size)
{
    GGPathAddRangePoints(ref, points, NSMakeRange(0, size));
}

/**
 * 折线每个点于某一y坐标展开动画
 *
 * @param points 折线点
 * @param size 折线大小
 * @param y 指定y轴坐标
 *
 * @return 路径动画数组
 */
NSArray * GGPathLinesStretchAnimation(CGPoint * points, size_t size, CGFloat y)
{
    NSMutableArray * ary = [NSMutableArray array];
    
    for (NSInteger i = 0; i < size; i++) {
        
        CGPoint basePoints[size];
        
        for (NSInteger j = 0; j < size; j++) {
            
            basePoints[j] = CGPointMake(points[j].x, y);
        }
        
        for (NSInteger z = 0; z < i; z++) {
            
            basePoints[z] = CGPointMake(points[z].x, points[z].y);
        }
        
        CGMutablePathRef ref = CGPathCreateMutable();
        CGPathAddLines(ref, NULL, basePoints, size);
        [ary addObject:(__bridge id)ref];
        CGPathRelease(ref);
    }
    
    CGMutablePathRef ref = CGPathCreateMutable();
    CGPathAddLines(ref, NULL, points, size);
    [ary addObject:(__bridge id)ref];
    CGPathRelease(ref);
    
    return ary;
}

/**
 * 折线于某一y坐标展开动画
 *
 * @param points 折线点
 * @param size 折线大小
 * @param y 指定y轴坐标
 *
 * @return 路径动画数组
 */
NSArray * GGPathLinesUpspringAnimation(CGPoint * points, size_t size, CGFloat y)
{
    NSMutableArray * ary = [NSMutableArray array];
    
    CGPoint basePoints[size];
    
    for (NSInteger i = 0; i < size; i++) {
        
        basePoints[i] = CGPointMake(points[i].x, y);
    }
    
//    CGMutablePathRef ref = CGPathCreateMutable();
//    CGPathAddLines(ref, NULL, basePoints, size);
//    [ary addObject:(__bridge id)ref];
//    CGPathRelease(ref);
    
//    ref = CGPathCreateMutable();
//    CGPathAddLines(ref, NULL, points, size);
//    [ary addObject:(__bridge id)ref];
//    CGPathRelease(ref);
    
    //绘制曲线
    UIBezierPath *path1=[UIBezierPath bezierPath];
    CGPoint prePoint;
    CGPoint nowPoint;
    for (int i=0; i< size; i++) {
        if (i==0) {
            prePoint = basePoints[i];
            [path1 moveToPoint:prePoint];
        }else{
            nowPoint = basePoints[i];

            [path1 addCurveToPoint:nowPoint controlPoint1:CGPointMake((prePoint.x+nowPoint.x)/2.0, prePoint.y) controlPoint2:CGPointMake((prePoint.x+nowPoint.x)/2.0, nowPoint.y)];

            prePoint=nowPoint;
        }
    }
     [ary addObject:(__bridge id)path1.CGPath];
    
    UIBezierPath *path2=[UIBezierPath bezierPath];
    CGPoint prePoint1;
    CGPoint nowPoint1;
    for (int i=0; i< size; i++) {
        if (i==0) {
            prePoint1 = points[i];
            [path2 moveToPoint:prePoint1];
        }else{
            nowPoint1 = points[i];
            
            [path2 addCurveToPoint:nowPoint1 controlPoint1:CGPointMake((prePoint1.x+nowPoint1.x)/2.0, prePoint1.y) controlPoint2:CGPointMake((prePoint1.x+nowPoint1.x)/2.0, nowPoint1.y)];
            
            prePoint1=nowPoint1;
        }
    }
    [ary addObject:(__bridge id)path2.CGPath];
    
    return ary;
}

/**
 * 折线填充每个点于某一y坐标展开动画
 *
 * @param points 折线点
 * @param size 折线大小
 * @param y 指定y轴坐标
 *
 * @return 路径动画数组
 */
NSArray * GGPathFillLinesStretchAnimation(CGPoint * points, size_t size, CGFloat y)
{
    NSMutableArray * ary = [NSMutableArray array];
    
    for (NSInteger i = 0; i < size; i++) {
        
        CGPoint basePoints[size];
        
        for (NSInteger j = 0; j < size; j++) {
            
            basePoints[j] = CGPointMake(points[j].x, y);
        }
        
        for (NSInteger z = 0; z < i; z++) {
            
            basePoints[z] = CGPointMake(points[z].x, points[z].y);
        }
        
        CGMutablePathRef ref = CGPathCreateMutable();
        CGPathAddLines(ref, NULL, basePoints, size);
        CGPathAddLineToPoint(ref, NULL, basePoints[size - 1].x, y);
        CGPathAddLineToPoint(ref, NULL, basePoints[0].x, y);
        [ary addObject:(__bridge id)ref];
        CGPathRelease(ref);
    }
    
    CGMutablePathRef ref = CGPathCreateMutable();
    CGPathAddLines(ref, NULL, points, size);
    CGPathAddLineToPoint(ref, NULL, points[size - 1].x, y);
    CGPathAddLineToPoint(ref, NULL, points[0].x, y);
    [ary addObject:(__bridge id)ref];
    CGPathRelease(ref);
    
    return ary;
}

/**
 * 折线填充于某一y坐标展开动画
 *
 * @param points 折线点
 * @param size 折线大小
 * @param y 指定y轴坐标
 *
 * @return 路径动画数组
 */
NSArray * GGPathFillLinesUpspringAnimation(CGPoint * points, size_t size, CGFloat y)
{
    NSMutableArray * ary = [NSMutableArray array];
    
    CGPoint basePoints[size];
    
    for (NSInteger i = 0; i < size; i++) {
        
        basePoints[i] = CGPointMake(points[i].x, y);
    }
    //填充直线区域
//    CGMutablePathRef ref = CGPathCreateMutable();
//    CGPathAddLines(ref, NULL, basePoints, size);
//    CGPathAddLineToPoint(ref, NULL, basePoints[size - 1].x, y);
//    CGPathAddLineToPoint(ref, NULL, basePoints[0].x, y);
//    [ary addObject:(__bridge id)ref];
//    CGPathRelease(ref);
//    
//    ref = CGPathCreateMutable();
//    CGPathAddLines(ref, NULL, points, size);
//    CGPathAddLineToPoint(ref, NULL, points[size - 1].x, y);
//    CGPathAddLineToPoint(ref, NULL, points[0].x, y);
//    [ary addObject:(__bridge id)ref];
//    CGPathRelease(ref);
    
    //填充曲线区域
    CGPoint lineFirstPoint = basePoints[0];
    CGPoint lineLastPoint = basePoints[size - 1];

    UIBezierPath *path=[UIBezierPath bezierPath];
    CGPoint prePoint;
    CGPoint nowPoint;
    for (int i=0; i<size; i++) {
        if (i==0) {
            prePoint = basePoints[i];
            [path moveToPoint:prePoint];
        }else{
            nowPoint = basePoints[i];

            [path addCurveToPoint:nowPoint controlPoint1:CGPointMake((prePoint.x+nowPoint.x)/2.0, prePoint.y) controlPoint2:CGPointMake((prePoint.x+nowPoint.x)/2.0, nowPoint.y)];

            prePoint=nowPoint;
        }
    }
    [path addLineToPoint:CGPointMake(lineLastPoint.x, y)];
    [path addLineToPoint:CGPointMake(lineFirstPoint.x, y)];
    [path closePath];
    [ary addObject:(__bridge id)path.CGPath];
    
    CGPoint lineFirstPoint1 = points[0];
    CGPoint lineLastPoint1 = points[size - 1];
    
    UIBezierPath *path1=[UIBezierPath bezierPath];
    CGPoint prePoint1;
    CGPoint nowPoint1;
    for (int i=0; i<size; i++) {
        if (i==0) {
            prePoint1 = points[i];
            [path1 moveToPoint:prePoint1];
        }else{
            nowPoint1 = points[i];
            
            [path1 addCurveToPoint:nowPoint1 controlPoint1:CGPointMake((prePoint1.x+nowPoint1.x)/2.0, prePoint1.y) controlPoint2:CGPointMake((prePoint1.x+nowPoint1.x)/2.0, nowPoint1.y)];
            
            prePoint1 = nowPoint1;
        }
    }
    [path1 addLineToPoint:CGPointMake(lineLastPoint1.x, y)];
    [path1 addLineToPoint:CGPointMake(lineFirstPoint1.x, y)];
    [path1 closePath];
    [ary addObject:(__bridge id)path1.CGPath];
    
    return ary;
}

/**
 * NSValue 扩展
 */
@implementation NSValue (GGValueGGLineExtensions)

GGValueMethodImplementation(GGLine);

@end

NS_ASSUME_NONNULL_END
