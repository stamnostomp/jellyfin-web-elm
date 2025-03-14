module JellyfinUI exposing (Model, Msg, init, update, view, subscriptions)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import JellyfinAPI exposing (MediaItem, MediaType(..), Category, ServerConfig, defaultServerConfig)
import MediaDetail
import ServerSettings
import Task
import Theme


-- MODEL

type alias Model =
    { categories : List Category
    , searchQuery : String
    , selectedCategory : Maybe String
    , isLoading : Bool
    , serverConfig : ServerConfig
    , mediaDetailModel : MediaDetail.Model
    , serverSettingsModel : ServerSettings.Model
    , isUserMenuOpen : Bool -- Track if user menu is open
    , isGenreFilterOpen : Bool -- Track if genre filter dropdown is open
    , selectedGenre : Maybe String -- Currently selected genre for filtering
    , availableGenres : List String -- List of available genres
    , isTypeFilterOpen : Bool -- Track if type filter dropdown is open
    , selectedType : Maybe MediaType -- Currently selected media type for filtering
    }

init : ( Model, Cmd Msg )
init =
    let
        ( mediaDetailModel, mediaDetailCmd ) =
            MediaDetail.init

        ( serverSettingsModel, serverSettingsCmd ) =
            ServerSettings.init

        -- Extract all unique genres from our mock data
        allGenres =
            [ "Sci-Fi", "Adventure", "Drama", "Action", "Romance", "Mystery",
              "Comedy", "Fantasy", "Thriller", "Horror", "Documentary" ]
    in
    ( { categories = mockCategories ++ mockLibraryCategories
      , searchQuery = ""
      , selectedCategory = Nothing
      , isLoading = False
      , serverConfig = defaultServerConfig
      , mediaDetailModel = mediaDetailModel
      , serverSettingsModel = serverSettingsModel
      , isUserMenuOpen = False -- Initialize as closed
      , isGenreFilterOpen = False -- Initialize genre filter as closed
      , selectedGenre = Nothing -- No genre selected initially
      , availableGenres = allGenres -- All available genres
      , isTypeFilterOpen = False -- Initialize type filter as closed
      , selectedType = Nothing -- No type selected initially
      }
    , Cmd.batch
        [ Cmd.map MediaDetailMsg mediaDetailCmd
        , Cmd.map ServerSettingsMsg serverSettingsCmd
        ]
    )


-- MOCK DATA

mockCategories : List Category
mockCategories =
    [ { id = "continue-watching"
      , name = "Continue Watching"
      , items =
          [ { id = "show2", title = "Chronicles of the Void", type_ = TVShow, imageUrl = "show2.jpg", year = 2021, rating = 8.7 }
          , { id = "movie4", title = "Nebula's Edge", type_ = Movie, imageUrl = "movie4.jpg", year = 2024, rating = 7.5 }
          ]
      }
    , { id = "recently-added"
      , name = "Recently Added"
      , items =
          [ { id = "movie1", title = "The Quantum Protocol", type_ = Movie, imageUrl = "movie1.jpg", year = 2023, rating = 8.5 }
          , { id = "movie2", title = "Echoes of Tomorrow", type_ = Movie, imageUrl = "movie2.jpg", year = 2024, rating = 7.8 }
          , { id = "show1", title = "Digital Horizons", type_ = TVShow, imageUrl = "show1.jpg", year = 2023, rating = 9.2 }
          , { id = "movie3", title = "Stellar Odyssey", type_ = Movie, imageUrl = "movie3.jpg", year = 2022, rating = 6.9 }
          ]
      }
    , { id = "recommended"
      , name = "Recommended For You"
      , items =
          [ { id = "movie5", title = "Hypernova", type_ = Movie, imageUrl = "movie5.jpg", year = 2023, rating = 9.1 }
          , { id = "show3", title = "Temporal Divide", type_ = TVShow, imageUrl = "show3.jpg", year = 2022, rating = 8.4 }
          , { id = "movie6", title = "Parallel Essence", type_ = Movie, imageUrl = "movie6.jpg", year = 2024, rating = 7.2 }
          , { id = "show4", title = "Quantum Nexus", type_ = TVShow, imageUrl = "show4.jpg", year = 2021, rating = 8.9 }
          ]
      }
    ]

