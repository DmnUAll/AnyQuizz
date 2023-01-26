import UIKit

// MARK: - NavigationController
final class NavigationController: UINavigationController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        configureNavigationController()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
extension NavigationController {

    @objc private func scoresButtonTapped() {
        pushViewController(ScoresController(), animated: true)
    }

    private func configureNavigationController() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.backgroundColor = .aqLime
        navigationBar.tintColor = .aqGreenDark
        navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 24),
            .foregroundColor: UIColor.aqGreenDark
        ]
        let scoresButton = UIBarButtonItem(image: UIImage(systemName: "medal"),
                                           style: .plain,
                                           target: nil,
                                           action: #selector(scoresButtonTapped))
        navigationBar.topItem?.rightBarButtonItem = scoresButton
        navigationBar.topItem?.backButtonTitle = "To Menu"
    }
}
