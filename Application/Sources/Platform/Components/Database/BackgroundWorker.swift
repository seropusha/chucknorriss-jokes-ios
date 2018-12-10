//
//  BackgroundWorker.swift
//  Application
//
//  Created by Sergey Navka on 12/6/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

final class BackgroundWorker: NSObject {
    typealias Action = () -> Void
    struct Task {
        let action: Action
        let disposable: Disposable
    }
    
    private let thread: Thread
    
    deinit {
        stop()
    }
    
    init(name: String? = nil) {
        self.thread = Thread {
            let runloop = RunLoop.current
            runloop.add(NSMachPort(), forMode: .defaultRunLoopMode)
            while !Thread.current.isCancelled {
                runloop.run(mode: .defaultRunLoopMode, before: Date.distantFuture)
            }
        }
        super.init()
        self.thread.name = name
        self.thread.start()
    }
    
    public func stop() {
        thread.cancel()
    }
    
    public func perform(action: @escaping Action) {
        let disposable = AnyDisposable()
        let task = Task(action: action, disposable: disposable)
        if Thread.current == thread {
            action()
        } else {
            perform(#selector(runAction(_:)), on: thread, with: task, waitUntilDone: false)
        }
    }
    
    public func perform(after delay: TimeInterval, action: @escaping Action) -> Disposable {
        let disposable = AnyDisposable()
        perform {
            guard !disposable.isDisposed else { return }
            let task = Task(action: action, disposable: disposable)
            self.perform(#selector(self.runAction(_:)), with: task, afterDelay: delay)
        }
        return disposable
    }
    
    // MARK: - Private
    @objc private func runAction(_ task: Any?) {
        guard let task = task as? Task, !task.disposable.isDisposed else { return }
        task.action()
    }
}

extension BackgroundWorker: DateScheduler {
    var currentDate: Date { return Date() }
    
    func schedule(after date: Date, action: @escaping () -> Void) -> Disposable? {
        let delay = max(0, date.timeIntervalSince(currentDate))
        return perform(after: delay, action: action)
    }
    
    func schedule(after date: Date, interval: DispatchTimeInterval,
                  leeway: DispatchTimeInterval,
                  action: @escaping () -> Void) -> Disposable? {
        let delay = max(0, date.timeIntervalSince(currentDate)) + interval.timeInterval
        return perform(after: delay, action: action)
    }
    
    func schedule(_ action: @escaping () -> Void) -> Disposable? {
        perform(action: action)
        return nil
    }
}



extension DispatchTimeInterval {
    public var timeInterval: TimeInterval {
        switch self {
        case .seconds(let value): return TimeInterval(value)
        case .milliseconds(let value): return TimeInterval(value) / 1_000
        case .microseconds(let value): return TimeInterval(value) / 1_000_000
        case .nanoseconds(let value): return TimeInterval(value) / 1_000_000_000
        case .never: return .infinity
        }
    }
}

