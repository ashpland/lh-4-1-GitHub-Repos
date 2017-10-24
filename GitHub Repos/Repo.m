//
//  Repo.m
//  GitHub Repos
//
//  Created by Andrew on 2017-10-23.
//  Copyright © 2017 Andrew. All rights reserved.
//

#import "Repo.h"

@implementation Repo

- (instancetype)initWithName:(NSString *)name andURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        _name = name;
        _url = url;
    }
    return self;
}


@end
