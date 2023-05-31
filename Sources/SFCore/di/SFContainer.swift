//
//  File.swift
//  
//
//  Created by Adrián R on 30/5/23.
//

import Foundation

public func assemble(_ assemblies: [SFAssembly]) {
    for assembly in assemblies {
        assembly.assemble(container: SFSharedContainer.shared)
    }
}

public func get<T>() -> T {
    SFSharedContainer.shared.resolve(type: T.self)!
}

public func get<T, Arg1>(argument: Arg1) -> T {
    SFSharedContainer.shared.resolve(type: T.self, argument: argument)!
}

struct ServiceParameters: Hashable {
    let type: String
    let arguments: [String]
}

class SFSharedContainer {
    fileprivate init() {}

    static let shared = SFSharedContainer()

    var services: [ServiceParameters: (SFResolver, [Any]) -> Any] = [:]
}

extension SFSharedContainer: SFResolver {
    func resolve<Service, Arg1>(type: Service.Type, argument: Arg1) -> Service? {
        let provider = services[.init(type: "\(type)", arguments: ["\(Arg1.self)"])]
        
        return provider?((SFSharedContainer.shared), [argument]) as? Service

    }
    
    func resolve<Service>(type: Service.Type) -> Service? {
        let provider = services[.init(type: "\(type)", arguments: [])]
        
        return provider?(SFSharedContainer.shared, []) as? Service
    }
}

extension SFSharedContainer: SFContainer {
    func register<Service>(type: Service.Type, service: @escaping (SFResolver) -> Service) {
        services[.init(type: "\(type)", arguments: [])] = { resolver, _ in
            service(resolver)
        }
    }
    
    func register<Service, Arg1>(type: Service.Type, service: @escaping (SFResolver, Arg1) -> Service) {
        services[.init(type: "\(type)", arguments: ["\(Arg1.self)"])] = { resolver, params in
            service(resolver, params[0] as! Arg1)
        }
    }
}

public protocol SFAssembly {
    func assemble(container: SFContainer)
}

public protocol SFResolver {
    func resolve<Service>(type: Service.Type) -> Service?
    func resolve<Service, Arg1>(type: Service.Type, argument: Arg1) -> Service?
}

public protocol SFContainer {
    func register<Service>(type: Service.Type, service: @escaping (SFResolver) -> Service)
    func register<Service, Arg1>(type: Service.Type, service: @escaping (SFResolver, Arg1) -> Service)
}

public extension SFResolver {
    func get<T>() -> T {
        resolve(type: T.self)!
    }
    
    func get<T, Arg1>(argument: Arg1) -> T {
        resolve(type: T.self, argument: argument)!
    }
}

#if DEBUG
import SwiftUI
public struct Assembling<Content: View>: View {
    private var previewContainer = SFSharedContainer()
    var content: (any SFResolver) -> Content
    
    public init(_ assembling: SFAssembly..., @ViewBuilder content: @escaping (SFResolver) -> Content) {
        for a in assembling {
            a.assemble(container: previewContainer)
        }
        
        self.content = content
    }
    
    public var body: some View {
        content(previewContainer)
    }
}
#endif
