import UIKit

class InfoController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    fileprivate let cellId = "Cell"
    fileprivate let headerId = "id"
    fileprivate let collectionView = UICollectionView(frame: .zero, collectionViewLayout: StretchyHeaderLayout())
    fileprivate let closeButton = UIButton(type: .system)
    fileprivate let confetti = ConfettiView()
    fileprivate lazy var floatingView = UIView()
    fileprivate let floatingViewHeight: CGFloat = 64
    fileprivate var header: InfoImageHeader?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(confetti)
        hideStatusBar(true)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.barTintColor = .black
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.barTintColor = .white
        handleDismiss()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    fileprivate func setupFloatingView() {
        view.addSubview(floatingView)
        floatingView.backgroundColor = UIColor(white: 0.1, alpha: 0.1)

        let blurEffect = UIBlurEffect(style: .prominent)
        let blurView = UIVisualEffectView(effect: blurEffect)

        floatingView.addSubview(blurView)
        blurView.fillSuperview()

        floatingView.clipsToBounds = true
        floatingView.layer.cornerRadius = 12
        floatingView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 8, bottom: -floatingViewHeight, right: 8), size: .init(width: 0, height: floatingViewHeight))

        let shareButton = ImageTextsButton()
        blurView.contentView.addSubview(shareButton)
        shareButton.centerInSuperview()
        shareButton.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
    }

    @objc fileprivate func handleShare() {
        let items: [Any] = [NSLocalizedString("shareMessage", comment: ""), URL(string: "https://itunes.apple.com/us/app/find-my-parking/id1459821681?mt=8")!]
        let shareSheet = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(shareSheet, animated: true)
    }

    fileprivate func animateFloatingView(_ offsetY: CGFloat) {
        let translationY = -self.floatingViewHeight - 24
        let transform = offsetY > 50 ? CGAffineTransform(translationX: 0, y: translationY) : .identity
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.floatingView.transform = transform
        })
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if -offsetY > 150 {
            return
        }
        if offsetY > 0 {
            header?.animator.fractionComplete = 0
            closeButton.alpha = 1
            animateFloatingView(offsetY)
            return
        }
        closeButton.alpha = 1 - abs(offsetY) / 100
        header?.animator.fractionComplete = abs(offsetY) / 300
    }

    fileprivate func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.backgroundColor = .black
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(InfoContentCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(InfoImageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = .init(top: 44, left: 0, bottom: 44 + floatingViewHeight, right: 0)
        }
    }

    @objc fileprivate func handleDismiss() {
        confetti.removeFromSuperview()
        hideStatusBar(false)
    }

    fileprivate func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.setImage(#imageLiteral(resourceName: "close_button").withRenderingMode(.alwaysOriginal), for: .normal)
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 24), size: .init(width: 40, height: 40))
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as? InfoImageHeader
        return header!
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InfoContentCell
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 48
        let dummyCell = InfoContentCell(frame: .init(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        dummyCell.layoutIfNeeded()
        let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: width, height: .greatestFiniteMagnitude))
        return .init(width: width, height: estimatedSize.height)
    }

    fileprivate func hideStatusBar(_ isHidden: Bool) {
        let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow
        statusBarWindow?.alpha = isHidden ? 0 : 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}
