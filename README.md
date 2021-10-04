<!-- PROJECT SHIELDS -->
[![Maintainability](https://api.codeclimate.com/v1/badges/e0950b6a90920b096e60/maintainability)](https://codeclimate.com/github/lucaslimapoa/SwiftRedux/maintainability)

<!-- ABOUT THE PROJECT -->
# SwiftRedux

SwiftRedux is a Swift implementation of the Redux state container. It relies on the same concepts and provides familiar Hooks through property wrappers.

<!-- INSTALLATION -->
# Installation

SwiftRedux doesn't contain any external dependencies.

The only supported installation option is through Swift Package Manager:

## Swift Package Manager

If you use Swift Package Manager, simply add `SwiftRedux` as a dependency of your package in `Package.swift`:

```swift
.package(url: "https://github.com/lucaslimapoa/SwiftRedux.git", from: "0.2.0")
```

## Prerequisites

SwiftRedux relies on SwiftUI and Combine, so iOS 13 or later is required for it to work.

<!-- USAGE EXAMPLES -->
## Usage

With SwiftRedux, the state of the app is kept inside a `Store` object. The `Store` is responsible for managing the state, updating the state through the use of reducers and handling logic, which can be handled my a middleware, for instance.

For starters, let's create a simple Counter app. 

First, define a state for our app.

```swift
struct AppState: Equatable {
  var counter = 0
}
```

The `AppState` will hold the state for the whole app. Since this is a simple Counter app, the state will contain a simple `count` field.
Now, we need a way to update the state. With SwiftRedux, the state can only be updated from Reducers. 
Reducers are objects that receive a dispatched action and the current state, the state is then updated based on the received action.
Action are directly dispatched to the Store.

Let's create actions increasing and decreasing the counter now, so that our reducer can use it:

```swift
enum CounterAction {
  case increase
  case decrease
}
```

Now the reducer for the handling such actions can be created:

```swift
struct AppReducer: Reducer {
    func reduce(state: inout AppState, action: CounterAction) {
        switch action {
        case .increase:
            state.counter += 1
        case .decrease:
            state.counter -= 1
        }
    }
}
```

*It's important to notice that the Reducer is sync, no async actions should be created or dispatched in the reducers.*

Now that we have the `AppState`, `CounterAction` and `AppReducer` we can proceed and create a store:

```swift
let store = Store(
  initialState: AppState(),
  reducer: AppReducer()
)
```

Now all we have to do is to pass our store to the initial SwiftUI view, so the store can be put in the SwiftUI Environment and the Hooks (property wrappers) can be used.

```swift
ContentView()
  .store(store)
```

SwiftRedux provides a few Hooks so that the Store can be accessed. `@Dispatch` and `@SelectState`.
The SwiftUI view would then look like this:

```swift
struct ContentView: View {
    @Dispatch<CounterAction> private var dispatch
    @SelectState(\AppState.counter) private var counter

    var body: some View {
        VStack {
            Stepper("Number of products", onIncrement: {
                dispatch(action: .increase)
            }, onDecrement: {
                dispatch(action: .decrease)
            })

            Text("The number of products is \(counter)")
        }
    }
}
```

Every time an action is dispatched and the state changes, the SwiftUI view will be updated and the counter property will have the new value from the store.

## Advanced Usage

For looking into more advanced usage, please refer to the [MovieDB-SwiftRedux](https://github.com/lucaslimapoa/MovieDB-SwiftRedux) app. 
