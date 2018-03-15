#import "BaseSQLiteContext.h"

@interface BaseSQLiteManager : NSObject

+(BaseSQLiteContext *)openSQLiteWithName:(NSString *)name;
+(BaseSQLiteContext *)openSQLiteWithPath:(NSString *)path;
//+(float)getSizeOfDataBase:(BaseSQLiteContext *)dataBase;
//+(float)getSizeOfDataBaseName:(NSString *)dataBaseName;
//+(float)getAllSizeOfDataBase;
//+(void)removeDataBase;

@end
