//
//  CounterViewController.swift
//  Counter
//
//  Created by DevYeom on 2022/06/15.
//

import UIKit
import Combine
import CombineCocoa

final class CounterViewController: UIViewController {
    typealias Action = CounterViewWay.Action

    // MARK: - UI Components

    private let numberLabel = UILabel()
    private let incrementButton = UIButton()
    private let decrementButton = UIButton()
    private let twiceButton = UIButton(type: .system)
    private let globalStateButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - Properties

    private let way: CounterViewWay
    private let globalState: GlobalState
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(
        way: CounterViewWay,
        globalState: GlobalState
    ) {
        self.way = way
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
        bind()
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

    private func bind() {
        incrementButton.tapPublisher
            .map({ Action.increment })
            .sink { [weak self] action in
                self?.way.send(action)
            }
            .store(in: &cancellables)

        decrementButton.tapPublisher
            .map({ Action.decrement })
            .sink { [weak self] action in
                self?.way.send(action)
            }
            .store(in: &cancellables)

        twiceButton.tapPublisher
            .map({ Action.twice })
            .sink { [weak self] action in
                self?.way.send(action)
            }
            .store(in: &cancellables)

        globalStateButton.tapPublisher
            .sink { [weak self] in
                self?.globalState.setNumber(.zero)
            }
            .store(in: &cancellables)

        way.publisher.number
            .receive(on: DispatchQueue.main)
            .sink { [weak self] number in
                self?.numberLabel.text = "\(number)"
            }
            .store(in: &cancellables)

        way.publisher.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }

}

