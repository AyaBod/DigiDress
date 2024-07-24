//
// clothingClassification.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML

@available(macOS 10.14, iOS 12.0, tvOS 12.0, *)
@available(watchOS, unavailable)
class ClothingClassifierInput : MLFeatureProvider {
    var image: CVPixelBuffer
    var featureNames: Set<String> { return ["image"] }
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if featureName == "image" { return MLFeatureValue(pixelBuffer: image) }
        return nil
    }
    init(image: CVPixelBuffer) { self.image = image }
}

@available(macOS 10.14, iOS 12.0, tvOS 12.0, *)
@available(watchOS, unavailable)
class ClothingClassifierOutput : MLFeatureProvider {
    private let provider: MLFeatureProvider
    var target: String { return provider.featureValue(for: "target")!.stringValue }
    var targetProbability: [String: Double] { return provider.featureValue(for: "targetProbability")!.dictionaryValue as! [String: Double] }
    var featureNames: Set<String> { return provider.featureNames }
    func featureValue(for featureName: String) -> MLFeatureValue? { return provider.featureValue(for: featureName) }
    init(target: String, targetProbability: [String: Double]) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["target": MLFeatureValue(string: target), "targetProbability": MLFeatureValue(dictionary: targetProbability as [AnyHashable: NSNumber])])
    }
    init(features: MLFeatureProvider) { self.provider = features }
}

@available(macOS 10.14, iOS 12.0, tvOS 12.0, *)
@available(watchOS, unavailable)
class ClothingClassifier {
    let model: MLModel
    class var urlOfModelInThisBundle: URL {
        let bundle = Bundle(for: self)
        return bundle.url(forResource: "clothingClassification", withExtension: "mlmodelc")!
    }
    init(model: MLModel) { self.model = model }
    convenience init() { try! self.init(contentsOf: type(of: self).urlOfModelInThisBundle) }
    convenience init(configuration: MLModelConfiguration) throws { try self.init(contentsOf: type(of: self).urlOfModelInThisBundle, configuration: configuration) }
    convenience init(contentsOf modelURL: URL) throws { try self.init(model: MLModel(contentsOf: modelURL)) }
    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws { try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration)) }
    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<ClothingClassifier, Error>) -> Void) {
        return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<ClothingClassifier, Error>) -> Void) {
        MLModel.load(contentsOf: modelURL, configuration: configuration) { result in
            switch result {
            case .failure(let error): handler(.failure(error))
            case .success(let model): handler(.success(ClothingClassifier(model: model)))
            }
        }
    }
    func prediction(input: ClothingClassifierInput) throws -> ClothingClassifierOutput { return try self.prediction(input: input, options: MLPredictionOptions()) }
    func prediction(input: ClothingClassifierInput, options: MLPredictionOptions) throws -> ClothingClassifierOutput {
        let outFeatures = try model.prediction(from: input, options: options)
        return ClothingClassifierOutput(features: outFeatures)
    }
    func prediction(image: CVPixelBuffer) throws -> ClothingClassifierOutput {
        let input = ClothingClassifierInput(image: image)
        return try self.prediction(input: input)
    }
}



/*
import CoreML

/// Model Prediction Input Type
@available(macOS 10.14, iOS 12.0, tvOS 12.0, *)
@available(watchOS, unavailable)
class ClothingClassifierInput : MLFeatureProvider {

    /// image as color (kCVPixelFormatType_32BGRA) image buffer, 299 pixels wide by 299 pixels high
    var image: CVPixelBuffer

    var featureNames: Set<String> {
        get {
            return ["image"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "image") {
            return MLFeatureValue(pixelBuffer: image)
        }
        return nil
    }
    
    init(image: CVPixelBuffer) {
        self.image = image
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    convenience init(imageWith image: CGImage) throws {
        self.init(image: try MLFeatureValue(cgImage: image, pixelsWide: 299, pixelsHigh: 299, pixelFormatType: kCVPixelFormatType_32BGRA, options: nil).imageBufferValue!)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    convenience init(imageAt image: URL) throws {
        self.init(image: try MLFeatureValue(imageAt: image, pixelsWide: 299, pixelsHigh: 299, pixelFormatType: kCVPixelFormatType_32BGRA, options: nil).imageBufferValue!)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func setImage(with image: CGImage) throws  {
        self.image = try MLFeatureValue(cgImage: image, pixelsWide: 299, pixelsHigh: 299, pixelFormatType: kCVPixelFormatType_32BGRA, options: nil).imageBufferValue!
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func setImage(with image: URL) throws  {
        self.image = try MLFeatureValue(imageAt: image, pixelsWide: 299, pixelsHigh: 299, pixelFormatType: kCVPixelFormatType_32BGRA, options: nil).imageBufferValue!
    }

}

/// Model Prediction Output Type
@available(macOS 10.14, iOS 12.0, tvOS 12.0, *)
@available(watchOS, unavailable)
class ClothingClassifierOutput : MLFeatureProvider {

    /// Source provided by CoreML
    private let provider : MLFeatureProvider

    /// target as string value
    var target: String {
        return self.provider.featureValue(for: "target")!.stringValue
    }

    /// targetProbability as dictionary of strings to doubles
    var targetProbability: [String : Double] {
        return self.provider.featureValue(for: "targetProbability")!.dictionaryValue as! [String : Double]
    }

    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(target: String, targetProbability: [String : Double]) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["target" : MLFeatureValue(string: target), "targetProbability" : MLFeatureValue(dictionary: targetProbability as [AnyHashable : NSNumber])])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}

/// Class for model loading and prediction
@available(macOS 10.14, iOS 12.0, tvOS 12.0, *)
@available(watchOS, unavailable)
class ClothingClassifier {
    let model: MLModel

    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: self)
        return bundle.url(forResource: "clothingClassification", withExtension:"mlmodelc")!
    }

    init(model: MLModel) {
        self.model = model
    }

    @available(*, deprecated, message: "Use init(configuration:) instead and handle errors appropriately.")
    convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }

    convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    convenience init(contentsOf modelURL: URL) throws {
        try self.init(model: MLModel(contentsOf: modelURL))
    }

    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
    }

    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<ClothingClassifier, Error>) -> Void) {
        return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> ClothingClassifier {
        return try await self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration)
    }

    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<ClothingClassifier, Error>) -> Void) {
        MLModel.load(contentsOf: modelURL, configuration: configuration) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let model):
                handler(.success(ClothingClassifier(model: model)))
            }
        }
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> ClothingClassifier {
        let model = try await MLModel.load(contentsOf: modelURL, configuration: configuration)
        return ClothingClassifier(model: model)
    }

    func prediction(input: ClothingClassifierInput) throws -> ClothingClassifierOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    func prediction(input: ClothingClassifierInput, options: MLPredictionOptions) throws -> ClothingClassifierOutput {
        let outFeatures = try model.prediction(from: input, options: options)
        return ClothingClassifierOutput(features: outFeatures)
    }

    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    func prediction(input: ClothingClassifierInput, options: MLPredictionOptions = MLPredictionOptions()) async throws -> ClothingClassifierOutput {
        let outFeatures = try await model.prediction(from: input, options: options)
        return ClothingClassifierOutput(features: outFeatures)
    }

    func prediction(image: CVPixelBuffer) throws -> ClothingClassifierOutput {
        let input_ = ClothingClassifierInput(image: image)
        return try self.prediction(input: input_)
    }

    func predictions(inputs: [ClothingClassifierInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [ClothingClassifierOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results: [ClothingClassifierOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result = ClothingClassifierOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}*/
