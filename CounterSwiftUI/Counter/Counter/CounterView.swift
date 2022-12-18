//
//  CounterView.swift
//  Counter+SwiftUI
//
//  Created by DevYeom on 2022/06/27.
//

import SwiftUI

struct CounterView: View {
//    if using less than iOS 14
//    @ObservedObject private var way: CounterViewWay
//
//    init(way: CounterViewWay) {
//        self.way = way
//    }

    @StateObject private var way: CounterViewWay

    init(way: CounterViewWay) {
        self._way = StateObject(wrappedValue: way)
    }

    var body: some View {
        VStack(spacing: 32) {
            Text("\(way.state.number)")
                .font(.system(size: 24, weight: .bold))
                .background(animationCircle)

            HStack {
                Button("minus") {
                    way.send(.decrement)
                }
                Button("plus") {
                    way.send(.increment)
                }
                Button("Twice") {
                    way.send(.twice)
                }
                Button("Set 0") {
                    way.send(.setNumber(0))
                }
            }
            .disabled(way.state.isLoading)
            .overlay(way.state.isLoading ? progressView : nil)
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
                width: CGFloat(24 * max(way.state.number, 0)),
                height: CGFloat(24 * max(way.state.number, 0))
            )
            .animation(.default, value: way.state.number)
            .transition(.opacity)
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(
            way: CounterViewWay(
                initialState: .init(number: 0, isLoading: true),
                globalState: GlobalState()
            )
        )
    }
}
