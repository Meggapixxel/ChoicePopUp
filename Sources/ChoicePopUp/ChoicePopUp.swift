import UIKit

public class ChoiceViewController<Element: P_ChoiceItem>: UITableViewController, UIPopoverPresentationControllerDelegate {
  
    private var elements: [Element]
    private let selection: Selection<Element>
    private let completion: (() -> ())?
    
    public init(
        preferredContentSize: CGSize = CGSize(width: 300, height: 200),
        sourceView: UIView,
        elements: [Element],
        selection: Selection<Element>,
        completion: (() -> ())? = nil
    ) {
        self.elements = elements
        self.selection = selection
        self.completion = completion
        
        super.init(style: .plain)
        
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
        return elements.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = element.choiceItemDisplayValue
        cell.accessoryType = element.isChoiceItemSelected ? .checkmark : .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let common = {
            self.elements[indexPath.row].isChoiceItemSelected.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        switch selection {
        case .single(_):
            if let index = elements.firstIndex(where: { $0.isChoiceItemSelected } ) {
                elements[index].isChoiceItemSelected = false
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
