//
//  AfterProtocol.swift
//  IOS_Test_Еask
//
//  Created by Oleg Zakladnyi on 30.09.2024.
//

import Foundation

protocol AfterProtocol {
    associatedtype T // swiftlint:disable:this type_name
    func after(_ block: (T) -> Void) -> T
}

extension AfterProtocol where Self: AnyObject {
    @discardableResult func after(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: AfterProtocol { }
