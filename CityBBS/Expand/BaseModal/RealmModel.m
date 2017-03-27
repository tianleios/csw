//
//  RealmModel.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "RealmModel.h"

@implementation RealmModel

#pragma mark- 声明属性不允许为空
/**
 1.name 属性将不允许为空
 */
+ (NSArray *)requiredProperties {
    return @[@"name"];
}


#pragma mark- 忽略属性
/**
 2.
 重写 +ignoredProperties 可以防止 Realm 存储数据模型的某个属性。
 Realm 将不会干涉这些属性的常规操作，它们将由成员变量(ivar)提供支持，
 并且您能够轻易重写它们的 setter 和 getter。
 */
+ (NSArray *)ignoredProperties {
    
    return @[@"tmpID"];
    
}

#pragma mark- 主键
/**
 3.主键，声明主键之后，对象将允许进行查询，并且更新速度更加高效
 */
+ (NSString *)primaryKey {
    return @"ID";
}

@end


#pragma mark- 狗狗和主人的实现
@implementation Dog
@end

@implementation Person


+ (void)realmTest {
    
    //
    Dog *kit = [[Dog alloc] init];
    Dog *yang = [[Dog alloc] init];
    
   //
    Person *tianlei = [[Person alloc] init];
    tianlei.name = @"田磊";
    tianlei.birthdate = [NSDate date];
    
    [tianlei.dogs addObject:kit];
    [tianlei.dogs addObject:yang];

    
    //1.增---存储::: relalm线程间不能共享
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    //方式1
    [realm beginWriteTransaction];
    [realm addObject:tianlei];
    [realm commitWriteTransaction];
    
    //方式2
    [realm transactionWithBlock:^{
        
        [realm addObject:tianlei];

    }];
    
    //2.删除对象
    [realm beginWriteTransaction];
    [realm deleteObject:tianlei];
    [realm commitWriteTransaction];
    
    //3.改--更新对象
    [realm beginWriteTransaction];
    tianlei.name = @"磊";
    [realm commitWriteTransaction];


    //4.查询对象
    RLMResults<Dog *> *dogs = [Dog allObjects];
    RLMResults<Dog *> *tanDogs = [Dog objectsWhere:@"color = '棕黄色' AND name BEGINSWITH '大'"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"color = %@ AND name BEGINSWITH %@",@"棕黄色", @"大"];
    tanDogs = [Dog objectsWithPredicate:pred];

    //4.1排序
    RLMResults<Dog *> *sortedDogs = [[Dog objectsWhere:@"color = '棕黄色' AND name BEGINSWITH '大'"] sortedResultsUsingProperty:@"name" ascending:YES];
                                     

}


- (void)threadIntroduce {

    
   //Realm 通过确保每个线程始终拥有 Realm 的一个快照，以便让并发运行变得十分轻松
   //你可以同时有任意数目的线程访问同一个 Realm 文件，并且由于每个线程都有对应的快照，因此线程之间绝不会产生影响
   //RLMRealm、RLMObject、RLMResults 或者 RLMArray 受管理实例皆_受到线程的限制_，这意味着它们只能够在被创建的线程上使用，否则就会抛出异常*

}

@end



