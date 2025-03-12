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
    }

init : ( Model, Cmd Msg )
init =
    let
        ( mediaDetailModel, mediaDetailCmd ) =
            MediaDetail.init

        ( serverSettingsModel, serverSettingsCmd ) =
            ServerSettings.init
    in
    ( { categories = mockCategories ++ mockLibraryCategories
      , searchQuery = ""
      , selectedCategory = Nothing
      , isLoading = False
      , serverConfig = defaultServerConfig
      , mediaDetailModel = mediaDetailModel
      , serverSettingsModel = serverSettingsModel
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

-- New mock library categories to replace sidebar navigation
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
                [ ServerSettings.view
                    model.serverSettingsModel
                    ServerSettingsMsg
                    UpdateServerConfig
                , button (Theme.button Theme.Primary)
                    [ text "Sign In" ]
                ]
            ]
        ]

viewContent : Model -> Html Msg
viewContent model =
    div [ class "px-4 md:px-6 lg:px-8 max-w-screen-2xl mx-auto space-y-10 mb-8" ]
        (case model.selectedCategory of
            Just categoryId ->
                -- View a specific category in detail
                case findCategory categoryId model.categories of
                    Just category ->
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
                        [ text "Category not found" ]

            Nothing ->
                -- View all categories
                List.map (viewCategory model.searchQuery) (filterCategories model.searchQuery model.categories)
        )

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

viewLoading : Html Msg
viewLoading =
    div [ class "flex justify-center items-center h-64" ]
        [ div [ class "text-primary text-xl" ]
            [ text "Loading..." ]
        ]

-- HELPERS

findCategory : String -> List Category -> Maybe Category
findCategory categoryId categories =
    List.filter (\cat -> cat.id == categoryId) categories
        |> List.head

mediaTypeToString : MediaType -> String
mediaTypeToString mediaType =
    case mediaType of
        Movie -> "Movie"
        TVShow -> "TV Show"
        Music -> "Music"