-- Mock library categories to replace sidebar navigation
mockLibraryCategories : List Category
mockLibraryCategories =
    [ { id = "movie-library"
      , name = "Movies"
      , items =
          [ { id = "movie7", title = "Cosmic Paradigm", type_ = Movie, imageUrl = "movie7.jpg", year = 2023, rating = 8.3 }
          , { id = "movie8", title = "Neural Connection", type_ = Movie, imageUrl = "movie8.jpg", year = 2024, rating = 7.9 }
          , { id = "movie9", title = "Synthetic Dreams", type_ = Movie, imageUrl = "movie9.jpg", year = 2022, rating = 8.1 }
          , { id = "movie10", title = "Digital Frontier", type_ = Movie, imageUrl = "movie10.jpg", year = 2023, rating = 7.6 }
          ]
      }
    , { id = "tv-library"
      , name = "TV Shows"
      , items =
          [ { id = "show5", title = "Ethereal Connection", type_ = TVShow, imageUrl = "show5.jpg", year = 2022, rating = 8.8 }
          , { id = "show6", title = "Parallel Futures", type_ = TVShow, imageUrl = "show6.jpg", year = 2023, rating = 9.0 }
          , { id = "show7", title = "Quantum Horizon", type_ = TVShow, imageUrl = "show7.jpg", year = 2024, rating = 8.2 }
          , { id = "show8", title = "Neural Network", type_ = TVShow, imageUrl = "show8.jpg", year = 2021, rating = 7.7 }
          ]
      }
    ]


-- UPDATE

