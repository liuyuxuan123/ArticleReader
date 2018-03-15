#import "BaseSQLiteManager.h"

@implementation BaseSQLiteManager


+(instancetype)standardBaseSQLManager{
    static BaseSQLiteManager * sharedModel = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedModel = [[BaseSQLiteManager alloc] init];
    });
    return sharedModel;
   
}

+(BaseSQLiteContext *)openSQLiteWithName:(NSString *)name{
    
    NSString * path =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    BaseSQLiteContext * context = [[BaseSQLiteContext alloc]init];
    context.name = name;
    
    //NSLog(@"SQL's Path = %@",[NSString stringWithFormat:@"%@/%@",path,name]);
    BOOL success = [context openDataBaseWithName:[NSString stringWithFormat:@"%@/%@",path,name]];
    
    if (success) {
        return context;
    }else{
        return nil;
    }
}

+(BaseSQLiteContext *)openSQLiteWithPath:(NSString *)path{
    BaseSQLiteContext * context = [[BaseSQLiteContext alloc]init];
    NSString * name = [path componentsSeparatedByString:@"/"].lastObject;
    context.name = name;
    BOOL success = [context openDataBaseWithName:path];
    if (success) {
        return context;
    }else{
        return nil;
    }
}

//+(float)getSizeOfDataBase:(BaseSQLiteContext *)dataBase{
//    return [[BaseCecheCenter sharedTheSingletion]getSizeFromDataBaseName:dataBase.name];
//}
//+(float)getSizeOfDataBaseName:(NSString *)dataBaseName{
//    return [[BaseCecheCenter sharedTheSingletion]getSizeFromDataBaseName:dataBaseName];
//}
//+(float)getAllSizeOfDataBase{
//    return [[BaseCecheCenter sharedTheSingletion]getAllDataBaseSize];
//}
//+(void)removeDataBase{
//    return [[BaseCecheCenter sharedTheSingletion]removeCacheFromPath:BaseDataBase];
//}
@end
