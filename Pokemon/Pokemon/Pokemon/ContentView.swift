//
//  ContentView.swift
//  Pokemon
//
//  Created by Diogo Lopes Mendes on 21/01/2022.
//

import SwiftUI
import Foundation

extension UIImage{
    static var defImg:UIImage{
        UIImage(named: "noIMG")!
    }
}


struct pokemonModel: Identifiable{
    var id = UUID()
    
    var tipo:String
    var nome:String
    var nickName:String
    var img:UIImage

    var atk:Int = Int.random(in: 50..<70)
    var def:Int = Int.random(in: 40..<50)
    var xp:Float = 0
    
    init(tipo:String, nome:String,nickName:String , img:String){
        self.tipo = tipo
        self.nome = nome
        self.nickName = nickName
        self.img = UIImage(named: img) ?? UIImage.defImg
    }
}

class PokemonViewModel: ObservableObject{
    @Published var pokemonArray: [pokemonModel] =
[pokemonModel(tipo: "Eletrico",nome: "Pikachu",nickName: "Joao", img: "pikachu"),
pokemonModel(tipo: "Fogo",nome: "Balbasaur",nickName: "balbasaur", img: "balbasaur"),
pokemonModel(tipo: "Água",nome: "Squirtle",nickName: "Joaos", img: "Squirtle")]
    @Published var isLoading: Bool = false
    init(){
        getPokemons()
    }

    func getPokemons(){
        //let pokemon1 = pokemonModel(tipo: "Eletrico",nome: "Pikachu",nickName: "Joao", img: "pikachu")
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
        
          //  self.pokemonArray.append(pokemon1)
            self.isLoading = false
        }
    }
    
    func deletePokemons(index: IndexSet){
        pokemonArray.remove(atOffsets: index)
    }
}

struct InserirPokemon: View{
    @ObservedObject var pokemonViewModel: PokemonViewModel = PokemonViewModel()
    var body: some View{
        Button("Add", action: {
            pokemonViewModel.pokemonArray.append(pokemonModel(tipo: "Eletrico",nome: "Pikachu",nickName: "Joao", img: "pikachu"))
        })
        
    }
}

struct PokeDex: View{
    @ObservedObject var pokemonViewModel: PokemonViewModel = PokemonViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View{
            List {
                
                if pokemonViewModel.isLoading {
                    ProgressView()
                }else{
                
                ForEach(pokemonViewModel.pokemonArray){ pokemon in
                    HStack{
                        NavigationLink(destination: RandomScreen(pokemon: pokemon)){
                                Image(uiImage: pokemon.img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                
                                VStack{
                                    Text(pokemon.nome)
                                    Text(pokemon.nickName)
                            }
                            VStack{
                                Text(pokemon.tipo)
                            }
                        }
                    }
                }
                .onDelete(perform: pokemonViewModel.deletePokemons)
                }
            }.listStyle(GroupedListStyle())
                .navigationTitle("Pokémons")
                .onAppear{
                    pokemonViewModel.getPokemons()
                }
                
        Button("Adicionar Pokémon", action: {
            let randomInt = Int.random(in: 1..<6)
            switch randomInt{
            case 1: pokemonViewModel.pokemonArray.append(pokemonModel(tipo: "Fogo",nome: "Balbasaur",nickName: "balbasaur", img: "balbasaur"))
            case 2: pokemonViewModel.pokemonArray.append(pokemonModel(tipo: "Água",nome: "Squirtle",nickName: "Joaos", img: "Squirtle"))
            case 3: pokemonViewModel.pokemonArray.append(pokemonModel(tipo: "Normal",nome: "Eevee",nickName: "Joaos", img: "Eevee"))
            case 4: pokemonViewModel.pokemonArray.append(pokemonModel(tipo: "Fogo",nome: "charizard",nickName: "Joaos", img: "charizard"))
            case 5: pokemonViewModel.pokemonArray.append(pokemonModel(tipo: "Elétrico",nome: "Jolteon",nickName: "Joaos", img: "Jolteon"))
            default:
                pokemonViewModel.pokemonArray.append(pokemonModel(tipo: "Eletrisco",nome: "Jolteon",nickName: "Joaos", img: "Jolteon"))
            }
            
        }).frame(width: 200)
            .buttonStyle(.bordered)
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        
            .navigationBarBackButtonHidden(true)
        
    }
}

struct ContentView: View {
    @State var progressao:Int = 0
    @State private var texto: String = ""
    var body: some View {
        NavigationView{
        ZStack{
            Image("forest")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack{
                ProgressView(value: Float(progressao), total: 100.0)
                {
                   Text("Para evoluir:")
                        .font(.footnote)
               }
                TextField(
                    "Insira o seu nome",
                    text: $texto
                )
                NavigationLink(destination: PokeDex()){
                    Text("Começar")
                }.frame(width: 150)
                .buttonStyle(.bordered)
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        }
    }

}

struct RandomScreen: View{
    @State var pokemon: pokemonModel
    var body: some View{
        
         VStack{
             
             HStack{
                 Group{
                     Image(uiImage: pokemon.img)
                         .resizable()
                         .scaledToFit()
                         .frame(width: 200, height: 200)
                         .padding(.leading, 30)
                     VStack(alignment: .leading){
                         Group{
                         Text(pokemon.nome)
                         Text("Ataque: \(pokemon.atk)")
                         Text("Defesa: \(pokemon.def)")
                             ProgressView(value: Float(pokemon.xp), total: 100.0)
                             {
                                Text("Para evoluir:")
                                     .font(.footnote)
                            }
                                 .progressViewStyle(.linear)
                                 .frame(width: 100)
                         }
                         .padding(.bottom, 1)
                     }
                 }
                 Spacer()
                 
             }//HStack
             .frame(height: 200)
             
             Spacer()
             
             NavigationLink(destination: Batalha(pokemon: pokemon)){
                  Text("Treinar")
                }.frame(width: 150)
                .buttonStyle(.bordered)
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 20))
             
             Spacer()
             
         }
         .navigationTitle(self.pokemon.nome)

    }
}

struct Batalha: View{
    @State var pokemon: pokemonModel
    @State var enimigoVida:Float = 100
    @State var atacanteVida:Float = 100
    @State var enimigoDefesa:Float = 45
    @State var estaAnimado: Bool = false
    @State var voltarInicio: Bool = false
    @State private var showingDetail = false
    @State private var showThirdView = false
    @State private var showDetail = false
    @State private var showView = false
    @ObservedObject var pokemonViewModel: PokemonViewModel = PokemonViewModel()
    @State var length:Int = 0
    @State var random:Int = Int.random(in: 0..<3)
    @State var regenerar:Float = 0

