//
//  ViewController.swift
//  RXSwiftMoviesApp
//
//  Created by Роман Важник on 09.06.2020.
//  Copyright © 2020 Роман Важник. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

fileprivate struct Constants {
    static let categoriesCollectionViewHeight: CGFloat = 60
    static let genresCollectionViewHeight: CGFloat = 40
    static let moviesCollectionViewHeight: CGFloat = UIScreen.main.bounds.height/1.6
    static let moviesCollectionViewCellWidth = UIScreen.main.bounds.width-80
    
    static let searchedResultIdentifire = "SearchedResultsCell"
    static let moviesCellIdentifier = "MoviesCell"
    static let categoriesCellIdentifier = "CategoriesCell"
    static let genresCellIdentifier = "GenresCell"
}

class MoviesViewController: UIViewController {
        
    //Categories Data
    var viewModel: MoviesViewModelProtocol! {
        didSet {
            configureCategoryCollectionViewDataSource(categories: viewModel.cateries)
            configureGenresCollectionViewDataSource(genres: viewModel.genres)
            configureMoviesCollectionViewDataSource(movies: viewModel.movies)
            configureSearchedResultsTableViewDataSource(searchedResults: viewModel.searchedResults)
        }
    }
    
    private let moviesViewModelConfigurator: MovieScreenConfiguratorProtocol = MovieScreenConfigurator()
    private lazy var categoriesCollectionView: HorizontalCollectionView = {
        let collectionView = HorizontalCollectionView(spacingBetweenElements: 26)
        collectionView.register(CategoriesCollectionViewCell.self,
                                forCellWithReuseIdentifier: Constants.categoriesCellIdentifier)
        return collectionView
    }()
    
    private let genresCollectionView: HorizontalCollectionView = {
        let collectionView = HorizontalCollectionView(spacingBetweenElements: 20)
        collectionView.register(GenresCollectionViewCell.self, forCellWithReuseIdentifier: Constants.genresCellIdentifier)
        return collectionView
    }()
    
    private lazy var moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: Constants.moviesCellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        let icon = SVGIconsManager.shared.getSVGImageInUIImage(forResourceName: "search",
                                                               size: CGSize(width: 18, height: 18))
        button.setImage(icon, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = false
        return textField
    }()
    private lazy var searchedResultTableView: SearchedResultsTableView = {
        let tableView = SearchedResultsTableView()
        tableView.register(SearchedResultsTableViewCell.self, forCellReuseIdentifier: Constants.searchedResultIdentifire)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.layer.cornerRadius = 10
        return tableView
    }()
    private let searchAreaStackView = UIStackView()
    
    private lazy var layoutMargins = view.layoutMarginsGuide
    private let disposeBag = DisposeBag()
    private var indexBeforeDragging = 0

    private var isPageCurrentlyWasChanged = false
    private var numberOfMoviesInSectionBeforePageWasChanged = 0
    
