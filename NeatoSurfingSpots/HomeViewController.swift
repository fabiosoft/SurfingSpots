//
//  HomeViewController.swift
//  NeatoSurfingSpots
//
//  Created by Fabio Nisci on 25/03/22.
//

import UIKit
import FNEasyBind

class HomeViewController: UIViewController {
    typealias HomeDataSource = UITableViewDiffableDataSource<HomeViewModelSection, CityViewModel>
    typealias HomeCitiesSnapshot = NSDiffableDataSourceSnapshot<HomeViewModelSection, CityViewModel>

    private var homeViewModel: HomeViewModelProtocol!
    weak var coordinator: MainCoordinator?
    private var disposeBag = DisposeBag()
    private lazy var dataSource = makeDataSource()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CityCell.self, forCellReuseIdentifier: CityCell.reuseIdentifier)
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()

    func makeDataSource() -> HomeDataSource {
        let dataSource = HomeDataSource(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, stargazer) ->
                UITableViewCell? in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CityCell.reuseIdentifier,
                    for: indexPath) as? CityCell
                cell?.model = stargazer
                return cell
            })
        var snapshot = HomeCitiesSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems([])
        dataSource.apply(snapshot, animatingDifferences: false)
        return dataSource
    }

    func applySnapshot(items: [CityViewModel], animatingDifferences: Bool = false) {
        var snapshot = HomeCitiesSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    init(viewModel: HomeViewModelProtocol? = HomeViewModel()) {
        super.init(nibName: nil, bundle: nil)
        self.homeViewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.fetchItems()
         self.homeViewModel.startUpdatingTemperatures()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bindViews()
    }

    private func fetchItems() {
        self.homeViewModel.fetchCities()
    }

    private func setupViews() {
        self.title = homeViewModel.title
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

    }

    private func bindViews() {
        self.homeViewModel.isfetching
            .subscribe { [weak self] value, _ in
                guard let self = self else {
                    return
                }
                if value {
                    self.tableView.tableFooterView = self.loadingSpinnerView()
                } else {
                    self.tableView.tableFooterView = nil
                }
            }.disposed(by: &disposeBag)
        self.homeViewModel.cities
            .subscribe(DispatchQueue.main, { [weak self] value, _ in
                guard let self = self else {
                    return
                }
                self.applySnapshot(items: value, animatingDifferences: true)
            }).disposed(by: &disposeBag)
    }

    private func loadingSpinnerView() -> UIView {
        let spinnerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.center = spinnerView.center
        spinnerView.addSubview(spinner)
        spinner.startAnimating()
        return spinnerView
    }

}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // if let city = dataSource.itemIdentifier(for: indexPath){}
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
}
