# Naming / File structure

## Routes

A route that encapsulates views and widgets that are related to each other.

### Listed Under

```
lib/routes/<route_name>
```

### Directories

-   `views`:

    -   Contains different views of this route. If this route has only one view, it must be named as `view.dart`.
    -   If the main view has different [Sub Route Views](#sub-route-views), they must be created within a folder of choice nested under the main views directory.

-   `widgets`:
    -   Contains the commonly used widgets within this route.
    -   If multiple widgets fall into the same category, they must be
        placed within a folder with a name that describes the category.

## Sub Route Views

A sub route view that relates to a parent [route](#routes) view. These views are typically navigated from a parent view.

### Listed Under

```
lib/routes/<parent_route>/views/<sub_route_name>
```
