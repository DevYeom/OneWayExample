//
//  GlobalState.swift
//  OneWayExample
//
//  Created by DevYeom on 2022/06/15.
//

import Foundation
import Combine

final class GlobalState {
    let numberSubject = PassthroughSubject<Int, Never>()

    func setNumber(_ number: Int) {
        numberSubject.send(number)
    }
}
