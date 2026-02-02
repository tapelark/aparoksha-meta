//
//  SafeWrapper.swift
//  Meta
//
//  Created by david-swift on 02.02.26.
//

/// Wrap a widget but keep its pointer.
struct SafeWrapper: ConvenienceWidget {

    /// The custom code to edit the wrapper.
    /// The pointer is the one of the child widget.
    var modify: (ViewStorage, WidgetData, Bool) -> Void
    /// The wrapped view.
    var content: AnyView

    /// The view storage.
    /// - Parameters:
    ///     - data: Modify views before being updated.
    ///     - type: The view render data type.
    /// - Returns: The view storage.
    func container<Data>(
        data: WidgetData,
        type: Data.Type
    ) -> ViewStorage where Data: ViewRenderData {
        let contentStorage = content.storage(data: data, type: type)
        let storage = ViewStorage(contentStorage.pointer, content: [.mainContent: [contentStorage]])
        modify(storage, data, true)
        return storage
    }

    /// Update the stored content.
    /// - Parameters:
    ///     - storage: The storage to update.
    ///     - data: Modify views before being updated
    ///     - updateProperties: Whether to update the view's properties.
    ///     - type: The view render data type.
    func update<Data>(
        _ storage: ViewStorage,
        data: WidgetData,
        updateProperties: Bool,
        type: Data.Type
    ) where Data: ViewRenderData {
        if let contentStorage = storage.content[.mainContent]?.first {
            content.updateStorage(contentStorage, data: data, updateProperties: updateProperties, type: type)
        }
        modify(storage, data, updateProperties)
    }

}

/// Extend any view.
extension AnyView {

    /// Wrap a widget but keep its pointer.
    /// - Parameter modify: Modify the storage. The boolean indicates whether state in parent views changed.
    /// - Returns: A view.
    public func wrap(_ modify: @escaping (ViewStorage, WidgetData, Bool) -> Void) -> AnyView {
        SafeWrapper(modify: modify, content: self)
    }

    /// Wrap a widget but keep its pointer.
    /// - Parameter modify: Modify the storage. The boolean indicates whether state in parent views changed.
    /// - Returns: A view.
    public func wrap(_ modify: @escaping (ViewStorage, Bool) -> Void) -> AnyView {
        wrap { storage, _, updateProperties in modify(storage, updateProperties) }
    }

}
