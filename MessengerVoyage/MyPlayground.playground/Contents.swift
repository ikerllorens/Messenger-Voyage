//: Playground - noun: a place where people can play

import UIKit

import Foundation

class PropertyListSerialization{
    class func loadFromFile(filePath:String, inout error:NSError?) -> Any?{
        var anError : NSError?
        
        let data : NSData! = NSData.dataWithContentsOfMappedFile(filePath) as! NSData//(filePath, options: NSDataReadingOptions.DataReadingUncached, error: anError)
        
        //Could we load the data?
        if let theError = anError{
            error = theError
            return nil
        }
        
        let pList : AnyObject! = NSPropertyListSerialization.propertyListWithData(
            data,
            options: 0,
            format: nil,
            error: anError)
        
        //Could we load the property list from the data?
        if let theError = anError{
            error = theError
            return nil
        }
        
        return swiftNativest(pList)
    }
    
    class func swiftNativest(object:AnyObject) -> Any?{
        
        if let nsDict:NSDictionary = object as? NSDictionary{
            var swiftDict : Dictionary<String,Any!> = Dictionary<String,Any!>()
            
            for key : AnyObject in nsDict.allKeys{
                let stringKey : String = key as! String
                
                if let keyValue : AnyObject = nsDict.valueForKey(stringKey){
                    swiftDict[stringKey] = swiftNativest(keyValue)
                }
            }
            
            return swiftDict
        } else if let nsArray:NSArray = object as? NSArray{
            var swiftArray : Array<Any!> = Array<Any!>()
            
            for value : AnyObject in nsArray{
                swiftArray.append(swiftNativest(value))
            }
            
            return swiftArray
        } else if let nsNumber:NSNumber = object as? NSNumber{
            return nsNumber.integerValue
        } else if let nsString:NSString = object as? NSString{
            return nsString as String
        }
        
        return nil
    }
}

let pListFilePath = "/Users/you/your.plist"
var anError : NSError?

if let pList = PropertyListSerialization.loadFromFile(pListFilePath, error: &anError){
    print("(pList)")
}