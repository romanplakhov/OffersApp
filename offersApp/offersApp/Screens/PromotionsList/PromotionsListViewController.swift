//
//  PromotionsListViewController.swift
//  offersApp
//
//  Created by Роман Плахов on 10.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import UIKit
import SwipeCellKit
import ReactiveSwift
import NVActivityIndicatorView

class PromotionsListViewController: UIViewController {
	
	//MARK: Public properties
	var viewModel: PromotionsListViewModel!

	//MARK: Private properties
	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet private weak var leftActionButton: ActionButton!
	@IBOutlet private weak var rightActionButton: ActionButton!
	@IBOutlet private weak var emptyTitle: UILabel!
	@IBOutlet private weak var emptyDescription: UILabel!
	@IBOutlet private weak var emptyView: UIView!
	@IBOutlet private weak var activityIndicator: NVActivityIndicatorView!
	
	@IBOutlet private weak var actionButtonsStackViewBottomConstraint: NSLayoutConstraint!
	
	private var hiddenActionButtonsBottomConstraintConstant: CGFloat = -100
	private var shownActionButtonsBottomConstraintConstant: CGFloat = 42
	
	//MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

		setup()
        bind()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		setEditingMode(false, animated: false)
		viewModel.updateData()
		
	}

	//MARK: Setup
	private func setup() {
		setupTableView()
		setupActionButtons()
		setupActivityIndicator()
		setupEmptyView()
	}
	
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(UINib.init(nibName: "PromotionsListTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: PromotionsListTableViewCell.identifier)
		tableView.tableFooterView = UIView()
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 600
		tableView.separatorStyle = .none
		
		let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
		longPressGesture.minimumPressDuration = 0.3
		self.tableView.addGestureRecognizer(longPressGesture)
		
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
		tapGestureRecognizer.numberOfTapsRequired = 2
		view.addGestureRecognizer(tapGestureRecognizer)
	}
	
	private func setupActionButtons() {
		self.actionButtonsStackViewBottomConstraint.constant = self.hiddenActionButtonsBottomConstraintConstant
		leftActionButton.configure(title: "Снять выделение", type: .neutral) {[weak self] in
			guard let self = self else {return}
			self.endEditing()
		}
		
		switch viewModel.type {
		case .active:
			rightActionButton.configure(title: "Деактивировать", type: .destructive) {[weak self] in
				guard let self = self else {return}
				self.viewModel.commitSelection()
				self.endEditing()
			}
		case .inactive:
			rightActionButton.configure(title: "Активировать", type: .constructive) {[weak self] in
				guard let self = self else {return}
				self.viewModel.commitSelection()
				self.endEditing()
			}
		}
	}
	
	private func setupActivityIndicator() {
		activityIndicator.type = .ballPulseRise
		activityIndicator.color = Config.Colors.primaryTintColor
		activityIndicator.startAnimating()
	}
	
	private func setupEmptyView() {
		emptyTitle.font = Config.Fonts.regularTextFont
		emptyDescription.font = Config.Fonts.smallTextFont
		
		emptyDescription.textColor = Config.Colors.paleTextColor
		emptyTitle.textColor = Config.Colors.paleTextColor
	}
	
	//MARK: Binding
	private func bind() {
		viewModel.reloadSignal.producer.observe(on: UIScheduler()).on {[weak self] in
			self?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
		}.start()
		
		viewModel.editingMode.signal.producer.observe(on: UIScheduler()).on {[weak self]value in
			guard let self = self else {return}
			self.tableView.allowsMultipleSelection = value
			for i in 0..<self.tableView.numberOfRows(inSection: 0) {
				guard let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? PromotionsListTableViewCell else {return}
				
				cell.setMultiselectableMode(value)
			}
		}.start()
		
		viewModel.isLoading.signal.producer.observe(on: UIScheduler()).on {[weak self]isLoading in
			guard let self = self else {return}
			if isLoading {
				self.activityIndicator.startAnimating()
			} else {
				self.activityIndicator.stopAnimating()
			}
		}.start()
		
		emptyTitle.reactive.text <~ viewModel.emptyViewTitle
		emptyDescription.reactive.text <~ viewModel.emptyViewBody
		emptyView.reactive.isHidden <~ viewModel.isEmpty.map {!$0}
	}
	
	//MARK: Gesture handlers
	@objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
		guard !viewModel.editingMode.value else {return}
		setEditingMode(true)
		
		if let indexPath = tableView.indexPathForRow(at: longPressGesture.location(in: tableView)),
			let cell = tableView.cellForRow(at: indexPath) as? PromotionsListTableViewCell{
			viewModel.addItemToSelectionList(at: indexPath)
			cell.setMultiselected(true)
		}
	}
	
	@objc func handleTap(_ tap: UITapGestureRecognizer) {
		guard viewModel.editingMode.value else {return}
		
		if let indexPath = tableView.indexPathForRow(at: tap.location(in: tableView)),
		let cell = tableView.cellForRow(at: indexPath) as? PromotionsListTableViewCell{
			for i in 0..<tableView.numberOfRows(inSection: 0) {
				let currentIndexPath = IndexPath(row: i, section: 0)
				if let currentCell = tableView.cellForRow(at: currentIndexPath) as? PromotionsListTableViewCell {
					currentCell.setMultiselected(cell.isMultiselected)
					cell.isMultiselected ? viewModel.addItemToSelectionList(at: currentIndexPath) : viewModel.removeItemFromSelectionList(at: currentIndexPath)
				}
			}
		}
	}
	
	//MARK: Other
	private func setEditingMode(_ value: Bool, animated: Bool = true) {
		viewModel.setEditingMode(value)
		
		actionButtonsStackViewBottomConstraint.constant = value ? shownActionButtonsBottomConstraintConstant : hiddenActionButtonsBottomConstraintConstant
		if animated {
			UIView.animate(withDuration: 0.5) {
				self.view.layoutIfNeeded()
			}
		} else {
			self.view.layoutIfNeeded()
		}
	}
	
	private func endEditing() {
		for i in 0..<tableView.numberOfRows(inSection: 0) {
			if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? PromotionsListTableViewCell {
				cell.setMultiselected(false)
			}
		}
		
		setEditingMode(false)
		
	}
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension PromotionsListViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfRowsForSection(section)
	}
	
	func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		guard !viewModel.editingMode.value else {
			if let cell = tableView.cellForRow(at: indexPath) as? PromotionsListTableViewCell {
				cell.isMultiselected ? viewModel.removeItemFromSelectionList(at: indexPath) : viewModel.addItemToSelectionList(at: indexPath)
				cell.setMultiselected(!cell.isMultiselected)
			}
			return false
		}
		
		return true
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		viewModel.didSelectItem(at: indexPath)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let viewModel = viewModel,
			let promotionsListTableViewCell = tableView.dequeueReusableCell(withIdentifier: PromotionsListTableViewCell.identifier) as? PromotionsListTableViewCell else {return UITableViewCell()}
		
		promotionsListTableViewCell.delegate = self
		
		return viewModel.prepareCellForRowAt(cell: promotionsListTableViewCell, indexPath: indexPath)
	}
}

