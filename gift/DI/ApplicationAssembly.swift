//
//  ApplicationAssembly.swift
//  gift
//
//  Created by Matan Lachmish on 27/05/2016.
//  Copyright © 2016 GiftApp. All rights reserved.
//

import Foundation
import Typhoon

public class ApplicationAssembly : TyphoonAssembly {
    public var coreComponentsAssembly: CoreComponentsAssembly!
    public var viewControllersAssembly: ViewControllersAssembly!
    
    public dynamic func appDelegate() -> Any {
        return TyphoonDefinition.withClass(AppDelegate.self) {
            (definition) in
            
            definition?.injectProperty(#selector(CoreComponentsAssembly.appRoute), with: self.coreComponentsAssembly.appRoute())
            definition?.injectProperty(#selector(CoreComponentsAssembly.launcher), with: self.coreComponentsAssembly.launcher())
            definition?.injectProperty(#selector(CoreComponentsAssembly.developerTools), with: self.coreComponentsAssembly.developerTools())
            
        }
    }
}
