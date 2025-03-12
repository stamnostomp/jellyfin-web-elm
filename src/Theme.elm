module Theme exposing
    ( button
    , container
    , card
    , title
    , subtitle
    , text
    , codeBlock
    , terminalBlock
    , ButtonStyle(..)
    , TextStyle(..)
    )

{-| This module centralizes all UI component styling based on the Everbush vim theme.
By defining reusable style combinations here, we can easily
update the look and feel of the entire application in one place.
-}

import Html exposing (Attribute)
import Html.Attributes exposing (class)


{-| Button style variants
-}
type ButtonStyle
    = Primary
    | Secondary
    | Success
    | Warning
    | Error
    | Ghost


{-| Text style variants
-}
type TextStyle
    = Heading1
    | Heading2
    | Heading3
    | Body
    | Caption
    | Label
    | Code


{-| Container styles
-}
container : List (Attribute msg)
container =
    [ class "flex flex-col items-center justify-center min-h-screen p-4 bg-background" ]


{-| Card styles with Everbush theme
-}
card : List (Attribute msg)
card =
    [ class "bg-surface border border-background-light rounded-lg p-6 max-w-md w-full shadow-lg" ]


{-| Button styles based on variant with Everbush colors
-}
button : ButtonStyle -> List (Attribute msg)
button style =
    let
        baseClasses =
            "font-medium py-2 px-4 rounded transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-opacity-50"
    in
    case style of
        Primary ->
            [ class (baseClasses ++ " bg-primary hover:bg-primary-dark text-text-primary focus:ring-primary-light") ]

        Secondary ->
            [ class (baseClasses ++ " bg-secondary hover:bg-secondary-dark text-background focus:ring-secondary-light") ]

        Success ->
            [ class (baseClasses ++ " bg-success hover:bg-success-dark text-background focus:ring-success-light") ]

        Warning ->
            [ class (baseClasses ++ " bg-warning hover:bg-warning-dark text-background-dark focus:ring-warning-light") ]

        Error ->
            [ class (baseClasses ++ " bg-error hover:bg-error-dark text-text-primary focus:ring-error-light") ]

        Ghost ->
            [ class (baseClasses ++ " bg-transparent hover:bg-surface-light text-text-primary border border-surface-light focus:ring-primary") ]


{-| Text styles for main titles
-}
title : List (Attribute msg)
title =
    [ class "text-3xl font-bold text-text-primary mb-4 text-glow" ]


{-| Text styles for subtitles
-}
subtitle : List (Attribute msg)
subtitle =
    [ class "text-xl text-secondary mb-4" ]


{-| Text styles based on variant
-}
text : TextStyle -> List (Attribute msg)
text style =
    case style of
        Heading1 ->
            [ class "text-4xl font-bold text-text-primary text-glow" ]

        Heading2 ->
            [ class "text-3xl font-semibold text-text-primary" ]

        Heading3 ->
            [ class "text-2xl font-semibold text-primary" ]

        Body ->
            [ class "text-base text-text-primary" ]

        Caption ->
            [ class "text-sm text-text-secondary" ]

        Label ->
            [ class "text-sm font-medium text-info" ]

        Code ->
            [ class "font-mono text-sm text-text-primary bg-background-light px-1 py-0.5 rounded" ]


{-| Code block for syntax-highlighted content
-}
codeBlock : List (Attribute msg)
codeBlock =
    [ class "code-block" ]


{-| Terminal-like block for command examples
-}
terminalBlock : List (Attribute msg)
terminalBlock =
    [ class "terminal-block" ]
