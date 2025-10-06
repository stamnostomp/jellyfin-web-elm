module UserSettings exposing (Model, Msg(..), init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Icon
import Theme



-- MODEL


type alias Model =
    { currentView : SettingsView
    , user : UserProfile
    , displaySettings : DisplaySettings
    , playbackSettings : PlaybackSettings
    , subtitleSettings : SubtitleSettings
    , homeScreenSettings : HomeScreenSettings
    }


type SettingsView
    = ProfileView
    | DisplayView
    | PlaybackView
    | SubtitlesView
    | HomeScreenView
    | LanguagesView
    | PasswordView


type alias UserProfile =
    { username : String
    , email : String
    , avatarUrl : Maybe String
    , isAdmin : Bool
    }


type alias DisplaySettings =
    { theme : String
    , backdropBlur : Int
    , enableBackdrops : Bool
    , showYearInTitles : Bool
    , detailsBanner : Bool
    , disableCinematicVideos : Bool
    }


type alias PlaybackSettings =
    { maxStreamingBitrate : Int
    , videoQuality : String
    , audioMode : String
    , skipIntroButton : Bool
    , nextUpSuggestions : Bool
    , rememberAudioSelection : Bool
    , rememberSubtitleSelection : Bool
    }


type alias SubtitleSettings =
    { subtitleMode : String
    , subtitleLanguage : String
    , fontSize : Int
    , textColor : String
    , backgroundColor : String
    , textOpacity : Int
    , backgroundOpacity : Int
    , position : String
    }


type alias HomeScreenSettings =
    { showContinueWatching : Bool
    , showNextUp : Bool
    , showLatestMedia : Bool
    , showRecommendations : Bool
    , sectionsOrder : List String
    }


init : ( Model, Cmd Msg )
init =
    ( { currentView = ProfileView
      , user =
            { username = "Administrator"
            , email = "admin@jellyfin.org"
            , avatarUrl = Nothing
            , isAdmin = True
            }
      , displaySettings =
            { theme = "Dark"
            , backdropBlur = 20
            , enableBackdrops = True
            , showYearInTitles = True
            , detailsBanner = True
            , disableCinematicVideos = False
            }
      , playbackSettings =
            { maxStreamingBitrate = 120000000
            , videoQuality = "Auto"
            , audioMode = "Auto"
            , skipIntroButton = True
            , nextUpSuggestions = True
            , rememberAudioSelection = True
            , rememberSubtitleSelection = True
            }
      , subtitleSettings =
            { subtitleMode = "OnlyForced"
            , subtitleLanguage = "English"
            , fontSize = 100
            , textColor = "#FFFFFF"
            , backgroundColor = "#000000"
            , textOpacity = 100
            , backgroundOpacity = 50
            , position = "Bottom"
            }
      , homeScreenSettings =
            { showContinueWatching = True
            , showNextUp = True
            , showLatestMedia = True
            , showRecommendations = True
            , sectionsOrder = [ "continue", "nextup", "latest", "recommendations" ]
            }
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = ChangeView SettingsView
    | CloseSettings
    | UpdateUsername String
    | UpdateEmail String
    | UpdateTheme String
    | UpdateBackdropBlur Int
    | ToggleBackdrops
    | ToggleYearInTitles
    | ToggleDetailsBanner
    | ToggleCinematicVideos
    | UpdateMaxBitrate Int
    | UpdateVideoQuality String
    | UpdateAudioMode String
    | ToggleSkipIntro
    | ToggleNextUpSuggestions
    | ToggleRememberAudio
    | ToggleRememberSubtitles
    | UpdateSubtitleMode String
    | UpdateSubtitleLanguage String
    | UpdateSubtitleFontSize Int
    | UpdateSubtitleTextColor String
    | UpdateSubtitleBgColor String
    | UpdateSubtitleTextOpacity Int
    | UpdateSubtitleBgOpacity Int
    | UpdateSubtitlePosition String
    | ToggleContinueWatching
    | ToggleNextUp
    | ToggleLatestMedia
    | ToggleRecommendations
    | SaveSettings
    | ChangePassword String String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeView newView ->
            ( { model | currentView = newView }, Cmd.none )

        CloseSettings ->
            ( model, Cmd.none )

        UpdateUsername username ->
            let
                user =
                    model.user

                updatedUser =
                    { user | username = username }
            in
            ( { model | user = updatedUser }, Cmd.none )

        UpdateEmail email ->
            let
                user =
                    model.user

                updatedUser =
                    { user | email = email }
            in
            ( { model | user = updatedUser }, Cmd.none )

        UpdateTheme theme ->
            let
                display =
                    model.displaySettings

                updatedDisplay =
                    { display | theme = theme }
            in
            ( { model | displaySettings = updatedDisplay }, Cmd.none )

        UpdateBackdropBlur blur ->
            let
                display =
                    model.displaySettings

                updatedDisplay =
                    { display | backdropBlur = blur }
            in
            ( { model | displaySettings = updatedDisplay }, Cmd.none )

        ToggleBackdrops ->
            let
                display =
                    model.displaySettings

                updatedDisplay =
                    { display | enableBackdrops = not display.enableBackdrops }
            in
            ( { model | displaySettings = updatedDisplay }, Cmd.none )

        ToggleYearInTitles ->
            let
                display =
                    model.displaySettings

                updatedDisplay =
                    { display | showYearInTitles = not display.showYearInTitles }
            in
            ( { model | displaySettings = updatedDisplay }, Cmd.none )

        ToggleDetailsBanner ->
            let
                display =
                    model.displaySettings

                updatedDisplay =
                    { display | detailsBanner = not display.detailsBanner }
            in
            ( { model | displaySettings = updatedDisplay }, Cmd.none )

        ToggleCinematicVideos ->
            let
                display =
                    model.displaySettings

                updatedDisplay =
                    { display | disableCinematicVideos = not display.disableCinematicVideos }
            in
            ( { model | displaySettings = updatedDisplay }, Cmd.none )

        UpdateMaxBitrate bitrate ->
            let
                playback =
                    model.playbackSettings

                updatedPlayback =
                    { playback | maxStreamingBitrate = bitrate }
            in
            ( { model | playbackSettings = updatedPlayback }, Cmd.none )

        UpdateVideoQuality quality ->
            let
                playback =
                    model.playbackSettings

                updatedPlayback =
                    { playback | videoQuality = quality }
            in
            ( { model | playbackSettings = updatedPlayback }, Cmd.none )

        UpdateAudioMode mode ->
            let
                playback =
                    model.playbackSettings

                updatedPlayback =
                    { playback | audioMode = mode }
            in
            ( { model | playbackSettings = updatedPlayback }, Cmd.none )

        ToggleSkipIntro ->
            let
                playback =
                    model.playbackSettings

                updatedPlayback =
                    { playback | skipIntroButton = not playback.skipIntroButton }
            in
            ( { model | playbackSettings = updatedPlayback }, Cmd.none )

        ToggleNextUpSuggestions ->
            let
                playback =
                    model.playbackSettings

                updatedPlayback =
                    { playback | nextUpSuggestions = not playback.nextUpSuggestions }
            in
            ( { model | playbackSettings = updatedPlayback }, Cmd.none )

        ToggleRememberAudio ->
            let
                playback =
                    model.playbackSettings

                updatedPlayback =
                    { playback | rememberAudioSelection = not playback.rememberAudioSelection }
            in
            ( { model | playbackSettings = updatedPlayback }, Cmd.none )

        ToggleRememberSubtitles ->
            let
                playback =
                    model.playbackSettings

                updatedPlayback =
                    { playback | rememberSubtitleSelection = not playback.rememberSubtitleSelection }
            in
            ( { model | playbackSettings = updatedPlayback }, Cmd.none )

        UpdateSubtitleMode mode ->
            let
                subtitles =
                    model.subtitleSettings

                updatedSubtitles =
                    { subtitles | subtitleMode = mode }
            in
            ( { model | subtitleSettings = updatedSubtitles }, Cmd.none )

        UpdateSubtitleLanguage lang ->
            let
                subtitles =
                    model.subtitleSettings

                updatedSubtitles =
                    { subtitles | subtitleLanguage = lang }
            in
            ( { model | subtitleSettings = updatedSubtitles }, Cmd.none )

        UpdateSubtitleFontSize size ->
            let
                subtitles =
                    model.subtitleSettings

                updatedSubtitles =
                    { subtitles | fontSize = size }
            in
            ( { model | subtitleSettings = updatedSubtitles }, Cmd.none )

        UpdateSubtitleTextColor color ->
            let
                subtitles =
                    model.subtitleSettings

                updatedSubtitles =
                    { subtitles | textColor = color }
            in
            ( { model | subtitleSettings = updatedSubtitles }, Cmd.none )

        UpdateSubtitleBgColor color ->
            let
                subtitles =
                    model.subtitleSettings

                updatedSubtitles =
                    { subtitles | backgroundColor = color }
            in
            ( { model | subtitleSettings = updatedSubtitles }, Cmd.none )

        UpdateSubtitleTextOpacity opacity ->
            let
                subtitles =
                    model.subtitleSettings

                updatedSubtitles =
                    { subtitles | textOpacity = opacity }
            in
            ( { model | subtitleSettings = updatedSubtitles }, Cmd.none )

        UpdateSubtitleBgOpacity opacity ->
            let
                subtitles =
                    model.subtitleSettings

                updatedSubtitles =
                    { subtitles | backgroundOpacity = opacity }
            in
            ( { model | subtitleSettings = updatedSubtitles }, Cmd.none )

        UpdateSubtitlePosition position ->
            let
                subtitles =
                    model.subtitleSettings

                updatedSubtitles =
                    { subtitles | position = position }
            in
            ( { model | subtitleSettings = updatedSubtitles }, Cmd.none )

        ToggleContinueWatching ->
            let
                homeScreen =
                    model.homeScreenSettings

                updatedHomeScreen =
                    { homeScreen | showContinueWatching = not homeScreen.showContinueWatching }
            in
            ( { model | homeScreenSettings = updatedHomeScreen }, Cmd.none )

        ToggleNextUp ->
            let
                homeScreen =
                    model.homeScreenSettings

                updatedHomeScreen =
                    { homeScreen | showNextUp = not homeScreen.showNextUp }
            in
            ( { model | homeScreenSettings = updatedHomeScreen }, Cmd.none )

        ToggleLatestMedia ->
            let
                homeScreen =
                    model.homeScreenSettings

                updatedHomeScreen =
                    { homeScreen | showLatestMedia = not homeScreen.showLatestMedia }
            in
            ( { model | homeScreenSettings = updatedHomeScreen }, Cmd.none )

        ToggleRecommendations ->
            let
                homeScreen =
                    model.homeScreenSettings

                updatedHomeScreen =
                    { homeScreen | showRecommendations = not homeScreen.showRecommendations }
            in
            ( { model | homeScreenSettings = updatedHomeScreen }, Cmd.none )

        SaveSettings ->
            -- In real app, this would save to server
            ( model, Cmd.none )

        ChangePassword _ _ ->
            -- In real app, this would validate and change password
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "fixed inset-0 bg-background z-50 flex" ]
        [ viewSidebar model
        , viewMainContent model
        ]


viewSidebar : Model -> Html Msg
viewSidebar model =
    div [ class "w-64 bg-surface border-r border-background-light flex flex-col" ]
        [ div [ class "p-4 border-b border-background-light flex items-center justify-between" ]
            [ h2 (Theme.text Theme.Heading2 ++ [ class "text-primary" ])
                [ text "Settings" ]
            , button
                [ class "text-text-secondary hover:text-text-primary"
                , onClick CloseSettings
                ]
                [ Icon.view [ class "text-2xl" ] Icon.close ]
            ]
        , div [ class "flex-1 overflow-y-auto py-2" ]
            [ viewSidebarItem model ProfileView "User Profile" Icon.person
            , viewSidebarItem model DisplayView "Display" Icon.settings
            , viewSidebarItem model PlaybackView "Playback" Icon.playArrow
            , viewSidebarItem model SubtitlesView "Subtitles" Icon.subtitles
            , viewSidebarItem model HomeScreenView "Home Screen" Icon.home
            , viewSidebarItem model LanguagesView "Languages" Icon.language
            , viewSidebarItem model PasswordView "Password" Icon.lock
            ]
        , div [ class "p-4 border-t border-background-light" ]
            [ button
                (Theme.button Theme.Primary ++ [ class "w-full", onClick SaveSettings ])
                [ text "Save Changes" ]
            ]
        ]


viewSidebarItem : Model -> SettingsView -> String -> Icon.Icon -> Html Msg
viewSidebarItem model settingsView label icon =
    let
        isActive =
            model.currentView == settingsView

        baseClasses =
            "flex items-center space-x-3 px-4 py-3 cursor-pointer transition-colors"

        activeClasses =
            if isActive then
                " bg-primary bg-opacity-20 border-l-4 border-primary text-primary"

            else
                " hover:bg-background-light text-text-primary"
    in
    div
        [ class (baseClasses ++ activeClasses)
        , onClick (ChangeView settingsView)
        ]
        [ Icon.view [ class "text-xl" ] icon
        , span (Theme.text Theme.Body) [ text label ]
        ]


viewMainContent : Model -> Html Msg
viewMainContent model =
    div [ class "flex-1 overflow-y-auto bg-background" ]
        [ div [ class "max-w-4xl mx-auto p-8" ]
            [ case model.currentView of
                ProfileView ->
                    viewProfileSettings model

                DisplayView ->
                    viewDisplaySettings model

                PlaybackView ->
                    viewPlaybackSettings model

                SubtitlesView ->
                    viewSubtitleSettings model

                HomeScreenView ->
                    viewHomeScreenSettings model

                LanguagesView ->
                    viewLanguageSettings model

                PasswordView ->
                    viewPasswordSettings model
            ]
        ]


viewProfileSettings : Model -> Html Msg
viewProfileSettings model =
    div [ class "space-y-6" ]
        [ h1 (Theme.text Theme.Heading1 ++ [ class "mb-4" ])
            [ text "User Profile" ]
        , div [ class "bg-surface rounded-lg p-6 space-y-4" ]
            [ div []
                [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                    [ text "Username" ]
                , input
                    [ type_ "text"
                    , value model.user.username
                    , onInput UpdateUsername
                    , class "w-full bg-background border border-background-light rounded px-3 py-2 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary"
                    ]
                    []
                ]
            , div []
                [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                    [ text "Email" ]
                , input
                    [ type_ "email"
                    , value model.user.email
                    , onInput UpdateEmail
                    , class "w-full bg-background border border-background-light rounded px-3 py-2 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary"
                    ]
                    []
                ]
            , div []
                [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                    [ text "Profile Picture" ]
                , div [ class "flex items-center space-x-4" ]
                    [ div [ class "w-20 h-20 rounded-full bg-primary flex items-center justify-center text-2xl text-white" ]
                        [ text (String.left 1 model.user.username) ]
                    , button (Theme.button Theme.Secondary)
                        [ text "Change Avatar" ]
                    ]
                ]
            , if model.user.isAdmin then
                div [ class "bg-warning bg-opacity-10 border border-warning rounded p-3" ]
                    [ p (Theme.text Theme.Body ++ [ class "text-warning" ])
                        [ text "This account has administrator privileges" ]
                    ]

              else
                text ""
            ]
        ]


viewDisplaySettings : Model -> Html Msg
viewDisplaySettings model =
    div [ class "space-y-6" ]
        [ h1 (Theme.text Theme.Heading1 ++ [ class "mb-4" ])
            [ text "Display Settings" ]
        , div [ class "bg-surface rounded-lg p-6 space-y-6" ]
            [ div []
                [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                    [ text "Theme" ]
                , select
                    [ class "w-full bg-background border border-background-light rounded px-3 py-2 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary"
                    , onInput UpdateTheme
                    ]
                    [ option [ value "Dark", selected (model.displaySettings.theme == "Dark") ] [ text "Dark" ]
                    , option [ value "Light", selected (model.displaySettings.theme == "Light") ] [ text "Light" ]
                    , option [ value "Auto", selected (model.displaySettings.theme == "Auto") ] [ text "Auto" ]
                    ]
                ]
            , viewToggleSetting "Enable Backdrops" "Show backdrop images throughout the interface" model.displaySettings.enableBackdrops ToggleBackdrops
            , div []
                [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                    [ text ("Backdrop Blur: " ++ String.fromInt model.displaySettings.backdropBlur ++ "px") ]
                , input
                    [ type_ "range"
                    , Html.Attributes.min "0"
                    , Html.Attributes.max "50"
                    , value (String.fromInt model.displaySettings.backdropBlur)
                    , onInput (String.toInt >> Maybe.withDefault 20 >> UpdateBackdropBlur)
                    , class "w-full"
                    ]
                    []
                ]
            , viewToggleSetting "Show Year in Titles" "Display year in media titles" model.displaySettings.showYearInTitles ToggleYearInTitles
            , viewToggleSetting "Details Banner" "Show banner on details page" model.displaySettings.detailsBanner ToggleDetailsBanner
            , viewToggleSetting "Disable Cinematic Videos" "Turn off background video previews" model.displaySettings.disableCinematicVideos ToggleCinematicVideos
            ]
        ]


viewPlaybackSettings : Model -> Html Msg
viewPlaybackSettings model =
    div [ class "space-y-6" ]
        [ h1 (Theme.text Theme.Heading1 ++ [ class "mb-4" ])
            [ text "Playback Settings" ]
        , div [ class "bg-surface rounded-lg p-6 space-y-6" ]
            [ div []
                [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                    [ text "Maximum Streaming Bitrate" ]
                , select
                    [ class "w-full bg-background border border-background-light rounded px-3 py-2 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary"
                    , onInput (String.toInt >> Maybe.withDefault 120000000 >> UpdateMaxBitrate)
                    ]
                    [ option [ value "120000000", selected (model.playbackSettings.maxStreamingBitrate == 120000000) ] [ text "120 Mbps (4K)" ]
                    , option [ value "60000000", selected (model.playbackSettings.maxStreamingBitrate == 60000000) ] [ text "60 Mbps" ]
                    , option [ value "40000000", selected (model.playbackSettings.maxStreamingBitrate == 40000000) ] [ text "40 Mbps (1080p)" ]
                    , option [ value "20000000", selected (model.playbackSettings.maxStreamingBitrate == 20000000) ] [ text "20 Mbps" ]
                    , option [ value "10000000", selected (model.playbackSettings.maxStreamingBitrate == 10000000) ] [ text "10 Mbps (720p)" ]
                    , option [ value "4000000", selected (model.playbackSettings.maxStreamingBitrate == 4000000) ] [ text "4 Mbps (480p)" ]
                    , option [ value "1500000", selected (model.playbackSettings.maxStreamingBitrate == 1500000) ] [ text "1.5 Mbps (360p)" ]
                    ]
                ]
            , div []
                [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                    [ text "Video Quality Preference" ]
                , select
                    [ class "w-full bg-background border border-background-light rounded px-3 py-2 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary"
                    , onInput UpdateVideoQuality
                    ]
                    [ option [ value "Auto", selected (model.playbackSettings.videoQuality == "Auto") ] [ text "Auto" ]
                    , option [ value "Max", selected (model.playbackSettings.videoQuality == "Max") ] [ text "Maximum" ]
                    , option [ value "High", selected (model.playbackSettings.videoQuality == "High") ] [ text "High" ]
                    , option [ value "Medium", selected (model.playbackSettings.videoQuality == "Medium") ] [ text "Medium" ]
                    , option [ value "Low", selected (model.playbackSettings.videoQuality == "Low") ] [ text "Low" ]
                    ]
                ]
            , div []
                [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                    [ text "Audio Mode" ]
                , select
                    [ class "w-full bg-background border border-background-light rounded px-3 py-2 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary"
                    , onInput UpdateAudioMode
                    ]
                    [ option [ value "Auto", selected (model.playbackSettings.audioMode == "Auto") ] [ text "Auto" ]
                    , option [ value "Stereo", selected (model.playbackSettings.audioMode == "Stereo") ] [ text "Stereo" ]
                    , option [ value "Surround", selected (model.playbackSettings.audioMode == "Surround") ] [ text "Surround Sound" ]
                    ]
                ]
            , viewToggleSetting "Skip Intro Button" "Show button to skip intros" model.playbackSettings.skipIntroButton ToggleSkipIntro
            , viewToggleSetting "Next Up Suggestions" "Show next episode suggestions" model.playbackSettings.nextUpSuggestions ToggleNextUpSuggestions
            , viewToggleSetting "Remember Audio Selection" "Remember audio track preference" model.playbackSettings.rememberAudioSelection ToggleRememberAudio
            , viewToggleSetting "Remember Subtitle Selection" "Remember subtitle track preference" model.playbackSettings.rememberSubtitleSelection ToggleRememberSubtitles
            ]
        ]


viewSubtitleSettings : Model -> Html Msg
viewSubtitleSettings model =
    div [ class "space-y-6" ]
        [ h1 (Theme.text Theme.Heading1 ++ [ class "mb-4" ])
            [ text "Subtitle Settings" ]
        , div [ class "bg-surface rounded-lg p-6 space-y-6" ]
            [ div []
                [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                    [ text "Subtitle Mode" ]
                , select
                    [ class "w-full bg-background border border-background-light rounded px-3 py-2 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary"
                    , onInput UpdateSubtitleMode
                    ]
                    [ option [ value "None", selected (model.subtitleSettings.subtitleMode == "None") ] [ text "Off" ]
                    , option [ value "OnlyForced", selected (model.subtitleSettings.subtitleMode == "OnlyForced") ] [ text "Only Forced Subtitles" ]
                    , option [ value "Default", selected (model.subtitleSettings.subtitleMode == "Default") ] [ text "Default" ]
                    , option [ value "Always", selected (model.subtitleSettings.subtitleMode == "Always") ] [ text "Always" ]
                    ]
                ]
            , div []
                [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                    [ text "Preferred Subtitle Language" ]
                , select
                    [ class "w-full bg-background border border-background-light rounded px-3 py-2 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary"
                    , onInput UpdateSubtitleLanguage
                    ]
                    [ option [ value "English", selected (model.subtitleSettings.subtitleLanguage == "English") ] [ text "English" ]
                    , option [ value "Spanish", selected (model.subtitleSettings.subtitleLanguage == "Spanish") ] [ text "Spanish" ]
                    , option [ value "French", selected (model.subtitleSettings.subtitleLanguage == "French") ] [ text "French" ]
                    , option [ value "German", selected (model.subtitleSettings.subtitleLanguage == "German") ] [ text "German" ]
                    , option [ value "Japanese", selected (model.subtitleSettings.subtitleLanguage == "Japanese") ] [ text "Japanese" ]
                    ]
                ]
            , h3 (Theme.text Theme.Heading3 ++ [ class "mt-4 mb-2" ])
                [ text "Appearance" ]
            , div []
                [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                    [ text ("Font Size: " ++ String.fromInt model.subtitleSettings.fontSize ++ "%") ]
                , input
                    [ type_ "range"
                    , Html.Attributes.min "50"
                    , Html.Attributes.max "200"
                    , value (String.fromInt model.subtitleSettings.fontSize)
                    , onInput (String.toInt >> Maybe.withDefault 100 >> UpdateSubtitleFontSize)
                    , class "w-full"
                    ]
                    []
                ]
            , div [ class "grid grid-cols-2 gap-4" ]
                [ div []
                    [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                        [ text "Text Color" ]
                    , input
                        [ type_ "color"
                        , value model.subtitleSettings.textColor
                        , onInput UpdateSubtitleTextColor
                        , class "w-full h-10 rounded"
                        ]
                        []
                    ]
                , div []
                    [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                        [ text "Background Color" ]
                    , input
                        [ type_ "color"
                        , value model.subtitleSettings.backgroundColor
                        , onInput UpdateSubtitleBgColor
                        , class "w-full h-10 rounded"
                        ]
                        []
                    ]
                ]
            , div []
                [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                    [ text ("Text Opacity: " ++ String.fromInt model.subtitleSettings.textOpacity ++ "%") ]
                , input
                    [ type_ "range"
                    , Html.Attributes.min "0"
                    , Html.Attributes.max "100"
                    , value (String.fromInt model.subtitleSettings.textOpacity)
                    , onInput (String.toInt >> Maybe.withDefault 100 >> UpdateSubtitleTextOpacity)
                    , class "w-full"
                    ]
                    []
                ]
            , div []
                [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                    [ text ("Background Opacity: " ++ String.fromInt model.subtitleSettings.backgroundOpacity ++ "%") ]
                , input
                    [ type_ "range"
                    , Html.Attributes.min "0"
                    , Html.Attributes.max "100"
                    , value (String.fromInt model.subtitleSettings.backgroundOpacity)
                    , onInput (String.toInt >> Maybe.withDefault 50 >> UpdateSubtitleBgOpacity)
                    , class "w-full"
                    ]
                    []
                ]
            , div []
                [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                    [ text "Position" ]
                , select
                    [ class "w-full bg-background border border-background-light rounded px-3 py-2 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary"
                    , onInput UpdateSubtitlePosition
                    ]
                    [ option [ value "Top", selected (model.subtitleSettings.position == "Top") ] [ text "Top" ]
                    , option [ value "Middle", selected (model.subtitleSettings.position == "Middle") ] [ text "Middle" ]
                    , option [ value "Bottom", selected (model.subtitleSettings.position == "Bottom") ] [ text "Bottom" ]
                    ]
                ]
            , div [ class "bg-background-dark rounded p-4" ]
                [ p
                    [ class "text-center"
                    , style "color" model.subtitleSettings.textColor
                    , style "background-color" (model.subtitleSettings.backgroundColor ++ opacityToHex model.subtitleSettings.backgroundOpacity)
                    , style "font-size" (String.fromInt model.subtitleSettings.fontSize ++ "%")
                    , style "opacity" (String.fromFloat (toFloat model.subtitleSettings.textOpacity / 100))
                    , style "padding" "8px 16px"
                    , style "display" "inline-block"
                    ]
                    [ text "Subtitle Preview" ]
                ]
            ]
        ]


viewHomeScreenSettings : Model -> Html Msg
viewHomeScreenSettings model =
    div [ class "space-y-6" ]
        [ h1 (Theme.text Theme.Heading1 ++ [ class "mb-4" ])
            [ text "Home Screen Settings" ]
        , div [ class "bg-surface rounded-lg p-6 space-y-4" ]
            [ p (Theme.text Theme.Body ++ [ class "text-text-secondary mb-4" ])
                [ text "Customize which sections appear on your home screen" ]
            , viewToggleSetting "Continue Watching" "Show continue watching section" model.homeScreenSettings.showContinueWatching ToggleContinueWatching
            , viewToggleSetting "Next Up" "Show next up section" model.homeScreenSettings.showNextUp ToggleNextUp
            , viewToggleSetting "Latest Media" "Show latest media section" model.homeScreenSettings.showLatestMedia ToggleLatestMedia
            , viewToggleSetting "Recommendations" "Show recommendations section" model.homeScreenSettings.showRecommendations ToggleRecommendations
            ]
        ]


viewLanguageSettings : Model -> Html Msg
viewLanguageSettings _ =
    div [ class "space-y-6" ]
        [ h1 (Theme.text Theme.Heading1 ++ [ class "mb-4" ])
            [ text "Language Settings" ]
        , div [ class "bg-surface rounded-lg p-6 space-y-4" ]
            [ div []
                [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                    [ text "Display Language" ]
                , select
                    [ class "w-full bg-background border border-background-light rounded px-3 py-2 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary" ]
                    [ option [ value "en" ] [ text "English" ]
                    , option [ value "es" ] [ text "Español" ]
                    , option [ value "fr" ] [ text "Français" ]
                    , option [ value "de" ] [ text "Deutsch" ]
                    , option [ value "ja" ] [ text "日本語" ]
                    ]
                ]
            , div []
                [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                    [ text "Preferred Audio Language" ]
                , select
                    [ class "w-full bg-background border border-background-light rounded px-3 py-2 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary" ]
                    [ option [ value "en" ] [ text "English" ]
                    , option [ value "es" ] [ text "Spanish" ]
                    , option [ value "fr" ] [ text "French" ]
                    , option [ value "de" ] [ text "German" ]
                    , option [ value "ja" ] [ text "Japanese" ]
                    ]
                ]
            ]
        ]


viewPasswordSettings : Model -> Html Msg
viewPasswordSettings _ =
    div [ class "space-y-6" ]
        [ h1 (Theme.text Theme.Heading1 ++ [ class "mb-4" ])
            [ text "Change Password" ]
        , div [ class "bg-surface rounded-lg p-6 space-y-4" ]
            [ div []
                [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                    [ text "Current Password" ]
                , input
                    [ type_ "password"
                    , class "w-full bg-background border border-background-light rounded px-3 py-2 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary"
                    ]
                    []
                ]
            , div []
                [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                    [ text "New Password" ]
                , input
                    [ type_ "password"
                    , class "w-full bg-background border border-background-light rounded px-3 py-2 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary"
                    ]
                    []
                ]
            , div []
                [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                    [ text "Confirm New Password" ]
                , input
                    [ type_ "password"
                    , class "w-full bg-background border border-background-light rounded px-3 py-2 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary"
                    ]
                    []
                ]
            , button
                (Theme.button Theme.Primary)
                [ text "Update Password" ]
            ]
        ]


viewToggleSetting : String -> String -> Bool -> Msg -> Html Msg
viewToggleSetting label description isEnabled toggleMsg =
    div [ class "flex items-center justify-between" ]
        [ div [ class "flex-1" ]
            [ p (Theme.text Theme.Body ++ [ class "font-medium" ])
                [ text label ]
            , p (Theme.text Theme.Caption ++ [ class "text-text-secondary" ])
                [ text description ]
            ]
        , button
            [ class
                (if isEnabled then
                    "relative inline-flex h-6 w-11 items-center rounded-full bg-primary transition-colors"

                 else
                    "relative inline-flex h-6 w-11 items-center rounded-full bg-background-light transition-colors"
                )
            , onClick toggleMsg
            ]
            [ span
                [ class
                    (if isEnabled then
                        "inline-block h-4 w-4 transform rounded-full bg-white transition-transform translate-x-6"

                     else
                        "inline-block h-4 w-4 transform rounded-full bg-white transition-transform translate-x-1"
                    )
                ]
                []
            ]
        ]



-- HELPERS


opacityToHex : Int -> String
opacityToHex opacity =
    let
        hexValue =
            round (toFloat opacity / 100 * 255)
                |> clamp 0 255
                |> String.fromInt
                |> String.toInt
                |> Maybe.withDefault 0
                |> (\n ->
                        let
                            hex =
                                toHex n
                        in
                        if String.length hex == 1 then
                            "0" ++ hex

                        else
                            hex
                   )
    in
    hexValue


toHex : Int -> String
toHex n =
    if n < 16 then
        case n of
            0 ->
                "0"

            1 ->
                "1"

            2 ->
                "2"

            3 ->
                "3"

            4 ->
                "4"

            5 ->
                "5"

            6 ->
                "6"

            7 ->
                "7"

            8 ->
                "8"

            9 ->
                "9"

            10 ->
                "a"

            11 ->
                "b"

            12 ->
                "c"

            13 ->
                "d"

            14 ->
                "e"

            _ ->
                "f"

    else
        toHex (n // 16) ++ toHex (modBy 16 n)
