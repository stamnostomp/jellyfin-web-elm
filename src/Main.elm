module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, h2, h3, p, text, button, pre, code, span, nav, a)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import JellyfinUI
import Theme


-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


-- MODEL


type Page
    = ThemeDemoPage
    | JellyfinPage


type alias Model =
    { currentPage : Page
    , themeDemoModel : ThemeDemoModel
    , jellyfinModel : JellyfinUI.Model
    }


type alias ThemeDemoModel =
    { count : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        ( jellyfinModel, jellyfinCmd ) =
            JellyfinUI.init
    in
    ( { currentPage = JellyfinPage
      , themeDemoModel = { count = 0 }
      , jellyfinModel = jellyfinModel
      }
    , Cmd.map JellyfinMsg jellyfinCmd
    )


-- UPDATE


type Msg
    = NavigateTo Page
    | ThemeDemoMsg ThemeDemoMsg
    | JellyfinMsg JellyfinUI.Msg


type ThemeDemoMsg
    = Increment
    | Decrement


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavigateTo page ->
            ( { model | currentPage = page }, Cmd.none )

        ThemeDemoMsg themeDemoMsg ->
            ( { model | themeDemoModel = updateThemeDemo themeDemoMsg model.themeDemoModel }, Cmd.none )

        JellyfinMsg jellyfinMsg ->
            let
                ( updatedJellyfinModel, jellyfinCmd ) =
                    JellyfinUI.update jellyfinMsg model.jellyfinModel
            in
            ( { model | jellyfinModel = updatedJellyfinModel }, Cmd.map JellyfinMsg jellyfinCmd )


updateThemeDemo : ThemeDemoMsg -> ThemeDemoModel -> ThemeDemoModel
updateThemeDemo msg model =
    case msg of
        Increment ->
            { model | count = model.count + 1 }

        Decrement ->
            { model | count = model.count - 1 }


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.currentPage of
        JellyfinPage ->
            Sub.map JellyfinMsg (JellyfinUI.subscriptions model.jellyfinModel)

        _ ->
            Sub.none


-- VIEW


view : Model -> Html Msg
view model =
    div [ class "min-h-screen bg-background" ]
        [ viewNavigation model.currentPage
        , viewPage model
        ]


viewNavigation : Page -> Html Msg
viewNavigation currentPage =
    nav [ class "bg-surface border-b border-background-light p-4" ]
        [ div [ class "container mx-auto flex space-x-4" ]
            [ navLink "Jellyfin UI" JellyfinPage (currentPage == JellyfinPage)
            , navLink "Theme Demo" ThemeDemoPage (currentPage == ThemeDemoPage)
            ]
        ]


navLink : String -> Page -> Bool -> Html Msg
navLink label page isActive =
    let
        baseClasses = "px-4 py-2 rounded transition-colors duration-200"
        classes =
            if isActive then
                baseClasses ++ " bg-primary text-text-primary"
            else
                baseClasses ++ " hover:bg-background-light text-text-secondary"
    in
    a
        [ class classes
        , onClick (NavigateTo page)
        ]
        [ text label ]


viewPage : Model -> Html Msg
viewPage model =
    case model.currentPage of
        ThemeDemoPage ->
            viewThemeDemo model.themeDemoModel

        JellyfinPage ->
            Html.map JellyfinMsg (JellyfinUI.view model.jellyfinModel)


viewThemeDemo : ThemeDemoModel -> Html Msg
viewThemeDemo model =
    div Theme.container
        [ div [ class "w-full max-w-4xl space-y-6" ]
            [ h1 Theme.title
                [ text "Everbush Theme Demo" ]
            , div Theme.card
                [ h2 (Theme.text Theme.Heading2)
                    [ text "Counter Example" ]
                , p (Theme.text Theme.Body ++ [ class "mb-4" ])
                    [ text "This counter demonstrates the Everbush theme colors applied to interactive elements." ]
                , div [ class "flex flex-col items-center py-4" ]
                    [ p (Theme.text Theme.Heading2) [ text (String.fromInt model.count) ]
                    , div [ class "flex space-x-4 mt-4" ]
                        [ button
                            (Theme.button Theme.Primary ++ [ onClick (ThemeDemoMsg Decrement) ])
                            [ text "-" ]
                        , button
                            (Theme.button Theme.Secondary ++ [ onClick (ThemeDemoMsg Increment) ])
                            [ text "+" ]
                        ]
                    ]
                ]
            , div Theme.card
                [ h2 (Theme.text Theme.Heading2)
                    [ text "Theme Palette" ]
                , p (Theme.text Theme.Body ++ [ class "mb-4" ])
                    [ text "Explore the various components and colors from the Everbush Vim theme:" ]
                , div [ class "grid grid-cols-1 md:grid-cols-2 gap-4" ]
                    [ colorSwatch "Primary" "bg-primary"
                    , colorSwatch "Secondary" "bg-secondary"
                    , colorSwatch "Success" "bg-success"
                    , colorSwatch "Warning" "bg-warning"
                    , colorSwatch "Error" "bg-error"
                    , colorSwatch "Info" "bg-info"
                    , colorSwatch "Comment" "bg-comment"
                    , colorSwatch "Accent" "bg-accent"
                    ]
                ]
            , div Theme.card
                [ h2 (Theme.text Theme.Heading2)
                    [ text "Button Styles" ]
                , div [ class "grid grid-cols-2 md:grid-cols-3 gap-4 my-4" ]
                    [ div []
                        [ button (Theme.button Theme.Primary) [ text "Primary" ] ]
                    , div []
                        [ button (Theme.button Theme.Secondary) [ text "Secondary" ] ]
                    , div []
                        [ button (Theme.button Theme.Success) [ text "Success" ] ]
                    , div []
                        [ button (Theme.button Theme.Warning) [ text "Warning" ] ]
                    , div []
                        [ button (Theme.button Theme.Error) [ text "Error" ] ]
                    , div []
                        [ button (Theme.button Theme.Ghost) [ text "Ghost" ] ]
                    ]
                ]
            , div Theme.card
                [ h2 (Theme.text Theme.Heading2)
                    [ text "Typography" ]
                , h1 (Theme.text Theme.Heading1 ++ [ class "mt-4" ]) [ text "Heading 1" ]
                , h2 (Theme.text Theme.Heading2) [ text "Heading 2" ]
                , h3 (Theme.text Theme.Heading3) [ text "Heading 3" ]
                , p (Theme.text Theme.Body ++ [ class "my-2" ]) [ text "Body text looks like this" ]
                , p (Theme.text Theme.Caption) [ text "Caption text looks like this" ]
                , p (Theme.text Theme.Label ++ [ class "mt-2" ]) [ text "Label text looks like this" ]
                , p [ class "mt-2" ]
                    [ text "Inline "
                    , span (Theme.text Theme.Code) [ text "code" ]
                    , text " looks like this."
                    ]
                ]
            , div Theme.card
                [ h2 (Theme.text Theme.Heading2)
                    [ text "Code Example" ]
                , pre Theme.codeBlock
                    [ code []
                        [ syntaxHighlight "-- This is a comment" "everbush-comment"
                        , text "\n"
                        , syntaxHighlight "module" "everbush-keyword"
                        , text " Main "
                        , syntaxHighlight "exposing" "everbush-keyword"
                        , text " (main)\n\n"
                        , syntaxHighlight "import" "everbush-keyword"
                        , text " Html "
                        , syntaxHighlight "exposing" "everbush-keyword"
                        , text " (..)\n\n"
                        , syntaxHighlight "main" "everbush-function"
                        , text " =\n    "
                        , syntaxHighlight "text" "everbush-function"
                        , text " "
                        , syntaxHighlight "\"Hello, Everbush!\"" "everbush-string"
                        ]
                    ]
                ]
            , div Theme.card
                [ h2 (Theme.text Theme.Heading2)
                    [ text "Terminal Example" ]
                , pre Theme.terminalBlock
                    [ code []
                        [ text "$ "
                        , syntaxHighlight "nix develop" "everbush-function"
                        , text "\n> "
                        , syntaxHighlight "build-all" "everbush-keyword"
                        , text "\nBuild completed successfully!"
                        ]
                    ]
                ]
            ]
        ]


-- HELPERS


colorSwatch : String -> String -> Html Msg
colorSwatch name bgClass =
    div [ class "flex items-center space-x-2" ]
        [ div [ class (bgClass ++ " w-6 h-6 rounded") ] []
        , span (Theme.text Theme.Body) [ text name ]
        ]


syntaxHighlight : String -> String -> Html Msg
syntaxHighlight content className =
    span [ class className ] [ text content ]
