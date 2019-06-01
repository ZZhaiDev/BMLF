

import MapKit
import Kingfisher

class CustomCalloutView: UIView{
    var imageV: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        return iv
    }()
    var data = AddAptProperties(){
        didSet{
            if let images = data.images, let fimage = images.first, let image = fimage.image{
                imageV.kf.indicatorType = .activity
                ZJPrint(image)
                let url = URL(string: image)
                imageV.kf.setImage(with: url)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageV)
        imageV.fillSuperview()
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomizedAnnotation: MKPointAnnotation {
    var data = AddAptProperties(){
        didSet{
        }
    }
}


class CustomizedAnnotationView: MKAnnotationView
{
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (hitView != nil)
        {
            self.superview?.bringSubviewToFront(self)
        }
        return hitView
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds
        var isInside: Bool = rect.contains(point)
        if(!isInside)
        {
            for view in self.subviews
            {
                isInside = view.frame.contains(point)
                if isInside
                {
                    break
                }
            }
        }
        return isInside
    }
}