    var body: some View{
        ZStack{
            Image("BattleBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack{
                
                Image(uiImage: pokemonViewModel.pokemonArray[random].img)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    
                ProgressView(value: enimigoVida, total: 100)
                {
                   Text("Vida:")
                        .font(.footnote)
               }
                    .progressViewStyle(.linear)
                    .frame(width: 100)
            }.padding(.leading, 90)
                .padding([.top], -250)
            
            Group{
                VStack{
                    Image(uiImage: pokemon.img)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding(.leading, -90)
                        .padding([.top], 100)
                        .offset(y: estaAnimado ? 0 : -130)
                        .offset(y: voltarInicio ? 0 : 130)
                    ProgressView(value: atacanteVida, total: 100.0)
                    {
                       Text("Vida:")
                            .font(.footnote)
                   }
                        .progressViewStyle(.linear)
                        .frame(width: 100)
                }

                VStack(alignment: .trailing){
                    HStack{
                        Button("Atacar", action: {
                                    
                            let bonus:Int = 1
                            
                            // if(pokemon.tipo == "Eletrico" and )
                            
                            enimigoVida -= (Float(pokemon.atk) - Float(pokemonViewModel.pokemonArray[random].def)) * Float(bonus)
                            atacanteVida -= (Float(pokemonViewModel.pokemonArray[random].atk) - Float(pokemon.def))
                            estaAnimado.toggle()
                            voltarInicio.toggle()
                            withAnimation(
                                Animation
                                    .default
                            ){
                                estaAnimado.toggle()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                withAnimation(
                                    Animation
                                        .default
                                ){
                                    voltarInicio.toggle()
                                }
                            }
                            if(enimigoVida <= 0) {
                                        showingDetail = true
                            }else if(atacanteVida <= 0){
                                showDetail = true
                            }
                        }).frame(width: 150)
                            .buttonStyle(.bordered)
                            .foregroundColor(.black)
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        Button("Regenerar", action: {
                            let regenerar:Float = Float.random(in: 10..<30)
                    // if(pokemon.tipo == "Eletrico" and )
                    
                    enimigoVida -= (Float(pokemon.atk) - Float(pokemonViewModel.pokemonArray[random].def)) - 10
                    atacanteVida -= (Float(pokemonViewModel.pokemonArray[random].atk) - Float(pokemon.def)) - Float(regenerar)
                    estaAnimado.toggle()
                    voltarInicio.toggle()
                    withAnimation(
                        Animation
                            .default
                    ){
                        estaAnimado.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        withAnimation(
                            Animation
                                .default
                        ){
                            voltarInicio.toggle()
                        }
                    }
                    if(enimigoVida <= 0) {
                                showingDetail = true
                    }else if(atacanteVida <= 0){
                        showDetail = true
                    }
                                
                            }).frame(width: 150)
                                .buttonStyle(.bordered)
                                .foregroundColor(.black)
                                .background(Color.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                    }.frame(maxHeight: .infinity, alignment: .bottom)
                        .padding([.bottom], 50)
                    
                }
            }

        }
        .fullScreenCover(isPresented: $showingDetail, content: {
            Ganhou(showNext: $showThirdView)
        })
        .fullScreenCover(isPresented: $showDetail, content: {
            Perdeu(showNext: $showView)
        })
        .background(
                      NavigationLink(destination: PokeDex(), isActive: $showThirdView) {
                            EmptyView()
                      }
                )
        .background(
                      NavigationLink(destination: PokeDex(), isActive: $showView) {
                            EmptyView()
                      }
                )
        
    }
}
struct Ganhou: View{
    @Environment(\.presentationMode) var presentationMode
    @Binding var showNext: Bool
    var body: some View{
        ZStack{
            VStack{
                Text("Parabéns!!").font(.largeTitle)
                    .lineSpacing(50)
                    .frame(width: 300)
                Text("Derrotou o inímigo!").font(.title)
                    .lineSpacing(50)
                    .frame(width: 300)
                
                Button("Voltar") {
                            self.presentationMode.wrappedValue.dismiss()
                            
            }.frame(width: 150)
                    .buttonStyle(.bordered)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}
}
struct Perdeu: View{
    @Environment(\.presentationMode) var presentationMode
    @Binding var showNext: Bool
    var body: some View{
        ZStack{
            VStack{
                Text("Perdeu!").font(.largeTitle)
                    .lineSpacing(50)
                    .frame(width: 300)
                Text("Tente mais tarde!").font(.title)
                    .lineSpacing(50)
                    .frame(width: 300)
                
                Button("Voltar") {
                            self.presentationMode.wrappedValue.dismiss()
                            
            }.frame(width: 150)
                    .buttonStyle(.bordered)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
