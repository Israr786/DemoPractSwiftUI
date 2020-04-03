//
//  ContentView.swift
//  DemoPractSwiftUI
//
//  Created by Israrul on 4/1/20.
//  Copyright © 2020 Israrul Haque. All rights reserved.
//

import SwiftUI
import Combine

struct User: Codable, Hashable {
    var id: Int
    var avatar_url: String
    var url: String
    var login: String
    var repos_url: String
}

class NetworkManager: ObservableObject {
    var objectWillChange = PassthroughSubject<NetworkManager, Never>()
    
    var users = [User]() {
        didSet {
            objectWillChange.send(self)
        }
    }
    init() {
        let urlString = "https://api.github.com/users?since=135"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            let users = try? decoder.decode([User].self, from: data)
            DispatchQueue.main.async {
                 self.users = users ?? []
            }
        }.resume()
    }
}

struct URLImage: View {
    
    @ObservedObject private var imageLoader = ImageLoader()
    
    var placeholder: Image
    
    init(url: String, placeholder: Image = Image(systemName: "photo")) {
        self.placeholder = placeholder
        self.imageLoader.load(url: url)
    }
    
    var body: some View {
        if let uiImage = self.imageLoader.downloadedImage {
            return Image(uiImage: uiImage)
        } else {
            return placeholder
        }
    }
    
}


struct ContentView: View {
    
    @ObservedObject var networkManager = NetworkManager()
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                List {
                    ForEach(networkManager.users.filter({ (user) -> Bool in
                        searchText.isEmpty ? true : user.login.localizedCaseInsensitiveContains(searchText)
                    }), id: \.id) { user in
                        NavigationLink(destination:
                        UserDetail(user: user, networkManager: self.networkManager)){
                        UserRowView(user: user)
                        }
                    }
                }
            }.navigationBarTitle(Text("GitHub Searcher"))
        }
    }
}

struct UserRowView: View {
    let user: User
    var body: some View {
        HStack {
            URLImage(url: user.avatar_url)
                .frame(width: 100, height: 80)
                .padding(.leading, 10)
                .clipped()
                .cornerRadius(10)
            Text(user.login)
            Spacer()
            Text(String("Repo:\(user.id)"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class ImageLoader: ObservableObject {
    
    var downloadedImage: UIImage?
    let objectWillChange = PassthroughSubject<ImageLoader?, Never>()
    
    func load(url: String) {
        
        guard let imageURL = URL(string: url) else {
            fatalError("ImageURL is not correct!")
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                     self.objectWillChange.send(nil)
                }
                return
            }
            
            self.downloadedImage = UIImage(data: data)
            DispatchQueue.main.async {
                self.objectWillChange.send(self)
            }
            
        }.resume()
    }
}
