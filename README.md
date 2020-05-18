# Gamepedia
Case Study

Gamepedia is wiki app for games. You can search games, check details and add to favorites if you like.

### Installation:
Just open and run the project

### Project Structure:
I prefer MVVM-R pattern on my projects. MVVM-R is classic MVVM pattern with `State` and `Router` extensions. State is our data container which controlled by view model. Router is handling routing on view controller. For further information please check [this blog post](https://medium.com/commencis/using-redux-with-mvvm-on-ios-18212454d676). 

Presentations are used with necessary fields for related view to avoid full network object passing around app. 

I like to use stackview in dynamic interfaces for easier show/hide handling.

I use Carthage because of better build times.

### Third-party Libs:
- `Alamofire` for networking and image download & cache operations

### Missing features:
- Split view to support landscape mode.

### Things I would change If I had more time:
- I would use split view controller to support landscape mode.
- Update game list with search controller to avoid large title glitch.
- Fix description last line bug in game detail.
- I would calculate description text line and show/hide read more button according to it.
- Localize strings.
- I would update tableview instead of reload for pagination.
- Image carousel with multiple images in game detail.

### Things needed for production:
- Crash tracking tool.
- Analysis tool for tracking user behaviour.
- More unit tests.