//
//  CounterViewController.swift
//  Counter
//
//  Created by DevYeom on 2022/06/15.
//

import Combine
import CombineCocoa
import OneWay
import UIKit

final class CounterViewController: UIViewController {
    typealias Action = CounterViewReducer.Action

    // MARK: - UI Components

    private let numberLabel = UILabel()
    private let incrementButton = UIButton()
    private let decrementButton = UIButton()
    private let twiceButton = UIButton(type: .system)
    private let globalStateButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - Properties

    private let store: ViewStore<CounterViewReducer>
    private let globalState: GlobalState
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(
        store: ViewStore<CounterViewReducer>,
        globalState: GlobalState
    ) {
        self.store = store
        self.globalState = globalState
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUserInterface()
        bindView()
        Task { @MainActor in
            await bindStore()
        }
    }

    private func setUserInterface() {
        view.backgroundColor = UIColor.systemBackground

        numberLabel.textAlignment = .center
        numberLabel.font = .systemFont(ofSize: 24, weight: .bold)
        incrementButton.setImage(UIImage(systemName: "plus"), for: .normal)
        decrementButton.setImage(UIImage(systemName: "minus"), for: .normal)
        twiceButton.setTitle("Twice", for: .normal)
        globalStateButton.setTitle("Set 0", for: .normal)

        let buttonStackView = UIStackView(arrangedSubviews: [
            decrementButton,
            incrementButton,
            twiceButton,
            globalStateButton,
        ])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually

        let stackView = UIStackView(arrangedSubviews: [
            numberLabel,
            buttonStackView,
        ])
        stackView.axis = .vertical

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 300),
            stackView.heightAnchor.constraint(equalToConstant: 200),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func bindView() {
        incrementButton.tapPublisher
            .map({ Action.increment })
            .sink { [weak self] action in
                self?.store.send(action)
            }
            .store(in: &cancellables)

        decrementButton.tapPublisher
            .map({ Action.decrement })
            .sink { [weak self] action in
                self?.store.send(action)
            }
            .store(in: &cancellables)

        twiceButton.tapPublisher
            .map({ Action.twice })
            .sink { [weak self] action in
                self?.store.send(action)
            }
            .store(in: &cancellables)

        globalStateButton.tapPublisher
            .sink { [weak self] in
                self?.globalState.setNumber(.zero)
            }
            .store(in: &cancellables)
    }

    private func bindStore() async {
        Task { @MainActor [weak self]  in
            if let numbers = self?.store.states.number {
                for await number in numbers {
                    guard let self else { break }
                    numberLabel.text = "\(number)"
                }
            }
        }
        Task { @MainActor [weak self] in
            if let isLoadings = self?.store.states.isLoading {
                for await isLoading in isLoadings {
                    guard let self else { break }
                    if isLoading {
                        activityIndicator.startAnimating()
                    } else {
                        activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}
