//
//  StateManager.swift
//  Meta
//
//  Created by david-swift on 21.06.24.
//

import Foundation

/// This type manages view updates.
public class StateManager {

    /// Whether to block updates in general.
    var blockUpdates = false
    /// The functions handling view updates.
    var updateHandlers: [(Bool) -> Void] = []

    /// Update all of the views.
    /// - Parameter force: Whether to force all views to update.
    public func updateViews(force: Bool = false) {
        if !blockUpdates {
            for handler in updateHandlers {
                handler(force)
            }
        }
    }

    /// Change properties without updating the view.
    /// - Parameter action: The action that changes properties.
    public func withBlockedUpdates(action: () -> Void) {
        blockUpdates = true
        action()
        blockUpdates = false
    }

    /// Add a handler that is called when the user interface should update.
    /// - Parameter handler: The handler. The parameter defines whether the whole UI should be force updated.
    public func addUpdateHandler(handler: @escaping (Bool) -> Void) {
        updateHandlers.append(handler)
    }

}