    private var blurEffectView: UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesViewModelConfigurator.configure(view: self)
        layoutSearchView()
        layoutCategoriesCollectionView()
        layoutGenresCollectionView()
        layoutMoviesCollectionView()
        layoutSearchedResultTableView()
        selectFirstItemInCategoryCollectionView()
        bindActionToSelectedRowAtGenreCollectioView()
        bindActionToSelectedRowAtCategoryCollectioView()
        bindActionsToSearchAriaElements()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeBlureEffectAndStopSearching()
    }
    
    private func bindActionsToSearchAriaElements() {
        searchButton.rx.tap.bind { [unowned self] in
            self.addBlurEffect()
            self.searchTextField.isUserInteractionEnabled = true
            self.searchTextField.becomeFirstResponder()
            self.searchButton.isEnabled = false
            self.searchedResultTableView.isHidden = false
        }.disposed(by: disposeBag)
        
        searchTextField.rx.text.bind { (text) in
            self.viewModel.searchFilmBy(name: text ?? "")
        }.disposed(by: disposeBag)
    }
    
    private func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView!.frame = view.bounds
        blurEffectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView!)
        view.bringSubviewToFront(searchAreaStackView)
        view.bringSubviewToFront(searchedResultTableView)
    }
    
    private func removeBlureEffectAndStopSearching() {
        if blurEffectView != nil {
            blurEffectView?.removeFromSuperview()
            searchedResultTableView.isHidden = true
            searchButton.isEnabled = true
            searchTextField.resignFirstResponder()
            blurEffectView = nil
            searchTextField.text = ""
            searchTextField.isUserInteractionEnabled = false
        }
    }
    
    private func bindActionToSelectedRowAtCategoryCollectioView() {
        categoriesCollectionView.rx.modelSelected(String.self).subscribe { [unowned self] (category) in
            self.viewModel.changeFilmsCategory(category: category.element!)
            self.scrollMovieCollectionViewToBeginning()
        }.disposed(by: disposeBag)
    }
    
    private func bindActionToSelectedRowAtGenreCollectioView() {
        genresCollectionView.rx.modelSelected(Genre.self).subscribe { [unowned self] (genre) in
            self.viewModel.changeFilmsGenre(genre: genre.element!)
            self.scrollMovieCollectionViewToBeginning()
        }.disposed(by: disposeBag)
    }
    
    private func scrollMovieCollectionViewToBeginning() {
        let firstElementIndexPath = IndexPath(item: 0, section: 0)
        self.moviesCollectionView.scrollToItem(at: firstElementIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    private func configureSearchedResultsTableViewDataSource(searchedResults:
        BehaviorRelay<[Movie]>) {
        searchedResults.bind(to: searchedResultTableView.rx.items(cellIdentifier: Constants.searchedResultIdentifire)) { index, model, cell in
            (cell as! SearchedResultsTableViewCell).configureCellWith(result: model)
        }.disposed(by: disposeBag)
    }
    
    private func configureCategoryCollectionViewDataSource(categories: Observable<[String]>) {
        categories.bind(to: categoriesCollectionView.rx.items(cellIdentifier:
            Constants.categoriesCellIdentifier)) { index, model, cell in
                (cell as! CategoriesCollectionViewCell).configureCellWith(category: model)
        }.disposed(by: disposeBag)
    }
    
    private func configureGenresCollectionViewDataSource(genres: BehaviorRelay<[Genre]>) {
        genres.asObservable().bind(to: genresCollectionView.rx.items(cellIdentifier:
            Constants.genresCellIdentifier)) { index, model, cell in
                (cell as! GenresCollectionViewCell).configureCellWith(genreName: model.name)
        }.disposed(by: disposeBag)
    }
    
    private func configureMoviesCollectionViewDataSource(movies: BehaviorRelay<[Movie]>) {
        movies.asObservable().bind(to: moviesCollectionView.rx.items(cellIdentifier:
            Constants.moviesCellIdentifier)) { index, model, cell in
                (cell as! MoviesCollectionViewCell).configureCellWith(movie: model)
        }.disposed(by: disposeBag)
    }
    
    private func selectFirstItemInCategoryCollectionView() {
        let indexPath = IndexPath(item: 0, section: 0)
        categoriesCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }

    //MARK: - Layout elements
    
    private func layoutSearchView() {
        searchAreaStackView.translatesAutoresizingMaskIntoConstraints = false
        searchAreaStackView.axis = .horizontal
        searchAreaStackView.distribution  = .equalSpacing
        searchAreaStackView.alignment = .center
        searchAreaStackView.spacing = 0
        view.addSubview(searchAreaStackView)
        
        searchAreaStackView.addArrangedSubview(searchTextField)
        searchAreaStackView.addArrangedSubview(searchButton)
        searchAreaStackView.topAnchor.constraint(equalTo: layoutMargins.topAnchor, constant: 15).isActive = true
        searchAreaStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        searchAreaStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        searchTextField.leadingAnchor.constraint(equalTo: searchAreaStackView.leadingAnchor).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -5).isActive =  true
    }
    
    private func layoutSearchedResultTableView() {
        view.addSubview(searchedResultTableView)
        searchedResultTableView.topAnchor.constraint(equalTo: searchAreaStackView.bottomAnchor).isActive = true
        searchedResultTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        searchedResultTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
    }
    
    private func layoutCategoriesCollectionView() {
        view.addSubview(categoriesCollectionView)
        categoriesCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10).isActive = true
        categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        categoriesCollectionView.heightAnchor.constraint(equalToConstant:
            Constants.categoriesCollectionViewHeight).isActive = true
    }
    
    private func layoutGenresCollectionView() {
        view.addSubview(genresCollectionView)
        genresCollectionView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: 25).isActive = true
        genresCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        genresCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        genresCollectionView.heightAnchor.constraint(equalToConstant:
            Constants.genresCollectionViewHeight).isActive = true
    }
    
    private func layoutMoviesCollectionView() {
        view.addSubview(moviesCollectionView)
        moviesCollectionView.centerYAnchor.constraint(
            equalTo: view.centerYAnchor,
            constant: Constants.categoriesCollectionViewHeight+35).isActive = true
        moviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        moviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        moviesCollectionView.heightAnchor.constraint(equalToConstant:
            Constants.moviesCollectionViewHeight).isActive = true
    }
    
    //Найти индекс ячейки в зависимости от смещения scrollView в CollectionView
    private func indexOfMajorCell(offset: CGPoint) -> Int {
        //получить смещение по x
        let xOffset = offset.x
        //поделить смещение по x на ширину ячейки что бы найти индекс
        let index = xOffset/Constants.moviesCollectionViewCellWidth
        //округлить индекс
        let roundedIndex = Int(round(index))
        let numberOfItems = moviesCollectionView.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(roundedIndex, numberOfItems-1))
        return safeIndex
    }
}

extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: Constants.moviesCollectionViewCellWidth,
               height: Constants.moviesCollectionViewHeight)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexBeforeDragging = indexOfMajorCell(offset: scrollView.contentOffset)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
                
        let index = indexOfMajorCell(offset: scrollView.contentOffset)
        let numberOfItems = moviesCollectionView.numberOfItems(inSection: 0)
        
        let hasEnoughToScrollToTheNextItem = indexBeforeDragging+1 < numberOfItems && velocity.x > 0.5
        let hasEnoughToScrollToThePreviousItem = indexBeforeDragging-1 >= 0 && velocity.x < -0.5
        
        //проверяем на наличие свайпа
        //если скорость больше 0.5 или меньше -0.5 и существует элемент и индекс
        //остался прежним, то свайпаем элемент
        if index == indexBeforeDragging &&
            (hasEnoughToScrollToTheNextItem || hasEnoughToScrollToThePreviousItem) {
            let swipeToIndex = indexBeforeDragging + (hasEnoughToScrollToTheNextItem ? 1 : -1)
            let toValue = Constants.moviesCollectionViewCellWidth * CGFloat(swipeToIndex) - 40
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
        } else {
            let indexPath = IndexPath(item: index, section: 0)
            moviesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        if isPageCurrentlyWasChanged && numberOfMoviesInSectionBeforePageWasChanged == numberOfItems {
            return
        }
        if (numberOfItems-index) <= 5 {
            viewModel.changePageAndGetNewMovies()
            isPageCurrentlyWasChanged = true
            numberOfMoviesInSectionBeforePageWasChanged = numberOfItems
        } else {
            isPageCurrentlyWasChanged = false
        }
    }
}
