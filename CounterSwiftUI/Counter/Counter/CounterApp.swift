//
//  CounterApp.swift
//  Counter
//
//  Created by SEUNG YEOP YEOM on 2022/12/16.
//

import SwiftUI

@main
struct CounterApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView(
                way: CounterViewWay(
                    initialState: .init(
                        number: 0,
                        isLoading: false
                    ),
                    globalState: GlobalState()
                )
            )
        }
    }
}
