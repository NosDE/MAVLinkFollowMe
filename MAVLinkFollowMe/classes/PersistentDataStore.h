//
//  PersistentDataStore.h
//
//  Created by Marco Bauer on 06.04.2014.
//  Copyright (c) 2014 de.wtns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersistentDataStore : NSObject <NSCoding>{

    double tcpPort;
    NSString *tcpHost;

}

@property (readwrite) double		tcpPort;
@property (readwrite) NSString		*tcpHost;


+ (PersistentDataStore *)getData;
- save;
- load;

@end

