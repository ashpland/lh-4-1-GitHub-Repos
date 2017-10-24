//
//  Repo.h
//  GitHub Repos
//
//  Created by Andrew on 2017-10-23.
//  Copyright © 2017 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repo : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *url;

- (instancetype)initWithName:(NSString *)name andURL:(NSURL *)url;

@end
