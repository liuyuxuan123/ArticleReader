
#import <Foundation/Foundation.h>
#import "BaseSQLError.h"
#import "BaseSQLTypeHeader.h"
#import <sqlite3.h>

@interface BaseSQLiteContext : NSObject

@property(strong) NSString* name;
@property sqlite3 * sqlite3_db;

/**
 * brief Open a Database,if not success,create one
 * param path:Path of the database
 * return Whether the action is success or not
 */

-(BOOL)openDataBaseWithName:(NSString *)path;
/**
 *  brief Create a table in Database,if exist,return error info
 *  param Name : Name of the table
 *  prarm Dic: Key in the table(More info in BaseSQLTypeHeader.h)
 *  param Complete: Complete handler
 */

-(void)createTableWithName:(NSString *)name
            keysDictionary:(NSDictionary<NSString*,NSString*> *) dic
                  callBack:(void (^)(BaseSQLError * error))complete;

/**
 *  brief Add a Key in the table
 *  param KName: Key's name
 *  prarm Type: Key's type
 *  prarm TableName: Table's name
 *  prarm Complete: Complete handler
 */
-(void)addKey:(NSString *)kName
      keyType:(NSString *)type
    intoTable:(NSString *)tableName
     complete:(void(^)(BaseSQLError *error))complete;

/**
 *  brief Insert data into table
 *  param DataDic: Added Key-Value pair
 *  param Name: Name of the table
 *  param complete: Complete handler
 */
-(void)insertData:(NSDictionary<NSString *,id>*)dataDic
        intoTable:(NSString *)name
         callBack:(void (^)(BaseSQLError * error))complete;

/**
 *  brief Updata data in table
 *  param DataDic: New Key-Value pair
 *  param wlStr:  Condition String(Could be nil)
 *  param Complete: Complete handler
 */
-(void)update:(NSDictionary<NSString*,id> *)dataDic
      inTable:(NSString *)tableName
  whileString:(NSString *)wlStr
     callBack:(void(^)(BaseSQLError * error))complete;
/**
 *  brief Delete data in table
 *  param tableName:Table's name
 *  param wlStr:Condition String(Could be nil)
 *  param Complete: Complete handler
 */
-(void)deleteDataFromTable:(NSString *)tableName
               whereString:(NSString *)wlStr
                  callBack:(void(^)(BaseSQLError * error))complete;
/**
 *  brief Delete a whole table
 *  param tableName: Table's name
 */
-(void)dropTable:(NSString *)tableName
        callBack:(void(^)(BaseSQLError * error))complete;
/**
 *  brief Inquiry data
 *  param keys: Data's key(nil -> Select *)
 *  param tableName: Table's name
 *  param orderKey: Sort order(nil -> Dont sort)
 *  param type: Type of Sort (BaseSQLTypeHeader.h)
 *  param wlstr: Conditional String
 *  param complete:dataArray is the inquired data
 */
-(void)selectKeys:(NSArray<NSDictionary *> *)keys
        fromTable:(NSString*)tableName
          orderBy:(NSString *)orderKey
        orderType:(NSString *)type
         whileStr:(NSString *)wlstr
         callBack:(void(^)(NSArray<NSDictionary *> * dataArray,BaseSQLError * error))complete;
/**
 *  @brief Close Context
 *  调用此方法后 这个context对象将不再有效 如果再需要使用 需要BaseSQLiteManager中的类方法再次返回
 */
-(void)closeContext;
@end
