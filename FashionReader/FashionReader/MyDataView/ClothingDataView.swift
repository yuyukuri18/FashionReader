//
//  ClothingDataView.swift
//  FRSample
//
//  Created by cmStudent on 2022/12/02.
//

import SwiftUI
import RealmSwift


struct ClothingDataView: View {
    @Binding var select: String
    let rectangleFrame = Rectangle()
    let sizeW = UIScreen.main.bounds.width - (UIScreen.main.bounds.width / 15)
    let sizeH = UIScreen.main.bounds.height / 8
    let bsizeW = UIScreen.main.bounds.width - (UIScreen.main.bounds.width / 15)
    let bsizeH = UIScreen.main.bounds.height / 1.1
    @EnvironmentObject var store: Clothe
    let item: clothesData
    let items: [clothesData]
    @ObservedObject var viewModel = ViewModel()
    @Binding var isAll: Bool
    @Binding var isTops: Bool
    @Binding var isOuter: Bool
    @Binding var isBottoms: Bool
    @Binding var isBag: Bool
    @Binding var isWrite: Bool
    @Binding var selectCategory: String
    @Binding var word: String
    var image = UIImage(named: "dummy")!
    var selectId = 0
    var body: some View {
        let sortedClothes = store.getSortedClothes(word: word, sort: select, categoryName: selectCategory)
        GeometryReader { geometry in
            ScrollView{
                VStack{
                    Rectangle()
                        .frame(width: 10, height: 50)
                        .foregroundColor(Color.white)
                    
                    
                    ForEach(sortedClothes, id: \.id) { item in
                        ZStack {
                            
                            Image(uiImage: viewModel.setImage(imagePath: item.imagePath) ?? image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(17)
                                .frame(width: (item.isOnMain ? 120 : 70),
                                       height: (item.isOnMain ? 120 : 70))
                                .position(x: (item.isOnMain ? sizeW / 2 : geometry.size.width - sizeW + 20), y : (item.isOnMain ? sizeH / 2 + 50 : sizeH / 2))
                                .shadow(color: .gray.opacity(0.7), radius: 5)
                                
                            VStack{
                                Text(item.brandName)
                                    .font(item.isOnMain ? .callout : .caption)
                                    .fontWeight(.regular)
                                Text(item.itemName)
                                    .font(item.isOnMain ? .title : .title2)
                                    .fontWeight(.medium)
                                Text(item.categoryName)
                                    .font(item.isOnMain ? .callout : .caption)
                                    .fontWeight(.regular)
                                
                            }.position(x: (item.isOnMain ? sizeW / 2 : geometry.size.width / 2),
                                       y: (item.isOnMain ? sizeH / 2 + 160 : sizeH / 2))
                            
                            Button {
                                store.delete(itemID: item.id)
                            } label: {
                                item.isOnMain  ? Image(systemName: "trash.circle.fill") : nil
                            }
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black.opacity(0.8))
                            .position(x: UIScreen.main.bounds.width - sizeW + 20, y: sizeH / 2 + 15)
                            .font(.system(size: 40))
                            
                            
                            
                            Button {
                                if item.isOnMain {
                                    store.update(itemID: item.id, brandName: item.brandName, itemName: item.itemName, categoryName: item.categoryName, itemToggle: false)
                                } else {
                                    store.update(itemID: item.id, brandName: item.brandName, itemName: item.itemName, categoryName: item.categoryName, itemToggle: true)
                                }
                                UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]){
                                    (granted, error) in
                                    if granted {
                                        //通知が許可されている場合の処理
                                        viewModel.makeNotification()
                                    }else {
                                        //通知が拒否されている場合の処理
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            //②１秒後に表示を元に戻しておく
                                        }
                                    }
                                }
                                print(Realm.Configuration.defaultConfiguration.fileURL!)
                            } label: {
                                item.isOnMain  ? Image(systemName: "chevron.up") : Image(systemName: "chevron.down")
                            }
                            .position(x: sizeW - 30, y: sizeH / 2)
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            
                            Group() { item.isOnMain ?
                                ZStack{
                                    if (item.categoryName == "トップス" || item.categoryName == "アウター") {
                                        Text("肩幅")
                                            .position(x: (sizeW / 1.23) / 4, y: ((bsizeH / 2) / 5) * 1)
                                        Text("\(String(format: "%.2f", item.sizeA))cm")
                                            .position(x: (sizeW / 1.23) - ((sizeW / 1.23) / 4), y: ((bsizeH / 2) / 5) * 1)
                                        
                                        Text("袖丈")
                                            .position(x: (sizeW / 1.23) / 4, y: ((bsizeH / 2) / 5) * 2)
                                        Text("\(String(format: "%.2f", item.sizeB))cm")
                                            .position(x: (sizeW / 1.23) - ((sizeW / 1.23) / 4), y: ((bsizeH / 2) / 5) * 2)
                                        
                                        Text("着丈")
                                            .position(x: (sizeW / 1.23) / 4, y: ((bsizeH / 2) / 5) * 3)
                                        Text("\(String(format: "%.2f", item.sizeC))cm")
                                            .position(x: (sizeW / 1.23) - ((sizeW / 1.23) / 4), y: ((bsizeH / 2) / 5) * 3)
                                        
                                        
                                        Text("身幅")
                                            .position(x: (sizeW / 1.23) / 4, y: ((bsizeH / 2) / 5) * 4)
                                        Text("\(String(format: "%.2f", item.sizeD))cm")
                                            .position(x: (sizeW / 1.23) - ((sizeW / 1.23) / 4), y: ((bsizeH / 2) / 5) * 4)
                                        
                                        
                                    } else if item.categoryName == "ボトム" {
                                        Text("股上")
                                            .position(x: (sizeW / 1.23) / 4, y: ((bsizeH / 2) / 4) * 1)
                                        Text("\(String(format: "%.2f", item.sizeA))cm")
                                            .position(x: (sizeW / 1.23) - ((sizeW / 1.23) / 4), y: ((bsizeH / 2) / 4) * 1)
                                        Text("股下")
                                            .position(x: (sizeW / 1.23) / 4, y: ((bsizeH / 2) / 4) * 2)
                                        Text("\(String(format: "%.2f", item.sizeB))cm")
                                            .position(x: (sizeW / 1.23) - ((sizeW / 1.23) / 4), y: ((bsizeH / 2) / 4) * 2)
                                        
                                        Text("パンツ丈")
                                            .position(x: (sizeW / 1.23) / 4, y: ((bsizeH / 2) / 4) * 3)
                                        Text("\(String(format: "%.2f", item.sizeC))cm")
                                            .position(x: (sizeW / 1.23) - ((sizeW / 1.23) / 4), y: ((bsizeH / 2) / 4) * 3)
                                        
                                    } else {
                                        
                                        Text("縦")
                                            .position(x: (sizeW / 1.23) / 4, y: ((bsizeH / 2) / 3) * 1)
                                        Text("\(String(format: "%.2f", item.sizeA))cm")
                                            .position(x: (sizeW / 1.23) - ((sizeW / 1.23) / 4), y: ((bsizeH / 2) / 3) * 1)
                                        Text("横")
                                            .position(x: (sizeW / 1.23) / 4, y: ((bsizeH / 2) / 3) * 2)
                                        Text("\(String(format: "%.2f", item.sizeB))cm")
                                            .position(x: (sizeW / 1.23) - ((sizeW / 1.23) / 4), y: ((bsizeH / 2) / 3) * 2)
                                    }
                                    
                                }
                                .font(.title)
                                .frame(width: sizeW / 1.23, height: bsizeH / 2)
                                .background(.white)
                                .cornerRadius(10)
                                .position(x: sizeW / 2, y: geometry.size.height / 1.5)
                                : nil
                            }
                        }
                        .frame(width: (item.isOnMain ? bsizeW : sizeW),
                               height: (item.isOnMain ? bsizeH : sizeH))
                        .background(.gray.opacity(0.2))
                        .cornerRadius(10)
                        .animation(.default)
                        .foregroundColor(.black.opacity(0.8))
                        
                    }
                    Rectangle()
                        .foregroundColor(.white)
                        .background(.white)
                        .frame(width: geometry.size.width, height: sizeH * 2)
                }
                .frame(width: geometry.size.width)
                
            }
        }
    }
}

