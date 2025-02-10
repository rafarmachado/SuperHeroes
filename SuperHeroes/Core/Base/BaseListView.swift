//
//  BaseListView.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 08/02/25.
//

import UIKit

/// A reusable base view for list-based screens, providing a table view, loading indicator,
/// empty state message, and error handling.
class BaseListView: UIView {
    
    /// The main table view used to display content.
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset = .zero
        tableView.rowHeight = 80
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    /// A label that appears when there are no items to display.
    let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// A label used to display error messages when data loading fails.
    let errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// An overlay view that appears when loading is in progress.
    let loadingOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A loading indicator displayed during data fetching.
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    /// Initializes the view with a custom empty state message.
    /// - Parameter emptyMessage: The message to display when the list is empty.
    init(emptyMessage: String) {
        super.init(frame: .zero)
        self.emptyStateLabel.text = emptyMessage
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configures the user interface elements.
    private func setupUI() {
        backgroundColor = .systemBackground
        addSubview(tableView)
        addSubview(emptyStateLabel)
        addSubview(errorLabel)
        addSubview(loadingIndicator)
        addSubview(loadingOverlay)
        setupConstraints()
    }
    
    /// Configures the layout constraints for UI elements.
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyStateLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.9),
            
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.9),
            
            loadingOverlay.topAnchor.constraint(equalTo: topAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    /// Controls the visibility of the loading indicator.
    /// - Parameter isLoading: A boolean indicating whether to show or hide the loading state.
    func showLoading(_ isLoading: Bool) {
        loadingOverlay.isHidden = !isLoading
        isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        emptyStateLabel.isHidden = true
        errorLabel.isHidden = true
    }
    
    /// Displays or hides the empty state label.
    /// - Parameter isEmpty: A boolean indicating whether the list is empty.
    func showEmptyState(_ isEmpty: Bool) {
        emptyStateLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        errorLabel.isHidden = true
    }
    
    /// Displays an error message and hides the table view.
    /// - Parameter message: The error message to display.
    func showError(_ message: String?) {
        errorLabel.text = message
        errorLabel.isHidden = (message == nil)
        emptyStateLabel.isHidden = true
        tableView.isHidden = message != nil
    }
}
