//
//  FileHandler.swift
//  Demo
//
//  Created by Globallogic on 23/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import Foundation

private let fileHandler = FileHandler()

class FileHandler {
    class var sharedInstance : FileHandler{
        return fileHandler
    }
    private let fileManager = FileManager.default
    
    fileprivate init(){
        
    }
    
    func readFromFile(file : String, completion : @escaping (_ data : String?)->()){
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        queue.async {
            guard let filepath = Bundle.main.path(forResource: file, ofType: "txt")
                else {completion(nil)
                    return
            }
            do {
                let contents = try String(contentsOfFile: filepath)
                completion(contents)
            } catch {
                print("File Read Error for file \(filepath)")
                completion(nil)
            }
        }
    }
    
    func writeToFile(data: String,file : String, completion : @escaping (_ status:Bool)->()) {
        guard let path = Bundle.main.path(forResource: file, ofType: "txt")
            else {
                return completion(false)
        }
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        
        queue.async {
            var done : Bool!
            do{
                try data.write(toFile: file, atomically: true, encoding: String.Encoding.utf8 )
                done = true
            } catch{
                done = false
            }
            DispatchQueue.main.async {
                completion(done)
            }
        }
    }
    
    func deleteFile(file : String) -> Bool{
       guard let path = Bundle.main.path(forResource: file, ofType: "txt")
            else {
                return false
        }
        if fileManager.isDeletableFile(atPath: path){
            do {
                try fileManager.removeItem(atPath: path)
                return true
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }
        }
        return false
    }
    
}
