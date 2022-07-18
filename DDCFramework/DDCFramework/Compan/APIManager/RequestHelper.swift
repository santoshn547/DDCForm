//
//  RequestHelper.swift
//  Compan
//
//  Created by Ambu Sangoli on 5/31/22.
//

import Foundation
class RequestHelper : NSObject {
    
    static let shared = RequestHelper()

    var pathCreation = ""
    var url = ""
    
    func createRequestForEntity(entity:Entity, newValue: Any, entityGroupId: String,parentEntityGroupId:String){
        self.getRepeatableEntityAddress(entityData: entity, newValue: newValue, entityGroupId: entityGroupId,parentEntityGroupId:parentEntityGroupId)
        
    }
    
    
    func updateValueAPI(parameter: [String:Any]) {

        let jsonData = try! JSONSerialization.data(withJSONObject: parameter, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        ERProgressHud.shared.show()
        APIManager.sharedInstance.makeRequestToUpdateEntityValue(data: jsonData){ (success, response,statusCode)  in
            if (success) {
                ERProgressHud.shared.hide()
                if statusCode != 200 {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadAPI"), object: nil)
            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                ERProgressHud.shared.hide()
            }
        }
    }
    
    
    func updateValue(entity:Entity, newValue: Any, path: String) {
        let parameters = [
            "template_instance_id": ddcModel?.template?.instanceID ?? "" ,
            "entities": [
                path : [
                    "type": entity.type?.rawValue ?? "",
                    "title": entity.title ?? "",
                    "active": entity.active ?? false,
                    "order": entity.order ?? "",
                    "guiControlType": entity.guiControlType ?? "",
                    "id": entity.id ?? "",
                    "value": newValue,
                    "oldValue": entity.value?.value,
                    "lastUpdatedBy": "Ambu iOS",
                    "lastUpdatedDate": Int64(Date().timeIntervalSince1970) ]
            ],
            "modified_by": "Ambu iOS"
        ] as [String : Any]
            self.updateValueAPI(parameter: parameters)
    }
    
    
    func getRepeatableEntityAddress(entityData:Entity, newValue: Any,entityGroupId: String,parentEntityGroupId:String) {
        pathCreation = "Template -> "
         url = "template"
        let entityId = entityData.id ?? ""
        let mainEntities = ddcModel?.template?.sortedArray
        for entityIndex in 0..<(mainEntities?.count ?? 0) {
            if let entity = mainEntities?[entityIndex].value {
                if entity.id == entityId {
//                        print("Got entity at main Entity at index:",entityIndex.description)
                    pathCreation += "Entites[\(entityIndex.description)]"
                    url += ".entities.\(entity.uri ?? "")"
                    print(pathCreation)
                    print(url)
                    self.updateValue(entity: entityData, newValue: newValue, path: url)
                    return
                }
                if entity.type == .entityGroupRepeatable || entity.type == .entityGroup{
                    if let entityGroup = entity.sortedEntityGroupsArray {
                        for entityGroupIndex in 0..<(entityGroup.count ) {
                            if parentEntityGroupId != "99" {
                                if entityGroup[entityGroupIndex].value.uniqueId == parentEntityGroupId  {
                                    for nestedEntityIndex in 0..<(entityGroup[entityGroupIndex].value.sortedEntitiesArray?.count ?? 0) {
                                        if let entityy = entityGroup[entityGroupIndex].value.sortedEntitiesArray?[nestedEntityIndex].value {
                                        if (entity.type == .entityGroupRepeatable || entity.type == .entityGroup) && entityy.id != entityId {
                                            pathCreation = pathCreation.replacingOccurrences(of: "Entities[\(entityIndex - 1 )] ->", with: "")
                                            pathCreation = pathCreation.replacingOccurrences(of: "Entities[\(entityIndex)] ->", with: "")

                                            url = url.replacingOccurrences(of: ".entities.\(entity.uri ?? "")", with: "")

                                            url += ".entities.\(entity.uri ?? "")"
                                            url += ".entity_groups[\(entityGroupIndex.description)].\(entityGroup[entityGroupIndex].value.uri ?? "")"
                                            pathCreation += "Entities[\(entityIndex)] -> "
                                            pathCreation += "Entity Group[\(entityGroupIndex)] -> "
                                        }
                                        if entityy.id == entityId {
                                            url += ".entities.\(entityy.uri ?? "")"
                                            pathCreation += "Entites[\(nestedEntityIndex.description)]"

                                            print(pathCreation)
                                            print(url)
                                            self.updateValue(entity: entityData, newValue: newValue, path: url)
                                            return
                                        }
                                        pathCreation = "Template -> Entites[\(entityIndex.description)] -> Entity Group[\(entityGroupIndex)] -> "
                                            url = "template.entities.\(entity.uri ?? "").entity_groups[\(entityGroupIndex.description)].\(entityGroup[entityGroupIndex].value.uri ?? "")"
                                        self.repeatableForLoopCheck(entity: entityy, entityIndex: nestedEntityIndex, entityId: entityId,entityData: entityData,newValue: newValue, entityGroupId: entityGroupId)
                                }
                            }
                        }
                            } else {
                                if entityGroup[entityGroupIndex].value.uniqueId == entityGroupId  {
                                    for nestedEntityIndex in 0..<(entityGroup[entityGroupIndex].value.sortedEntitiesArray?.count ?? 0) {
                                        if let entityy = entityGroup[entityGroupIndex].value.sortedEntitiesArray?[nestedEntityIndex].value {
                                    if (entity.type == .entityGroupRepeatable || entity.type == .entityGroup) && entityy.id != entityId {
                                        pathCreation = pathCreation.replacingOccurrences(of: "Entities[\(entityIndex - 1 )] ->", with: "")
                                        pathCreation = pathCreation.replacingOccurrences(of: "Entities[\(entityIndex)] ->", with: "")

                                        url = url.replacingOccurrences(of: ".entities.\(entity.uri ?? "")", with: "")

                                        url += ".entities.\(entity.uri ?? "")"
                                        url += ".entity_groups[\(entityGroupIndex.description)].\(entityGroup[entityGroupIndex].value.uri ?? "")"
                                        pathCreation += "Entities[\(entityIndex)] -> "
                                        pathCreation += "Entity Group[\(entityGroupIndex)] -> "
                                    }
                                    if entityy.id == entityId {
                                        url += ".entities.\(entityy.uri ?? "")"
                                        pathCreation += "Entites[\(nestedEntityIndex.description)]"

                                        print(pathCreation)
                                        print(url)
                                        self.updateValue(entity: entityData, newValue: newValue, path: url)
                                        return
                                    }
                                    pathCreation = "Template -> Entites[\(entityIndex.description)] -> Entity Group[\(entityGroupIndex)] -> "
                                            url = "template.entities.\(entity.uri ?? "").entity_groups[\(entityGroupIndex.description)].\(entityGroup[entityGroupIndex].value.uri ?? "")"
                                    self.repeatableForLoopCheck(entity: entityy, entityIndex: nestedEntityIndex, entityId: entityId,entityData: entityData,newValue: newValue, entityGroupId: entityGroupId)
                            }
                        }
                    }
                  }
                }
                    }
            }
        }
    }
 }
    
    func repeatableForLoopCheck( entity: Entity,entityIndex: Int,entityId: String,entityData: Entity, newValue: Any,entityGroupId: String){
                if entity.type == .entityGroupRepeatable || entity.type == .entityGroup {
                    if let entityGroup = entity.sortedEntityGroupsArray {
                        for entityGroupIndex in 0..<(entityGroup.count ) {
                            if entityGroup[entityGroupIndex].value.uniqueId == entityGroupId {
                                for nesstedEntityIndex in 0..<(entityGroup[entityGroupIndex].value.sortedEntitiesArray?.count ?? 0) {
                                    if let entityy = entityGroup[entityGroupIndex].value.sortedEntitiesArray?[nesstedEntityIndex].value {
                                    if entityy.type == .entityGroupRepeatable || entityy.type == .entityGroup {
                                        pathCreation += "Entity Group[\(entityGroupIndex)] -> "
                                        
                                        url += ".entity_groups[\(entityGroupIndex.description)].\(entityGroup[entityGroupIndex].value.uri ?? "")"
                                    } else {
                                        pathCreation = pathCreation.replacingOccurrences(of: "Entities[\(entityIndex - 1 )] ->", with: "")
                                        pathCreation = pathCreation.replacingOccurrences(of: "Entities[\(entityIndex)] ->", with: "")
                                        pathCreation += "Entities[\(entityIndex)] -> "
                                        url = url.replacingOccurrences(of: ".entities.\(entity.uri ?? "")", with: "")
                                        url += ".entities.\(entity.uri ?? "")"
                                    }
                                    if entityy.id == entityId {
                                        pathCreation += "Entity Group[\(entityGroupIndex)] ->  Entites[\(nesstedEntityIndex.description)]"
                                        print(pathCreation)
                                        
                                        url += ".entity_groups[\(entityGroupIndex.description)].\(entityGroup[entityGroupIndex].value.uri ?? "").entities.\(entityy.uri ?? "")"
                                        print(url)
                                        self.updateValue(entity: entityData, newValue: newValue, path: url)
                                        return
                                    }
                                    self.repeatableForLoopCheck(entity: entityy, entityIndex: nesstedEntityIndex, entityId: entityId,entityData: entityData,newValue: newValue, entityGroupId: entityGroupId)
                            }
                        }
                    }
                  }
                }
            }
        }
   
    func repeatEntityGroup(entityGroupToRepeat: EntityRepeatableGroup){
        let mainEntities = ddcModel?.template?.sortedArray
        for entityIndex in 0..<(mainEntities?.count ?? 0) {
            if let entity = mainEntities?[entityIndex].value {
                if entity.type == .entityGroupRepeatable {
                    if let entityGroup = entity.sortedEntityGroupsArray {
                        var orderArray : [Int] = []
                        for entityGroupIndex in 0..<(entityGroup.count ) {
                            let data = entityGroup[entityGroupIndex].value
                            orderArray.append(data.order ?? 0)
                        }
                        for entityGroupIndex in 0..<(entityGroup.count ) {
                            let data = entityGroup[entityGroupIndex].value
                            if entityGroup[entityGroupIndex].value.uri == entityGroupToRepeat.uri {
                                let heighValue = orderArray.max() ?? 0

                                let entityGroupToAdd : EntityRepeatableGroup = EntityRepeatableGroup(type: data.type, title: data.title, active: data.active, order: heighValue + 1, guiControlType: data.guiControlType, id: data.id, value: data.value, oldValue: data.oldValue, lastUpdatedBy: data.lastUpdatedBy, lastUpdatedDate: data.lastUpdatedDate, uri: data.uri, valueSetRef: data.valueSetRef, settings: data.settings, entityGroups: data.entityGroups, isRepeated: data.isRepeated, entities: data.entities,sortedEntityGroupsArray: data.sortedEntityGroupsArray, sortedEntitiesArray: data.sortedEntitiesArray, uniqueId: self.randomStringWithLength())
                                
                                let group : Dictionary<String, EntityRepeatableGroup> = [entityGroupToRepeat.uri! : entityGroupToAdd]
                                
                                ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?.insert(contentsOf: group, at: entityGroupIndex + 1)
                                self.addRepeatableEntityGroup(object: [entityGroupToRepeat.uri ?? "" : Utilities.shared.convertToDictionary(text: entityGroupToAdd.convertToString!) ?? ""],path: "template.entities.\(entity.uri ?? "").entity_groups")
                                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
                                return
                            } else {
                                self.repeatEntityGroupCheck(entityGroupToRepeat: entityGroupToRepeat, entities: data.sortedEntitiesArray, mainEntityIndex: entityIndex,entityGroupsIndex: entityGroupIndex)
                                return
                            }
                        }
                    }
                }
            }
        }
        
    }
    
func repeatEntityGroupCheck(entityGroupToRepeat: EntityRepeatableGroup, entities:[Dictionary<String, Entity>.Element]?,mainEntityIndex:Int,entityGroupsIndex:Int) {
    for entityIndex in 0..<(entities?.count ?? 0) {
        if let entity = entities?[entityIndex].value {
            if entity.type == .entityGroupRepeatable {
                if var entityGroup = entity.sortedEntityGroupsArray {
                    var orderArray : [Int] = []
                    for entityGroupIndex in 0..<(entityGroup.count ) {
                        let data = entityGroup[entityGroupIndex].value
                        orderArray.append(data.order ?? 0)
                    }
                    for entityGroupIndex in 0..<(entityGroup.count ) {
                        let data = entityGroup[entityGroupIndex].value
                        if data.uri == entityGroupToRepeat.uri {
                            let heighValue = orderArray.max() ?? 0

                            let entityGroupToAdd : EntityRepeatableGroup = EntityRepeatableGroup(type: data.type, title: data.title, active: data.active, order: heighValue + 1, guiControlType: data.guiControlType, id: data.id, value: data.value, oldValue: data.oldValue, lastUpdatedBy: data.lastUpdatedBy, lastUpdatedDate: data.lastUpdatedDate, uri: data.uri, valueSetRef: data.valueSetRef, settings: data.settings, entityGroups: data.entityGroups, isRepeated: data.isRepeated, entities: data.entities,sortedEntityGroupsArray: data.sortedEntityGroupsArray, sortedEntitiesArray: data.sortedEntitiesArray, uniqueId: self.randomStringWithLength())
                            let group : Dictionary<String, EntityRepeatableGroup> = [entityGroupToRepeat.uri! : entityGroupToAdd]
                            entityGroup.insert(contentsOf: group, at: entityGroupIndex + 1)

                            ddcModel?.template?.sortedArray?[mainEntityIndex].value.sortedEntityGroupsArray?[entityGroupsIndex].value.sortedEntitiesArray?[entityIndex].value.sortedEntityGroupsArray?.insert(entityGroup[entityGroupIndex], at: entityGroupIndex + 1)
                            
                            let path = "template.entities.\(ddcModel?.template?.sortedArray?[mainEntityIndex].value.uri ?? "").entity_groups[\(entityGroupsIndex.description)].\(ddcModel?.template?.sortedArray?[mainEntityIndex].value.sortedEntityGroupsArray?[entityGroupsIndex].value.uri ?? "").entities.\(ddcModel?.template?.sortedArray?[mainEntityIndex].value.sortedEntityGroupsArray?[entityGroupsIndex].value.sortedEntitiesArray?[entityIndex].value.uri ?? "").entity_groups"
                            
                            self.addRepeatableEntityGroup(object: [entityGroupToRepeat.uri ?? "" : Utilities.shared.convertToDictionary(text: entityGroupToAdd.convertToString!) ?? ""],path: path)

                             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
                            return
                        }  else {
                            self.repeatEntityGroupCheck(entityGroupToRepeat: entityGroupToRepeat, entities: data.sortedEntitiesArray, mainEntityIndex: entityIndex,entityGroupsIndex: entityGroupIndex)
                            return
                        }
                    }
                }
            }
    }
    }
}
    
    func removeEntityGroup(entityGroupToRepeat: EntityRepeatableGroup){
        let mainEntities = ddcModel?.template?.sortedArray
        for entityIndex in 0..<(mainEntities?.count ?? 0) {
            if let entity = mainEntities?[entityIndex].value {
                if entity.type == .entityGroupRepeatable {
                    if let entityGroup = entity.sortedEntityGroupsArray {
                        for entityGroupIndex in 0..<(entityGroup.count ) {
                            if entityGroup[entityGroupIndex].value.uri == entityGroupToRepeat.uri {
                                if entityGroupIndex <= ((ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?.count ?? 0) - 1) {
                                    ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?.remove(at: entityGroupIndex)
                                    self.deleteRepeatableEntityGroup(object: [entityGroupToRepeat.uri ?? "" : Utilities.shared.convertToDictionary(text: entityGroupToRepeat.convertToString!) ?? ""],path: "template.entities.\(entity.uri ?? "").entity_groups")

                                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
                                    return
                                }
                            } else {
                                self.removeRepeatEntityGroupCheck(entityGroupToRepeat: entityGroupToRepeat, entities: entityGroup[entityGroupIndex].value.sortedEntitiesArray, mainEntityIndex: entityIndex,entityGroupsIndex: entityGroupIndex)
                                return
                            }
                        }
                    }
                }
            }
        }
    }
    
    func removeRepeatEntityGroupCheck(entityGroupToRepeat: EntityRepeatableGroup, entities:[Dictionary<String, Entity>.Element]?,mainEntityIndex:Int,entityGroupsIndex:Int) {
        for entityIndex in 0..<(entities?.count ?? 0) {
            if let entity = entities?[entityIndex].value {
                if entity.type == .entityGroupRepeatable {
                    if var entityGroup = entity.sortedEntityGroupsArray {
                        for entityGroupIndex in 0..<(entityGroup.count ) {
                            if entityGroup[entityGroupIndex].value.uri == entityGroupToRepeat.uri {
                                let group : Dictionary<String, EntityRepeatableGroup> = [entityGroupToRepeat.uri! : entityGroupToRepeat]
                                entityGroup.insert(contentsOf: group, at: entityGroupIndex + 1)
                                
                                if entityGroupIndex <= ((ddcModel?.template?.sortedArray?[mainEntityIndex].value.sortedEntityGroupsArray?[entityGroupsIndex].value.sortedEntitiesArray?[entityIndex].value.sortedEntityGroupsArray?.count ?? 0) - 1) {
                                    ddcModel?.template?.sortedArray?[mainEntityIndex].value.sortedEntityGroupsArray?[entityGroupsIndex].value.sortedEntitiesArray?[entityIndex].value.sortedEntityGroupsArray?.remove( at: entityGroupIndex + 1)
                                    let path = "template.entities.\(ddcModel?.template?.sortedArray?[mainEntityIndex].value.uri ?? "").entity_groups[\(entityGroupsIndex.description)].\(ddcModel?.template?.sortedArray?[mainEntityIndex].value.sortedEntityGroupsArray?[entityGroupsIndex].value.uri ?? "").entities.\(ddcModel?.template?.sortedArray?[mainEntityIndex].value.sortedEntityGroupsArray?[entityGroupsIndex].value.sortedEntitiesArray?[entityIndex].value.uri ?? "").entity_groups"
                                    self.deleteRepeatableEntityGroup(object: [entityGroupToRepeat.uri ?? "" : Utilities.shared.convertToDictionary(text: entityGroupToRepeat.convertToString!) ?? ""],path: path)
                                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
                                    return
                                }
                            }  else {
                                self.repeatEntityGroupCheck(entityGroupToRepeat: entityGroupToRepeat, entities: entityGroup[entityGroupIndex].value.sortedEntitiesArray,mainEntityIndex: entityIndex,entityGroupsIndex: entityGroupIndex)
                                return
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func addRepeatableEntityGroup(object: [String : Any],path: String ) {
        let parameters : [String : Any] = [
        
          "entity_group_object": object,
          "entity_group_path": path,
          "modified_by": "Ambu iOS",
          "template_instance_id": ddcModel?.template?.instanceID ?? ""
        
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        ERProgressHud.shared.show()
        APIManager.sharedInstance.makeRequestToAddRepeatableEntityGroup(data: jsonData){ (success, response,statusCode)  in
            if (success) {
                ERProgressHud.shared.hide()
                if statusCode != 200 {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                }
            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                ERProgressHud.shared.hide()
            }
        }
    }
    
    func deleteRepeatableEntityGroup(object: [String : Any],path: String ) {
        let parameters : [String : Any] = [
        
          "entity_group_object": object,
          "entity_group_path": path,
          "modified_by": "Ambu iOS",
          "template_instance_id": ddcModel?.template?.instanceID ?? ""
        
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        ERProgressHud.shared.show()
        APIManager.sharedInstance.makeRequestToDeleteRepeatableEntityGroup(data: jsonData){ (success, response,statusCode)  in
            if (success) {
                ERProgressHud.shared.hide()
                if statusCode != 200 {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                }
            } else {
//                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                ERProgressHud.shared.hide()
            }
        }
    }
    
    

    
    func randomStringWithLength(len: Int = 10) -> String {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

        let randomString : NSMutableString = NSMutableString(capacity: len)

        for _ in 1...len{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }

        return randomString as String
    }

}
