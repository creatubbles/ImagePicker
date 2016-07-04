import UIKit
import Photos

class ImageGalleryViewCell: UICollectionViewCell {
  static var durationFormatter: NSDateComponentsFormatter {
    let formatter = NSDateComponentsFormatter()
    formatter.unitsStyle = .Positional
    formatter.allowedUnits = [ .Minute, .Second ]
    formatter.zeroFormattingBehavior = [ .Pad ]
    
    return formatter
  }

  lazy var imageView = UIImageView()
  lazy var selectedImageView = UIImageView()
  
  lazy var durationLabel: UILabel = {
    let durationLabel = UILabel()
    return durationLabel
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    for view in [imageView, selectedImageView] {
      view.contentMode = .ScaleAspectFill
      view.translatesAutoresizingMaskIntoConstraints = false
      view.clipsToBounds = true
      contentView.addSubview(view)
    }
    durationLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(durationLabel)
    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Configuration
  
  func configureCell(image: UIImage, asset: PHAsset) {
    imageView.image = image
    
    if asset.mediaType == .Video {
      if let durationString = ImageGalleryViewCell.durationFormatter.stringFromTimeInterval(asset.duration) {
        durationLabel.text = " \(durationString)"
      }
      durationLabel.textColor = UIColor.whiteColor()
      durationLabel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    } else {
      durationLabel.text = nil
      durationLabel.backgroundColor = UIColor.clearColor()
    }
  }
}
