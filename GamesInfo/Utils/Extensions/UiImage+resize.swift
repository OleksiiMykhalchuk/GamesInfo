//
//  UiImage+resize.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/20/24.
//

import UIKit

extension UIImage {

    func resize(width: CGFloat, compress: CGFloat) -> UIImage? {
        let ratio = self.size.width / self.size.height
        let size = CGSize(width: width, height: width / ratio)
        let resized = UIGraphicsImageRenderer(size: size)
            .image { _ in
                self.draw(in: CGRect(origin: .zero, size: size))
            }
        guard let compress = resized.jpegData(compressionQuality: compress) else {
            return resized
        }
        return UIImage(data: compress)
    }
}
