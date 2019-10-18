//
//  FilterChoiceViewController.swift
//  
//
//  Created by Vadim Zhydenko on 18.10.2019.
//

import UIKit

public protocol Filterable: Equatable, P_ChoiceItem {
    var filterField:String { get }
}
@propertyWrapper
class Filtered<T> where T: Filterable {

    var filter: String?

    private var lastFilter: String?
    private var lastFiltered = [T]()
    var filtered: [T] {
        defer { lastFilter = filter }
        
        guard let filter = filter else {
            lastFiltered.removeAll()
            return wrappedValue
        }
        
        guard filter != lastFilter else { return lastFiltered }
        
        let lowercasedFilter = filter.lowercased()
        lastFiltered = wrappedValue.filter {
            $0.filterField.lowercased().contains(lowercasedFilter)
        }
        return lastFiltered
    }

    var wrappedValue = [T]()

}

public class FilterChoiceViewController<Element: Filterable>: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    @Filtered private var elements: [Element]
    private let selection: Selection<Element>
    private let completion: (() -> ())?
    
    public init(
        preferredContentSize: CGSize = CGSize(width: 300, height: 200),
        sourceView: UIView,
        elements: [Element],
        selection: Selection<Element>,
        completion: (() -> ())? = nil
    ) {
        self.selection = selection
        self.completion = completion
        
        super.init(style: .plain)
        
        self.elements = elements
        
        self.preferredContentSize = preferredContentSize
        self.modalPresentationStyle = .popover
        let presentationController = self.presentationController as! UIPopoverPresentationController
        presentationController.delegate = self
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func applyFilter(_ filter: String?) {
        _elements.filter = filter
        tableView.reloadData()
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard isBeingDismissed else { return }
        switch self.selection {
        case .single(let completion): completion(elements.first { $0.isChoiceItemSelected } )
        case .multiple(let completion): completion(elements.filter { $0.isChoiceItemSelected } )
        }
        completion?()
    }
    
    // MARK: - UITableViewDataSource
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _elements.filtered.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = _elements.filtered[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = element.choiceItemDisplayValue
        cell.accessoryType = element.isChoiceItemSelected ? .checkmark : .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let common = {
            let filteredSelection = self._elements.filtered[indexPath.row]
            guard let globalIndex = self.elements.firstIndex(where: { $0 == filteredSelection } ) else { return }
            self.elements[globalIndex].isChoiceItemSelected.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        switch selection {
        case .single(_):
            if let index = elements.firstIndex(where: { $0.isChoiceItemSelected } ) {
                elements[index].isChoiceItemSelected.toggle()
                tableView.reloadRows(at: [IndexPath(row: index, section: indexPath.section)], with: .automatic)
            }
            common()
            dismiss(animated: true)
        case .multiple(_):
            common()
        }
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
