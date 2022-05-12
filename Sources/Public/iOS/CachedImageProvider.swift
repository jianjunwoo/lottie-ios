// Created by Jianjun Wu on 2022/5/12.
// Copyright © 2022 Airbnb Inc. All rights reserved.

import CoreGraphics
import Foundation
#if os(iOS) || os(tvOS) || os(watchOS) || targetEnvironment(macCatalyst)
import UIKit

// MARK: - CachedImageProvider

private final class CachedImageProvider: AnimationImageProvider {

  // MARK: Lifecycle

  /// Initializes an image provider with an image provider
  ///
  /// - Parameter imageProvider: The provider to load image from asset
  ///
  public init(imageProvider: AnimationImageProvider) {
    self.imageProvider = imageProvider
  }

  // MARK: Public

  public func imageForAsset(asset: ImageAsset) -> CGImage? {
    if let image = imageCache.object(forKey: asset.id as NSString) {
      return image
    }
    if let image = imageProvider.imageForAsset(asset: asset) {
      imageCache.setObject(image, forKey: asset.id as NSString)
      return image
    }
    return nil
  }

  // MARK: Internal

  let imageCache: NSCache<NSString, CGImage> = .init()
  let imageProvider: AnimationImageProvider
}

extension AnimationImageProvider {
  public var cachedImageProvider: AnimationImageProvider {
    CachedImageProvider(imageProvider: self)
  }
}

#endif
