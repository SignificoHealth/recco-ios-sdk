//
//  ReccoContainer.swift
//
//
//  Created by Adrián R on 30/5/23.
//

import Foundation

public func assemble(_ assemblies: [ReccoAssembly]) {
    for assembly in assemblies {
        assembly.assemble(container: ReccoSharedContainer.shared)
    }
}

public func get<T>() -> T {
    ReccoSharedContainer.shared.resolve(type: T.self)!
}

public func tget<T>() throws -> T {
    guard let result: T = ReccoSharedContainer.shared.resolve(type: T.self) else {
        throw NSError(domain: "\(T.self) was not previously registered", code: 0)
    }

    return result
}

public func get<T, Arg1>(argument: Arg1) -> T {
    ReccoSharedContainer.shared.resolve(type: T.self, argument: argument)!
}

struct ServiceParameters: Hashable {
    let type: String
    let arguments: [String]
}

class ReccoSharedContainer {
    fileprivate init() {}

    static let shared = ReccoSharedContainer()

    private var rememberedSingletons: [ServiceParameters: Bool] = [:]
    var singletons: [ServiceParameters: Any] = [:]
    var services: [ServiceParameters: (ReccoResolver, [Any]) -> Any] = [:]
}

extension ReccoSharedContainer: ReccoResolver {
    func resolve<Service, Arg1>(type: Service.Type, argument: Arg1) -> Service? {
        let key: ServiceParameters = .init(type: "\(type)", arguments: ["\(Arg1.self)"])
        let provider = services[key]

        if rememberedSingletons[key] ?? false {
            guard let value = singletons[key] else {
                let value = provider?((ReccoSharedContainer.shared), [argument])
                singletons[key] = value
                return value as? Service
            }

            return value as? Service
        }

        return provider?((ReccoSharedContainer.shared), [argument]) as? Service
    }

    func resolve<Service>(type: Service.Type) -> Service? {
        let key: ServiceParameters = .init(type: "\(type)", arguments: [])
        let provider = services[key]

        if rememberedSingletons[key] ?? false {
            guard let value = singletons[key] else {
                let value = provider?(ReccoSharedContainer.shared, [])
                singletons[key] = value
                return value as? Service
            }

            return value as? Service
        }

        return provider?(ReccoSharedContainer.shared, []) as? Service
    }
}

extension ReccoSharedContainer: ReccoContainer {
    func register<Service>(
        type: Service.Type,
        singleton: Bool,
        service: @escaping (ReccoResolver) -> Service
    ) {
        let params = ServiceParameters(type: "\(type)", arguments: [])
        rememberedSingletons[params] = singleton
        services[params] = { resolver, _ in
            service(resolver)
        }
    }

    func register<Service, Arg1>(
        type: Service.Type,
        singleton: Bool,
        service: @escaping (ReccoResolver, Arg1) -> Service
    ) {
        let params = ServiceParameters(type: "\(type)", arguments: ["\(Arg1.self)"])
        rememberedSingletons[params] = singleton
        services[params] = { resolver, params in
            service(resolver, params[0] as! Arg1)
        }
    }

    func reset() {
        services = [:]
        singletons = [:]
        rememberedSingletons = [:]
    }
}

public protocol ReccoAssembly {
    func assemble(container: ReccoContainer)
}

public protocol ReccoResolver {
    func resolve<Service>(type: Service.Type) -> Service?
    func resolve<Service, Arg1>(type: Service.Type, argument: Arg1) -> Service?
}

public protocol ReccoContainer {
    func register<Service>(type: Service.Type, singleton: Bool, service: @escaping (ReccoResolver) -> Service)
    func register<Service, Arg1>(type: Service.Type, singleton: Bool, service: @escaping (ReccoResolver, Arg1) -> Service)
}

extension ReccoContainer {
    public func register<Service>(type: Service.Type, service: @escaping (ReccoResolver) -> Service) {
        register(type: type, singleton: false, service: service)
    }

    public func register<Service, Arg1>(type: Service.Type, service: @escaping (ReccoResolver, Arg1) -> Service) {
        register(type: type, singleton: false, service: service)
    }
}

public extension ReccoResolver {
    func get<T>() -> T {
        resolve(type: T.self)!
    }

    func get<T, Arg1>(argument: Arg1) -> T {
        resolve(type: T.self, argument: argument)!
    }
}

import SwiftUI

public struct Assembling<Content: View>: View {
    var content: (any ReccoResolver) -> Content

    public init(_ assembling: ReccoAssembly..., @ViewBuilder content: @escaping (ReccoResolver) -> Content) {
        for a in assembling {
            a.assemble(container: ReccoSharedContainer.shared)
        }

        self.content = content
    }

    public var body: some View {
        content(ReccoSharedContainer.shared)
    }
}
