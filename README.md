# CleanMeme 
## *A Clean Swift Architecture iOS Application*
This README serves as a walkthrough of the [Clean Swift](https://clean-swift.com/) iOS architecture pattern. The *Clean Swift* app called *CleanMeme* is referenced throughout the walkthrough as a means of showing how the aspects of *Clean Swift* work and come together in practice.

### Clean Swift TL;DR
*Clean Swift* extracts the business and presentation logic from the user interface code of iOS apps, decoupling application logic and thereby making it more testable and scalable. The decoupling process is achieved by incorporating what's known as a ViewController-Interactor-Presenter (VIP) cycle into every application use case / scene.

### Some Problems that Clean Swift Tackles
1. **Massive view controllers**
* **How:** abstracting code to different components
2. **Growing model size as a result of trying to decrease View Controller (VC) size**
* **How:** having Interactor and Presenter components that divide up this code growth
3. **Frequent regressions**
* **How:** maintaining abstracted components that can each be tested in isolation, which creates a higher potential for more comprehensive code coverage 
4. **Highly coupled dependency graphs (classes having unnecessary and by-directional references etc.) → reducing this coupling reduces risk of memory leaks due to circular references and unneeded references**
* **How:** highly enforced uni-directional dependencies and data flow between components via the VIP cycle. Values are weakly referenced if they loop back to create a circular reference.

### Strengths of Clean Swift
The strengths of *Clean Swift* will be evaluated on the basis of the following [non-functional requirements](https://www.scaledagileframework.com/nonfunctional-requirements/) which are common to a multitude of different types of software applications: **Maintainability**, **Testability**, and **Extensibility**.

1. **Maintainability:** Organizing code for the same use cases – or scenes – into the same folders (as opposed to typical MVC folder structure: Models, Views, ViewControllers)
* Allows for ease of finding all related code for specific application function
* Can put common code between use cases (i.e. shared classes, protocols) into a common folder
2. **Maintainability + Testability:** Reduces and decouples view controller code by use of the VIP, Worker, and Router components. Reduces dependency graph to uni-directional, three-element VIP cycle
3. **Maintainability + Extensibility:** Ease of swapping components of the VIP cycle due to dependence on protocols instead of classes
* No class reference to a component by another; protocol reference instead. Therefore, any component that conforms to the appropriate VIP protocol can be swapped out for the current component if necessary
4. **Extensibility + Testability:** Ease of extending app business logic by writing new Worker classes for Interactors instead of increasing the size of the Interactor classes. These separate Workers can then each be individually unit tested

### Weaknesses of Clean Swift
The afforementioned non-functional requirements will be used in the assessment of some of *Clean Swift*'s weaknesses as well.

1. **Maintainability:** Steeper learning curve than just plain MVC; maintainability will be more difficult for unfamiliar developers; initial folder structure can be daunting
2. **Maintainability:** More files in the project in general
3. **Maintainability + Extensibility:** Large degree of boilerplate code in general
4. **Extensibility:** More code needs to be written to handle simple tasks

## How is this pattern implemented?
The remainder of this document provides a more thorough explanation of the *Clean Swift* paradigm by walking through the implementation of a section of the *Clean Swift* app called *CleanMeme*.

### Introduction

The crux of **Clean Swift** is the concept of the **VIP cycle**. VIP stands for **View Controller**, **Interactor**, and **Presenter**. These are the *three major components that make up a scene*. A **scene** is a specific use case of the application, such as creating an order or showing a list of orders to a user.

The main idea of *Clean Swift* architecture is to have the application be comprised entirely of scenes that communicate between one-another. There is a scene for each specific application use case, and each scene has its own associated 3 VIP components that undergo VIP cycles. Below is an example of the structure of an Order app that’s been built using *Clean Swift* (this example is adapted from *The Clean Swift Handbook* by Raymond Law).

![Figure 1](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-1.png)

There are three scenes in this app, denoted in grey. there’s a scene for creating an order (*CreateOrder*), a scene for listing orders (*ListOrders*), and a scene for showing a specific order (*ShowOrder*). Each of these three scenes have the three associated VIP components, denoted in blue, and these VIP components undergo VIP cycles as denoted by the blue arrows. Finally, each scene has a **Router**, which is a *Clean Swift* component that handles routing. Routing encompases *navigating between scenes and passing data between them* as well. The scenes’ Routers, along with the routing they establish between scenes, is denoted in green.

For the remainder of this README, we will be following along with a *Clean Swift* sample app called *CleanMeme* which is located in this repository. This app allows users to add memes to a list, and to display a detail view of those memes once they are added. Structurally, this app follows the same graph depicted in the first figure.

Below is an example of the project structure for a *Clean Swift* project, being subdivided into the different scenes of the CleanMeme project in this case: *AddMeme*, *ListMemes*, and *ShowMeme*.

![Figure 2](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-2.png)

### The VIP Cycle

![Figure 3](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-3.png)

The VIP cycle shown in the above image (taken from *The Clean Swift Handbook* by Raymond Law) is an input-output loop: it controls the flow of information for any given app scene, starting with an initial input from a user, and ending with an output presented back to the user at the end of the cycle. *The VIP cycle always starts and ends at the View Controller.*

The following are the high-level functions of each of the three VIP Components:
* **ViewController:** gathers user input events (initiating the cycle) and sends them to the Interactor in the form of a **Request**; ultimately displays corresponding output events (terminating the cycle)
* **Interactor:** performs and delegates business logic on the Request, sends conditioned data to the Presenter in the form of a **Response**
* **Presenter:** transforms the Response data into a simple format that’s easy to display, packages the data up in a View Model, and sends the **View Model** to the View Controller to be used for display (terminating the cycle)

The Request, Response, and View Model data that gets passed around the VIP cycle are called **data models**. These are models that have a specific enum and nested struct format. The following are the contents of each of these models:
* **Request:** User input information (if any)
* **Response:** User input information (if any) that has been conditioned by business logic 
* **View Model:** Output information (if any) that’s in a simple, primitive format (i.e. ints or strings) that’s ready and easy to display to the user

Below is an example of the `AddMeme` model, which is the model that’s used in the *AddMeme* scene of the sample application.

![Figure 4](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-4.png)

In this case, the View Controller passes data to the Interactor in the form of `AddMeme.Request`, the Interactor passes data to the Presenter in the form of `AddMeme.Response`, and the Presenter passes data back to the View Controller in the form of `AddMeme.ViewModel`.

Protocols are used to establish the connection between the VIP components. *Every VIP component has its own associated protocol.* The protocol for a VIP component should be declared in the same file as that VIP component. These protocols take on the following naming conventions for each VIP component:
* View Controller: `<Scene>DisplayLogic`
* Interactor: `<Scene>BusinessLogic`
* Presenter: `<Scene>PresentationLogic`

For instance, in the case of the *AddMeme* scene, `AddMemeViewController`’s protocol would be `AddMemeDisplayLogic`, `AddMemeInteractor`’s protocol would be `AddMemeBusinessLogic`, and `AddMemePresenter`’s protocol would be `AddMemePresentationLogic`.

These protocols enforce the unidirectional flow of the data models between each of the VIP components by use of a protocol method. Below is the declaration of the `AddMemeInteractor` protocol:

![Figure 5](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-5.png)

*Think of these protocol methods as the one-way arrows connecting the VIP components.* The process is as follows:
1. A VIP component conforms to the protocol – i.e. `AddMemeInteractor: AddMemeBusinessLogic`
2. The preceding VIP component contains a member variable of the component from (1.), and calls the associated protocol method. *The member variable’s type is its associated protocol.* –  i.e. `var interactor: AddMemeBusinessLogic?` within `AddMemeViewController`.

By referencing VIP components by their associated protocol, the corresponding protocol method is the only thing that becomes visible, and all of the other properties of the referenced VIP component are abstracted away. This allows for an ease of swapping VIP components, since we only need the components to conform to their associated protocols to be properly used in a VIP cycle. 

Now let’s take a look at the specific VIP components.

### The View Controller

Consider the example of adding a meme to your list within *CleanMeme*.

![Figure 6](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-6.png)

Within any scene, the first thing we want to do in the View Controller is set up all of the VIP components and the router. This should be done in the constructor(s) of the View Controller. In our case, we have the following `setup()` helper method to handle this component wiring, and this method gets called in all the constructors in `AddMemeViewController`.

![Figure 7](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-7.png)

The user starts by entering information into a form. Once the information has been inputted, the Save button is clicked to initialize a VIP cycle to persist the meme in memory and show the meme in the user’s list of memes. This functionality is detailed within the `saveButtonTapped(_sender: Any)` function below.

![Figure 8](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-8.png)

*The View Controller gathers inputs and displays final outputs for a scene.* At this point, the first part of this statement is done and the View Controller sends these inputs to the Interactor as a `request` via calling `interactor?.addMeme(request: request)`. The `addMeme(request:)` protocol method is what the Interactor will use to conduct business logic on the input. This process is displayed in the following diagram.

![Figure 9](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-9.png)

### The Interactor

*The Interactor delegates the business logic associated with a scene.* The term *delegate* is used here, as opposed to *performs*, since *the business logic is actually performed by objects called workers that the interactor owns and interacts with.* **Workers** are objects that performs specific use cases of business logic. *In general, an Interactor can have n workers for n different business logic use cases.* The idea is to abstract different business logic flows to different workers so that the Interactor file doesn’t get intractably large. Once the Interactor receives the business logic output of all of its workers, it creates a `response` object with those values and sends it to the Presenter. This process is displayed in the following diagram.

![Figure 10](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-10.png)

The following is `AddMemeInteractor`’s `addMeme(request:)` protocol method implementation.

![Figure 11](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-11.png)

After initial data conditioning (i.e. converting our data to a `meme`), this method calls `memesWorker.addMeme(memeToAdd:)`, where `memesWorker` is an instance variable of `AddMemeInteractor`. This is the worker for the use case of adding a meme.

### The Worker

As mentioned previously, *Workers are objects that perform specific use cases of business logic.* The `memesWorker` instance variable of `AddMemeInteractor` is of type `MemesWorker`, and contains an `addMeme(memeToAdd:)` method that the Interactor calls within its method of the same name as showcased in the ViewController-to-Interactor flow figure. `MemesWorker.addMeme(memeToAdd:)` is defined below.

![Figure 12](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-12.png)

In the case of adding a meme, the “business logic” we want to perform is persisting the meme in local memory and generating an ID for the meme. We delegate this work to the `memesStore` instance variable of type `MemesMemStore`, which is a simple class that stores a static array of our memes and writes to it when we call `memesStore.addMeme(memeToadd:)`. This isn’t a `Clean Swift` specific component, so I won’t be going into further details with it.

Once the `memesStore` is done with the meme object, a chain of callbacks is made that ultimately sends the `meme` object back to the `AddMemeInteractor`. It’s at this point that the `AddMemeInteractor` creates a response object and sends it over to the `AddMemePresenter`. This process is showcased below.

![Figure 13](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-13.png)

Similar to how the `AddMemeViewController` sends a `request` to the `AddMemeInteractor`, the `AddMemeInteractor` sends a `response` over to the `AddMemePresenter` via calling the Presenter instance’s protocol method: `presenter?.presentAddedMeme(response: response)`. The associated protocol is defined as follows within the `AddMemePresenter` file.

![Figure 14](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-14.png)

### The Presenter

*The Presenter conditions information into a simple format that is easy to display for a user.* This conditioning is done within the Presenter’s associated protocol method. In our case, the `AddMemePresenter’s presentAddedMeme(response:)` protocol method only needs to transform the `response` from the `AddMemeInteractor` into a `AddMeme.ViewModel` before it sends that `viewModel` To the `AddMemeViewController` via `viewController?.displayAddedMeme(viewModel: viewModel)`, thereby completing the VIP cycle. This process is displayed below.

![Figure 15](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-15.png)

Note that the `viewController` property of any Presenter should have a `weak` reference. This is done to avoid a [retain cycle](https://medium.com/@vinodhswamy/strong-cycle-retain-cycle-in-swift-f452f07518b2) which can cause memory leaks (a strong reference of this property would create a circular dependency between the View Controller and the Presenter).

The `displayAddedMeme(viewModel: viewModel)` protocol method of `AddMemeViewController` takes in the `viewModel`, checks that it contains our meme object, and if so, routes us back to the `ListMemesViewController` where we can now see the added meme in our list. This router is of type `AddMemeRouter`. This process is displayed below.

![Figure 16](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-16.png)

Notice that we have a `nil` check for `meme` all the way back here in the View Controller. In other words, we’re only actioning on any errors at the end of the cycle. If anything were to go wrong in the VIP cycle, the cycle should not stop at that point of error. Rather, the error should be cascaded through the rest of the cycle and ultimately be displayed in a user-readable format back in the View Controller. This way, *the cycle can always run in a deterministic way, and we can always expect some kind of response back in the View Controller*, whether it’s a correct View Model object or an error.

### The Router

Similar to the three VIP components, the Router uses protocols and their associated methods to perform the key actions of the component. For the Router, these actions comprise *transferring data between scenes*, and *navigating between scenes*. The protocol for transferring data between scenes takes the following naming form:

* `<Scene>DataPassing`

In the case of `AddMemeRouter`, this protocol is called `AddMemeDataPassing`, and is declared as follows.

![Figure 17](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-17.png)

This is the general form that all `<Scene>DataPassing` protocols would take for a Router for a given Scene, where the `dataStore` variable’s type would be `<Scene>DataStore?`. Recall that this dataStore type is a protocol that we declare in the Interactor as follows.

![Figure 18](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-18.png)

In the case of the *AddMeme* scene, our data store protocol is empty because we store the added meme in local memory and thus don’t have to transfer it between the *AddMeme* scene and the *ListMeme* scene (i.e. the *ListMeme* scene’s View Controller can fetch this meme from local memory when loading the list). If we did want to pass data between scenes, our associated `<Scene>DataStore` protocol would contain the data that we want to pass. For instance, consider the `ShowMemeDataStore` shown below, which contains the `meme` we want to show from the list of memes.

![Figure 19](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-19.png)

The protocol for navigating between scenes takes the following naming form:

* `<Scene>RoutingLogic`

In the case of `AddMemeRouter`, this protocol is called `AddMemeRoutingLogic`, and is declared as follows.

![Figure 20](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-20.png)

The only other scene we go to from the *AddMeme* scene is the *ListMemes* scene, so we only have this one protocol method with the corresponding name. *In general, the `<Scene>RoutingLogic protocol` of a Router will have n routing methods for n scenes that the router is transferring data / navigating to.* These methods take on the following general naming form:

* `routeTo<SceneToRouteTo>(segue: UIStoryboardSegue?)`

The protocol methods of `<Scene>RoutingLogic` protocols of a Router are meant to handle *routing*. In *Clean Swift*, routing comprises *both* *data transfer* and *navigation*. The `routeTo<SceneToRouteTo>(segue: UIStoryboardSegue?)` protocol methods transfer data by accessing the `dataStore` property of the `<Scene>DataPassing` protocol, and they navigate between scenes by accessing the Router’s `viewController` member variable (note that like in the case of the Presenter, this member variable is weakly referenced to avoid retain cycles).

In general, the router conforms to the `<Scene>DataPassing` and `<Scene>RoutingLogic` protocols and declares / implements the associated dataStore and routing methods. In the case of the `AddMemeRouter`, we have the following implementation of `routeToListMemes(segue: UIStoryboardSegue?)` protocol method.

![Figure 21](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-21.png)

The `segue` argument only needs to be supplied if we are performing the segue programmatically. Whether or not we have the `segue`, we ultimately set up our  `destinationVC`, which is a `ListMemesViewController`, and then call `passDataToListMemes(source:destination:)` to transfer data between the *AddMeme* and *ListMemes* scenes, and call `navigateToListMemes(source:destination:)` to navigate to the *ListMemes* scene. The `passDataToListMemes(source:destination:)` method is implemented as follows.

![Figure 22](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-22.png)

In general, the data passing method takes the following form:

* `passDataTo<sceneToPassDataTo>(source:destination: inout)`

Note that we set the `destination` parameter to be `inout`. This means that we’re passing the destination argument to the method *by reference*. We’re doing this so that we can mutate the destination view controller’s router’s data store (`destinationDS`) values within the method, thereby transferring the data in question to the next scene.

Recall that in the case of transitioning from the *AddMeme* scene to the *ListMemes* scene, we don’t need to transfer any meme data since we have stored the meme in local memory. Hence, the `passDataToListMemes(source:destination:)` method is empty. To get an idea of how a non-empty implementation would look, we can take a look at the corresponding data-passing method implementation of the `ListMemesRouter` for transferring data between the *ListMemes* scene and the *ShowMeme* scene.

![Figure 23](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-23.png)

When transitioning from the *ListMemes* scene to the *ShowMeme* scene, we want to transfer the meme that we’re going to show. We do this by setting the destination dataStore’s `meme` property (recall the `ShowMemeDataStore` protocol from a previous figure) to the source dataStore’s `memes` property as shown below.

![Figure 24](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-24.png)

In general, the navigation method takes the following form:

* `navigateTo<sceneToNavigateTo>(source:destination:)`

In this method, we perform any navigation logic to get to the next scene. If the scene navigation is handled by the storyboard (as is the case for navigating from the *ShowMeme* scene to the *ListMemes* scene since we’re just pressing the back button), we can have an empty implementation for this method. 

Once the `AddMemeRouter`’s `routeToListMemes(segue:)` method is done executing, we’ve successfully routed to the *ListMeme* scene where our new meme is displayed!

![Figure 25](https://github.com/Seabsaye/CleanMeme/raw/master/readme-images/figure-25.png)

### Conclusion

By walking through the *AddMeme* scene, we’ve gone through all of the *Clean Swift* components: the 3 VIP components (View Controller, Interactor, Presenter), the Interactor’s Workers, the Router, and the Router’s DataStore. You should now have a high-level understanding of how *Clean Swift* architecture is laid out! The rest of the app is just the other two scenes: *ListMemes* and *ShowMeme*, so if you were able to follow along with this README fine, you shouldn’t have much trouble looking at the code for these scenes as they follow a very similar format to *AddMeme*.
