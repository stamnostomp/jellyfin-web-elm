module JellyfinUI exposing (Model, Msg, init, update, view, subscriptions)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import JellyfinAPI exposing (MediaItem, MediaType(..), Category, ServerConfig, defaultServerConfig, CastMember, CrewMember)
import MediaDetail
import MockData exposing (mockCategories, mockLibraryCategories)
import ServerSettings
import Task
import Theme
import TMDBData exposing (TMDBResponse, fetchTMDBData)


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
    , categoryTranslation : Dict String Float  -- Stores X-translation for each category
    , errorMessage : Maybe String -- Store error messages
    }

init : ( Model, Cmd Msg )
init =
    let
        ( mediaDetailModel, mediaDetailCmd ) =
            MediaDetail.init

        ( serverSettingsModel, serverSettingsCmd ) =
            ServerSettings.init

        -- Initial list of genres (will be updated when TMDB data loads)
        allGenres =
            [ "Sci-Fi", "Adventure", "Drama", "Action", "Romance", "Mystery",
              "Comedy", "Fantasy", "Thriller", "Horror", "Documentary" ]
    in
    ( { categories = [] -- Start with empty categories until data loads
      , searchQuery = ""
      , selectedCategory = Nothing
      , isLoading = True -- Start in loading state
      , serverConfig = defaultServerConfig
      , mediaDetailModel = mediaDetailModel
      , serverSettingsModel = serverSettingsModel
      , isUserMenuOpen = False
      , isGenreFilterOpen = False
      , selectedGenre = Nothing
      , availableGenres = allGenres
      , isTypeFilterOpen = False
      , selectedType = Nothing
      , categoryTranslation = Dict.empty
      , errorMessage = Nothing
      }
    , Cmd.batch
        [ Cmd.map MediaDetailMsg mediaDetailCmd
        , Cmd.map ServerSettingsMsg serverSettingsCmd
        , fetchTMDBData TMDBDataReceived -- Fetch data from TMDB JSON
        ]
    )

