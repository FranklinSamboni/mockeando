#  Mockeando

## Requirements

- [x] Load the posts from the JSON API and populate the view.
- [x] Each cell/row should show the title of the post without clipping ( dynamic height ).
- [x] Once a Post is tapped, the user should be taken to a Post Details Screen.
- [x] The post details screen should contain:
-   [x] The post title and description.
-   [x] The post author information.
-   [x] The list of comments.
- [x] Implement a mechanism to favorite/unfavorite a post.
- [x] Favorite posts should be at the top of the list.
- [x] Favorite posts should have a star indicator.
- [x] Implement a mechanism to delete a post.
- [x] Implement a mechanism to remove all posts except from the favorites ones.
- [x] Implement a mechanism to load all posts from the API.
- [x] Add meaningful Unit Tests.

## Extra points
- [x] Provide an off line solution where:
- [x] User should be able to see previously loaded posts.
- [] User should be able to see post details.
- [] Incorporate a RFP (Reactive Functional Programming) solution as part of your implementation wherever it makes sense.

## Process of building

Part of this project was built using test driven development, the API components are 100% tested, also part of the Presentation. 
Test are pending for Cache, UI and the entry point sections of the App, so at the end the real coverage is 48%. 

This project follows SOLID principles, mainly focus on single responsability, interface segregration, 
and dependency inversion principles.

Trying to follow CLEAN architecture concepts I ended up with the following structure:

- Feature
    - Cache
    - API
    - Domain
    - Presentation
    - UI
    
Where domain abstractions does not have any dependency with any framework or module like Cache, API, Presentation or UI. 
The presentation layer does not depend on UIKit components, making it easily reusable with other framework like SwiftUI if needed,
or even other platforms like macOS, iPad OS or WatchOS. 

## Guide 
1. Open the project.
2. Start looking at the Demo video, so you will know how to use the App.
3. Run unit test using `CMD+U`
4. Run the App
5. Navigate it
6. Search the entry point of the App, which is the `SceneDelete`
7. Look how each feature is composed, you will see how all the components come together to build a feature
8. From here my recommendations is to start looking the modules in the following order, Domain -> API -> Cache -> Presentation -> UI
9. Look at the UTs structure when reviewing API and Presentation layers. 
 
 
