//
//  RoboboManager.swift
//  robobo-framework-ios
//
//  Created by Luis Felipe Llamas Luaces on 21/02/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//

import UIKit
public class RoboboManager: NSObject {
    
    var loadedModules: [String: IModule] = [:]
    var frameworkDelegates : [RoboboManagerDelegate]
    var state = RoboboManagerState.CREATED
    let logger : Logger
    
    
    
    public override init() {
        frameworkDelegates = [RoboboManagerDelegate]()
        self.logger = Logger()
    }
    

    public func isStartedUp() -> Bool{
        return self.state == RoboboManagerState.RUNNING
    }

    public func currentState() -> RoboboManagerState{
        return self.state
    }
    
    public func log(_ text:String, _ logLevel:LogLevel = LogLevel.DEBUG){
        logger.log(text, logLevel)
    }
    
    public func suscribeLogger(_ logDelegate:IRoboboLogDelegate){
        logger.suscribe(logDelegate)
    }
    
    public func unsuscribeLogger(_ logDelegate:IRoboboLogDelegate){
        logger.unsuscribe(logDelegate)
    }
    
    public func startup () throws{
        if (state == RoboboManagerState.CREATED){
            do {
                try self.loadModules()
            } catch FrameworkError.classNotFound{
                frameworkError(FrameworkError.classNotFound)
                throw FrameworkError.internalError

            } catch {
                
                logger.log("Unexpected error loading modules: \(error).",  LogLevel.ERROR)
                frameworkError(error)
                throw FrameworkError.internalError
                
            }
            frameworkStateChanged(RoboboManagerState.ALL_MODULES_LOADED)
            frameworkStateChanged(RoboboManagerState.RUNNING)
        }
        
    }
    
    public func shutdown () {
        self.frameworkStateChanged(RoboboManagerState.STOPPING)
        for (id, module) in self.loadedModules{
            do {
                try module.shutdown()
            }catch {
                logger.log("Error shutting down module \(id): \(error)", LogLevel.ERROR)
            }
            self.loadedModules.removeValue(forKey: id)
        }
        self.frameworkStateChanged(RoboboManagerState.STOPPED)

    }
    
    public func getModuleInstance(_ module : String) throws -> IModule{
        // Try to load the desired module
        guard let module: IModule = loadedModules[module] else{
            // If the module is not registered on the modules array throw an exception
            throw FrameworkError.moduleNotFound
        }
            return module
       
    }
    
    public func loadModules() throws{
        // Order property list before loading modules
        let moduleDict = readPropertyList()?.sorted { $0.key < $1.key }
        
        for (key, value) in moduleDict!{
            // Split key to retrieve real key string: 1.IDummymodule -> IDummyModule
            let keyArray = key.split() {$0 == "."}
            let realKey = String(keyArray[1])
            
            do{
                // Try to load the module class by its name and store it on the
                // modules array
                try loadedModules[realKey] = loadModuleByName(value as! String)
                
                // Call the startup method on the loaded module
                try loadedModules[realKey]?.startup(self)
                logger.log("Loaded \(value)")
            } catch FrameworkError.classNotFound {
                logger.log("Module \(realKey) not loaded, class not found",  LogLevel.ERROR)
                throw FrameworkError.classNotFound
            }
            catch {
                
                throw error
            }
        }
    }
    
    func loadModuleByName(_ className:String) throws-> IModule?{
        let cla = NSClassFromString(className)
        var instance: IModule
        
        
        if let cla = cla as? NSObject.Type {
            instance = cla.init() as! IModule
        
            return instance
        }else{
            throw FrameworkError.classNotFound
        }
        
        
          
    }
    
    // Get the properties file
    func getPlist() -> [String]? {
        let name :String = "modules"

        if  let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path)
        {
            return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String]
        }
        
        return nil
    }
    
    func readPropertyList() -> [String:AnyObject]?  {
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
        var plistData: [String: AnyObject] = [:] //Our data
        let plistPath: String? = Bundle.main.path(forResource: "modules", ofType: "plist")! //the path of the data
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        do {//convert the data to a dictionary and handle errors.
            plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! [String:AnyObject]
            return plistData
            
        } catch {
            logger.log("Error reading plist: \(error), format: \(propertyListFormat)",  LogLevel.ERROR)
            return nil
        }
    }
    
    func frameworkStateChanged(_ newState:RoboboManagerState){
        self.state = newState
        
        for delegate in frameworkDelegates {
            delegate.frameworkStateChanged(newState)
        }
    }
    
    func frameworkError(_ error: Error){
        for delegate in frameworkDelegates{
            delegate.frameworkError(error)
        }
        frameworkStateChanged(RoboboManagerState.ERROR)
    }
    
    public func addFrameworkDelegate(_ delegate: RoboboManagerDelegate) {
        self.frameworkDelegates.append(delegate)
    }
    
    
}

