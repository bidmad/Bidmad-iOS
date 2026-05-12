//
//  ConsumableExampleViewController.swift
//  BidmadSDKTest
//

import OpenBiddingHelper
import UIKit

private func onMain(_ block: @escaping () -> Void) {
    DispatchQueue.main.async(execute: block)
}

final class FullscreenAd: NSObject, BidmadFullscreenAdDelegate,
    @unchecked Sendable
{
    let zoneId: String
    let ad: BidmadFullscreenAd
    private(set) var isLoaded: Bool = false
    private var isLoading: Bool = false
    private var loadedInfo: BidmadInfo?
    private var loadCompletions: [(Result<BidmadInfo, Error>) -> Void] = []
    private var showCompletion: ((Result<BidmadFullscreenAd, Error>) -> Void)?
    private var holdUntilClose: FullscreenAd?

    init(zoneId: String) {
        self.zoneId = zoneId
        self.ad = BidmadFullscreenAd(zoneID: zoneId)
        self.ad.isAutoReload = false
        super.init()
        self.ad.delegate = self
    }

    func load(completionHandler: @escaping (Result<BidmadInfo, Error>) -> Void)
    {
        onMain { [weak self] in
            guard let self = self else { return }
            if isLoaded, let info = loadedInfo {
                completionHandler(.success(info))
                return
            }
            loadCompletions.append(completionHandler)
            guard !isLoading else { return }
            isLoading = true
            ad.load()
        }
    }

    func show(
        on viewController: UIViewController,
        completionHandler: @escaping (Result<BidmadFullscreenAd, Error>) -> Void
    ) {
        onMain { [weak self] in
            guard let self = self else { return }
            if showCompletion != nil {
                completionHandler(
                    .failure(
                        NSError(
                            domain: "FullscreenAd",
                            code: -2,
                            userInfo: [
                                NSLocalizedDescriptionKey:
                                    "show already in progress"
                            ]
                        )
                    )
                )
                return
            }
            if isLoaded {
                showCompletion = completionHandler
                holdUntilClose = self
                ad.show(on: viewController)
                return
            }
            load { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.showCompletion = completionHandler
                    self.holdUntilClose = self
                    self.ad.show(on: viewController)
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }

    func bidmadFullscreenLoad(ad: BidmadFullscreenAd, info: BidmadInfo) {
        onMain { [weak self] in
            guard let self = self else { return }
            isLoading = false
            isLoaded = true
            loadedInfo = info
            let pending = loadCompletions
            loadCompletions = []
            pending.forEach { $0(.success(info)) }
        }
    }

    func bidmadFullscreenLoadFail(ad: BidmadFullscreenAd, error: Error) {
        onMain { [weak self] in
            guard let self = self else { return }
            isLoading = false
            isLoaded = false
            loadedInfo = nil
            let pending = loadCompletions
            loadCompletions = []
            pending.forEach { $0(.failure(error)) }
        }
    }

    func bidmadFullscreenShow(ad: BidmadFullscreenAd, info: BidmadInfo) {
        onMain { [weak self] in
            guard let self = self else { return }
            isLoaded = false
            loadedInfo = nil
            let completion = showCompletion
            showCompletion = nil
            completion?(.success(ad))
        }
    }

    func bidmadFullscreenShowFail(
        ad: BidmadFullscreenAd,
        info: BidmadInfo?,
        error: Error
    ) {
        onMain { [weak self] in
            guard let self = self else { return }
            isLoaded = false
            loadedInfo = nil
            let completion = showCompletion
            showCompletion = nil
            completion?(.failure(error))
            holdUntilClose = nil
        }
    }

    func bidmadFullscreenClick(ad: BidmadFullscreenAd, info: BidmadInfo) {
        NSLog("FullscreenAd[%@] click: %@", zoneId, info)
    }

    func bidmadFullscreenComplete(ad: BidmadFullscreenAd, info: BidmadInfo) {
        NSLog("FullscreenAd[%@] complete: %@", zoneId, info)
    }

    func bidmadFullscreenSkip(ad: BidmadFullscreenAd, info: BidmadInfo) {
        NSLog("FullscreenAd[%@] skip: %@", zoneId, info)
    }

    func bidmadFullscreenClose(ad: BidmadFullscreenAd, info: BidmadInfo) {
        NSLog("FullscreenAd[%@] close: %@", zoneId, info)
        onMain { [weak self] in
            self?.holdUntilClose = nil
        }
    }
}

final class BannerAd: UIView, BIDMADOpenBiddingBannerDelegate,
    @unchecked Sendable
{
    let zoneId: String
    private(set) var ad: BidmadBannerAd!
    private(set) var isLoaded: Bool = false
    private var isLoading: Bool = false
    private var loadedInfo: BidmadInfo?
    private var loadCompletions: [(Result<BidmadInfo, Error>) -> Void] = []

    init(zoneId: String, parentViewController: UIViewController) {
        self.zoneId = zoneId
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 320),
            heightAnchor.constraint(equalToConstant: 50),
        ])
        self.ad = BidmadBannerAd(
            parentViewController,
            containerView: self,
            zoneID: zoneId
        )
        self.ad.delegate = self
        NSLog("BannerAd[%@] init %p (sdk %p)", zoneId, self, self.ad)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    deinit {
        NSLog("BannerAd[%@] deinit %p", zoneId, self)
        let adToRelease = ad
        DispatchQueue.main.async {
            adToRelease?.remove()
        }
    }

    func onLoadAd(_ bidmadAd: OpenBiddingBanner, info: BidmadInfo) {
        onMain { [weak self] in
            guard let self = self else { return }
            isLoading = false
            isLoaded = true
            loadedInfo = info
            let pending = loadCompletions
            loadCompletions = []
            pending.forEach { $0(.success(info)) }
        }
    }

    func onLoadFailAd(_ bidmadAd: OpenBiddingBanner, error: Error) {
        onMain { [weak self] in
            guard let self = self else { return }
            isLoading = false
            isLoaded = false
            loadedInfo = nil
            let pending = loadCompletions
            loadCompletions = []
            pending.forEach { $0(.failure(error)) }
        }
    }

    func onClickAd(_ bidmadAd: OpenBiddingBanner, info: BidmadInfo) {
        NSLog("BannerAd[%@] click: %@", zoneId, info)
    }

    func load(completionHandler: @escaping (Result<BidmadInfo, Error>) -> Void)
    {
        onMain { [weak self] in
            guard let self = self else { return }
            if isLoaded, let info = loadedInfo {
                completionHandler(.success(info))
                return
            }
            loadCompletions.append(completionHandler)
            guard !isLoading else { return }
            isLoading = true
            ad.load()
        }
    }

    func show(
        completionHandler: @escaping (Result<BidmadBannerAd, Error>) -> Void
    ) {
        onMain { [weak self] in
            guard let self = self else { return }
            if isLoaded {
                ad.show()
                isLoaded = false
                loadedInfo = nil
                completionHandler(.success(ad))
                return
            }
            load { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.ad.show()
                    self.isLoaded = false
                    self.loadedInfo = nil
                    completionHandler(.success(self.ad))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }
}

final class Consumable: NSObject, @unchecked Sendable {
    @objc public static let shared = Consumable()

    private override init() { super.init() }

    var fullscreenAds: [String: [FullscreenAd]] = [:]
    var bannerAds: [String: [BannerAd]] = [:]

    private var hasLoaded = false

    @objc func load(
        fullscreenAdZoneIds: [String],
        bannerAdZoneIds: [String]
    ) {
        onMain { [weak self] in
            guard let self = self else { return }
            if self.hasLoaded { return }
            self.hasLoaded = true
            let tasks: [(isFullscreen: Bool, zoneId: String)] =
                fullscreenAdZoneIds.map { (true, $0) }
                + bannerAdZoneIds.map { (false, $0) }
            self.loadSequentially(tasks: tasks, index: 0)
        }
    }

    private func loadSequentially(
        tasks: [(isFullscreen: Bool, zoneId: String)],
        index: Int
    ) {
        guard index < tasks.count else { return }
        let task = tasks[index]
        let advance: () -> Void = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.loadSequentially(tasks: tasks, index: index + 1)
            }
        }
        if task.isFullscreen {
            loadFullscreenAd(for: task.zoneId) { _ in advance() }
        } else {
            loadBannerAd(for: task.zoneId) { _ in advance() }
        }
    }

    private func loadFullscreenAd(
        for zoneId: String,
        completionHandler: @escaping (Result<BidmadInfo, Error>) -> Void
    ) {
        onMain { [weak self] in
            guard let self = self else { return }
            let wrapper = FullscreenAd(zoneId: zoneId)
            fullscreenAds[zoneId, default: []].append(wrapper)
            wrapper.load(completionHandler: completionHandler)
        }
    }

    func consumeFullscreenAd(
        for zoneId: String,
        on viewController: UIViewController,
        completionHandler: @escaping (Result<BidmadFullscreenAd, Error>) -> Void
    ) {
        onMain { [weak self] in
            guard let self = self else { return }
            var pool = fullscreenAds[zoneId] ?? []

            let pickedIndex =
                pool.firstIndex(where: { $0.isLoaded })
                ?? (pool.isEmpty ? nil : 0)

            if let index = pickedIndex {
                let wrapper = pool.remove(at: index)
                fullscreenAds[zoneId] = pool
                wrapper.show(on: viewController) { result in
                    _ = wrapper
                    switch result {
                    case .success(let ad):
                        completionHandler(.success(ad))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
                loadFullscreenAd(for: zoneId) { _ in }
                return
            }

            let transient = FullscreenAd(zoneId: zoneId)
            transient.show(on: viewController) { result in
                _ = transient
                switch result {
                case .success(let ad):
                    completionHandler(.success(ad))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }

    private func loadBannerAd(
        for zoneId: String,
        completionHandler: @escaping (Result<BidmadInfo, Error>) -> Void
    ) {
        onMain { [weak self] in
            guard let self = self else { return }
            NSLog(
                "Consumable.loadBannerAd[%@] pool=%d (before)",
                zoneId,
                self.bannerAds[zoneId]?.count ?? 0
            )
            guard let wrapper = makeBannerAd(for: zoneId) else {
                completionHandler(
                    .failure(
                        NSError(
                            domain: "Consumable",
                            code: -1,
                            userInfo: [
                                NSLocalizedDescriptionKey:
                                    "No top view controller available"
                            ]
                        )
                    )
                )
                return
            }
            bannerAds[zoneId, default: []].append(wrapper)
            wrapper.load(completionHandler: completionHandler)
        }
    }

    func consumeBannerAd(
        for zoneId: String,
        completionHandler: @escaping (Result<BannerAd, Error>) -> Void
    ) {
        onMain { [weak self] in
            guard let self = self else { return }
            var pool = bannerAds[zoneId] ?? []

            let pickedIndex =
                pool.firstIndex(where: { $0.isLoaded })
                ?? (pool.isEmpty ? nil : 0)

            if let index = pickedIndex {
                let wrapper = pool.remove(at: index)
                bannerAds[zoneId] = pool
                wrapper.show { result in
                    switch result {
                    case .success: completionHandler(.success(wrapper))
                    case .failure(let error): completionHandler(.failure(error))
                    }
                }
                loadBannerAd(for: zoneId) { _ in }
                return
            }

            guard let transient = makeBannerAd(for: zoneId) else {
                completionHandler(
                    .failure(
                        NSError(
                            domain: "Consumable",
                            code: -1,
                            userInfo: [
                                NSLocalizedDescriptionKey:
                                    "No top view controller available"
                            ]
                        )
                    )
                )
                return
            }
            transient.show { result in
                switch result {
                case .success: completionHandler(.success(transient))
                case .failure(let error): completionHandler(.failure(error))
                }
            }
        }
    }

    private func makeBannerAd(for zoneId: String) -> BannerAd? {
        guard let parentViewController = Self.topViewController() else {
            return nil
        }
        return BannerAd(
            zoneId: zoneId,
            parentViewController: parentViewController
        )
    }

    private static func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }

        var top = keyWindow?.rootViewController
        while let presented = top?.presentedViewController {
            top = presented
        }
        if let nav = top as? UINavigationController {
            return nav.visibleViewController ?? nav
        }
        if let tab = top as? UITabBarController {
            return tab.selectedViewController ?? tab
        }
        return top
    }
}

class ConsumableExampleViewController: UIViewController {

    private let fullscreenZoneId = "dcd42036-e54c-4b63-bdce-295bbfdc2ed6"
    private let bannerZoneId = "1c3e3085-333f-45af-8427-2810c26a72fc"

    private let fullscreenConsumeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Consume Fullscreen", for: .normal)
        button.backgroundColor = .systemTeal
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let bannerConsumeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Consume Banner", for: .normal)
        button.backgroundColor = .systemTeal
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let bannerRemoveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove Banner", for: .normal)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let bannerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(fullscreenConsumeButton)
        view.addSubview(bannerConsumeButton)
        view.addSubview(bannerRemoveButton)
        view.addSubview(bannerStackView)

        fullscreenConsumeButton.addTarget(
            self,
            action: #selector(consumeFullscreenTapped),
            for: .touchUpInside
        )
        bannerConsumeButton.addTarget(
            self,
            action: #selector(consumeBannerTapped),
            for: .touchUpInside
        )
        bannerRemoveButton.addTarget(
            self,
            action: #selector(removeBannerTapped),
            for: .touchUpInside
        )

        NSLayoutConstraint.activate([
            fullscreenConsumeButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            fullscreenConsumeButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 20
            ),
            fullscreenConsumeButton.widthAnchor.constraint(
                equalToConstant: 220
            ),
            fullscreenConsumeButton.heightAnchor.constraint(
                equalToConstant: 40
            ),

            bannerConsumeButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            bannerConsumeButton.topAnchor.constraint(
                equalTo: fullscreenConsumeButton.bottomAnchor,
                constant: 12
            ),
            bannerConsumeButton.widthAnchor.constraint(equalToConstant: 220),
            bannerConsumeButton.heightAnchor.constraint(equalToConstant: 40),

            bannerRemoveButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            bannerRemoveButton.topAnchor.constraint(
                equalTo: bannerConsumeButton.bottomAnchor,
                constant: 12
            ),
            bannerRemoveButton.widthAnchor.constraint(equalToConstant: 220),
            bannerRemoveButton.heightAnchor.constraint(equalToConstant: 40),

            bannerStackView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            bannerStackView.topAnchor.constraint(
                equalTo: bannerRemoveButton.bottomAnchor,
                constant: 20
            ),
            bannerStackView.leadingAnchor.constraint(
                greaterThanOrEqualTo: view.leadingAnchor,
                constant: 16
            ),
            bannerStackView.trailingAnchor.constraint(
                lessThanOrEqualTo: view.trailingAnchor,
                constant: -16
            ),
        ])
    }

    @objc private func consumeFullscreenTapped() {
        let zoneId = fullscreenZoneId
        Consumable.shared.consumeFullscreenAd(for: zoneId, on: self) {
            result in
            switch result {
            case .success: print("Fullscreen consumed for \(zoneId)")
            case .failure(let error):
                print("Fullscreen consume failed: \(error)")
            }
        }
    }

    @objc private func consumeBannerTapped() {
        let zoneId = bannerZoneId
        Consumable.shared.consumeBannerAd(for: zoneId) {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let banner):
                self.bannerStackView.addArrangedSubview(banner)
                print("Banner consumed for \(zoneId)")
            case .failure(let error): print("Banner consume failed: \(error)")
            }
        }
    }

    @objc private func removeBannerTapped() {
        guard let last = bannerStackView.arrangedSubviews.last else {
            print("No banner to remove")
            return
        }
        NSLog(
            "removeBannerTapped: removing %p (stack before=%d)",
            last,
            bannerStackView.arrangedSubviews.count
        )
        bannerStackView.removeArrangedSubview(last)
        last.removeFromSuperview()
        NSLog(
            "removeBannerTapped: removed, stack after=%d, pool=%@",
            bannerStackView.arrangedSubviews.count,
            Consumable.shared.bannerAds.mapValues { $0.count } as NSDictionary
        )
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true)
    }
}
