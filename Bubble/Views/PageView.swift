//
//  PageView.swift
//  Localist
//
//  Created by Steven Tran on 11/9/20.
//  Copyright © 2020 Localist. All rights reserved.
//

import SwiftUI
import SlideOverCard
import Combine

struct PageView: View {
    @State private var selectedTab = 0
    @State private var categories = ["Deals", "Happy Hour", "Recreation", "What's Happening?", "Misc"]
    
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var categoryGlobal: Category
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    let minDragTranslationForSwipe: CGFloat = 50
    let numTabs = 5
    
    var handler: Binding<Int> { Binding(
        get: { self.selectedTab },
        set: {
            self.selectedTab = $0
            categoryGlobal.setCategory(category: categories[selectedTab])
            categoryGlobal.refreshCategory(category: categories[selectedTab])
        }
    )}
    
    var body: some View {
        TabView(selection: handler) {
            ForEach(0 ..< categoryGlobal.categories.count) { i in
                    if #available(iOS 14.0, *) {
                        
                        FeedView(category: self.$categories[i])
                            .tabItem {
                                selectedTab == i ? Image(categoryGlobal.selected_cat_names1[i]).resizable().padding() : Image(categoryGlobal.cat_names1[i]).resizable().padding()
                            }
                            .tag(i)
                            .highPriorityGesture(DragGesture().onEnded({ self.handleSwipe(translation: $0.translation.width)}))
                            .animation(.default)
                            .environmentObject(userAuth)
                            .environmentObject(locationViewModel)
                            .environmentObject(categoryGlobal)
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    
                }
        }
        .accentColor(Color.white)
        .onAppear(perform: self.locationViewModel.retriveCurrentLocation)

    }
    private func handleSwipe(translation: CGFloat) {
        if translation > minDragTranslationForSwipe && selectedTab > 0 {
            selectedTab -= 1
            categoryGlobal.setCategory(category: categories[selectedTab])
        } else  if translation < -minDragTranslationForSwipe && selectedTab < numTabs-1 {
            selectedTab += 1
            categoryGlobal.setCategory(category: categories[selectedTab])
        }
    }
}