type Msg
    = SearchInput String
    | SelectCategory String
    | ClearCategory
    | SelectMediaItem String
    | PlayMedia String
    | FetchCategories
    | CategoriesReceived (List Category)
    | MediaDetailMsg MediaDetail.Msg
    | ServerSettingsMsg ServerSettings.Msg
    | UpdateServerConfig ServerConfig
    | ToggleUserMenu -- For handling user menu toggle
    | UserMenuAction String -- For user menu actions
    | ToggleGenreFilter -- New message to toggle genre filter dropdown
    | SelectGenre String -- New message to select a genre
    | ClearGenreFilter -- New message to clear genre filter
    | ToggleTypeFilter -- Toggle type filter dropdown
    | SelectType MediaType -- Select a media type
    | ClearTypeFilter -- Clear type filter

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchInput query ->
            ( { model | searchQuery = query }, Cmd.none )

        SelectCategory categoryId ->
            ( { model | selectedCategory = Just categoryId }, Cmd.none )

        ClearCategory ->
            ( { model | selectedCategory = Nothing }, Cmd.none )

        SelectMediaItem mediaId ->
            -- Find the media item in our categories
            let
                foundItem =
                    model.categories
                        |> List.concatMap .items
                        |> List.filter (\item -> item.id == mediaId)
                        |> List.head

                -- Create a mock detail for now
                mockDetail =
                    case foundItem of
                        Just item ->
                            { id = item.id
                            , title = item.title
                            , type_ = item.type_
                            , imageUrl = item.imageUrl
                            , year = item.year
                            , rating = item.rating
                            , description = "This is a placeholder description for " ++ item.title ++ ", which would typically be fetched from the Jellyfin API."
                            , directors = ["Jane Director", "John Filmmaker"]
                            , actors = ["Actor One", "Actor Two", "Supporting Role", "Guest Star", "Famous Voice", "New Talent"]
                            , duration = 115
                            , genres = ["Sci-Fi", "Adventure", "Drama"]
                            }
                            |> Ok

                        Nothing ->
                            Err "Media item not found"

                mediaDetailCmd =
                    case mockDetail of
                        Ok detail ->
                            MediaDetail.MediaDetailReceived (Ok detail)
                                |> MediaDetailMsg
                                |> (\cmd -> Task.perform identity (Task.succeed cmd))

                        Err error ->
                            MediaDetail.MediaDetailReceived (Err error)
                                |> MediaDetailMsg
                                |> (\cmd -> Task.perform identity (Task.succeed cmd))
            in
            ( model, mediaDetailCmd )

        PlayMedia mediaId ->
            -- In a real implementation, this would start playback
            ( model, Cmd.none )

        FetchCategories ->
            -- This would fetch real data from the Jellyfin API
            ( { model | isLoading = True }, Cmd.none )

        CategoriesReceived categories ->
            ( { model | categories = categories, isLoading = False }, Cmd.none )

        MediaDetailMsg subMsg ->
            let
                ( updatedMediaDetailModel, mediaDetailCmd ) =
                    MediaDetail.update subMsg model.mediaDetailModel
            in
            ( { model | mediaDetailModel = updatedMediaDetailModel }
            , Cmd.map MediaDetailMsg mediaDetailCmd
            )

        ServerSettingsMsg subMsg ->
            let
                ( updatedServerSettingsModel, serverSettingsCmd ) =
                    ServerSettings.update subMsg model.serverSettingsModel
            in
            ( { model | serverSettingsModel = updatedServerSettingsModel }
            , Cmd.map ServerSettingsMsg serverSettingsCmd
            )

        UpdateServerConfig newConfig ->
            ( { model | serverConfig = newConfig }, Cmd.none )

        ToggleUserMenu ->
            ( { model | isUserMenuOpen = not model.isUserMenuOpen, isGenreFilterOpen = False, isTypeFilterOpen = False }, Cmd.none )

        ToggleGenreFilter ->
            ( { model | isGenreFilterOpen = not model.isGenreFilterOpen, isUserMenuOpen = False, isTypeFilterOpen = False }, Cmd.none )

        SelectGenre genre ->
            ( { model | selectedGenre = Just genre, isGenreFilterOpen = False }, Cmd.none )

        ClearGenreFilter ->
            ( { model | selectedGenre = Nothing }, Cmd.none )

        ToggleTypeFilter ->
            ( { model | isTypeFilterOpen = not model.isTypeFilterOpen, isUserMenuOpen = False, isGenreFilterOpen = False }, Cmd.none )

        SelectType mediaType ->
            ( { model | selectedType = Just mediaType, isTypeFilterOpen = False }, Cmd.none )

        ClearTypeFilter ->
            ( { model | selectedType = Nothing }, Cmd.none )

        UserMenuAction action ->
            -- Handle user menu actions (placeholder for now)
            ( { model | isUserMenuOpen = False }, Cmd.none )


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map MediaDetailMsg (MediaDetail.subscriptions model.mediaDetailModel)


-- VIEW

view : Model -> Html Msg
view model =
    div [ class "flex flex-col min-h-screen bg-background" ]
        [ viewHeader model
        , div [ class "flex-1 overflow-y-auto pt-6 pb-16" ]
            [ if model.isLoading then
                viewLoading
              else
                viewContent model
            ]
        , Html.map MediaDetailMsg (MediaDetail.view model.mediaDetailModel)
        ]