-- View a media item (large card version for category detail view)
viewMediaItemLarge : MediaItem -> Html Msg
viewMediaItemLarge item =
    div
        [ class "flex flex-col bg-surface border-2 border-background-light rounded-md overflow-hidden transition-all duration-300 hover:shadow-xl hover:border-primary hover:scale-103 hover:z-10 group h-full"
        , onClick (SelectMediaItem item.id)
        ]
        [ div [ class "relative pt-[150%]" ] -- Aspect ratio 2:3 for posters
            [ div
                [ class "absolute inset-0 bg-surface-light flex items-center justify-center transition-all duration-300 group-hover:brightness-110"
                , style "background-image" "linear-gradient(rgba(40, 40, 40, 0.2), rgba(30, 30, 30, 0.8))"
                ]
                [ div [ class "text-4xl text-primary-light opacity-70" ]
                    [ text "🎬" ]  -- Movie icon placeholder where an image would be
                ]
            , div
                [ class "absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 z-20"
                ]
                [ button
                    [ class "bg-primary text-white rounded-full w-20 h-20 flex items-center justify-center opacity-0 group-hover:opacity-90 hover:opacity-100 transition-all duration-300 cursor-pointer hover:scale-110"
                    , style "box-shadow" "0 0 30px 10px rgba(95, 135, 175, 0.7)"
                    , onClick (PlayMedia item.id)
                    ]
                    [ span [ class "text-3xl font-bold", style "margin-left" "4px" ] [ text "▶" ]
                    ]
                ]
            ]
        , div [ class "p-4 flex-grow transition-colors duration-300 group-hover:bg-surface-light" ]
            [ h3 (Theme.text Theme.Heading3 ++ [ class "truncate group-hover:text-primary transition-colors duration-300" ])
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
                [ text (Maybe.withDefault "No description available." item.description) ]
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
            categories
                |> List.map (\category ->
                    { category |
                        items = List.filter (itemHasGenre genre) category.items
                    }
                )
                |> List.filter (\category -> not (List.isEmpty category.items))

-- Check if an item has a specific genre
itemHasGenre : String -> MediaItem -> Bool
itemHasGenre genre item =
    List.member genre item.genres

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
    | ToggleGenreFilter -- Toggle genre filter dropdown
    | SelectGenre String -- Select a genre
    | ClearGenreFilter -- Clear genre filter
    | ToggleTypeFilter -- Toggle type filter dropdown
    | SelectType MediaType -- Select a media type
    | ClearTypeFilter -- Clear type filter
    | ScrollCategory String Int -- categoryId, direction (+1 for right, -1 for left)
    | TMDBDataReceived (Result Http.Error TMDBResponse) -- Handle TMDB data response
    | RetryLoadTMDBData -- Retry loading data if it fails
    | NoOp

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

                -- Create a detail from the found item or mock if not found
                detailCmd =
                    case foundItem of
                        Just item ->
                            -- Get description from the item or default
                            let
                                description =
                                    Maybe.withDefault "No description available." item.description

                                -- Get actual duration (120 minutes as a default for now)
                                duration = 120

                                -- Create the MediaDetail with real data
                                detail =
                                    { id = item.id
                                    , title = item.title
                                    , type_ = item.type_
                                    , imageUrl = item.imageUrl
                                    , year = item.year
                                    , rating = item.rating
                                    , description = description
                                    , directors = item.directors
                                    , actors = item.cast
                                    , duration = duration
                                    , genres = item.genres
                                    }
                                    |> Ok
                            in
                            MediaDetail.MediaDetailReceived detail
                                |> MediaDetailMsg
                                |> (\cmd -> Task.perform identity (Task.succeed cmd))

                        Nothing ->
                            MediaDetail.MediaDetailReceived (Err "Media item not found")
                                |> MediaDetailMsg
                                |> (\cmd -> Task.perform identity (Task.succeed cmd))
            in
            ( model, detailCmd )

        PlayMedia mediaId ->
            -- In a real implementation, this would start playback
            ( model, Cmd.none )

        FetchCategories ->
            -- This would fetch real data from the Jellyfin API in a complete implementation
            -- Now it's a placeholder for future real API integration
            ( { model | isLoading = True }, fetchTMDBData TMDBDataReceived )

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

        ScrollCategory categoryId direction ->
            let
                -- Get current translation or default to 0
                currentTranslation =
                    Dict.get categoryId model.categoryTranslation
                        |> Maybe.withDefault 0

                -- Calculate scroll amount per click
                scrollAmount = 300.0

                -- Get the category to determine item count
                maybeCategory = findCategory categoryId model.categories

                -- Calculate a maximum negative scroll distance based on item count
                maxScroll =
                    case maybeCategory of
                        Just category ->
                            -- Calculate based on number of items, card width, and container width
                            -- (Negative because we're translating left)
                            let
                                itemCount = List.length category.items |> toFloat
                                itemWidth = 280.0 -- Approximate width including margins
                                visibleItems = 4.0 -- Approximate number of visible items
                                containerWidth = visibleItems * itemWidth
                                contentWidth = itemCount * itemWidth
                                maxNegativeScroll = negate (contentWidth - containerWidth)
                            in
                            if itemCount <= visibleItems then
                                -- Don't allow scrolling if all items fit
                                0.0
                            else
                                -- Allow scrolling but limit to prevent empty space
                                Basics.max maxNegativeScroll -9999.0
                        Nothing ->
                            0.0

                -- Calculate new translation with bounds checking
                newTranslation =
                    if direction > 0 then
                        -- Scrolling right (more negative translation) with lower bound
                        Basics.max maxScroll (currentTranslation - scrollAmount)
                    else
                        -- Scrolling left (more positive translation) with upper bound of 0
                        Basics.min 0.0 (currentTranslation + scrollAmount)

                -- Update the dictionary with new translation
                updatedTranslations =
                    Dict.insert categoryId newTranslation model.categoryTranslation
            in
            ( { model | categoryTranslation = updatedTranslations }
            , Cmd.none
            )

        TMDBDataReceived result ->
            case result of
                Ok tmdbData ->
                    -- Extract all unique genres from the received data
                    let
                        allGenres =
                            tmdbData.categories
                                |> List.concatMap .items
                                |> List.concatMap .genres
                                |> List.sort
                                |> List.foldl
                                    (\genre acc ->
                                        if List.member genre acc then acc else genre :: acc
                                    ) []
                    in
                    ( { model
                      | categories = tmdbData.categories
                      , isLoading = False
                      , availableGenres = if List.isEmpty allGenres then model.availableGenres else allGenres
                      , errorMessage = Nothing
                      }
                    , Cmd.none
                    )

                Err error ->
                    -- Handle different error types
                    let
                        errorMsg =
                            case error of
                                Http.BadUrl url ->
                                    "Bad URL: " ++ url
                                Http.Timeout ->
                                    "Request timed out"
                                Http.NetworkError ->
                                    "Network error - check your connection"
                                Http.BadStatus status ->
                                    "Bad status: " ++ String.fromInt status
                                Http.BadBody message ->
                                    "Data parsing error: " ++ message

                        -- Fall back to mock data if there's an error
                    in
                    ( { model
                      | categories = mockCategories ++ mockLibraryCategories -- Use mock data as fallback
                      , isLoading = False
                      , errorMessage = Just errorMsg
                      }
                    , Cmd.none
                    )

        RetryLoadTMDBData ->
            ( { model | isLoading = True, errorMessage = Nothing }
            , fetchTMDBData TMDBDataReceived
            )

        NoOp ->
            -- Do nothing
            ( model, Cmd.none )

-- Helper to extract genres from a MediaItem
getItemGenres : MediaItem -> List String
getItemGenres item =
    item.genres

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map MediaDetailMsg (MediaDetail.subscriptions model.mediaDetailModel)


-- VIEW

view : Model -> Html Msg
view model =
    div [ class "flex flex-col min-h-screen bg-background" ]
        [ viewHeader model
        , div [ class "flex-1 overflow-y-auto pt-10 pb-8" ]
            [ if model.isLoading then
                viewLoading
              else
                case model.errorMessage of
                    Just error ->
                        viewError error
                    Nothing ->
                        viewContent model
            ]
        , Html.map MediaDetailMsg (MediaDetail.view model.mediaDetailModel)
        ]

viewHeader : Model -> Html Msg
viewHeader model =
    header [ class "bg-surface border-b border-background-light py-2 px-3" ]
        [ div [ class "px-1 md:px-2 max-w-screen-2xl mx-auto flex items-center justify-between" ]
            [ div [ class "flex items-center space-x-3" ]
                [ h1 (Theme.text Theme.Heading2)
                    [ text "Jellyfin" ]
                , span (Theme.text Theme.Caption)
                    [ text "Media Server" ]
                ]
            , div [ class "w-full max-w-md mx-2" ]
                [ div [ class "relative" ]
                    [ input
                        ([ class "w-full bg-background border border-background-light rounded py-1 px-3 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary focus:ring-opacity-50"
                         , placeholder "Search media..."
                         , value model.searchQuery
                         , onInput SearchInput
                         ] ++ Theme.text Theme.Body)
                        []
                    ]
                ]
            , div [ class "flex items-center space-x-2" ]
                [ viewTypeFilter model
                , viewGenreFilter model
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
                [ class "flex items-center space-x-1 py-1 px-2"
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
                    [ class "ml-1 text-text-secondary hover:text-error"
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
        [ class "absolute right-0 mt-1 w-48 bg-surface rounded-md shadow-lg z-50 border border-background-light" ]
        [ div
            [ class "bg-surface border-b border-background-light p-1" ]
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
        [ class "px-3 py-1 hover:bg-background-light cursor-pointer text-text-primary"
        , onClick (SelectType mediaType)
        ]
        [ text (mediaTypeToString mediaType) ]

-- Genre filter dropdown (existing function)
viewGenreFilter : Model -> Html Msg
viewGenreFilter model =
    div [ class "relative" ]
        [ button
            (Theme.button Theme.Ghost ++
                [ class "flex items-center space-x-1 py-1 px-2"
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
                    [ class "ml-1 text-text-secondary hover:text-error"
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
        [ class "absolute right-0 mt-1 w-48 bg-surface rounded-md shadow-lg z-50 border border-background-light" ]
        [ div
            [ class "bg-surface border-b border-background-light p-1" ]
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
        [ class "px-3 py-1 hover:bg-background-light cursor-pointer text-text-primary"
        , onClick (SelectGenre genre)
        ]
        [ text genre ]

-- User profile view remains the same
viewUserProfile : Model -> Html Msg
viewUserProfile model =
    div [ class "relative" ]
        [ button
            [ class "w-8 h-8 rounded-full bg-primary flex items-center justify-center text-text-primary hover:bg-primary-dark transition-colors focus:outline-none focus:ring-2 focus:ring-primary-light"
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
        [ class "absolute right-0 mt-1 w-56 bg-surface rounded-md shadow-lg py-1 z-50 border border-background-light" ]
        [ viewUserMenuHeader
        , viewUserMenuItem "Profile" "User profile and settings" "profile"
        , viewUserMenuItem "Display Preferences" "Customize your experience" "display"
        , viewUserMenuItem "Watch Party" "Watch with a group" "watchParty"
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
    div [ class "px-3 py-2 border-b border-background-light" ]
        [ div [ class "flex items-center space-x-2" ]
            [ div [ class "w-8 h-8 rounded-full bg-primary flex items-center justify-center text-text-primary" ]
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
        [ class "px-3 py-1 hover:bg-background-light cursor-pointer"
        , onClick (UserMenuAction action)
        ]
        [ p (Theme.text Theme.Body ++ [ class "font-medium" ])
            [ text label ]
        , p (Theme.text Theme.Caption)
            [ text description ]
        ]

-- Loading view
viewLoading : Html Msg
viewLoading =
    div [ class "flex justify-center items-center h-48" ]
        [ div [ class "text-primary text-xl" ]
            [ text "Loading..." ]
        ]

-- Error view
viewError : String -> Html Msg
viewError errorMessage =
    div [ class "flex flex-col items-center justify-center h-48 px-4" ]
        [ div [ class "bg-error bg-opacity-20 border border-error rounded-lg p-4 max-w-md" ]
            [ h3 (Theme.text Theme.Heading3 ++ [ class "text-error mb-2" ])
                [ text "Error Loading Data" ]
            , p (Theme.text Theme.Body ++ [ class "mb-4" ])
                [ text errorMessage ]
            , button
                (Theme.button Theme.Primary ++ [ onClick RetryLoadTMDBData ])
                [ text "Retry" ]
            ]
        ]

viewContent : Model -> Html Msg
viewContent model =
    div [ class "px-2 md:px-3 lg:px-4 max-w-screen-2xl mx-auto space-y-4 mb-4" ]
        [ -- Show active filters if any
          if model.selectedGenre /= Nothing || model.selectedType /= Nothing then
              div [ class "flex items-center py-1 space-x-2 flex-wrap" ]
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
                  case findCategory categoryId (filterCategoriesByType model.selectedType (filterCategoriesByGenre model.selectedGenre (filterCategories model.searchQuery model.categories))) of
                      Just category ->
                          div []
                              [ div [ class "flex items-center mb-3 mt-1" ]
                                  [ button
                                      (Theme.button Theme.Ghost ++ [ onClick ClearCategory, class "mr-2" ])
                                      [ text "← Back" ]
                                  , h2 (Theme.text Theme.Heading2 ++ [ class "font-bold text-primary" ])
                                      [ text category.name ]
                                  ]
                              , div [ class "grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-6" ]
                                  (List.map viewMediaItemLarge category.items)
                              ]
                      Nothing ->
                          div [] [ text "Category not found" ]

              Nothing ->
                  -- View all categories with filters applied
                  div [ class "space-y-4" ]
                      (List.map
                          (viewCategory model)
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
            div [ class "flex items-center bg-primary bg-opacity-20 border border-primary rounded-full px-2 py-0.5" ]
                [ span (Theme.text Theme.Body)
                    [ text genre ]
                , button
                    [ class "ml-1 text-primary hover:text-primary-dark"
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
            div [ class "flex items-center bg-secondary bg-opacity-20 border border-secondary rounded-full px-2 py-0.5" ]
                [ span (Theme.text Theme.Body)
                    [ text (mediaTypeToString mediaType) ]
                , button
                    [ class "ml-1 text-secondary hover:text-secondary-dark"
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

-- View a category row with its items and scroll arrows
viewCategory : Model -> Category -> Html Msg
viewCategory model category =
    if List.isEmpty category.items then
        text ""
    else
        let
            -- Get the current translation for this category or default to 0
            currentTranslation =
                Dict.get category.id model.categoryTranslation
                    |> Maybe.withDefault 0

            -- Calculate scroll limits
            itemCount = List.length category.items |> toFloat
            itemWidth = 280.0
            visibleItems = 4.0
            contentWidth = itemCount * itemWidth
            containerWidth = visibleItems * itemWidth
            maxNegativeScroll = negate (contentWidth - containerWidth)

            -- Determine if we're at scroll limits
            isAtStart = currentTranslation >= 0.0
            isAtEnd = currentTranslation <= maxNegativeScroll || itemCount <= visibleItems

            -- Button styles based on scroll position
            leftButtonStyle =
                if isAtStart then
                    Theme.button Theme.Ghost ++
                        [ onClick NoOp
                        , class "flex items-center justify-center w-6 h-6 opacity-50 cursor-not-allowed"
                        ]
                else
                    Theme.button Theme.Ghost ++
                        [ onClick (ScrollCategory category.id 1)  -- Scroll left
                        , class "flex items-center justify-center w-6 h-6"
                        ]

            rightButtonStyle =
                if isAtEnd then
                    Theme.button Theme.Ghost ++
                        [ onClick NoOp
                        , class "flex items-center justify-center w-6 h-6 opacity-50 cursor-not-allowed"
                        ]
                else
                    Theme.button Theme.Ghost ++
                        [ onClick (ScrollCategory category.id -1)  -- Scroll right
                        , class "flex items-center justify-center w-6 h-6"
                        ]
        in
        div [ class "space-y-1" ]
            [ div [ class "flex justify-between items-center" ]
                [ h2 (Theme.text Theme.Heading3 ++ [ class "font-bold text-primary" ])
                    [ text category.name ]
                , div [ class "flex items-center space-x-1" ]
                    [ button leftButtonStyle [ text "←" ]
                    , button rightButtonStyle [ text "→" ]
                    , button
                        (Theme.button Theme.Ghost ++ [ onClick (SelectCategory category.id), class "py-1 px-2" ])
                        [ text "See All" ]
                    ]
                ]
            , div [ class "relative overflow-visible px-1 py-1" ]
                [ div
                    [ class "flex"
                    , style "transform" ("translateX(" ++ String.fromFloat currentTranslation ++ "px)")
                    , style "transition" "transform 0.4s ease"
                    ]
                    (if List.isEmpty category.items then
                        [ div [ class "w-full text-center p-6" ]
                            [ p (Theme.text Theme.Body)
                                [ text "No items in this category" ]
                            ]
                        ]
                     else
                        List.map
                            (\item ->
                                div [ class "flex-shrink-0 w-56 md:w-64 lg:w-72 px-2 py-2" ]
                                    [ viewMediaItem item ]
                            )
                            category.items
                    )
                ]
            ]

-- View a media item (small card version)
viewMediaItem : MediaItem -> Html Msg
viewMediaItem item =
    div
        [ class "bg-surface border-2 border-background-light rounded-md overflow-hidden transition-all duration-300 hover:shadow-xl hover:border-primary cursor-pointer h-full hover:scale-103 hover:z-10 group"
        , onClick (SelectMediaItem item.id)
        ]
        [ div [ class "relative pt-[150%]" ]
            [ div
                [ class "absolute inset-0 bg-surface-light flex flex-col justify-end transition-all duration-300 group-hover:brightness-110"
                , style "background-image" "linear-gradient(rgba(40, 40, 40, 0.2), rgba(30, 30, 30, 0.8))"
                ]
                [ div [ class "absolute inset-0 flex items-center justify-center" ]
                    [ div [ class "text-2xl text-primary-light opacity-70" ]
                        [ text "🎬" ]
                    ]
                , div [ class "relative z-10 p-3" ]
                    [ h3 (Theme.text Theme.Heading3 ++ [ class "truncate group-hover:text-primary transition-colors duration-300" ])
                        [ text item.title ]
                    , div [ class "flex justify-between items-center mt-1" ]
                        [ span (Theme.text Theme.Caption)
                            [ text (String.fromInt item.year) ]
                        , span (Theme.text Theme.Caption ++ [ class "text-warning" ])
                            [ text ("★ " ++ String.fromFloat item.rating) ]
                        ]
                    , if List.length item.genres > 0 then
                        div [ class "flex flex-wrap gap-1 mt-1" ]
                            (List.take 2 item.genres
                                |> List.map (\genre ->
                                    span [ class "bg-background-light px-1 py-0.5 rounded text-text-secondary text-xs" ]
                                        [ text genre ]
                                )
                            )
                      else
                        text ""
                    ]
                ]
            ]
        ]
