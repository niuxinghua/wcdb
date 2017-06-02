/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "sample_advance_main.h"
#import "WCTSampleAdvance.h"
#import "WCTSampleAdvanceMulti.h"

void sample_advance_main(NSString *baseDirectory)
{
    NSString *className = NSStringFromClass(WCTSampleAdvance.class);
    NSString *path = [baseDirectory stringByAppendingPathComponent:className];
    NSString *tableName = className;
    WCTDatabase *database = [[WCTDatabase alloc] initWithPath:path];
    [database close:^{
      [database removeFilesWithError:nil];
    }];

    //Using [as] to redirect selection
    {
        WCTSampleAdvance *object = [database getOneObjectOnResults:WCTSampleAdvance.AnyProperty.count().as(WCTSampleAdvance.intValue)
                                                         fromTable:tableName];
        NSLog(@"Count %d", object.intValue);
    }

    //Multi select
    {
        NSString *tableName2 = NSStringFromClass(WCTSampleAdvanceMulti.class);
        WCTMultiSelect *select = [[database prepareSelectMultiObjectsOnResults:{
                                                                                   WCTSampleAdvance.intValue.inTable(tableName),
                                                                                   WCTSampleAdvanceMulti.intValue.inTable(tableName2)}
                                                                    fromTables:@[ tableName, tableName2 ]] where:WCTSampleAdvance.intValue == WCTSampleAdvanceMulti.intValue];
        NSArray<WCTMultiObject *> *multiObjects = select.allMultiObjects;
        for (WCTMultiObject *multiObjects : multiObjects) {
            WCTSampleAdvance *object1 = (WCTSampleAdvance *) [multiObjects objectForKey:tableName];
            WCTSampleAdvanceMulti *object2 = (WCTSampleAdvanceMulti *) [multiObjects objectForKey:tableName2];
        }
    }

    //Column coding
    {
        WCTSampleAdvance *object = [database getOneObjectOfClass:WCTSampleAdvance.class
                                                       fromTable:tableName];
        float value = object.columnCoding.floatValue;
    }
}