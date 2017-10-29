# highlight
Highlight selected graphics object in MATLAB



## Overview

This function helps to differentiate several graphics objects by emphasizing one, the selected object. The program works with any objects: lines, patches, meshes, surfaces, etc.
All the options can be accessed from a context menu. It facilitates the usage as the user does not need to remember the option names and values.
The goal was to create an easy-to-use tool which runs on old MATLAB releases, therefore I do not use

 - undocumented features
 - nested functions (introduced in about 2007)
 - dot notation (introduced in R2014b) to access and set properties
 - `groot` (introduced in R2014b), instead: `get(0)`

Suppressing unused function input or output arguments with a tilde (`~`) was introduced in R2009b. I chose to use this feature for readability.



## Usage

Type `highlight` to call the function on the currently active figure. The two most important actions are:

 - selection with single click
 - restoring original view by double clicking somewhere in the figure

All options are available through a context menu activated by right clicking on the part of the axes not occupied by other objects. The options are:

- Style: determines how to highlight the selected object
  - invisible: makes the objects other than the selected one invisible
  - thicken: keeps the other objects and sets double line width for the selected one. Maximum 20 pt line width is allowed. Has no effect on objects lacking the `'LineWidth'` property.

- Axes limits: drives the behavior how the region of interest is changed when an object is selected
  - auto: resizes the axes to fit to the selected object
  - manual: keeps the original axes limits (makes sense when used with the invisible style)

- Restore: resets the default line width and visibility of the objects, i.e. before "highlight" was called




## Contribution

Bug reports, feature requests are welcome. This tool is meant to be robust, so it would be especially useful to report under which MATLAB versions it works.