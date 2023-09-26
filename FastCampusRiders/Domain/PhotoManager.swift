//
//  PhotoManager.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/29.
//

import AVKit
import Combine
import Foundation

class PhotoManager: NSObject, UINavigationControllerDelegate {
    enum PhotoError: Error {
        case permissionDenied
        case loadingError
        case userCancel
        case unknownError
    }
    
    let photoSubject = PassthroughSubject<Result<UIImage, PhotoError>, Never>()
}

extension PhotoManager {
    private func checkAutorizationStatus(with type: AVMediaType) async -> Bool {
        return await withCheckedContinuation { continuation in
            AVCaptureDevice.requestAccess(for: type) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    func presentImagePickerViewcontroller(with type: AVMediaType,
                                          sourceType: UIImagePickerController.SourceType,
                                          allowEditing: Bool,
                                          on viewController: UIViewController) {
        Task { @MainActor in
            if await self.checkAutorizationStatus(with: type) {
                let pickerController = UIImagePickerController()
                pickerController.sourceType = sourceType
                pickerController.allowsEditing = allowEditing
                pickerController.mediaTypes = ["public.image"]
                pickerController.delegate = self
                viewController.present(pickerController, animated: true)
            } else {
                self.photoSubject.send(.failure(.permissionDenied))
            }
        }
    }
}

extension PhotoManager: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                               info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            self.photoSubject.send(.failure(.loadingError))
            picker.dismiss(animated: true)
            return
        }
        
        self.photoSubject.send(.success(image))
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.photoSubject.send(.failure(.userCancel))
    }
}
