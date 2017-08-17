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
    
    class FoodNutrition{
        var energy: Double = 0
        var carbohydrates: Double = 0
        var protein: Double = 0
        var fatTotal: Double = 0
        var fiber: Double = 0
    }
    
    var healthStore = HKHealthStore()
    
    let dietaryEnergyConsumedType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!
    let dietaryCarbohydratesType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!
    let dietaryProteinType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein)!
    let dietaryFatTotalType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal)!
    let dietaryFiberType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFiber)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let WriteDataTypes = dataTypesToWrite()
        //let ReadDataTypes = dataTypesToRead()
        
        if !self.authorizeHealthKit(writeDataTypes: WriteDataTypes, readDataTypes: nil){
            print("healthKit not authorized")
        }
    }
    
    func authorizeHealthKit(writeDataTypes: Set<HKSampleType>?,readDataTypes: Set<HKObjectType>?) -> Bool {
        var isEnabled = true
        if HKHealthStore.isHealthDataAvailable(){
            self.healthStore.requestAuthorization(toShare: writeDataTypes, read: readDataTypes){
                (success, error) -> Void in
                isEnabled = success
                let foodNutrition = FoodNutrition()
                self.addNutritionInfo(foodNutrition: foodNutrition)
            }
        }else{
            isEnabled = false
        }
        return isEnabled
    }
    
    func dataTypesToWrite() -> Set<HKSampleType> {
        
        let writeDataTypes: Set<HKSampleType> = [self.dietaryEnergyConsumedType,self.dietaryCarbohydratesType,self.dietaryProteinType,self.dietaryFatTotalType,self.dietaryFiberType]
        return writeDataTypes
    }
    /*
     func dataTypesToRead() -> Set<HKObjectType> {
     
     let readDataTypes: Set<HKObjectType> = [self.dietaryEnergyConsumedType,self.dietaryCarbohydratesType,self.dietaryProteinType,self.dietaryFatTotalType,self.dietaryFiberType]
     return readDataTypes
     }
     */
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
        
        let energyQuantityConsumed = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: (foodNutrition!.energy))
        let CarbohydratesQuantityConsumed = HKQuantity(unit: HKUnit.gram(), doubleValue: (foodNutrition!.carbohydrates))
        let ProteinQuantityConsumed = HKQuantity(unit: HKUnit.gram(), doubleValue: (foodNutrition!.protein))
        let FatTotalQuantityConsumed = HKQuantity(unit: HKUnit.gram(), doubleValue: (foodNutrition!.fatTotal))
        let FiberQuantityConsumed = HKQuantity(unit: HKUnit.gram(), doubleValue: (foodNutrition!.fiber))
        
        let energyConsumedSample = HKQuantitySample(type: self.dietaryEnergyConsumedType, quantity: energyQuantityConsumed, start: nowDate, end: nowDate)
        let CarbohydratesSample = HKQuantitySample(type: self.dietaryCarbohydratesType, quantity: CarbohydratesQuantityConsumed, start: nowDate, end: nowDate)
        let ProteinSample = HKQuantitySample(type: self.dietaryProteinType, quantity: ProteinQuantityConsumed, start: nowDate, end: nowDate)
        let FatTotalSample = HKQuantitySample(type: self.dietaryFatTotalType, quantity: FatTotalQuantityConsumed, start: nowDate, end: nowDate)
        let FiberSample = HKQuantitySample(type: self.dietaryFiberType, quantity: FiberQuantityConsumed, start: nowDate, end: nowDate)
        
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