//MARK: IndicatorInfoProvider
extension PromotionsListViewController: IndicatorInfoProvider {
	func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
		return IndicatorInfo(title: viewModel.type.title)
	}
}

//MARK: SwipeTableViewCellDelegate
extension PromotionsListViewController: SwipeTableViewCellDelegate {
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

		if orientation == .left && viewModel.type == .inactive {
			let activateAction = SwipeAction(style: .default, title: "АКТИВИРОВАТЬ") { [weak self]_, indexPath in
				self?.viewModel.changeActivationStatus(forItemAt: indexPath)
			}

			activateAction.backgroundColor = Config.Colors.constructiveColor
			activateAction.font = Config.Fonts.boldFont
			return [activateAction]
		} else if orientation == .right && viewModel.type == .active {
			let deactivateAction = SwipeAction(style: .default, title: "ДЕАКТИВИРОВАТЬ") { [weak self]_, indexPath in
				self?.viewModel.changeActivationStatus(forItemAt: indexPath)
			}

			deactivateAction.backgroundColor = Config.Colors.destructiveColor
			deactivateAction.font = Config.Fonts.boldFont
			return [deactivateAction]
		}

		return nil
	}
	
	func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
		var options = SwipeOptions()
		options.transitionStyle = .border
		return options
	}
}
