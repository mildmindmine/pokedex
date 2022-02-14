# pokedex

### Simple application to display list of pokemon as a part of Appsynth's assignment

#### This application contains 2 main features

1. Landing Page

- Displaying list of pokemon fetch from API
- Infinite scrolling (with loader at the bottom of the list)
- Pull to refresh data

2. Pokemon Detail Section

- Bottom sheet modal
- While data is still loading from API, will display loading indicator
- Once finished loading data, display `name`, `front image`, `back image`, `weight`, and `height` of
  that pokemon

#### Main dependency libraries used in the project:

- rxdart
- json_annotation
- freezed_annotation
- dio
- retrofit

(For the minimal external lib, I've decided not to use getIt or injection package since the project
is quite small and doesn't have much dependency)
