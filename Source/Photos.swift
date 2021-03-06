import Photos

public struct ImagePicker {

  public static func fetch(completion: (assets: [PHAsset]) -> Void) {
    let fetchOptions = PHFetchOptions()
    fetchOptions.predicate = NSPredicate(format:"mediaType == %d OR mediaType == %d", PHAssetMediaType.Image.rawValue, PHAssetMediaType.Video.rawValue)
    fetchOptions.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
    let authorizationStatus = PHPhotoLibrary.authorizationStatus()
    var fetchResult: PHFetchResult?

    guard authorizationStatus == .Authorized else { return }

    if fetchResult == nil {
      fetchResult = PHAsset.fetchAssetsWithOptions(fetchOptions)
    }

    if fetchResult?.count > 0 {
      var assets = [PHAsset]()
      fetchResult?.enumerateObjectsUsingBlock { object, index, stop in
        if let asset = object as? PHAsset {
          assets.insert(asset, atIndex: 0)
        }
      }

      dispatch_async(dispatch_get_main_queue(), {
        completion(assets: assets)
      })
    }
  }

  public static func resolveAsset(asset: PHAsset, size: CGSize = CGSize(width: 720, height: 1280), completion: (image: UIImage?) -> Void) {
    let imageManager = PHImageManager.defaultManager()
    let requestOptions = PHImageRequestOptions()

    imageManager.requestImageForAsset(asset, targetSize: size, contentMode: .AspectFill, options: requestOptions) { image, info in
      if let info = info, degraded = info[PHImageResultIsDegradedKey] where degraded as! Bool == false {
        dispatch_async(dispatch_get_main_queue(), {
          completion(image: image)
        })
      }
    }
  }

  public static func resolveAssets(assets: [PHAsset], size: CGSize = CGSize(width: 720, height: 1280)) -> [UIImage] {
    let imageManager = PHImageManager.defaultManager()
    let requestOptions = PHImageRequestOptions()
    requestOptions.synchronous = true

    var images = [UIImage]()
    for asset in assets {
      imageManager.requestImageForAsset(asset, targetSize: size, contentMode: .AspectFill, options: requestOptions) { image, info in
        if let image = image {
          images.append(image)
        }
      }
    }

    return images
  }
}
