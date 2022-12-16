//
//  GlobalState.swift
//  Counter+SwiftUI
//
//  Created by SEUNG YEOP YEOM on 2022/06/27.
//

import Foundation
import Combine

final class GlobalState {
    let numberSubject = PassthroughSubject<Int, Never>()

    func setNumber(_ number: Int) {
        numberSubject.send(number)
    }
}
