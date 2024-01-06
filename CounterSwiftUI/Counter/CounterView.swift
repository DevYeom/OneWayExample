//
//  CounterView.swift
//  Counter+SwiftUI
//
//  Created by DevYeom on 2022/06/27.
//

import OneWay
import SwiftUI

struct CounterView: View {
    @StateObject private var store = ViewStore(
        reducer: CounterViewReducer(globalState: GlobalState()),
        state: .init(number: 0, isLoading: false)
    )

    var body: some View {
        VStack(spacing: 32) {
            Text("\(store.state.number)")
                .font(.system(size: 24, weight: .bold))
                .background(animationCircle)

            HStack {
                Button("minus") {
                    store.send(.decrement)
                }
                Button("plus") {
                    store.send(.increment)
                }
                Button("Twice") {
                    store.send(.twice)
                }
                Button("Set 0") {
                    store.send(.setNumber(0))
                }
            }
            .disabled(store.state.isLoading)
            .overlay(store.state.isLoading ? progressView : nil)

            Toggle(
                "isLoading",
                isOn: Binding<Bool>(
                    get: { store.state.isLoading },
                    set: { store.send(.setIsLoading($0)) }
                )
            )
        }
        .frame(width: 300, height: 200, alignment: .center)
    }

    var progressView: some View {
        ProgressView().controlSize(.large)
    }

    var animationCircle: some View {
        Circle()
            .fill(Color.green)
            .frame(
                width: CGFloat(24 * max(store.state.number, 0)),
                height: CGFloat(24 * max(store.state.number, 0))
            )
            .animation(.default, value: store.state.number)
            .transition(.opacity)
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView()
    }
}