viewHeader : Model -> Html Msg
viewHeader model =
    header [ class "bg-surface border-b border-background-light p-4" ]
        [ div [ class "px-2 md:px-4 max-w-screen-2xl mx-auto flex items-center justify-between" ]
            [ div [ class "flex items-center space-x-4" ]
                [ h1 (Theme.text Theme.Heading2)
                    [ text "Jellyfin" ]
                , span (Theme.text Theme.Caption)
                    [ text "Media Server" ]
                ]
            , div [ class "w-full max-w-md mx-4" ]
                [ div [ class "relative" ]
                    [ input
                        ([ class "w-full bg-background border border-background-light rounded py-2 px-4 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary focus:ring-opacity-50"
                         , placeholder "Search media..."
                         , value model.searchQuery
                         , onInput SearchInput
                         ] ++ Theme.text Theme.Body)
                        []
                    ]
                ]
            , div [ class "flex items-center space-x-4" ]
                [ viewTypeFilter model -- New type filter dropdown
                , viewGenreFilter model -- Genre filter dropdown
                , viewUserProfile model
                ]
            ]
        ]

-- New function for type filter dropdown
viewTypeFilter : Model -> Html Msg
viewTypeFilter model =
    div [ class "relative" ]
        [ button
            (Theme.button Theme.Ghost ++
                [ class "flex items-center space-x-2"
                , onClick ToggleTypeFilter
                ]
            )
            [ text
                (case model.selectedType of
                    Just mediaType ->
                        "Type: " ++ mediaTypeToString mediaType
                    Nothing ->
                        "Filter by Type"
                )
            , if model.selectedType /= Nothing then
                button
                    [ class "ml-2 text-text-secondary hover:text-error"
                    , onClick ClearTypeFilter
                    ]
                    [ text "×" ]
              else
                text ""
            ]
        , if model.isTypeFilterOpen then
            viewTypeDropdown
          else
            text ""
        ]

-- Type dropdown menu
viewTypeDropdown : Html Msg
viewTypeDropdown =
    div
        [ class "absolute right-0 mt-2 w-48 bg-surface rounded-md shadow-lg z-50 border border-background-light" ]
        [ div
            [ class "bg-surface border-b border-background-light p-2" ]
            [ p (Theme.text Theme.Label)
                [ text "Select Media Type" ]
            ]
        , div
            [ class "py-1" ]
            [ viewTypeOption Movie
            , viewTypeOption TVShow
            ]
        ]

-- Individual type option
viewTypeOption : MediaType -> Html Msg
viewTypeOption mediaType =
    div
        [ class "px-4 py-2 hover:bg-background-light cursor-pointer text-text-primary"
        , onClick (SelectType mediaType)
        ]
        [ text (mediaTypeToString mediaType) ]

-- Genre filter dropdown (existing function)
viewGenreFilter : Model -> Html Msg
viewGenreFilter model =
    div [ class "relative" ]
        [ button
            (Theme.button Theme.Ghost ++
                [ class "flex items-center space-x-2"
                , onClick ToggleGenreFilter
                ]
            )
            [ text
                (case model.selectedGenre of
                    Just genre ->
                        "Genre: " ++ genre
                    Nothing ->
                        "Filter by Genre"
                )
            , if model.selectedGenre /= Nothing then
                button
                    [ class "ml-2 text-text-secondary hover:text-error"
                    , onClick ClearGenreFilter
                    ]
                    [ text "×" ]
              else
                text ""
            ]
        , if model.isGenreFilterOpen then
            viewGenreDropdown model.availableGenres
          else
            text ""
        ]

-- Genre dropdown menu
viewGenreDropdown : List String -> Html Msg
viewGenreDropdown genres =
    div
        [ class "absolute right-0 mt-2 w-48 bg-surface rounded-md shadow-lg z-50 border border-background-light" ]
        [ div
            [ class "bg-surface border-b border-background-light p-2" ]
            [ p (Theme.text Theme.Label)
                [ text "Select Genre" ]
            ]
        , div
            [ class "max-h-64 overflow-y-auto py-1" ]
            (List.map viewGenreOption genres)
        ]

-- Individual genre option
viewGenreOption : String -> Html Msg
viewGenreOption genre =
    div
        [ class "px-4 py-2 hover:bg-background-light cursor-pointer text-text-primary"
        , onClick (SelectGenre genre)
        ]
        [ text genre ]

