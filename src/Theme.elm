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
    [ class "flex flex-col items-center justify-center min-h-screen p-2 bg-background" ] -- Reduced padding


{-| Card styles with Everbush theme
-}
card : List (Attribute msg)
card =
    [ class "bg-surface border border-background-light rounded-lg p-3 max-w-md w-full shadow-lg" ] -- Reduced padding


{-| Button styles based on variant with Everbush colors
-}
button : ButtonStyle -> List (Attribute msg)
button style =
    let
        baseClasses =
            "font-medium py-1 px-3 rounded transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-opacity-50 text-sm" -- Reduced padding and added smaller text
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
    [ class "text-2xl font-bold text-text-primary mb-2 text-glow" ] -- Reduced text size and margin


{-| Text styles for subtitles
-}
subtitle : List (Attribute msg)
subtitle =
    [ class "text-lg text-secondary mb-2" ] -- Reduced text size and margin


{-| Text styles based on variant
-}
text : TextStyle -> List (Attribute msg)
text style =
    case style of
        Heading1 ->
            [ class "text-3xl font-bold text-text-primary text-glow" ] -- Reduced from 4xl to 3xl

        Heading2 ->
            [ class "text-2xl font-semibold text-text-primary" ] -- Reduced from 3xl to 2xl

        Heading3 ->
            [ class "text-xl font-semibold text-primary" ] -- Reduced from 2xl to xl

        Body ->
            [ class "text-sm text-text-primary" ] -- Reduced from base to sm

        Caption ->
            [ class "text-xs text-text-secondary" ] -- Reduced from sm to xs

        Label ->
            [ class "text-xs font-medium text-info" ] -- Reduced from sm to xs

        Code ->
            [ class "font-mono text-xs text-text-primary bg-background-light px-1 py-0.5 rounded" ] -- Reduced from sm to xs


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
