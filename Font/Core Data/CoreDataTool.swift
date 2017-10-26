//
//  CoreDataTool.swift
//  Font
//
//  Created by 王坤田 on 2017/10/25.
//  Copyright © 2017年 王坤田. All rights reserved.
//

import UIKit
import Foundation
import CoreData

struct CoreDataTool {
    
    static let entityName = "FontModel"
    
    private static func getContext() -> NSManagedObjectContext {
        
        let app = UIApplication.shared.delegate as! AppDelegate
        
        return app.persistentContainer.viewContext
        
    }
    
    private static func save(){
        
        let context = getContext()
        
        
        do {
            
            try context.save()
            
            print("保存成功")
            
        }catch{
            
            fatalError("不能保存：\(error)")
            
        }
    }
    
    static func insert(fontName : String , isFavorite : Bool) {
        
        let fontModel = NSEntityDescription.insertNewObject(forEntityName: entityName, into: getContext()) as! FontModel
        
        fontModel.fontName = fontName
        fontModel.isFavorite = isFavorite
        
        save()
        
    }
    
    static func delete(fontName : String){
        
        let context = getContext()

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        let predicate = NSPredicate(format: "fontName == %@", fontName)
        
        fetchRequest.predicate = predicate
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        deleteRequest.resultType = .resultTypeCount
        
        do {
            
            try context.execute(deleteRequest)
            context.refreshAllObjects()
            
            print("删除成功！")
            
            
        }catch{
            
            print("删除失败！")
        }
        
    }
    
    static func getAllFonts() -> [FontModel] {
        
        var array : [FontModel] = []
        
        
        let context = getContext()
        
        
        let fetchRequest = NSFetchRequest<FontModel>.init(entityName: entityName)
        
        do {
            
            array = try context.fetch(fetchRequest)
            
        }catch{
            
            fatalError("查询失败:\(error)")
        }
        
        return array
        
    }
    
    static func getFont(by fontName : String) -> [FontModel] {
        
        var array : [FontModel] = []
        
        
        let context = getContext()
        
        
        let fetchRequest = NSFetchRequest<FontModel>.init(entityName: entityName)
        
        fetchRequest.predicate = NSPredicate(format: "fontName == %@", fontName)
        
        do {
            
            array = try context.fetch(fetchRequest)
            
        }catch{
            
            fatalError("查询失败:\(error)")
        }
        
        return array
        
    }
    
    static func update(fontName : String, isFavorite : Bool) {
        
        let context = getContext()
        
        let updateRequest = NSBatchUpdateRequest.init(entityName: entityName)
        
        updateRequest.predicate = NSPredicate.init(format: "fontName == %@",fontName)
        
        updateRequest.propertiesToUpdate = ["isFavorite" : isFavorite]
        
        updateRequest.resultType = .statusOnlyResultType
        
        do {
            
            let batchResult = try context.execute(updateRequest) as!  NSBatchUpdateResult
            
            let flag = batchResult.result as! Bool
            
            print("更新：\(flag)")
            
        }catch{
            
            print("更新：失败")
        }
        
    }
    
    
}