-- User profile view remains the same
viewUserProfile : Model -> Html Msg
viewUserProfile model =
    div [ class "relative" ]
        [ button
            [ class "w-10 h-10 rounded-full bg-primary flex items-center justify-center text-text-primary hover:bg-primary-dark transition-colors focus:outline-none focus:ring-2 focus:ring-primary-light"
            , onClick ToggleUserMenu
            ]
            [ text "A" ]  -- "A" for Admin/Avatar
        , if model.isUserMenuOpen then
            viewUserMenu
          else
            text ""
        ]

-- User dropdown menu
viewUserMenu : Html Msg
viewUserMenu =
    div
        [ class "absolute right-0 mt-2 w-56 bg-surface rounded-md shadow-lg py-1 z-50 border border-background-light" ]
        [ viewUserMenuHeader
        , viewUserMenuItem "Profile" "User profile and settings" "profile"
        , viewUserMenuItem "Display Preferences" "Customize your experience" "display"
        , viewUserMenuItem "Watch Party" "Whatch with a group" "watchParty"
        , div [ class "border-t border-background-light my-1" ] []
        , viewUserMenuItem "Manage Libraries" "Organize your media collection" "libraries"
        , viewUserMenuItem "Manage Users" "Add or edit user access" "users"
        , viewUserMenuItem "Server Dashboard" "System status and settings" "dashboard"
        , div [ class "border-t border-background-light my-1" ] []
        , viewUserMenuItem "Sign Out" "Exit your account" "signout"
        ]

-- User menu header with user info
viewUserMenuHeader : Html Msg
viewUserMenuHeader =
    div [ class "px-4 py-3 border-b border-background-light" ]
        [ div [ class "flex items-center space-x-3" ]
            [ div [ class "w-10 h-10 rounded-full bg-primary flex items-center justify-center text-text-primary" ]
                [ text "A" ]
            , div []
                [ p (Theme.text Theme.Body ++ [ class "font-medium" ])
                    [ text "Administrator" ]
                , p (Theme.text Theme.Caption)
                    [ text "admin@jellyfin.org" ]
                ]
            ]
        ]

-- Individual menu item
viewUserMenuItem : String -> String -> String -> Html Msg
viewUserMenuItem label description action =
    div
        [ class "px-4 py-2 hover:bg-background-light cursor-pointer"
        , onClick (UserMenuAction action)
        ]
        [ p (Theme.text Theme.Body ++ [ class "font-medium" ])
            [ text label ]
        , p (Theme.text Theme.Caption)
            [ text description ]
        ]

-- Loading view - now properly defined
viewLoading : Html Msg
viewLoading =
    div [ class "flex justify-center items-center h-64" ]
        [ div [ class "text-primary text-xl" ]
            [ text "Loading..." ]
        ]

viewContent : Model -> Html Msg
viewContent model =
    div [ class "px-4 md:px-6 lg:px-8 max-w-screen-2xl mx-auto space-y-10 mb-8" ]
        [ -- Show active filters if any
          if model.selectedGenre /= Nothing || model.selectedType /= Nothing then
              div [ class "flex items-center py-2 space-x-2 flex-wrap" ]
                  [ span (Theme.text Theme.Label)
                      [ text "Active filters:" ]
                  , viewActiveFilter model.selectedGenre
                  , viewActiveTypeFilter model.selectedType
                  ]
          else
              text ""
        , case model.selectedCategory of
              Just categoryId ->
                  -- View a specific category in detail
                  case findCategory categoryId (filterCategoriesByType model.selectedType (filterCategoriesByGenre model.selectedGenre model.categories)) of
                      Just category ->
                          div []
                              [ div [ class "flex items-center mb-6 mt-2" ]
                                  [ button
                                      (Theme.button Theme.Ghost ++ [ onClick ClearCategory, class "mr-2" ])
                                      [ text "← Back" ]
                                  , h2 (Theme.text Theme.Heading2)
                                      [ text category.name ]
                                  ]
                              , div [ class "grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-6" ]
                                  (List.map viewMediaItemLarge category.items)
                              ]
                      Nothing ->
                          div [] [ text "Category not found" ]

              Nothing ->
                  -- View all categories with filters applied
                  div [ class "space-y-10" ]
                      (List.map
                          (viewCategory model.searchQuery)
                          (filterCategories
                              model.searchQuery
                              (filterCategoriesByType model.selectedType
                                  (filterCategoriesByGenre model.selectedGenre model.categories)
                              )
                          )
                      )
        ]

