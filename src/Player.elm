module Player exposing (Model, Msg(..), init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import JellyfinAPI exposing (MediaItem, MediaType(..))
import Theme
import Time



-- MODEL


type alias Model =
    { currentMedia : Maybe MediaItem
    , isPlaying : Bool
    , currentTime : Float -- in seconds
    , duration : Float -- in seconds
    , volume : Float -- 0.0 to 1.0
    , isMuted : Bool
    , isFullscreen : Bool
    , showControls : Bool
    , playbackRate : Float
    }


init : ( Model, Cmd Msg )
init =
    ( { currentMedia = Nothing
      , isPlaying = False
      , currentTime = 0.0
      , duration = 0.0
      , volume = 1.0
      , isMuted = False
      , isFullscreen = False
      , showControls = True
      , playbackRate = 1.0
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = LoadMedia MediaItem
    | TogglePlayPause
    | Seek Float
    | SetVolume Float
    | ToggleMute
    | ToggleFullscreen
    | SetPlaybackRate Float
    | UpdateTime Float
    | ShowControls
    | HideControls
    | ExitPlayer
    | NextEpisode
    | PreviousEpisode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadMedia mediaItem ->
            let
                -- Simulate duration based on media type
                estimatedDuration =
                    case mediaItem.type_ of
                        Movie ->
                            7200.0

                        -- 2 hours
                        TVShow ->
                            2700.0

                        -- 45 minutes
                        Music ->
                            180.0

                -- 3 minutes
            in
            ( { model
                | currentMedia = Just mediaItem
                , isPlaying = True
                , currentTime = 0.0
                , duration = estimatedDuration
                , showControls = True
              }
            , Cmd.none
            )

        TogglePlayPause ->
            ( { model | isPlaying = not model.isPlaying }
            , Cmd.none
            )

        Seek time ->
            ( { model | currentTime = Basics.max 0.0 (Basics.min model.duration time) }
            , Cmd.none
            )

        SetVolume volume ->
            ( { model | volume = Basics.max 0.0 (Basics.min 1.0 volume), isMuted = False }
            , Cmd.none
            )

        ToggleMute ->
            ( { model | isMuted = not model.isMuted }
            , Cmd.none
            )

        ToggleFullscreen ->
            ( { model | isFullscreen = not model.isFullscreen }
            , Cmd.none
            )

        SetPlaybackRate rate ->
            ( { model | playbackRate = rate }
            , Cmd.none
            )

        UpdateTime time ->
            let
                newTime =
                    if model.isPlaying then
                        Basics.min model.duration (model.currentTime + time)

                    else
                        model.currentTime
            in
            ( { model | currentTime = newTime }
            , Cmd.none
            )

        ShowControls ->
            ( { model | showControls = True }
            , Cmd.none
            )

        HideControls ->
            ( { model | showControls = False }
            , Cmd.none
            )

        ExitPlayer ->
            ( { model | currentMedia = Nothing, isPlaying = False, currentTime = 0.0 }
            , Cmd.none
            )

        NextEpisode ->
            -- In a real app, this would load the next episode
            ( model, Cmd.none )

        PreviousEpisode ->
            -- In a real app, this would load the previous episode
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.isPlaying then
        Time.every 1000 (\_ -> UpdateTime 1.0)

    else
        Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    case model.currentMedia of
        Just media ->
            div
                [ class "fixed inset-0 bg-background z-50 flex flex-col"
                , onMouseOver ShowControls
                ]
                [ viewPlayerArea model media
                , if model.showControls then
                    viewPlayerControls model media

                  else
                    text ""
                ]

        Nothing ->
            text ""


viewPlayerArea : Model -> MediaItem -> Html Msg
viewPlayerArea model media =
    div
        [ class "flex-1 relative bg-background-dark flex items-center justify-center"
        , onClick TogglePlayPause
        ]
        [ -- Video placeholder area
          div
            [ class "w-full h-full flex items-center justify-center relative" ]
            [ -- Background image if available
              case media.backdropUrl of
                Just backdropUrl ->
                    img
                        [ src backdropUrl
                        , class "absolute inset-0 w-full h-full object-cover opacity-30"
                        , alt media.title
                        ]
                        []

                Nothing ->
                    text ""

            -- Play/pause overlay
            , if model.showControls then
                div
                    [ class "absolute inset-0 flex items-center justify-center" ]
                    [ button
                        [ class "bg-background-dark bg-opacity-70 rounded-full w-20 h-20 flex items-center justify-center text-primary hover:bg-opacity-90 transition-all duration-300"
                        , onClick TogglePlayPause
                        ]
                        [ if model.isPlaying then
                            span [ class "text-3xl" ] [ text "⏸" ]

                          else
                            span [ class "text-3xl ml-1" ] [ text "▶" ]
                        ]
                    ]

              else
                text ""

            -- Media info overlay
            , div
                [ class "absolute top-4 left-4 right-4" ]
                [ if model.showControls then
                    div
                        [ class "flex justify-between items-start" ]
                        [ div []
                            [ h1 (Theme.text Theme.Heading1 ++ [ class "text-white mb-2" ])
                                [ text media.title ]
                            , div [ class "flex items-center space-x-4 text-white" ]
                                [ span (Theme.text Theme.Body)
                                    [ text (String.fromInt media.year) ]
                                , if media.rating > 0 then
                                    span (Theme.text Theme.Body ++ [ class "text-warning" ])
                                        [ text ("★ " ++ String.fromFloat media.rating) ]

                                  else
                                    text ""
                                , if List.length media.genres > 0 then
                                    span (Theme.text Theme.Body)
                                        [ text (String.join ", " (List.take 3 media.genres)) ]

                                  else
                                    text ""
                                ]
                            ]
                        , button
                            (Theme.button Theme.Ghost
                                ++ [ onClick ExitPlayer
                                   , class "text-white hover:text-error"
                                   ]
                            )
                            [ text "✕ Exit" ]
                        ]

                  else
                    text ""
                ]

            -- Loading indicator when not playing
            , if not model.isPlaying && model.currentTime == 0.0 then
                div
                    [ class "absolute inset-0 flex items-center justify-center" ]
                    [ div
                        [ class "text-primary text-xl" ]
                        [ text "Loading..." ]
                    ]

              else
                text ""
            ]
        ]


viewPlayerControls : Model -> MediaItem -> Html Msg
viewPlayerControls model media =
    div
        [ class "bg-surface border-t border-background-light p-4" ]
        [ -- Progress bar
          div [ class "mb-4" ]
            [ div [ class "flex items-center space-x-2 text-text-secondary text-sm mb-2" ]
                [ span [] [ text (formatTime model.currentTime) ]
                , div [ class "flex-1" ]
                    [ input
                        [ type_ "range"
                        , value (String.fromFloat model.currentTime)
                        , Html.Attributes.min "0"
                        , Html.Attributes.max (String.fromFloat model.duration)
                        , step "1"
                        , class "w-full h-2 bg-background-light rounded-lg appearance-none cursor-pointer progress-bar"
                        , onInput (String.toFloat >> Maybe.withDefault 0.0 >> Seek)
                        ]
                        []
                    ]
                , span [] [ text (formatTime model.duration) ]
                ]
            ]

        -- Control buttons
        , div [ class "flex items-center justify-between" ]
            [ -- Left controls
              div [ class "flex items-center space-x-4" ]
                [ -- Previous episode (for TV shows)
                  if media.type_ == TVShow then
                    button
                        (Theme.button Theme.Ghost ++ [ onClick PreviousEpisode ])
                        [ text "⏮" ]

                  else
                    text ""

                -- Rewind
                , button
                    (Theme.button Theme.Ghost ++ [ onClick (Seek (model.currentTime - 30)) ])
                    [ text "↶ 30s" ]

                -- Play/Pause
                , button
                    (Theme.button Theme.Primary ++ [ onClick TogglePlayPause, class "w-12 h-12" ])
                    [ if model.isPlaying then
                        text "⏸"

                      else
                        text "▶"
                    ]

                -- Fast forward
                , button
                    (Theme.button Theme.Ghost ++ [ onClick (Seek (model.currentTime + 30)) ])
                    [ text "30s ↷" ]

                -- Next episode (for TV shows)
                , if media.type_ == TVShow then
                    button
                        (Theme.button Theme.Ghost ++ [ onClick NextEpisode ])
                        [ text "⏭" ]

                  else
                    text ""
                ]

            -- Center info
            , div [ class "flex items-center space-x-4" ]
                [ -- Playback rate
                  div [ class "flex items-center space-x-2" ]
                    [ span (Theme.text Theme.Label) [ text "Speed:" ]
                    , select
                        [ class "bg-background border border-background-light rounded py-1 px-2 text-text-primary"
                        , onInput (String.toFloat >> Maybe.withDefault 1.0 >> SetPlaybackRate)
                        ]
                        [ option [ value "0.5", selected (model.playbackRate == 0.5) ] [ text "0.5x" ]
                        , option [ value "0.75", selected (model.playbackRate == 0.75) ] [ text "0.75x" ]
                        , option [ value "1.0", selected (model.playbackRate == 1.0) ] [ text "1.0x" ]
                        , option [ value "1.25", selected (model.playbackRate == 1.25) ] [ text "1.25x" ]
                        , option [ value "1.5", selected (model.playbackRate == 1.5) ] [ text "1.5x" ]
                        , option [ value "2.0", selected (model.playbackRate == 2.0) ] [ text "2.0x" ]
                        ]
                    ]
                ]

            -- Right controls
            , div [ class "flex items-center space-x-4" ]
                [ -- Volume control
                  div [ class "flex items-center space-x-2" ]
                    [ button
                        (Theme.button Theme.Ghost ++ [ onClick ToggleMute ])
                        [ if model.isMuted || model.volume == 0 then
                            text "🔇"

                          else if model.volume < 0.5 then
                            text "🔉"

                          else
                            text "🔊"
                        ]
                    , input
                        [ type_ "range"
                        , value
                            (String.fromFloat
                                (if model.isMuted then
                                    0

                                 else
                                    model.volume
                                )
                            )
                        , Html.Attributes.min "0"
                        , Html.Attributes.max "1"
                        , step "0.1"
                        , class "w-20 h-2 bg-background-light rounded-lg appearance-none cursor-pointer"
                        , onInput (String.toFloat >> Maybe.withDefault 0.0 >> SetVolume)
                        ]
                        []
                    ]

                -- Fullscreen toggle
                , button
                    (Theme.button Theme.Ghost ++ [ onClick ToggleFullscreen ])
                    [ if model.isFullscreen then
                        text "⛶"

                      else
                        text "⛶"
                    ]
                ]
            ]
        ]



-- HELPERS


formatTime : Float -> String
formatTime seconds =
    let
        totalSeconds =
            round seconds

        hours =
            totalSeconds // 3600

        minutes =
            (totalSeconds // 60) |> modBy 60

        secs =
            totalSeconds |> modBy 60

        padZero n =
            if n < 10 then
                "0" ++ String.fromInt n

            else
                String.fromInt n
    in
    if hours > 0 then
        String.fromInt hours ++ ":" ++ padZero minutes ++ ":" ++ padZero secs

    else
        String.fromInt minutes ++ ":" ++ padZero secs
