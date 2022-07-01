//
//  NetworkManager.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 26.05.2022.
//

import Foundation
import UIKit
import Alamofire
//import SwiftUI

class NetworkManager {
    
    static let shared = NetworkManager()
   private init(){}
    
    let encoder = URLEncoding()
    let urlFirstChar = "https://quickchart.io/chart?c="
    
    

    func gettingAnImage( from url:URL, with complition: @escaping(UIImage)->Void) {
        guard let data = try? Data(contentsOf: url) else {return}
        guard let image = UIImage.init(data: data) else {return}
        DispatchQueue.main.async {
            complition(image)
        }
    }

}

extension NetworkManager {
    
    func monchTarget(_ target:Double, _ complition: @escaping (URL)->Void) {
        let urlLastChar = encoder.escape("{type:'radialGauge',data:{datasets:[{data:[\(target)],backgroundColor:'#FFCC00',borderColor: '#CC9900'}]},options:{domain:[0,100],centerPercentage:80,backgroundColor:'#FFCC00',centerArea:{text:(val)=>val+'%' ,fontColor:'#FFCC00'},}}")
        guard let url = URL(string: (urlFirstChar + urlLastChar)) else {return}
        complition(url)
    }
    
    
    func clockNightOfDay(_ dayClock: Double, _ nightClock: Double, _ complition: @escaping(URL)->Void){
        let urlLastChar =
        encoder.escape(
        """
{
  "type": "outlabeledPie",
  "data": {
    "labels": ["Ночные", "Дневные"],
    "datasets": [{
        "backgroundColor": ["Orange","#FFcc00"],
        "data": [\(nightClock), \(dayClock)]
    }]
  },
  "options": {
    "plugins": {
      "legend": false,
      "outlabels": {
        "text": "%l %p",
        "color": "Black",
        "stretch": 50,
        "font": {
          "resizable": true,
          "minSize": 16,
          "maxSize": 40
        }
      }
    }
  }
}
"""
        )
        guard let url = URL(string: (urlFirstChar + urlLastChar)) else {return}
        complition(url)
    }
    
    func statisticToMonth(_ arrayNameMonch: [String], _ arrayTimeMonch: [Double], _ complition: (URL)-> Void) {
        let urlLastChar = encoder.escape(
                    """
                    {
                      type: 'bar',
                      data: {
                        labels: \(arrayNameMonch),
                        datasets: [{
                          label: 'Отработанные часы',
                          data: \(arrayTimeMonch),
                          backgroundColor: '#FFCC00'
                        },]
                      },
                      options: {
                        legend: false,
                        scales: {
                          xAxes: [{
                            ticks: {
                              beginAtZero: true,
                              fontColor: '#FFCC00',
                             fontSize: 20
                            }
                          }],
                          yAxes: [{
                            ticks: {
                              beginAtZero: false,
                              fontColor: '#FFCC00',
                             fontSize: 15
                            },
                            gridLines: {
                              color: '#FFCC00'
                            }
                          }]
                        },
                      }
                    }
        """
        )
        guard let url = URL(string: (urlFirstChar + urlLastChar)) else {return}
        complition(url)
    }
}

