//
//  ViewController.swift
//  demoHealthKit
//
//  Created by 陳鈞廷 on 2017/8/16.
//  Copyright © 2017年 陳鈞廷. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    var healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let WriteDataTypes = dataTypesToWrite()
        let ReadDataTypes = dataTypesToRead()
        
        if !self.authorizeHealthKit(writeDataTypes: WriteDataTypes, readDataTypes: ReadDataTypes){
            print("healthKit not authorized")
        }
        
        self.addNutritionInfo()
        
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
    
    func addNutritionInfo() -> Void {
        let foodCorrelationToAdd: HKCorrelation = foodCorrelationForFoodItem()
        
        self.healthStore.save(foodCorrelationToAdd){
            (success, error) -> Void in
            if !success {
                print("error")
                return
            }
            print("successful")
        }
    }
    
    func foodCorrelationForFoodItem() -> HKCorrelation
    {
        let nowDate = Date()
        
        let energyQuantityConsumed = HKQuantity(unit: HKUnit.largeCalorie(), doubleValue: 100)
        let CarbohydratesQuantityConsumed = HKQuantity(unit: HKUnit.gram(), doubleValue: 100)
        let ProteinQuantityConsumed = HKQuantity(unit: HKUnit.gram(), doubleValue: 100)
        let FatTotalQuantityConsumed = HKQuantity(unit: HKUnit.gram(), doubleValue: 100)
        let FiberQuantityConsumed = HKQuantity(unit: HKUnit.gram(), doubleValue: 0.0001)
        
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

