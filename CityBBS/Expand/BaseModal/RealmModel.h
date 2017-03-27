//
//  RealmModel.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Realm/Realm.h>

@interface RealmModel : RLMObject
@property  NSString *ID;

@end



@class Person;
// 狗狗的数据模型
@interface Dog : RLMObject
{
    NSString *name1;

}
@property NSString *name;
@property Person   *owner;

@end
RLM_ARRAY_TYPE(Dog) //定义RLMArray<Dog>

// 狗狗主人的数据模型
@interface Person : RLMObject
@property NSString      *name;
@property NSDate        *birthdate;
@property RLMArray<Dog> *dogs;
@end
//RLM_ARRAY_TYPE(Person) // 定义RLMArray<Person>
