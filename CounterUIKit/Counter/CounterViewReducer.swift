//
//  CounterViewWay.swift
//  Counter
//
//  Created by DevYeom on 2022/06/15.
//

import Foundation
import OneWay

struct CounterViewReducer: Reducer {
    enum Action: Sendable {
        case increment
        case decrement
        case twice
        case setNumber(Int)
        case setIsLoading(Bool)
    }

    struct State: Sendable, Equatable {
        var number: Int
        var isLoading: Bool
    }

    private let globalState: GlobalState

    init(
        globalState: GlobalState
    ) {
        self.globalState = globalState
    }

    func reduce(state: inout State, action: Action) -> AnyEffect<Action> {
        switch action {
        case .increment:
            state.number += 1
            return .none

        case .decrement:
            state.number -= 1
            return .none

        case .twice:
            return .concat(
                .just(.setIsLoading(true)),
                .single {
                    try! await Task.sleep(nanoseconds: NSEC_PER_SEC)
                    return .increment
                },
                .just(.increment),
                .just(.setIsLoading(false))
            )

        case .setNumber(let number):
            state.number = number
            return .none

        case .setIsLoading(let isLoading):
            state.isLoading = isLoading
            return .none
        }
    }

    func bind() -> AnyEffect<Action> {
        let numbers = globalState.numberSubject.values
        return .merge(
            .sequence { send in
                for await number in numbers {
                    send(Action.setNumber(number))
                }
            }
        )
    }
}
