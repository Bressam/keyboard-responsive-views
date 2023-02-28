# Keyboard Responsive ViewControllers

## Description
This is just a study project, used to create keyboard responsive views without the need of scroolviews, so keyboard don't cover the textfields that user is typing.
So this is completely done by myself to understand how would be possible to create a viewController that behaves as expected.

This project also uses some protocol and extensions to simplify code.
Also, I have done this study project to be able to easily add this feature on multiple apps that I created later, that ended up easily implementing and using this ViewController style.

## Sample
<img width=260px src="https://github.com/Bressam/keyboard-responsive-views/blob/master/Sample/keyboard_move_view.gif">

## Usage
To use the behavior is easy, just inherit the ViewController from 
> UIViewControllerWithKeyboardMove

and the viewController will be responsive to keayboard covering textFields.
