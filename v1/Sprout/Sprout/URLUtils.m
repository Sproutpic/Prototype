//
//  URLUtils.m
//  Sprout
//
//  Created by LLDM 0038 on 05/08/2016.
//  Copyright © 2016 sprout. All rights reserved.
//

#import "URLUtils.h"

@implementation URLUtils
-(NSString *)urlBase{
    return @"http://www.sproutpic.com/api/Mobile";
}
-(NSString *)urlCreateUser{
    return [NSString stringWithFormat:@"%@/Register",[self urlBase]];
}
-(NSString *)urlLoginUser{
    return [NSString stringWithFormat:@"%@/Login",[self urlBase]];
}
@end
