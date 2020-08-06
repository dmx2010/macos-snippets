//
//  Sidebar.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI
import Combine

struct Sidebar: View {
  
  @ObservedObject var viewModel: SideBarViewModel
  
  var body: some View {
    VStack(alignment: .leading) {
      List() {
        
        addElementView
        
        logo
        
        favorites
        
        local
        
        //tags
      }
      .removeBackground()
      .padding(.top, 16)
      .background(Color.clear)
      
      HStack {
        Spacer()
        
        ImageButton(imageName: "ic_settings", action: viewModel.openSettings)
      }
      .padding()
    }
    .background(Color.clear)
    .listRowBackground(Color.PURPLE_500)
      //.listStyle(SidebarListStyle())
      .environment(\.defaultMinListRowHeight, 36)
  }
  
  var addElementView: some View {
    HStack{
      Spacer()
      MenuButton("+") {
        Button(action: {self.viewModel.addNewSnippet(id: nil)}) {
          Text("New snippet")
            .font(.system(size: 14))
        }
        Button(action: {self.viewModel.addNewFolder(id: nil)}) {
          Text("New folder")
            .font(.system(size: 14))
        }
      }.menuButtonStyle(BorderlessButtonMenuButtonStyle())
        .font(.system(size: 22))
        .background(Color.clear)
        .frame(maxWidth: 16, alignment: .center)
    }.background(Color.clear)
  }
  
  var logo: some View {
    HStack(alignment: .center) {
      Spacer()
      Image("snip")
        .resizable()
        .frame(width: 30, height: 30, alignment: .center)
      Spacer()
    }
    .padding(.top, 16)
    .padding(.bottom, 16)
  }
  
  @ViewBuilder
  var favorites: some View {
    Text("Favorites")
      .font(Font.custom("AppleSDGothicNeo-UltraLight", size: 13.0))
      .padding(.bottom, 3)
    
    /*SnipItemsList(snipItems: $settings.snips, //SnipItem.getAllFavorites(settings.snips)
     onMove: viewModel.onMove,
     onActionTrigger: viewModel.onActionTrigger(action:))*/
  }
  
  @ViewBuilder
  var local: some View {
    Text("Local")
      .font(Font.custom("AppleSDGothicNeo-UltraLight", size: 13.0))
      .padding(.bottom, 3)
      .padding(.top, 16)
    
    SnipItemsList(model: SnipItemsListModel(),
                  onMove: viewModel.onMove,
                  onActionTrigger: viewModel.onActionTrigger(action:))
    .environmentObject(viewModel.snippetsStore)
  }
  
  /*@ViewBuilder
   var tags: some View {
   Text("Tags")
   .font(Font.custom("AppleSDGothicNeo-UltraLight", size: 11.0))
   .padding(.bottom, 3)
   .padding(.top, 16)
   
   NavigationLink(destination: CodeViewer()) {
   Text("Hello")
   .frame(maxWidth: .infinity, alignment: .leading)
   .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
   }
   .listRowBackground(Color.PURPLE_500)
   }*/
  
}


final class SideBarViewModel: ObservableObject {
  
  @ObservedObject var snippetsStore = SnippetStore(snippets: SnippetFileManager.shared.getSnippets())
  
  private var stores = Set<AnyCancellable>()
  
  init() {
    snippetsStore.objectWillChange.sink { (_) in
      print("SideBar objectWillChange")
    }
  .store(in: &stores)
  }
  
  func addNewSnippet(id: String?) {
    print("New snippet")
  }
  
  func addNewFolder(id: String?) {
    print("New folder")
  }
  
  func rename(id: String) {
    print("Rename")
  }
  
  func delete(id: String) {
    print("Delete")
  }
  
  func openSettings() {
    print("settings")
  }
  
  func onMove(from: IndexSet, to: Int) {
    
  }
  
  func onActionTrigger(action: SnipItemsListAction) {
    switch action {
    case .addFolder(let id):
      self.addNewFolder(id: id)
    case .addSnippet(let id):
      self.addNewSnippet(id: id)
    case .rename(let id):
      self.rename(id: id)
    case .delete(let id):
      self.delete(id: id)
    }
  }
}


struct Sidebar_Previews: PreviewProvider {
  static var previews: some View {
    Sidebar(viewModel: SideBarViewModel())
  }
}
