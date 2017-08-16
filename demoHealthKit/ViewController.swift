//
//  ViewController.swift
//  demoHealthKit
//
//  Created by 陳鈞廷 on 2017/8/16.
//  Copyright © 2017年 陳鈞廷. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    class FoodNutrition{
        var energy: Double = 0
        var carbohydrates: Double = 0
        var protein: Double = 0
        var fatTotal: Double = 0
        var fiber: Double = 0
    }
    //
    let submitButton = UIButton()
    let energyInput = UITextField()
    let carbohydratesInput = UITextField()
    let proteinInput = UITextField()
    let fatTotalInput = UITextField()
    let fiberInput = UITextField()
    //
    var healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let WriteDataTypes = dataTypesToWrite()
        //let ReadDataTypes = dataTypesToRead()
        
        if !self.authorizeHealthKit(writeDataTypes: WriteDataTypes, readDataTypes: nil){
            print("healthKit not authorized")
        }
        //
        self.submitButton.frame = CGRect(x: (self.view.frame.size.width - 100)/2, y: self.view.frame.size.height - 100, width: 100, height: 50)
        self.submitButton.backgroundColor = UIColor.blue
        self.submitButton.setTitle("Submit", for: .normal)
        self.submitButton.addTarget(self, action: #selector(submitData), for: .touchUpInside)
        self.view.addSubview(self.submitButton)
        
        self.placeTextField(textField: energyInput, placeholder: "請輸入熱量", frame: CGRect(x: (self.view.frame.size.width - 200)/2, y: 50, width: 200, height: 50))
        
        self.placeTextField(textField: carbohydratesInput, placeholder: "請輸入醣類", frame: CGRect(x: (self.view.frame.size.width - 200)/2, y: 125, width: 200, height: 50))
        
        self.placeTextField(textField: proteinInput, placeholder: "請輸入蛋白質", frame: CGRect(x: (self.view.frame.size.width - 200)/2, y: 200, width: 200, height: 50))
        
        self.placeTextField(textField: fatTotalInput, placeholder: "請輸入脂肪", frame: CGRect(x: (self.view.frame.size.width - 200)/2, y: 275, width: 200, height: 50))
        
        self.placeTextField(textField: fiberInput, placeholder: "請輸入纖維質", frame: CGRect(x: (self.view.frame.size.width - 200)/2, y: 350, width: 200, height: 50))
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
        
        // At every character in this "inverseSet" contained in the string,
        // split the string up into components which exclude the characters
        // in this inverse set
        let components = string.components(separatedBy: inverseSet)
        
        // Rejoin these components
        let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift 1.2
        
        // If the original string is equal to the filtered string, i.e. if no
        // inverse characters were present to be eliminated, the input is valid
        // and the statement returns true; else it returns false
        return string == filtered
    }
    
    func placeTextField(textField: UITextField,placeholder: String,frame: CGRect){
        textField.frame = frame
        textField.placeholder = placeholder
        textField.backgroundColor = UIColor.lightGray
        textField.keyboardType = .numberPad
        self.view.addSubview(textField)
    }
    
    @objc func submitData(sender: UIButton!){
        let foodNutrition = FoodNutrition()
        if let energy = Double(energyInput.text!) {
            foodNutrition.energy = energy
        }
        if let carbohydrates = Double(carbohydratesInput.text!) {
            foodNutrition.carbohydrates = carbohydrates
        }
        if let protein = Double(proteinInput.text!) {
            foodNutrition.protein = protein
        }
        if let fat = Double(fatTotalInput.text!) {
            foodNutrition.fatTotal = fat
        }
        if let fiber = Double(fiberInput.text!) {
            foodNutrition.fiber = fiber
        }
        self.addNutritionInfo(foodNutrition: foodNutrition)
    }
    
    func authorizeHealthKit(writeDataTypes: Set<HKSampleType>?,readDataTypes: Set<HKObjectType>?) -> Bool {
        var isEnabled = true
        if HKHealthStore.isHealthDataAvailable(){
            self.healthStore.requestAuthorization(toShare: writeDataTypes, read: readDataTypes){
                (success, error) -> Void in
                isEnabled = success
            }
        }else{
            isEnabled = false
        }
        return isEnabled
    }
    
    func dataTypesToWrite() -> Set<HKSampleType> {
        let dietaryEnergyConsumedType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!
        let dietaryCarbohydratesType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!
        let dietaryProteinType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein)!
        let dietaryFatTotalType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal)!
        let dietaryFiberType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFiber)!
        
        let writeDataTypes: Set<HKSampleType> = [dietaryEnergyConsumedType,dietaryCarbohydratesType,dietaryProteinType,dietaryFatTotalType,dietaryFiberType]
        return writeDataTypes
    }
    
    func dataTypesToRead() -> Set<HKObjectType> {
        let dietaryEnergyConsumedType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!
        let dietaryCarbohydratesType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!
        let dietaryProteinType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein)!
        let dietaryFatTotalType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal)!
        let dietaryFiberType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFiber)!
        
        let readDataTypes: Set<HKObjectType> = [dietaryEnergyConsumedType,dietaryCarbohydratesType,dietaryProteinType,dietaryFatTotalType,dietaryFiberType]
        return readDataTypes
    }
    
    func addNutritionInfo(foodNutrition: FoodNutrition?) -> Void {
        let foodCorrelationToAdd: HKCorrelation = foodCorrelationForFoodItem(foodNutrition: foodNutrition)
        
        self.healthStore.save(foodCorrelationToAdd){
            (success, error) -> Void in
            if !success {
                print("error")
                return
            }
            print("successful")
        }
    }
    
    func foodCorrelationForFoodItem(foodNutrition: FoodNutrition?) -> HKCorrelation
    {
        let nowDate = Date()
        
        let energyQuantityConsumed = HKQuantity(unit: HKUnit.largeCalorie(), doubleValue: foodNutrition!.energy)
        let CarbohydratesQuantityConsumed = HKQuantity(unit: HKUnit.gram(), doubleValue: foodNutrition!.carbohydrates)
        let ProteinQuantityConsumed = HKQuantity(unit: HKUnit.gram(), doubleValue: foodNutrition!.protein)
        let FatTotalQuantityConsumed = HKQuantity(unit: HKUnit.gram(), doubleValue: foodNutrition!.fatTotal)
        let FiberQuantityConsumed = HKQuantity(unit: HKUnit.gram(), doubleValue: foodNutrition!.fiber)
        
        let dietaryEnergyConsumedType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!
        let dietaryCarbohydratesType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!
        let dietaryProteinType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein)!
        let dietaryFatTotalType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal)!
        let dietaryFiberType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFiber)!
        
        
        let energyConsumedSample = HKQuantitySample(type: dietaryEnergyConsumedType, quantity: energyQuantityConsumed, start: nowDate, end: nowDate)
        let CarbohydratesSample = HKQuantitySample(type: dietaryCarbohydratesType, quantity: CarbohydratesQuantityConsumed, start: nowDate, end: nowDate)
        let ProteinSample = HKQuantitySample(type: dietaryProteinType, quantity: ProteinQuantityConsumed, start: nowDate, end: nowDate)
        let FatTotalSample = HKQuantitySample(type: dietaryFatTotalType, quantity: FatTotalQuantityConsumed, start: nowDate, end: nowDate)
        let FiberSample = HKQuantitySample(type: dietaryFiberType, quantity: FiberQuantityConsumed, start: nowDate, end: nowDate)
        
        let NutritionSamples: Set<HKSample> = [energyConsumedSample,CarbohydratesSample,ProteinSample,FatTotalSample,FiberSample]
        
        let foodType = HKCorrelationType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.food)!
        let foodCorrelationMetadata: Dictionary<String, String> = [HKMetadataKeyFoodType: "unknown"]
        
        let foodCorrelation = HKCorrelation(type: foodType, start: nowDate, end: nowDate, objects: NutritionSamples, metadata: foodCorrelationMetadata)
        
        return foodCorrelation
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

