# CleanMeme 
## *A Clean Swift Architecture iOS Application*
This README serves as a walkthrough of the *Clean Swift* iOS architecture pattern. The *Clean Swift* app called *CleanMeme* is referenced throughout the walkthrough as a means of showing how the aspects of *Clean Swift* work and come together in practice

### Clean Swift TL;DR
*Clean Swift* extracts the business and presentation logic from the user interface code of iOS apps, decoupling application logic and thereby making it more testable and scalable. The decoupling process is achieved by incorporating what's known as a ViewController-Interactor-Presenter (VIP) cycle into every application use case / scene.

### Some Problems that Clean Swift Tackles
1. Massive view controllers
* How: abstracting code to different components
2. Growing model size as a result of trying to decrease View Controller (VC) size
* How: having Interactor and Presenter components that divide up this code growth
3. Frequent regressions
* How: maintaining abstracted components that can each be tested in isolation, which creates a higher potential for more comprehensive code coverage 
4. Highly coupled dependency graphs (classes having unnecessary and by-directional references etc.) → reducing this coupling reduces risk of memory leaks due to circular references and unneeded references
* How: highly enforced uni-directional dependencies and data flow between components via the VIP cycle. Values are weakly referenced if they loop back to create a circular reference.

### Strengths of Clean Swift
The strengths of *Clean Swift* will be evaluated on the basis of the following non-functional requirements which are common to a multitude of different types of software applications: **Maintainability**, **Testability**, and **Extensibility**.

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

The main idea of *Clean Swift* architecture is to have the application be comprised entirely of scenes that communicate between one-another. There is a scene for each specific application use case, and each scene has its own associated 3 VIP components that undergo VIP cycles. Below is an example of the structure of an Order app that’s been built using *Clean Swift*. 
