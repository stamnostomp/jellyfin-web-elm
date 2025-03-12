module ServerSettings exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import JellyfinAPI exposing (ServerConfig, defaultServerConfig)
import Json.Decode as Decode
import Task
import Theme


-- MODEL

type alias Model =
    { serverConfig : ServerConfig
    , isVisible : Bool
    , baseUrlInput : String
    , apiKeyInput : String
    , userIdInput : String
    , isTestingConnection : Bool
    , connectionStatus : Maybe ConnectionStatus
    }


type ConnectionStatus
    = Success
    | Failure String


init : ( Model, Cmd Msg )
init =
    ( { serverConfig = defaultServerConfig
      , isVisible = False
      , baseUrlInput = defaultServerConfig.baseUrl
      , apiKeyInput = Maybe.withDefault "" defaultServerConfig.apiKey
      , userIdInput = Maybe.withDefault "" defaultServerConfig.userId
      , isTestingConnection = False
      , connectionStatus = Nothing
      }
    , Cmd.none
    )


-- UPDATE

type Msg
    = ToggleVisibility
    | UpdateBaseUrl String
    | UpdateApiKey String
    | UpdateUserId String
    | SaveSettings
    | TestConnection
    | ConnectionTested ConnectionStatus
    | ResetToDefaults


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleVisibility ->
            ( { model | isVisible = not model.isVisible }, Cmd.none )

        UpdateBaseUrl value ->
            ( { model | baseUrlInput = value }, Cmd.none )

        UpdateApiKey value ->
            ( { model | apiKeyInput = value }, Cmd.none )

        UpdateUserId value ->
            ( { model | userIdInput = value }, Cmd.none )

        SaveSettings ->
            let
                newConfig =
                    { baseUrl = model.baseUrlInput
                    , apiKey =
                        if String.isEmpty model.apiKeyInput then
                            Nothing
                        else
                            Just model.apiKeyInput
                    , userId =
                        if String.isEmpty model.userIdInput then
                            Nothing
                        else
                            Just model.userIdInput
                    }
            in
            ( { model
                | serverConfig = newConfig
                , isVisible = False
                , connectionStatus = Nothing
              }
            , Cmd.none
            )

        TestConnection ->
            ( { model | isTestingConnection = True, connectionStatus = Nothing }
            , -- In a real app, this would test the connection to the server
              -- For now we'll just simulate success
              Task.perform identity (Task.succeed (ConnectionTested Success))
            )

        ConnectionTested status ->
            ( { model
                | connectionStatus = Just status
                , isTestingConnection = False
              }
            , Cmd.none
            )

        ResetToDefaults ->
            ( { model
                | baseUrlInput = defaultServerConfig.baseUrl
                , apiKeyInput = Maybe.withDefault "" defaultServerConfig.apiKey
                , userIdInput = Maybe.withDefault "" defaultServerConfig.userId
                , connectionStatus = Nothing
              }
            , Cmd.none
            )


-- VIEW

view : Model -> (Msg -> msg) -> (ServerConfig -> msg) -> Html msg
view model toMsg onSave =
    div []
        [ button
            (Theme.button Theme.Ghost ++ [ onClick (toMsg ToggleVisibility) ])
            [ text "Server Settings" ]
        , if model.isVisible then
            viewSettingsModal model toMsg onSave
          else
            text ""
        ]


viewSettingsModal : Model -> (Msg -> msg) -> (ServerConfig -> msg) -> Html msg
viewSettingsModal model toMsg onSave =
    div [ class "fixed inset-0 bg-background-dark bg-opacity-80 flex items-center justify-center z-50 p-4" ]
        [ div [ class "bg-surface rounded-lg w-full max-w-md" ]
            [ div [ class "p-6" ]
                [ h2 (Theme.text Theme.Heading2)
                    [ text "Jellyfin Server Settings" ]
                , p (Theme.text Theme.Body ++ [ class "mt-2" ])
                    [ text "Configure your Jellyfin server connection" ]
                , div [ class "mt-6 space-y-4" ]
                    [ div []
                        [ label (Theme.text Theme.Label ++ [ class "block mb-1", for "baseUrl" ])
                            [ text "Server URL" ]
                        , input
                            [ class "w-full bg-background border border-background-light rounded py-2 px-3 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary"
                            , id "baseUrl"
                            , placeholder "http://localhost:8096"
                            , value model.baseUrlInput
                            , onInput (toMsg << UpdateBaseUrl)
                            ]
                            []
                        ]
                    , div []
                        [ label (Theme.text Theme.Label ++ [ class "block mb-1", for "apiKey" ])
                            [ text "API Key (optional)" ]
                        , input
                            [ class "w-full bg-background border border-background-light rounded py-2 px-3 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary"
                            , id "apiKey"
                            , placeholder "Enter your API key"
                            , value model.apiKeyInput
                            , onInput (toMsg << UpdateApiKey)
                            ]
                            []
                        ]
                    , div []
                        [ label (Theme.text Theme.Label ++ [ class "block mb-1", for "userId" ])
                            [ text "User ID (optional)" ]
                        , input
                            [ class "w-full bg-background border border-background-light rounded py-2 px-3 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary"
                            , id "userId"
                            , placeholder "Enter your user ID"
                            , value model.userIdInput
                            , onInput (toMsg << UpdateUserId)
                            ]
                            []
                        ]
                    , viewConnectionStatus model.connectionStatus
                    ]
                , div [ class "mt-6 flex flex-col space-y-2" ]
                    [ button
                        (Theme.button Theme.Primary ++
                            [ onClick (toMsg TestConnection)
                            , disabled model.isTestingConnection
                            ]
                        )
                        [ if model.isTestingConnection then
                            text "Testing..."
                          else
                            text "Test Connection"
                        ]
                    , div [ class "flex space-x-2" ]
                        [ button
                            (Theme.button Theme.Ghost ++ [ onClick (toMsg ResetToDefaults) ])
                            [ text "Reset" ]
                        , button
                            (Theme.button Theme.Secondary ++
                                [ onClick (toMsg SaveSettings)
                                , Html.Events.on "click" (Decode.succeed (onSave model.serverConfig))
                                ]
                            )
                            [ text "Save" ]
                        ]
                    ]
                ]
            ]
        ]


viewConnectionStatus : Maybe ConnectionStatus -> Html msg
viewConnectionStatus maybeStatus =
    case maybeStatus of
        Just status ->
            case status of
                Success ->
                    div [ class "p-2 bg-success bg-opacity-20 border border-success rounded" ]
                        [ p (Theme.text Theme.Body)
                            [ text "Connection successful!" ]
                        ]

                Failure error ->
                    div [ class "p-2 bg-error bg-opacity-20 border border-error rounded" ]
                        [ p (Theme.text Theme.Body)
                            [ text ("Connection failed: " ++ error) ]
                        ]

        Nothing ->
            text ""
