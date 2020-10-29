import UIKit

final class DetailViewController: UIViewController {
    private var stack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    var selected: MercadoLibre.Item
    
    init(_ selected: MercadoLibre.Item) {
        self.selected = selected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "navigation.detail.title".localized
        self.view.backgroundColor = .white
        
        self.view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 8),
            stack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
        ])
        
        buildLabel(prefix: "detail.name", selected.title)
        buildLabel(prefix: "detail.domain", selected.domainId)
        buildLabel(prefix: "detail.category", selected.category)
        buildLabel(prefix: "detail.acceptsMercadopago", selected.acceptsMercadopago?.description.localized)
    }
    
    private func buildLabel(prefix: String, _ str: String?) {
        guard let str = str else { return }
        let label = UILabel()
        label.numberOfLines = 0
        label.text = prefix.localized + str
        stack.addArrangedSubview(label)
    }
}
