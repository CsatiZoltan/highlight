function highlight
% Highlight selected graphics object.
%   This function helps to differentiate several graphics items (we call them 
%   objects from now) by emphasizing one, the selected object.
%   The program works with any objects: lines, patches, meshes, surfaces, etc.
%   The two most important actions are:
%       - selection with single click
%       - restoring original view by double clicking somewhere in the figure
%   All options are available through a context menu activated by right clicking
%   on the part of the axes not occupied by other objects. The options are:
%      Style: determines how to highlight the selected object
%         invisible: makes the objects other than the selected one invisible
%         thicken: keeps the other objects and sets double line width for the 
%                  selected one. Maximum 20 pt line width is allowed. Has no
%                  effect on objects lacking the 'LineWidth' property.
%      Axes limits: drives the behavior how the region of interest is changed
%                   when an object is selected
%         auto: resizes the axes to fit to the selected object
%         manual: keeps the original axes limits (makes sense when used with the 
%                 invisible style)
%      Restore: resets the default line width and visibility of the objects,
%               i.e. before "highlight" was called

%   Zoltan Csati
%   29/10/2017



% The program needs at least one figure
assert(~isempty(get(0, 'Children')), 'highlight:noExistingFigure', ...
    'No figure detected. Nothing to highlight.');

% Context menu to show up by right clicking on the axes
c = uicontextmenu;
set(gca, 'UIContextMenu',c);

% Highlightable objects
axesObjects = get(gca, 'Children');

% Default line width of the objects
for iObject = 1:numel(axesObjects)
    try %#ok<TRYNC>
        defaultLineWidth = get(axesObjects(iObject), 'LineWidth');
        set(axesObjects(iObject), 'UserData',defaultLineWidth);
    end
end

% Create menu items for the context menu
styleMenu = uimenu(c, 'Label','Style');
uimenu(styleMenu, 'Label','thicken', 'Callback',@changeSelection);      
uimenu(styleMenu, 'Label','invisible', 'Checked','on', 'Callback',@changeSelection);
axeslimitsMenu = uimenu(c, 'Label','Axes limits');
uimenu(axeslimitsMenu, 'Label','auto', 'Callback',@changeSelection);
uimenu(axeslimitsMenu, 'Label','manual', 'Checked','on', 'Callback',@changeSelection);
uimenu(c, 'Label','Reset', 'Callback',{@resetScene, axesObjects});

% Highlight selected object (single or double click)
set(axesObjects, 'ButtonDownFcn',{@highlightSelected, axesObjects, axeslimitsMenu, styleMenu});

% Restore original view by clicking somewhere on the figure
set(gcf, 'WindowbuttonDownFcn',{@restoreView, axesObjects});

% Bring to the foreground the figure the highlighter is attached to
figure(gcf);

end % end of the main function


%% Callback functions

function highlightSelected(this, ~, axesObjects, axeslimitsMenu, styleMenu)
% Use a selection on this object based on the active style

% Identify which highlighting options are selected
allStyle = get(styleMenu, 'Children');
selectedStyle = allStyle(strcmp(get(allStyle, 'Checked'), 'on'));
allLimit = get(axeslimitsMenu, 'Children');
selectedLimit = allLimit(strcmp(get(allLimit, 'Checked'), 'on'));
% Obtain the remaining objects
exceptThis = axesObjects(axesObjects ~= this);
% Set axis limits
if strcmp(get(selectedLimit, 'Label'), 'manual')
    set(gca, 'XLimMode', 'manual');
    set(gca, 'YLimMode', 'manual');
    set(gca, 'ZLimMode', 'manual');
else % although 'auto' is the default, previous 'manual' could have overwritten it
    set(gca, 'XLimMode', 'auto');
    set(gca, 'YLimMode', 'auto');
    set(gca, 'ZLimMode', 'auto');
end
% Highlighting according to the selected style
switch get(selectedStyle, 'Label')
    case 'invisible'
        set(exceptThis, 'Visible','off');
    case 'thicken'
        % Set double line width where the line width is a valid property
        try
            originalLineWidth = get(this, 'LineWidth');
            newLineWidth = min(2*originalLineWidth, 20);
            set(this, 'LineWidth', newLineWidth);
        catch
            warning('highlight:lineWidthNotDefined', ...
                'Line width is not defined for the selected option.');
        end
end

end


function changeSelection(this, ~)
% Select the submenu which is clicked on and uncheck the other submenus

parentMenu = get(this, 'Parent');
allSubmenu = get(parentMenu, 'Children');
exceptThis = allSubmenu(allSubmenu ~= this);
set(this, 'Checked','on');
set(exceptThis, 'Checked','off');

end


function restoreView(this, ~, axesObjects)
% Restore original view when double clicking (taken from https://goo.gl/EB1Yp4)

if strcmp(get(this, 'SelectionType'), 'open')
    set(axesObjects, 'Visible','on');
end

end


function resetScene(~, ~, axesObjects)
% Reset default line width and visibility of the objects but keep the options

for iObject = 1:numel(axesObjects)
    try %#ok<TRYNC>
        defaultLineWidth = get(axesObjects(iObject), 'UserData');
        set(axesObjects(iObject), 'LineWidth',defaultLineWidth);
    end
end
set(axesObjects, 'Visible','on');

end