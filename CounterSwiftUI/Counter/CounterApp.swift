//
//  CounterApp.swift
//  Counter
//
//  Created by SEUNG YEOP YEOM on 2022/12/16.
//

import OneWay
import SwiftUI

@main
struct CounterApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView(
                store: ViewStore(
                    reducer: CounterViewReducer(globalState: GlobalState()),
                    state: .init(number: 0, isLoading: false)
                )
            )
        }
    }
}
