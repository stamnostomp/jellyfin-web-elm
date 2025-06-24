module MediaDetail exposing (Model, Msg(..), init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import JellyfinAPI exposing (CastMember, CrewMember, MediaDetail, MediaType(..))
import Theme



-- MODEL


type alias Model =
    { mediaDetail : Maybe MediaDetail
    , isLoading : Bool
    , error : Maybe String
    }


init : ( Model, Cmd Msg )
init =
    ( { mediaDetail = Nothing
      , isLoading = False
      , error = Nothing
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = FetchMediaDetail String
    | MediaDetailReceived (Result String MediaDetail)
    | CloseDetail
    | PlayMedia String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchMediaDetail mediaId ->
            ( { model | isLoading = True, error = Nothing }
            , Cmd.none
              -- In a real app, we would fetch the details from the API
            )

        MediaDetailReceived result ->
            case result of
                Ok detail ->
                    ( { model | mediaDetail = Just detail, isLoading = False, error = Nothing }
                    , Cmd.none
                    )

                Err error ->
                    ( { model | error = Just error, isLoading = False }
                    , Cmd.none
                    )

        CloseDetail ->
            ( { model | mediaDetail = Nothing, error = Nothing }
            , Cmd.none
            )

        PlayMedia _ ->
            -- In a real app, this would trigger the playback
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ if model.isLoading then
            viewLoading

          else
            case model.mediaDetail of
                Just detail ->
                    viewMediaDetail detail

                Nothing ->
                    case model.error of
                        Just errorMsg ->
                            viewError errorMsg

                        Nothing ->
                            text ""
        ]


viewLoading : Html Msg
viewLoading =
    div [ class "fixed inset-0 bg-background-dark bg-opacity-80 flex items-center justify-center z-50" ]
        [ div [ class "text-primary text-lg" ]
            [ text "Loading..." ]
        ]


viewError : String -> Html Msg
viewError errorMsg =
    div [ class "fixed inset-0 bg-background-dark bg-opacity-80 flex items-center justify-center z-50" ]
        [ div [ class "bg-surface p-4 rounded-lg max-w-lg w-full" ]
            [ h2 (Theme.text Theme.Heading2 ++ [ class "text-error" ])
                [ text "Error" ]
            , p (Theme.text Theme.Body ++ [ class "my-3" ])
                [ text errorMsg ]
            , div [ class "flex justify-end" ]
                [ button
                    (Theme.button Theme.Primary ++ [ onClick CloseDetail ])
                    [ text "Close" ]
                ]
            ]
        ]


viewMediaDetail : MediaDetail -> Html Msg
viewMediaDetail detail =
    div [ class "fixed inset-0 bg-background-dark bg-opacity-80 flex items-center justify-center z-50 p-2 overflow-y-auto" ]
        [ div [ class "bg-surface rounded-lg max-w-4xl w-full shadow-lg relative" ]
            [ button
                [ class "absolute top-2 right-2 text-text-secondary hover:text-text-primary z-10"
                , onClick CloseDetail
                ]
                [ text "✕" ]
            , div [ class "md:flex" ]
                [ div [ class "md:w-1/3 p-3" ]
                    [ div [ class "relative pt-[150%] bg-background-light rounded-md overflow-hidden" ]
                        [ img
                            [ src detail.imageUrl
                            , alt detail.title
                            , class "absolute inset-0 w-full h-full object-cover"
                            , attribute "onerror" "this.style.display='none'; this.nextElementSibling.style.display='flex';"
                            ]
                            []
                        , div
                            [ class "absolute inset-0 flex items-center justify-center bg-background-light text-primary-light"
                            , style "display" "none"
                            ]
                            [ div [ class "text-6xl" ] [ text "🎬" ] ]
                        , div
                            [ class "absolute inset-0"
                            , style "background-image" "linear-gradient(rgba(28, 28, 28, 0.0), rgba(28, 28, 28, 0.3))"
                            ]
                            []
                        ]
                    , button
                        (Theme.button Theme.Primary
                            ++ [ class "w-full mt-2"
                               , onClick (PlayMedia detail.id)
                               ]
                        )
                        [ text "Play" ]
                    , if detail.type_ == TVShow then
                        button
                            (Theme.button Theme.Ghost ++ [ class "w-full mt-1" ])
                            [ text "View Episodes" ]

                      else
                        text ""
                    ]
                , div [ class "md:w-2/3 p-3" ]
                    [ h1 (Theme.text Theme.Heading1)
                        [ text detail.title ]
                    , div [ class "flex flex-wrap items-center space-x-1 mt-1" ]
                        [ span (Theme.text Theme.Caption)
                            [ text (String.fromInt detail.year) ]
                        , span (Theme.text Theme.Caption)
                            [ text "•" ]
                        , span (Theme.text Theme.Caption)
                            [ text (mediaTypeToString detail.type_) ]
                        , span (Theme.text Theme.Caption)
                            [ text "•" ]
                        , span (Theme.text Theme.Caption)
                            [ text (formatDuration detail.duration) ]
                        , span (Theme.text Theme.Caption ++ [ class "text-warning" ])
                            [ text ("★ " ++ String.fromFloat detail.rating) ]
                        ]
                    , div [ class "mt-2" ]
                        [ h3 (Theme.text Theme.Label)
                            [ text "Genres" ]
                        , div [ class "flex flex-wrap gap-1 mt-1" ]
                            (List.map viewGenre detail.genres)
                        ]
                    , div [ class "mt-2" ]
                        [ h3 (Theme.text Theme.Label)
                            [ text "Overview" ]
                        , p (Theme.text Theme.Body ++ [ class "mt-1" ])
                            [ text detail.description ]
                        ]
                    , div [ class "mt-2" ]
                        [ h3 (Theme.text Theme.Label)
                            [ text "Cast" ]
                        , div [ class "grid grid-cols-2 gap-1 mt-1" ]
                            (List.take 6 (List.map viewCastMember detail.actors))
                        ]
                    , div [ class "mt-2" ]
                        [ h3 (Theme.text Theme.Label)
                            [ text "Directors" ]
                        , div [ class "flex flex-wrap gap-1 mt-1" ]
                            (List.map viewCrewMember detail.directors)
                        ]
                    ]
                ]
            ]
        ]


viewGenre : String -> Html Msg
viewGenre genre =
    span [ class "bg-background-light px-2 py-0.5 rounded text-text-secondary text-xs" ]
        [ text genre ]



-- Updated to display cast member with character name


viewCastMember : CastMember -> Html Msg
viewCastMember cast =
    div [ class "flex items-center space-x-1" ]
        [ div
            [ class "w-8 h-8 rounded-full bg-background-light flex items-center justify-center text-xs overflow-hidden" ]
            [ case cast.profileUrl of
                Just url ->
                    img [ src url, alt cast.name, class "w-full h-full object-cover" ] []

                Nothing ->
                    text (String.left 1 cast.name)
            ]
        , div [ class "flex flex-col" ]
            [ span (Theme.text Theme.Body ++ [ class "text-sm" ])
                [ text cast.name ]
            , span (Theme.text Theme.Caption ++ [ class "text-xs text-text-secondary" ])
                [ text cast.character ]
            ]
        ]



-- Updated to display crew member with job


viewCrewMember : CrewMember -> Html Msg
viewCrewMember crew =
    div [ class "flex items-center space-x-1" ]
        [ div
            [ class "w-7 h-7 rounded-full bg-background-light flex items-center justify-center text-xs overflow-hidden" ]
            [ case crew.profileUrl of
                Just url ->
                    img [ src url, alt crew.name, class "w-full h-full object-cover" ] []

                Nothing ->
                    text (String.left 1 crew.name)
            ]
        , div [ class "flex flex-col" ]
            [ span (Theme.text Theme.Body ++ [ class "text-sm" ])
                [ text crew.name ]
            , span (Theme.text Theme.Caption ++ [ class "text-xs text-text-secondary" ])
                [ text crew.job ]
            ]
        ]



-- HELPERS


formatDuration : Int -> String
formatDuration minutes =
    let
        hours =
            minutes // 60

        mins =
            modBy 60 minutes
    in
    if hours > 0 then
        String.fromInt hours ++ "h " ++ String.fromInt mins ++ "m"

    else
        String.fromInt mins ++ "m"


mediaTypeToString : MediaType -> String
mediaTypeToString mediaType =
    case mediaType of
        Movie ->
            "Movie"

        TVShow ->
            "TV Show"

        Music ->
            "Music"