-- View for active filter badge
viewActiveFilter : Maybe String -> Html Msg
viewActiveFilter maybeGenre =
    case maybeGenre of
        Just genre ->
            div [ class "flex items-center bg-primary bg-opacity-20 border border-primary rounded-full px-3 py-1" ]
                [ span (Theme.text Theme.Body)
                    [ text genre ]
                , button
                    [ class "ml-2 text-primary hover:text-primary-dark"
                    , onClick ClearGenreFilter
                    ]
                    [ text "×" ]
                ]
        Nothing ->
            text ""

-- View for active type filter badge
viewActiveTypeFilter : Maybe MediaType -> Html Msg
viewActiveTypeFilter maybeType =
    case maybeType of
        Just mediaType ->
            div [ class "flex items-center bg-secondary bg-opacity-20 border border-secondary rounded-full px-3 py-1" ]
                [ span (Theme.text Theme.Body)
                    [ text (mediaTypeToString mediaType) ]
                , button
                    [ class "ml-2 text-secondary hover:text-secondary-dark"
                    , onClick ClearTypeFilter
                    ]
                    [ text "×" ]
                ]
        Nothing ->
            text ""

-- Find a category by ID
findCategory : String -> List Category -> Maybe Category
findCategory categoryId categories =
    List.filter (\cat -> cat.id == categoryId) categories
        |> List.head

-- View a category row with its items
viewCategory : String -> Category -> Html Msg
viewCategory searchQuery category =
    if List.isEmpty category.items then
        text ""
    else
        div [ class "space-y-3" ]
            [ div [ class "flex justify-between items-center" ]
                [ h2 (Theme.text Theme.Heading2)
                    [ text category.name ]
                , button
                    (Theme.button Theme.Ghost ++ [ onClick (SelectCategory category.id) ])
                    [ text "See All" ]
                ]
            , div [ class "grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4" ]
                (List.map viewMediaItem category.items)
            ]

-- View a media item (small card version)
viewMediaItem : MediaItem -> Html Msg
viewMediaItem item =
    div
        [ class "bg-surface border border-background-light rounded-md overflow-hidden transition-all duration-200 hover:shadow-lg hover:border-primary cursor-pointer"
        , onClick (SelectMediaItem item.id)
        ]
        [ div [ class "relative pt-[150%]" ] -- Aspect ratio 2:3 for posters
            [ div
                [ class "absolute inset-0 bg-background-light"
                , style "background-image" "linear-gradient(rgba(28, 28, 28, 0.2), rgba(28, 28, 28, 0.8))"
                ]
                []
            , div [ class "absolute bottom-0 left-0 right-0 p-3" ]
                [ p (Theme.text Theme.Body ++ [ class "font-semibold truncate" ])
                    [ text item.title ]
                , div [ class "flex justify-between items-center mt-1" ]
                    [ span (Theme.text Theme.Caption)
                        [ text (String.fromInt item.year) ]
                    , span (Theme.text Theme.Caption ++ [ class "flex items-center" ])
                        [ text (String.fromFloat item.rating) ]
                    ]
                ]
            , button
                [ class "absolute top-2 right-2 bg-primary rounded-full p-1 opacity-0 hover:opacity-100 transition-opacity"
                , onClick (PlayMedia item.id)
                ]
                [ text "▶" ]
            ]
        ]

