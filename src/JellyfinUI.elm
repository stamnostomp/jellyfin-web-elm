module JellyfinUI exposing (Model, Msg, init, subscriptions, update, view)

{-| The main UI module for Jellyfin web client.
This module handles the overall UI layout and state management.
-}

import Browser.Dom as Dom
import Browser.Events as Events
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (alt, attribute, class, disabled, placeholder, src, style, value)
import Html.Events exposing (onClick, onInput)
import Http
import Icon
import JellyfinAPI exposing (CastMember, Category, CrewMember, MediaItem, MediaType(..), ServerConfig, defaultServerConfig)
import MediaDetail
import MockData exposing (mockCategories, mockLibraryCategories)
import Player
import ServerSettings
import TMDBData exposing (TMDBResponse, fetchTMDBData)
import Task
import Theme



-- MODEL


{-| Main model for the Jellyfin UI
-}
type alias Model =
    { categories : List Category
    , searchQuery : String
    , selectedCategory : Maybe String
    , isLoading : Bool
    , serverConfig : ServerConfig
    , mediaDetailModel : MediaDetail.Model
    , serverSettingsModel : ServerSettings.Model
    , playerModel : Player.Model -- ADD THIS LINE
    , isUserMenuOpen : Bool
    , isGenreFilterOpen : Bool
    , selectedGenre : Maybe String
    , availableGenres : List String
    , isTypeFilterOpen : Bool
    , selectedType : Maybe MediaType
    , categoryTranslation : Dict String Float
    , errorMessage : Maybe String
    , windowWidth : Int
    }


{-| Initialize the model and commands
-}
init : ( Model, Cmd Msg )
init =
    let
        ( mediaDetailModel, mediaDetailCmd ) =
            MediaDetail.init

        ( serverSettingsModel, serverSettingsCmd ) =
            ServerSettings.init

        ( playerModel, playerCmd ) =
            -- ADD THIS
            Player.init

        -- Initial list of genres
        allGenres =
            [ "Sci-Fi"
            , "Adventure"
            , "Drama"
            , "Action"
            , "Romance"
            , "Mystery"
            , "Comedy"
            , "Fantasy"
            , "Thriller"
            , "Horror"
            , "Documentary"
            ]
    in
    ( { categories = []
      , searchQuery = ""
      , selectedCategory = Nothing
      , isLoading = True
      , serverConfig = defaultServerConfig
      , mediaDetailModel = mediaDetailModel
      , serverSettingsModel = serverSettingsModel
      , playerModel = playerModel -- ADD THIS LINE
      , isUserMenuOpen = False
      , isGenreFilterOpen = False
      , selectedGenre = Nothing
      , availableGenres = allGenres
      , isTypeFilterOpen = False
      , selectedType = Nothing
      , categoryTranslation = Dict.empty
      , errorMessage = Nothing
      , windowWidth = 1200
      }
    , Cmd.batch
        [ Cmd.map MediaDetailMsg mediaDetailCmd
        , Cmd.map ServerSettingsMsg serverSettingsCmd
        , Cmd.map PlayerMsg playerCmd -- ADD THIS LINE
        , fetchTMDBData TMDBDataReceived
        , Task.perform
            (\vp -> WindowResized (round vp.viewport.width) (round vp.viewport.height))
            Dom.getViewport
        ]
    )



-- UPDATE


{-| Messages that can be sent in the Jellyfin UI
-}
type Msg
    = SearchInput String
    | SelectCategory String
    | ClearCategory
    | SelectMediaItem String
    | PlayMedia String
    | FetchCategories
    | CategoriesReceived (List Category)
    | PlayerMsg Player.Msg
    | MediaDetailMsg MediaDetail.Msg
    | ServerSettingsMsg ServerSettings.Msg
    | UpdateServerConfig ServerConfig
    | ToggleUserMenu
    | UserMenuAction String
    | ToggleGenreFilter
    | SelectGenre String
    | ClearGenreFilter
    | ToggleTypeFilter
    | SelectType MediaType
    | ClearTypeFilter
    | ScrollCategory String Int
    | TMDBDataReceived (Result Http.Error TMDBResponse)
    | RetryLoadTMDBData
    | WindowResized Int Int
    | NoOp


