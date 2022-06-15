//
//  CounterViewWay.swift
//  OneWayExample
//
//  Created by DevYeom on 2022/06/15.
//

import Foundation
import OneWay

final class CounterViewWay: Way<CounterViewWay.Action, CounterViewWay.State> {

    enum Action {
        case increment
        case decrement
        case twice
        case setNumber(Int)
        case setLoading(Bool)
    }

    struct State: Equatable {
        var number: Int
        var isLoading: Bool
    }

    private let globalState: GlobalState

    init(
        initialState: State,
        globalState: GlobalState
    ) {
        self.globalState = globalState
        super.init(initialState: initialState)
    }

    override func reduce(state: inout State, action: Action) -> SideWay<Action, Never> {
        switch action {
        case .increment:
            state.number += 1
            return .none
        case .decrement:
            state.number -= 1
            return .none
        case .twice:
            return .concat(
                .just(.setLoading(true)),
                .just(.increment)
                    .delay(for: .seconds(1), scheduler: DispatchQueue.main)
                    .eraseToSideWay(),
                .just(.increment),
                .just(.setLoading(false))
            )
        case .setNumber(let number):
            state.number = number
            return .none
        case .setLoading(let isLoading):
            state.isLoading = isLoading
            return .none
        }
    }

    override func bind() -> SideWay<Action, Never> {
        return .merge(
            globalState.numberSubject
                .map({ Action.setNumber($0) })
                .eraseToSideWay()
        )
    }
}
