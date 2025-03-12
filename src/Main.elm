module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, h2, h3, p, text, button, pre, code, span)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
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


type alias Model =
    { count : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { count = 0 }
    , Cmd.none
    )


-- UPDATE


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | count = model.count + 1 }, Cmd.none )

        Decrement ->
            ( { model | count = model.count - 1 }, Cmd.none )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


-- VIEW


view : Model -> Html Msg
view model =
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
                            (Theme.button Theme.Primary ++ [ onClick Decrement ])
                            [ text "-" ]
                        , button
                            (Theme.button Theme.Secondary ++ [ onClick Increment ])
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