{-| Update function to handle messages
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WindowResized width height ->
            ( { model | windowWidth = width }
            , Cmd.none
            )

        SearchInput query ->
            ( { model | searchQuery = query }, Cmd.none )

        SelectCategory categoryId ->
            ( { model | selectedCategory = Just categoryId }, Cmd.none )

        ClearCategory ->
            ( { model | selectedCategory = Nothing }, Cmd.none )

        SelectMediaItem mediaId ->
            let
                foundItem =
                    model.categories
                        |> List.concatMap .items
                        |> List.filter (\item -> item.id == mediaId)
                        |> List.head

                detailCmd =
                    case foundItem of
                        Just item ->
                            let
                                description =
                                    Maybe.withDefault "No description available." item.description

                                duration =
                                    120

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
            let
                foundItem =
                    model.categories
                        |> List.concatMap .items
                        |> List.filter (\item -> item.id == mediaId)
                        |> List.head

                playerCmd =
                    case foundItem of
                        Just item ->
                            Player.LoadMedia item
                                |> PlayerMsg
                                |> (\cmd -> Task.perform identity (Task.succeed cmd))

                        Nothing ->
                            Cmd.none
            in
            ( model, playerCmd )

        PlayerMsg subMsg ->
            let
                ( updatedPlayerModel, playerCmd ) =
                    Player.update subMsg model.playerModel
            in
            ( { model | playerModel = updatedPlayerModel }
            , Cmd.map PlayerMsg playerCmd
            )

        FetchCategories ->
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
            ( { model | isUserMenuOpen = False }, Cmd.none )

        ScrollCategory categoryId direction ->
            let
                currentTranslation =
                    Dict.get categoryId model.categoryTranslation
                        |> Maybe.withDefault 0

                scrollAmount =
                    300.0

                maybeCategory =
                    findCategory categoryId model.categories

                maxScrollPosition =
                    case maybeCategory of
                        Just category ->
                            let
                                itemsCount =
                                    toFloat (List.length category.items)

                                itemSize =
                                    200.0

                                displayCount =
                                    if model.windowWidth > 1600 then
                                        5.0

                                    else if model.windowWidth > 1200 then
                                        4.0

                                    else if model.windowWidth > 900 then
                                        3.0

                                    else if model.windowWidth > 600 then
                                        2.0

                                    else
                                        1.0

                                containerSize =
                                    displayCount * itemSize

                                contentSize =
                                    itemsCount * itemSize
                            in
                            if itemsCount <= displayCount then
                                0.0

                            else
                                negate (contentSize - containerSize)

                        Nothing ->
                            0.0

                -- Fixed direction logic:
                -- direction > 0 = scroll right (show next items) = negative translation
                -- direction < 0 = scroll left (show previous items) = positive translation
                newTranslation =
                    if direction > 0 then
                        -- Scroll right (show next items) - move content left
                        Basics.max maxScrollPosition (currentTranslation - scrollAmount)

                    else
                        -- Scroll left (show previous items) - move content right
                        Basics.min 0.0 (currentTranslation + scrollAmount)

                updatedTranslations =
                    Dict.insert categoryId newTranslation model.categoryTranslation
            in
            ( { model | categoryTranslation = updatedTranslations }
            , Cmd.none
            )

        TMDBDataReceived result ->
            case result of
                Ok tmdbData ->
                    let
                        allGenres =
                            tmdbData.categories
                                |> List.concatMap .items
                                |> List.concatMap .genres
                                |> List.sort
                                |> List.foldl
                                    (\genre acc ->
                                        if List.member genre acc then
                                            acc

                                        else
                                            genre :: acc
                                    )
                                    []
                    in
                    ( { model
                        | categories = tmdbData.categories
                        , isLoading = False
                        , availableGenres =
                            if List.isEmpty allGenres then
                                model.availableGenres

                            else
                                allGenres
                        , errorMessage = Nothing
                      }
                    , Cmd.none
                    )

                Err error ->
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
                    in
                    ( { model
                        | categories = mockCategories ++ mockLibraryCategories
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
            ( model, Cmd.none )



-- SUBSCRIPTIONS


{-| Subscribe to window resize events and media detail subscriptions
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map MediaDetailMsg (MediaDetail.subscriptions model.mediaDetailModel)
        , Sub.map PlayerMsg (Player.subscriptions model.playerModel) -- ADD THIS LINE
        , Events.onResize WindowResized
        ]



-- VIEW


{-| Main view function
-}
view : Model -> Html Msg
view model =
    -- Check if player is active first
    case model.playerModel.currentMedia of
        Just _ ->
            -- Show player full screen
            Html.map PlayerMsg (Player.view model.playerModel)

        Nothing ->
            -- Show normal UI
            div [ class "flex flex-col min-h-screen bg-background overflow-x-hidden" ]
                [ viewHeader model
                , div [ class "flex-1 overflow-y-auto pt-10 pb-8 overflow-x-hidden" ]
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


{-| View the header with search and filters
-}
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
                         ]
                            ++ Theme.text Theme.Body
                        )
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


{-| View the type filter dropdown
-}
viewTypeFilter : Model -> Html Msg
viewTypeFilter model =
    div [ class "relative" ]
        [ button
            (Theme.button Theme.Ghost
                ++ [ class "flex items-center space-x-1 py-1 px-2"
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


{-| View the type options dropdown
-}
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


{-| View a single type option
-}
viewTypeOption : MediaType -> Html Msg
viewTypeOption mediaType =
    div
        [ class "px-3 py-1 hover:bg-background-light cursor-pointer text-text-primary"
        , onClick (SelectType mediaType)
        ]
        [ text (mediaTypeToString mediaType) ]


{-| View the genre filter dropdown
-}
viewGenreFilter : Model -> Html Msg
viewGenreFilter model =
    div [ class "relative" ]
        [ button
            (Theme.button Theme.Ghost
                ++ [ class "flex items-center space-x-1 py-1 px-2"
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


{-| View the genre options dropdown
-}
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


{-| View a single genre option
-}
viewGenreOption : String -> Html Msg
viewGenreOption genre =
    div
        [ class "px-3 py-1 hover:bg-background-light cursor-pointer text-text-primary"
        , onClick (SelectGenre genre)
        ]
        [ text genre ]


{-| View the user profile button and dropdown
-}
viewUserProfile : Model -> Html Msg
viewUserProfile model =
    div [ class "relative" ]
        [ button
            [ class "w-8 h-8 rounded-full bg-primary flex items-center justify-center text-text-primary hover:bg-primary-dark transition-colors focus:outline-none focus:ring-2 focus:ring-primary-light"
            , onClick ToggleUserMenu
            ]
            [ text "A" ]
        , if model.isUserMenuOpen then
            viewUserMenu

          else
            text ""
        ]


{-| View the user menu dropdown
-}
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


{-| View the user menu header with user info
-}
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


{-| View a single user menu item
-}
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


{-| View the loading indicator
-}
viewLoading : Html Msg
viewLoading =
    div [ class "flex justify-center items-center h-48" ]
        [ div [ class "text-primary text-xl" ]
            [ text "Loading..." ]
        ]


{-| View the error message with retry button
-}
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


{-| View the main content area
-}
viewContent : Model -> Html Msg
viewContent model =
    div [ class "px-4 max-w-screen-2xl mx-auto space-y-4 mb-4" ]
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
                viewCategoryDetail model categoryId

            Nothing ->
                -- View all categories with filters applied
                viewAllCategories model
        ]


{-| View active filter badge
-}
viewActiveFilter : Maybe String -> Html Msg
viewActiveFilter maybeGenre =
    case maybeGenre of
        Just genre ->
            div [ class "flex items-center bg-primary bg-opacity-20 border border-primary rounded-full px-2 py-0.5" ]
                [ span (Theme.text Theme.Body)
                    [ text genre ]
                , button
                    [ class "ml-1 text-primary hover:text-primary-dark flex items-center"
                    , onClick ClearGenreFilter
                    ]
                    [ Icon.view [ class "text-sm" ] Icon.close ]
                ]

        Nothing ->
            text ""


{-| View active type filter badge
-}
viewActiveTypeFilter : Maybe MediaType -> Html Msg
viewActiveTypeFilter maybeType =
    case maybeType of
        Just mediaType ->
            div [ class "flex items-center bg-secondary bg-opacity-20 border border-secondary rounded-full px-2 py-0.5" ]
                [ span (Theme.text Theme.Body)
                    [ text (mediaTypeToString mediaType) ]
                , button
                    [ class "ml-1 text-secondary hover:text-secondary-dark flex items-center"
                    , onClick ClearTypeFilter
                    ]
                    [ Icon.view [ class "text-sm" ] Icon.close ]
                ]

        Nothing ->
            text ""


{-| View a specific category detail page
-}
viewCategoryDetail : Model -> String -> Html Msg
viewCategoryDetail model categoryId =
    let
        filteredCategories =
            filterCategoriesByType model.selectedType
                (filterCategoriesByGenre model.selectedGenre
                    (filterCategories model.searchQuery model.categories)
                )
    in
    case findCategory categoryId filteredCategories of
        Just category ->
            div []
                [ div [ class "flex items-center justify-between mb-3 mt-1" ]
                    [ h2 (Theme.text Theme.Heading2 ++ [ class "font-bold text-primary" ])
                        [ text category.name ]
                    , button
                        (Theme.button Theme.Ghost ++ [ onClick ClearCategory, class "flex items-center justify-center" ])
                        [ Icon.view [ class "text-2xl" ] Icon.close ]
                    ]
                , div [ class "grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-3 px-4" ]
                    (List.map viewMediaItemLarge category.items)
                ]

        Nothing ->
            div [] [ text "Category not found" ]


{-| View all categories with filters applied
-}
viewAllCategories : Model -> Html Msg
viewAllCategories model =
    let
        filteredCategories =
            filterCategoriesByType model.selectedType
                (filterCategoriesByGenre model.selectedGenre
                    (filterCategories model.searchQuery model.categories)
                )
    in
    div [ class "space-y-6" ]
        (List.map
            (viewCategory model)
            filteredCategories
        )


{-| Find a category by ID in a list of categories
-}
findCategory : String -> List Category -> Maybe Category
findCategory categoryId categories =
    List.filter (\cat -> cat.id == categoryId) categories
        |> List.head


{-| View a category row with its items and scroll arrows
-}
viewCategory : Model -> Category -> Html Msg
viewCategory model category =
    if List.isEmpty category.items then
        text ""

    else
        let
            -- Calculate display parameters
            itemCount =
                toFloat (List.length category.items)

            itemWidth =
                200.0

            -- Calculate visible items based on window width
            displayCount =
                if model.windowWidth > 1600 then
                    5.0

                else if model.windowWidth > 1200 then
                    4.0

                else if model.windowWidth > 900 then
                    3.0

                else if model.windowWidth > 600 then
                    2.0

                else
                    1.0

            -- Get the current translation
            currentTranslation =
                Dict.get category.id model.categoryTranslation
                    |> Maybe.withDefault 0

            -- Determine scroll limits
            maxScrollPosition =
                if itemCount <= displayCount then
                    0.0

                else
                    negate ((itemCount * itemWidth) - (displayCount * itemWidth))

            -- Determine if we're at scroll limits
            isAtStart =
                currentTranslation >= 0.0

            isAtEnd =
                currentTranslation <= maxScrollPosition || itemCount <= displayCount

            -- Button styles based on scroll position
            leftButtonStyle =
                if isAtStart then
                    Theme.button Theme.Ghost
                        ++ [ onClick NoOp
                           , class "flex items-center justify-center w-6 h-6 opacity-50 cursor-not-allowed"
                           ]

                else
                    Theme.button Theme.Ghost
                        ++ [ onClick (ScrollCategory category.id -1) -- Changed to -1 for left (previous)
                           , class "flex items-center justify-center w-6 h-6"
                           ]

            rightButtonStyle =
                if isAtEnd then
                    Theme.button Theme.Ghost
                        ++ [ onClick NoOp
                           , class "flex items-center justify-center w-6 h-6 opacity-50 cursor-not-allowed"
                           ]

                else
                    Theme.button Theme.Ghost
                        ++ [ onClick (ScrollCategory category.id 1) -- Changed to 1 for right (next)
                           , class "flex items-center justify-center w-6 h-6"
                           ]
        in
        div [ class "space-y-2" ]
            [ div [ class "flex justify-between items-center mx-1" ]
                [ h2 (Theme.text Theme.Heading3 ++ [ class "font-bold text-primary" ])
                    [ text category.name ]
                , div [ class "flex items-center space-x-1" ]
                    [ button (leftButtonStyle ++ [ class "flex items-center justify-center" ])
                        [ Icon.view [ class "text-lg" ] Icon.arrowBack ]
                    , button (rightButtonStyle ++ [ class "flex items-center justify-center" ])
                        [ Icon.view [ class "text-lg" ] Icon.arrowForward ]
                    , button
                        (Theme.button Theme.Ghost ++ [ onClick (SelectCategory category.id), class "py-1 px-2" ])
                        [ text "See All" ]
                    ]
                ]
            , div
                [ class "relative overflow-hidden" ]
                [ div
                    [ class "flex space-x-2 hide-scrollbar"
                    , style "transform" ("translateX(" ++ String.fromFloat currentTranslation ++ "px)")
                    , style "transition" "transform 0.4s ease"
                    , style "width" "100%"
                    , style "overscroll-behavior-x" "contain"
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
                                div
                                    [ class "flex-shrink-0 w-52 relative py-2 px-1 overflow-visible"
                                    , style "min-width" "185px"
                                    ]
                                    [ viewMediaItem item ]
                            )
                            category.items
                    )
                ]
            ]


{-| View a media item card (small version for category rows)
-}
viewMediaItem : MediaItem -> Html Msg
viewMediaItem item =
    div
        [ class "bg-surface border-2 border-background-light rounded-md overflow-hidden transition-all duration-300 hover:shadow-xl hover:border-primary cursor-pointer h-full group transform hover:scale-105"
        , style "transition" "all 0.3s cubic-bezier(0.25, 0.1, 0.25, 1.0)"
        , style "will-change" "transform, box-shadow, border-color"
        , onClick (SelectMediaItem item.id)
        ]
        [ div [ class "relative pt-[150%]" ]
            [ img
                [ src item.imageUrl
                , class "absolute inset-0 w-full h-full object-cover transition-all duration-300 group-hover:brightness-110"
                , alt item.title
                , attribute "onerror" "this.style.display='none'; this.nextElementSibling.style.display='flex';"
                ]
                []
            , div
                [ class "absolute inset-0 flex items-center justify-center bg-background-light text-primary-light"
                , style "display" "none"
                ]
                [ Icon.view [ class "text-6xl opacity-50" ] Icon.movie ]

            -- Fallback if image fails to load
            -- Add play button overlay that appears on hover
            , div
                [ class "absolute inset-0 flex items-center justify-center z-30"
                ]
                [ button
                    [ class "flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-300 cursor-pointer hover:scale-105 relative z-40"
                    , onClick (PlayMedia item.id)
                    , attribute "data-testid" "play-button"
                    ]
                    [ div
                        [ class "bg-primary bg-opacity-90 w-8 h-8 flex items-center justify-center rounded-md shadow-lg"
                        , style "box-shadow" "0 0 10px 3px rgba(95, 135, 175, 0.8)"
                        , style "position" "relative"
                        , style "z-index" "50"
                        ]
                        [ span
                            [ class "text-sm font-bold text-white"
                            ]
                            [ Icon.view [ class "text-base" ] Icon.playArrow ]
                        ]
                    ]
                ]
            , div
                [ class "absolute inset-0 flex flex-col justify-end bg-gradient-to-t from-background-dark via-transparent to-transparent opacity-90 text-text-primary p-3 transition-all duration-300"
                ]
                [ h3 (Theme.text Theme.Heading3 ++ [ class "truncate text-white" ])
                    [ text item.title ]
                , div [ class "flex justify-between items-center mt-1" ]
                    [ span (Theme.text Theme.Caption)
                        [ text (String.fromInt item.year) ]
                    , span (Theme.text Theme.Caption ++ [ class "text-warning flex items-center" ])
                        [ Icon.view [ class "text-xs mr-0.5" ] Icon.star
                        , text (String.fromFloat item.rating)
                        ]
                    ]
                , if List.length item.genres > 0 then
                    div [ class "flex flex-wrap gap-1 mt-1" ]
                        (List.take 2 item.genres
                            |> List.map
                                (\genre ->
                                    span [ class "bg-background-light bg-opacity-50 px-1 py-0.5 rounded text-white text-xs" ]
                                        [ text genre ]
                                )
                        )

                  else
                    text ""
                ]
            ]
        ]


{-| View a media item card (large version for detailed view)
-}
viewMediaItemLarge : MediaItem -> Html Msg
viewMediaItemLarge item =
    div
        [ class "bg-surface border-2 border-background-light rounded-md overflow-hidden transition-all duration-300 hover:shadow-xl hover:border-primary cursor-pointer h-full group transform hover:scale-105"
        , style "transition" "all 0.3s cubic-bezier(0.25, 0.1, 0.25, 1.0)"
        , style "will-change" "transform, box-shadow, border-color"
        , onClick (SelectMediaItem item.id)
        ]
        [ div [ class "relative pt-[150%]" ]
            [ img
                [ src item.imageUrl
                , class "absolute inset-0 w-full h-full object-cover transition-all duration-300 group-hover:brightness-110"
                , alt item.title
                , attribute "onerror" "this.style.display='none'; this.nextElementSibling.style.display='flex';"
                ]
                []
            , div
                [ class "absolute inset-0 flex items-center justify-center bg-background-light text-primary-light"
                , style "display" "none"
                ]
                [ Icon.view [ class "text-6xl opacity-50" ] Icon.movie ]
            , div
                [ class "absolute inset-0 flex items-center justify-center z-30"
                ]
                [ button
                    [ class "flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-300 cursor-pointer hover:scale-105 relative z-40"
                    , onClick (PlayMedia item.id)
                    , attribute "data-testid" "play-button"
                    ]
                    [ div
                        [ class "bg-primary bg-opacity-90 w-12 h-12 flex items-center justify-center rounded-md shadow-lg"
                        , style "box-shadow" "0 0 15px 5px rgba(95, 135, 175, 0.8)"
                        , style "position" "relative"
                        , style "z-index" "50"
                        ]
                        [ Icon.view [ class "text-2xl text-white" ] Icon.playArrow
                        ]
                    ]
                ]
            , div
                [ class "absolute inset-0 flex flex-col justify-end bg-gradient-to-t from-background-dark via-transparent to-transparent opacity-90 text-text-primary p-3 transition-all duration-300"
                ]
                [ h3 (Theme.text Theme.Heading3 ++ [ class "truncate text-white" ])
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
                            |> List.map
                                (\genre ->
                                    span [ class "bg-background-light bg-opacity-50 px-1 py-0.5 rounded text-white text-xs" ]
                                        [ text genre ]
                                )
                        )

                  else
                    text ""
                ]
            ]
        ]



-- HELPER FUNCTIONS


{-| Convert MediaType to string
-}
mediaTypeToString : MediaType -> String
mediaTypeToString mediaType =
    case mediaType of
        Movie ->
            "Movie"

        TVShow ->
            "TV Show"

        Music ->
            "Music"


{-| Check if an item has a specific genre
-}
itemHasGenre : String -> MediaItem -> Bool
itemHasGenre genre item =
    List.member genre item.genres


{-| Filter categories based on search query
-}
filterCategories : String -> List Category -> List Category
filterCategories query categories =
    if String.isEmpty query then
        categories

    else
        categories
            |> List.map
                (\category ->
                    { category
                        | items =
                            List.filter
                                (\item -> String.contains (String.toLower query) (String.toLower item.title))
                                category.items
                    }
                )
            |> List.filter (\category -> not (List.isEmpty category.items))


{-| Filter categories based on genre
-}
filterCategoriesByGenre : Maybe String -> List Category -> List Category
filterCategoriesByGenre maybeGenre categories =
    case maybeGenre of
        Nothing ->
            categories

        Just genre ->
            categories
                |> List.map
                    (\category ->
                        { category
                            | items = List.filter (itemHasGenre genre) category.items
                        }
                    )
                |> List.filter (\category -> not (List.isEmpty category.items))


{-| Filter categories based on media type
-}
filterCategoriesByType : Maybe MediaType -> List Category -> List Category
filterCategoriesByType maybeType categories =
    case maybeType of
        Nothing ->
            categories

        Just mediaType ->
            categories
                |> List.map
                    (\category ->
                        { category
                            | items = List.filter (\item -> item.type_ == mediaType) category.items
                        }
                    )
                |> List.filter (\category -> not (List.isEmpty category.items))
