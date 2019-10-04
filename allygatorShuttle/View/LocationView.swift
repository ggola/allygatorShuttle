//
//  LocationView.swift
//  allygatorShuttle
//
//  Created by Giulio Gola on 02/10/2019.
//  Copyright © 2019 Giulio Gola. All rights reserved.
//

import UIKit
import MapKit

// Custom view for the annotations: shows location markers and the trabant
class LocationView: MKAnnotationView {
    private var imageView: UIImageView!
    var bearingShift: Double?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.imageView.contentMode = .scaleAspectFit

        self.addSubview(self.imageView)
    }
    
    override var image: UIImage? {
        get {
            return self.imageView.image
        }
        set {
            self.imageView.image = newValue
            // Rotate image according to bearing only if bearing is not nil (MKAnnotationView refers to vehicle)
            if let bearing = bearingShift {
                self.imageView.transform = self.imageView.transform.rotated(by: CGFloat(bearing))
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