-- View a media item (large card version for category detail view)
viewMediaItemLarge : MediaItem -> Html Msg
viewMediaItemLarge item =
    div
        [ class "flex flex-col bg-surface border border-background-light rounded-md overflow-hidden transition-all duration-200 hover:shadow-lg hover:border-primary"
        , onClick (SelectMediaItem item.id)
        ]
        [ div [ class "relative pt-[150%]" ] -- Aspect ratio 2:3 for posters
            [ div
                [ class "absolute inset-0 bg-background-light"
                , style "background-image" "linear-gradient(rgba(28, 28, 28, 0.2), rgba(28, 28, 28, 0.8))"
                ]
                []
            , button
                [ class "absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 bg-primary bg-opacity-80 hover:bg-opacity-100 rounded-full p-4 transition-all duration-200"
                , onClick (PlayMedia item.id)
                ]
                [ text "▶" ]
            ]
        , div [ class "p-4" ]
            [ h3 (Theme.text Theme.Heading3 ++ [ class "truncate" ])
                [ text item.title ]
            , div [ class "flex justify-between items-center mt-2" ]
                [ div [ class "flex items-center space-x-2" ]
                    [ span (Theme.text Theme.Caption)
                        [ text (mediaTypeToString item.type_) ]
                    , span (Theme.text Theme.Caption)
                        [ text ("(" ++ String.fromInt item.year ++ ")") ]
                    ]
                , div [ class "flex items-center" ]
                    [ span (Theme.text Theme.Caption ++ [ class "text-warning" ])
                        [ text ("★ " ++ String.fromFloat item.rating) ]
                    ]
                ]
            , p (Theme.text Theme.Caption ++ [ class "mt-2 line-clamp-2" ])
                [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore." ]
            ]
        ]

-- Filter categories based on search query
filterCategories : String -> List Category -> List Category
filterCategories query categories =
    if String.isEmpty query then
        categories
    else
        categories
            |> List.map (\category ->
                { category |
                    items = List.filter
                        (\item -> String.contains (String.toLower query) (String.toLower item.title))
                        category.items
                }
            )
            |> List.filter (\category -> not (List.isEmpty category.items))

-- Filter categories based on genre
filterCategoriesByGenre : Maybe String -> List Category -> List Category
filterCategoriesByGenre maybeGenre categories =
    case maybeGenre of
        Nothing ->
            categories

        Just genre ->
            -- For the purpose of this demo, we'll randomly filter some items
            -- to simulate genre filtering. In a real app, each media item would have
            -- its own genre information.
            let
                -- Use a simple hashing of the first char of the genre to get consistent filtering
                genreChar = String.left 1 genre |> String.toList |> List.head |> Maybe.withDefault 'A'
                genreValue = Char.toCode genreChar

                -- Return true for approximately 1/3 of items using a deterministic pattern
                shouldKeepItem item =
                    (String.length item.title + genreValue) |> modBy 3 |> (==) 0
            in
            categories
                |> List.map (\category ->
                    { category |
                        items = List.filter shouldKeepItem category.items
                    }
                )
                |> List.filter (\category -> not (List.isEmpty category.items))

-- Add new filter function for media type
filterCategoriesByType : Maybe MediaType -> List Category -> List Category
filterCategoriesByType maybeType categories =
    case maybeType of
        Nothing ->
            categories

        Just mediaType ->
            categories
                |> List.map (\category ->
                    { category |
                        items = List.filter (\item -> item.type_ == mediaType) category.items
                    }
                )
                |> List.filter (\category -> not (List.isEmpty category.items))

-- HELPERS

-- Convert MediaType to string
mediaTypeToString : MediaType -> String
mediaTypeToString mediaType =
    case mediaType of
        Movie -> "Movie"
        TVShow -> "TV Show"
        Music -> "Music"