struct ClothingDataView_Previews: PreviewProvider {
    static var previews: some View {
        ClothingDataView(select: .constant(""),
                         item: clothesData(clothesDB: ClothesDB()),
                         items: ItemMock.itemMock,
                         isAll: .constant(true),
                         isTops: .constant(false),
                         isOuter: .constant(false),
                         isBottoms: .constant(false),
                         isBag: .constant(false),
                         isWrite: .constant(false),
                         selectCategory: .constant("全て"),
                         word: .constant(""))
    }
}


/**
 ZStack{
 rectangleFrame
 .foregroundColor(.gray.opacity(0.2))
 .cornerRadius(10)
 .frame(width: (isOpen ? bsizeW : sizeW), height: (isOpen ? bsizeH : sizeH))
 .position(x: (isOpen ? geometry.size.width / 2 : geometry.size.width / 2),
 y: (isOpen ? (geometry.size.height / 2) + (bsizeH - sizeH) / 2 : geometry.size.height / 2))
 Button {
 if isOpen { isOpen = false }
 else { isOpen = true }
 } label: {
 isOpen ? Image(systemName: "chevron.up") : Image(systemName: "chevron.down")
 }
 .foregroundColor(.black.opacity(0.7))
 .position(x: sizeW - 20 , y: geometry.size.height / 2)
 
 HStack{
 Circle()
 .frame(width: 70, height: 70)
 .offset(x: (geometry.size.width - sizeW) / 2 + 50 - ((geometry.size.width) / 2))
 }
 .position(x: geometry.size.width / 2 , y: geometry.size.height / 2)
 
 VStack{
 Text(brandName)
 .font(.body)
 .fontWeight(.regular)
 Text(itemName)
 .font(.title)
 .fontWeight(.medium)
 Text(categoryName)
 .font(.caption)
 .fontWeight(.regular)
 }.position(x: geometry.size.width / 2 + 30 , y: geometry.size.height / 2)
 
 }
 .frame(width: geometry.size.width, height: geometry.size.height)
 .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
 .ignoresSafeArea(.all)
 }
 */