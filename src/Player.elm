port module Player exposing (Model, Msg(..), init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, onInput, onMouseEnter, onMouseLeave)
import Icon
import JellyfinAPI exposing (MediaItem, MediaType(..))
import Json.Decode as Decode
import Theme
import Time



-- PORTS for JavaScript interop


port requestFullscreen : () -> Cmd msg


port exitFullscreen : () -> Cmd msg


port fullscreenChanged : (Bool -> msg) -> Sub msg



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
    , hoverTime : Maybe Float -- Time at hover position
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
      , hoverTime = Nothing
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
    | FullscreenChanged Bool
    | SetPlaybackRate Float
    | UpdateTime Float
    | ShowControls
    | HideControls
    | AutoHideControls
    | ExitPlayer
    | NextEpisode
    | PreviousEpisode
    | HoverProgress Float Float -- offsetX, width
    | LeaveProgress


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
            if model.isFullscreen then
                ( model, exitFullscreen () )

            else
                ( model, requestFullscreen () )

        FullscreenChanged isFullscreen ->
            ( { model | isFullscreen = isFullscreen }
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

        AutoHideControls ->
            -- Auto-hide only if playing
            if model.isPlaying then
                ( { model | showControls = False }
                , Cmd.none
                )

            else
                ( model, Cmd.none )

        ExitPlayer ->
            let
                exitCmd =
                    if model.isFullscreen then
                        exitFullscreen ()

                    else
                        Cmd.none
            in
            ( { model | currentMedia = Nothing, isPlaying = False, currentTime = 0.0 }
            , exitCmd
            )

        NextEpisode ->
            -- In a real app, this would load the next episode
            ( model, Cmd.none )

        PreviousEpisode ->
            -- In a real app, this would load the previous episode
            ( model, Cmd.none )

        HoverProgress offsetX width ->
            let
                -- Calculate the time based on mouse position
                percentage =
                    offsetX / width

                time =
                    percentage * model.duration
            in
            ( { model | hoverTime = Just time }, Cmd.none )

        LeaveProgress ->
            ( { model | hoverTime = Nothing }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ if model.isPlaying then
            Time.every 1000 (\_ -> UpdateTime 1.0)

          else
            Sub.none
        , fullscreenChanged FullscreenChanged
        , if model.showControls && model.isPlaying then
            Time.every 3000 (\_ -> AutoHideControls)

          else
            Sub.none
        ]



-- VIEW


view : Model -> Html Msg
view model =
    case model.currentMedia of
        Just media ->
            div
                [ class "fixed inset-0 bg-background z-50"
                , on "mousemove" (Decode.succeed ShowControls)
                , id "player-container" -- Add ID for JavaScript targeting
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
        [ class "w-full h-full bg-background-dark flex items-center justify-center relative"
        , onClick TogglePlayPause
        , onMouseEnter ShowControls
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
                        , style "filter" "blur(20px)"
                        , alt media.title
                        ]
                        []

                Nothing ->
                    text ""

            -- Play/pause overlay
            , if model.showControls then
                div
                    [ class "absolute inset-0 flex items-center justify-center z-10" ]
                    [ button
                        [ class "bg-background-dark bg-opacity-70 rounded-2xl w-32 h-32 flex items-center justify-center text-primary hover:bg-opacity-90 transition-all duration-300"
                        , onClick TogglePlayPause
                        ]
                        [ if model.isPlaying then
                            Icon.view [ class "text-6xl" ] Icon.pauseSimple

                          else
                            Icon.view [ class "text-6xl" ] Icon.playArrow
                        ]
                    ]

              else
                text ""

            -- Media info overlay
            , div
                [ class "absolute top-4 left-4 right-4 z-10" ]
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
                                   , class "text-white hover:text-error flex items-center space-x-2"
                                   ]
                            )
                            [ Icon.view [ class "text-2xl" ] Icon.close
                            , text "Exit"
                            ]
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
        [ class <|
            "absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black via-black/95 to-transparent py-4 pb-6 z-10"
                ++ (if model.isFullscreen then
                        ""

                    else
                        ""
                   )
        , onMouseEnter ShowControls
        ]
        [ -- Progress bar - full width
          div [ class "mb-4 px-8" ]
            [ div [ class "flex items-center space-x-3" ]
                [ span [ class "text-white/80 text-xs font-medium min-w-[45px] text-right" ]
                    [ text (formatTime model.currentTime) ]
                , div [ class "flex-1 group relative" ]
                    [ input
                        [ type_ "range"
                        , value (String.fromFloat model.currentTime)
                        , Html.Attributes.min "0"
                        , Html.Attributes.max (String.fromFloat model.duration)
                        , step "1"
                        , class "w-full h-1 bg-white/20 rounded-full appearance-none cursor-pointer hover:h-1.5 transition-all duration-200"
                        , style "background" ("linear-gradient(to right, rgb(95, 135, 175) 0%, rgb(95, 135, 175) " ++ String.fromFloat ((model.currentTime / model.duration) * 100) ++ "%, rgba(255,255,255,0.2) " ++ String.fromFloat ((model.currentTime / model.duration) * 100) ++ "%, rgba(255,255,255,0.2) 100%)")
                        , onInput (String.toFloat >> Maybe.withDefault 0.0 >> Seek)
                        , onProgressHover
                        , onMouseLeave LeaveProgress
                        ]
                        []
                    -- Hover tooltip bubble
                    , case model.hoverTime of
                        Just time ->
                            let
                                -- Position tooltip based on hover percentage
                                percentage =
                                    (time / model.duration) * 100
                            in
                            div
                                [ class "absolute -top-10 pointer-events-none whitespace-nowrap"
                                , style "left" (String.fromFloat percentage ++ "%")
                                , style "transform" "translateX(-50%)"
                                ]
                                [ -- Bubble
                                  div
                                    [ class "bg-black text-white text-xs font-semibold px-3 py-1.5 rounded-lg shadow-lg" ]
                                    [ text (formatTime time) ]
                                -- Arrow pointing down
                                , div
                                    [ class "w-0 h-0 mx-auto"
                                    , style "border-left" "4px solid transparent"
                                    , style "border-right" "4px solid transparent"
                                    , style "border-top" "4px solid black"
                                    ]
                                    []
                                ]

                        Nothing ->
                            text ""
                    ]
                , span [ class "text-white/80 text-xs font-medium min-w-[45px]" ]
                    [ text (formatTime model.duration) ]
                ]
            ]

        -- Control buttons - constrained width
        , div [ class "flex items-center justify-between px-16" ]
            [ -- Left controls - playback
              div [ class "flex items-center space-x-4" ]
                [ -- Rewind
                  button
                    [ class "w-8 h-8 rounded-lg text-white/70 hover:text-white hover:bg-white/10 flex items-center justify-center transition-all duration-200"
                    , onClick (Seek (model.currentTime - 10))
                    ]
                    [ Icon.view [ class "text-lg" ] Icon.fastRewind
                    ]

                -- Play/Pause - larger and more prominent
                , button
                    [ class "w-12 h-12 rounded-lg bg-white/15 hover:bg-white/25 flex items-center justify-center text-white transition-all duration-200 backdrop-blur-sm hover:scale-105"
                    , onClick TogglePlayPause
                    ]
                    [ if model.isPlaying then
                        Icon.view [ class "text-2xl" ] Icon.pauseSimple
                      else
                        Icon.view [ class "text-2xl" ] Icon.playArrow
                    ]

                -- Fast forward
                , button
                    [ class "w-8 h-8 rounded-lg text-white/70 hover:text-white hover:bg-white/10 flex items-center justify-center transition-all duration-200"
                    , onClick (Seek (model.currentTime + 10))
                    ]
                    [ Icon.view [ class "text-lg" ] Icon.fastForward
                    ]

                -- Next episode (for TV shows)
                , if media.type_ == TVShow then
                    button
                        [ class "w-8 h-8 rounded-lg text-white/70 hover:text-white hover:bg-white/10 flex items-center justify-center transition-all duration-200"
                        , onClick NextEpisode
                        ]
                        [ Icon.view [ class "text-lg" ] Icon.skipForward ]
                  else
                    text ""
                ]

            -- Right controls - settings
            , div [ class "flex items-center space-x-3" ]
                [ -- Playback rate - minimal dropdown
                  select
                    [ class "bg-white/10 hover:bg-white/20 backdrop-blur-sm border-0 rounded-lg px-2 py-1 text-white text-xs font-medium cursor-pointer transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-primary/50"
                    , onInput (String.toFloat >> Maybe.withDefault 1.0 >> SetPlaybackRate)
                    ]
                    [ option [ value "0.5", selected (model.playbackRate == 0.5) ] [ text "0.5×" ]
                    , option [ value "0.75", selected (model.playbackRate == 0.75) ] [ text "0.75×" ]
                    , option [ value "1.0", selected (model.playbackRate == 1.0) ] [ text "1×" ]
                    , option [ value "1.25", selected (model.playbackRate == 1.25) ] [ text "1.25×" ]
                    , option [ value "1.5", selected (model.playbackRate == 1.5) ] [ text "1.5×" ]
                    , option [ value "2.0", selected (model.playbackRate == 2.0) ] [ text "2×" ]
                    ]

                -- Volume control - cleaner
                , div [ class "flex items-center space-x-2 group" ]
                    [ button
                        [ class "w-8 h-8 rounded-lg text-white/80 hover:text-white hover:bg-white/10 flex items-center justify-center transition-all duration-200"
                        , onClick ToggleMute
                        ]
                        [ if model.isMuted || model.volume == 0 then
                            Icon.view [ class "text-lg" ] Icon.volumeOff
                          else if model.volume < 0.5 then
                            Icon.view [ class "text-lg" ] Icon.volumeDown
                          else
                            Icon.view [ class "text-lg" ] Icon.volumeUp
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
                        , step "0.05"
                        , class "w-20 h-1 bg-white/20 rounded-full appearance-none cursor-pointer opacity-0 group-hover:opacity-100 transition-opacity duration-200"
                        , style "background" ("linear-gradient(to right, white 0%, white " ++ String.fromFloat (model.volume * 100) ++ "%, rgba(255,255,255,0.2) " ++ String.fromFloat (model.volume * 100) ++ "%, rgba(255,255,255,0.2) 100%)")
                        , onInput (String.toFloat >> Maybe.withDefault 0.0 >> SetVolume)
                        ]
                        []
                    ]

                -- Fullscreen toggle
                , button
                    [ class "w-8 h-8 rounded-lg text-white/80 hover:text-white hover:bg-white/10 flex items-center justify-center transition-all duration-200"
                    , onClick ToggleFullscreen
                    ]
                    [ if model.isFullscreen then
                        Icon.view [ class "text-lg" ] Icon.fullscreenExit
                      else
                        Icon.view [ class "text-lg" ] Icon.fullscreen
                    ]
                ]
            ]
        ]



-- HELPERS


{-| Decode mouse move events to get offsetX and target width
-}
onProgressHover : Attribute Msg
onProgressHover =
    on "mousemove"
        (Decode.map2 HoverProgress
            (Decode.at [ "offsetX" ] Decode.float)
            (Decode.at [ "target", "offsetWidth" ] Decode.float)
        )


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
