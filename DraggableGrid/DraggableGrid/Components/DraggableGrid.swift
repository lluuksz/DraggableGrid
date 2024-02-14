//
//  DraggableGrid.swift
//  DraggableGrid
//
//  Created by Łukasz Łuczak on 16/01/2024.
//

import SwiftUI
import Combine

class DraggableGridModel<Element: ElementType>: ObservableObject {
    
    struct IdIdentifable: Identifiable {
        let id: Element.ID
    }
    
    @Published private(set) var elements: [Element] = []
    @Published private(set) var backgroundElementIds: [IdIdentifable] = []
    
    private var locations: [Element.ID:CGRect] = [:]
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        $elements.sink { value in
            self.backgroundElementIds = value.map({ IdIdentifable(id: $0.id) })
        }.store(in: &cancellable)
    }
    
    func setElement(elements: [Element]) {
        self.elements = elements
    }
    
    func saveOriginalPosition(id: Element.ID, rect: CGRect) {
        if locations[id] == nil {
            locations[id] = rect
            print("original location: \(rect)")
        }
    }
    
    func getOriginalPosition(for element: Element) -> CGRect? {
        locations[element.id]
    }
    
    func sort(element: Element, using location: CGPoint) {
        print(location)
        
        guard let newLocation = locations.first(where: {
            abs($0.value.midX - location.x) < 15 && abs($0.value.midY - location.y) < 15
        }) else { return }
        
        guard newLocation.key != element.id else { return }

        print("\(newLocation.key): \(newLocation.value)")
        
        
    }
}

struct DraggableGrid<Content: View, DraggingContent: View, Placeholder: View, Element: ElementType>: View where Element.ID == String {
    @State private var draggingElement: Element?
    @State private var offset: CGSize = .zero
    @ObservedObject private var model: DraggableGridModel<Element>
    
    private let columns: Int
    private let columnSpacing: CGFloat
    private let rowSpacing: CGFloat
    private let content: (Element) -> Content
    private let draggingContent: (Element) -> DraggingContent
    private let placeholder: () -> Placeholder
    
    init(
        columns: Int,
        columnSpacing: CGFloat,
        rowSpacing: CGFloat,
        model: DraggableGridModel<Element>,
        @ViewBuilder content: @escaping (Element) -> Content,
        @ViewBuilder draggingContent: @escaping (Element) -> DraggingContent,
        @ViewBuilder placeholder: @escaping () -> Placeholder) {
            
            self.columns = columns
            self.rowSpacing = rowSpacing
            self.columnSpacing = columnSpacing
            self.model = model
            self.content = content
            self.draggingContent = draggingContent
            self.placeholder = placeholder
    }
    
    var body: some View {
        ZStack {
            Grid(columns: columns, columnSpacing: columnSpacing, rowSpacing: rowSpacing, list: model.backgroundElementIds) { id in
                if let element = model.elements.first(where: { $0.id == id.id }) {
                    if id.id == draggingElement?.id {
                        placeholder()
                    } else {
                        content(element)
                    }
                } else {
                    EmptyView()
                }
            }
            
            Grid(columns: columns, columnSpacing: columnSpacing, rowSpacing: rowSpacing, list: model.elements) { element in
                DraggableElement(draggingElement: $draggingElement, element: element) {
                    draggingContent(element)
                }
                .overlay(
                    GeometryReader { proxy -> Color in
                        model.saveOriginalPosition(id: element.id, rect: proxy.frame(in: .named("grid")))
                        
                        return Color.clear
                    }
                )

            }
        }
        .coordinateSpace(name: "grid")
        .environmentObject(model)
    }
}

struct DraggableElement<Content: View, Element: ElementType>: View {
    @State private var offset: CGSize = .zero
    @State private var active: Bool = false
    @Binding var draggingElement: Element?
    
    @EnvironmentObject var model: DraggableGridModel<Element>
    
    let element: Element
    let content: () -> Content
    
    var body: some View {
        ZStack {
            content()
                .opacity(draggingElement?.id == element.id || active ? 1 : 0)
        }
        .contentShape(Rectangle())
        .offset(offset)
        .gesture(dragGesture())
        .onLongPressGesture(perform: { }) { value in
            active = value
        }
    }
    
    private func dragGesture() -> some Gesture {
        let longPressGesture = LongPressGesture()
            .onChanged { value in
                draggingElement = nil
            }
        
        let dragGesture = DragGesture(minimumDistance: 0, coordinateSpace: .named("grid"))
            .onChanged { value in
                draggingElement = element
                offset = value.translation
                
                if let originalLocation = model.getOriginalPosition(for: element) {
                    let midX = originalLocation.midX - value.translation.width
                    let midY = originalLocation.midY - value.translation.height
                    let point = CGPoint(x: midX, y: midY)
                    
                    model.sort(element: element, using: point)
                }
                
                
            }
            .onEnded { value in
                withAnimation {
                    draggingElement = nil
                    offset = .zero
                }

            }
        
        return longPressGesture.sequenced(before: dragGesture)
    }
}

#Preview {
    struct PreviewElement: Hashable & Identifiable {
        let id = UUID().uuidString
        let text: String
    }
    
    let list: [PreviewElement] = [
        PreviewElement(text: "Element 1"),
        PreviewElement(text: "Element 2"),
        PreviewElement(text: "Element 3"),
        PreviewElement(text: "Element 4")
    ]
    
    var model = DraggableGridModel<PreviewElement>()
    
    return DraggableGrid(columns: 3, columnSpacing: 8, rowSpacing: 8, model: model, content: { element in
        VStack(spacing: 8) {
            Image(systemName: "star")
            Text(element.text)
        }
        .padding()
        .border(Color.black)
    }, draggingContent: { (element) in
        VStack(spacing: 8) {
            Image(systemName: "star")
            Text(element.text)
        }
        .padding()
        .background(Color.red)
        .border(Color.black)
    }, placeholder: {
        VStack(spacing: 8) {

        }
        .padding()
        .border(Color.green)
    })
}
