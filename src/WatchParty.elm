module WatchParty exposing (Model, Msg(..), PartyInfo, init, subscriptions, update, view, viewIndicator)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Icon
import Theme



-- MODEL


type alias Model =
    { currentParty : Maybe PartyInfo
    , showDialog : Bool
    , partyCodeInput : String
    , createPartyName : String
    , isCreating : Bool
    , isMinimized : Bool
    }


type alias PartyInfo =
    { partyId : String
    , partyName : String
    , hostName : String
    , memberCount : Int
    , members : List PartyMember
    , isHost : Bool
    , syncEnabled : Bool
    }


type alias PartyMember =
    { username : String
    , avatarUrl : Maybe String
    , isOnline : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { currentParty = Nothing
      , showDialog = False
      , partyCodeInput = ""
      , createPartyName = ""
      , isCreating = False
      , isMinimized = False
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = OpenDialog
    | CloseDialog
    | UpdatePartyCode String
    | UpdatePartyName String
    | JoinParty
    | CreateParty
    | LeaveParty
    | ToggleSync
    | InviteMember
    | RemoveMember String
    | PartyJoined PartyInfo
    | PartyCreated PartyInfo
    | PartyLeft
    | SwitchToCreate
    | SwitchToJoin
    | ToggleMinimize


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OpenDialog ->
            ( { model | showDialog = True }, Cmd.none )

        CloseDialog ->
            ( { model | showDialog = False, partyCodeInput = "", createPartyName = "", isCreating = False }
            , Cmd.none
            )

        UpdatePartyCode code ->
            ( { model | partyCodeInput = code }, Cmd.none )

        UpdatePartyName name ->
            ( { model | createPartyName = name }, Cmd.none )

        SwitchToCreate ->
            ( { model | isCreating = True, partyCodeInput = "", createPartyName = "" }, Cmd.none )

        SwitchToJoin ->
            ( { model | isCreating = False, partyCodeInput = "", createPartyName = "" }, Cmd.none )

        JoinParty ->
            -- In real app, this would make an API call
            let
                mockParty =
                    { partyId = model.partyCodeInput
                    , partyName = "Watch Party"
                    , hostName = "Other User"
                    , memberCount = 3
                    , members =
                        [ { username = "Host", avatarUrl = Nothing, isOnline = True }
                        , { username = "User2", avatarUrl = Nothing, isOnline = True }
                        , { username = "You", avatarUrl = Nothing, isOnline = True }
                        ]
                    , isHost = False
                    , syncEnabled = True
                    }
            in
            ( { model | currentParty = Just mockParty, showDialog = False, partyCodeInput = "" }
            , Cmd.none
            )

        CreateParty ->
            -- In real app, this would make an API call
            let
                partyId =
                    "PARTY-" ++ String.fromInt (String.length model.createPartyName * 1234)

                mockParty =
                    { partyId = partyId
                    , partyName = model.createPartyName
                    , hostName = "You"
                    , memberCount = 1
                    , members =
                        [ { username = "You", avatarUrl = Nothing, isOnline = True }
                        ]
                    , isHost = True
                    , syncEnabled = True
                    }
            in
            ( { model | currentParty = Just mockParty, showDialog = False, createPartyName = "" }
            , Cmd.none
            )

        LeaveParty ->
            ( { model | currentParty = Nothing }, Cmd.none )

        ToggleSync ->
            case model.currentParty of
                Just party ->
                    ( { model | currentParty = Just { party | syncEnabled = not party.syncEnabled } }
                    , Cmd.none
                    )

                Nothing ->
                    ( model, Cmd.none )

        InviteMember ->
            -- In real app, this would show invite dialog
            ( model, Cmd.none )

        RemoveMember _ ->
            -- In real app, this would remove the member
            ( model, Cmd.none )

        PartyJoined party ->
            ( { model | currentParty = Just party }, Cmd.none )

        PartyCreated party ->
            ( { model | currentParty = Just party }, Cmd.none )

        PartyLeft ->
            ( { model | currentParty = Nothing }, Cmd.none )

        ToggleMinimize ->
            ( { model | isMinimized = not model.isMinimized }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    if model.showDialog then
        div [ class "fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50" ]
            [ div [ class "bg-surface rounded-lg max-w-md w-full mx-4 shadow-xl" ]
                [ -- Header
                  div [ class "flex items-center justify-between p-4 border-b border-background-light" ]
                    [ h2 (Theme.text Theme.Heading2 ++ [ class "text-primary" ])
                        [ text "Watch Party" ]
                    , button
                        [ class "text-text-secondary hover:text-text-primary"
                        , onClick CloseDialog
                        ]
                        [ Icon.view [ class "text-2xl" ] Icon.close ]
                    ]
                , -- Tabs
                  div [ class "flex border-b border-background-light" ]
                    [ button
                        [ class
                            (if not model.isCreating then
                                "flex-1 px-4 py-3 font-medium text-primary border-b-2 border-primary"

                             else
                                "flex-1 px-4 py-3 font-medium text-text-secondary hover:text-text-primary"
                            )
                        , onClick SwitchToJoin
                        ]
                        [ text "Join Party" ]
                    , button
                        [ class
                            (if model.isCreating then
                                "flex-1 px-4 py-3 font-medium text-primary border-b-2 border-primary"

                             else
                                "flex-1 px-4 py-3 font-medium text-text-secondary hover:text-primary"
                            )
                        , onClick SwitchToCreate
                        ]
                        [ text "Create Party" ]
                    ]
                , -- Content
                  div [ class "p-6" ]
                    [ if model.isCreating then
                        viewCreatePartyForm model

                      else
                        viewJoinPartyForm model
                    ]
                ]
            ]

    else
        text ""


viewJoinPartyForm : Model -> Html Msg
viewJoinPartyForm model =
    div [ class "space-y-4" ]
        [ p (Theme.text Theme.Body ++ [ class "text-text-secondary" ])
            [ text "Enter the party code to join a watch party with friends" ]
        , div []
            [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                [ text "Party Code" ]
            , input
                [ type_ "text"
                , value model.partyCodeInput
                , onInput UpdatePartyCode
                , placeholder "Enter party code..."
                , class "w-full bg-background border border-background-light rounded px-3 py-2 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary"
                ]
                []
            ]
        , button
            (Theme.button Theme.Primary
                ++ [ class "w-full"
                   , onClick JoinParty
                   , disabled (String.isEmpty model.partyCodeInput)
                   ]
            )
            [ text "Join Party" ]
        ]


viewCreatePartyForm : Model -> Html Msg
viewCreatePartyForm model =
    div [ class "space-y-4" ]
        [ p (Theme.text Theme.Body ++ [ class "text-text-secondary" ])
            [ text "Create a new watch party and invite friends to watch together" ]
        , div []
            [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                [ text "Party Name" ]
            , input
                [ type_ "text"
                , value model.createPartyName
                , onInput UpdatePartyName
                , placeholder "Enter party name..."
                , class "w-full bg-background border border-background-light rounded px-3 py-2 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary"
                ]
                []
            ]
        , button
            (Theme.button Theme.Primary
                ++ [ class "w-full"
                   , onClick CreateParty
                   , disabled (String.isEmpty model.createPartyName)
                   ]
            )
            [ text "Create Party" ]
        ]


viewIndicator : Model -> Html Msg
viewIndicator model =
    case model.currentParty of
        Just party ->
            div [ class "fixed bottom-4 right-4 z-40" ]
                [ div [ class "bg-surface border-2 border-primary rounded-lg shadow-xl max-w-sm" ]
                    [ -- Header (always visible)
                      div [ class "flex items-start justify-between p-4" ]
                        [ div [ class "flex-1" ]
                            [ div [ class "flex items-center space-x-2" ]
                                [ div [ class "w-2 h-2 bg-success rounded-full animate-pulse" ] []
                                , h3 (Theme.text Theme.Heading3 ++ [ class "text-primary" ])
                                    [ text party.partyName ]
                                ]
                            , p (Theme.text Theme.Caption ++ [ class "text-text-secondary mt-1" ])
                                [ text ("Hosted by " ++ party.hostName) ]
                            ]
                        , div [ class "flex items-center space-x-1" ]
                            [ button
                                [ class "text-text-secondary hover:text-primary"
                                , onClick ToggleMinimize
                                , title
                                    (if model.isMinimized then
                                        "Expand"

                                     else
                                        "Minimize"
                                    )
                                ]
                                [ Icon.view [ class "text-lg" ]
                                    (if model.isMinimized then
                                        Icon.chevronLeft

                                     else
                                        Icon.chevronRight
                                    )
                                ]
                            , button
                                [ class "text-text-secondary hover:text-error"
                                , onClick LeaveParty
                                , title "Leave party"
                                ]
                                [ Icon.view [ class "text-lg" ] Icon.close ]
                            ]
                        ]
                    , -- Body (collapsible)
                      if not model.isMinimized then
                        div [ class "px-4 pb-4" ]
                            [ viewPartyBody party ]

                      else
                        text ""
                    ]
                ]

        Nothing ->
            text ""


viewPartyBody : PartyInfo -> Html Msg
viewPartyBody party =
    div []
        [ div [ class "flex items-center justify-between mb-3" ]
            [ div [ class "flex items-center space-x-2" ]
                [ Icon.view [ class "text-lg text-primary" ] Icon.person
                , span (Theme.text Theme.Body)
                    [ text (String.fromInt party.memberCount ++ " watching") ]
                ]
            , if party.isHost then
                button
                    (Theme.button Theme.Ghost ++ [ class "py-1 px-2", onClick InviteMember ])
                    [ text "Invite" ]

              else
                text ""
            ]
        , div [ class "flex flex-wrap gap-2 mb-3" ]
            (List.map viewMemberAvatar party.members)
        , if party.isHost then
            div [ class "flex items-center justify-between pt-3 border-t border-background-light" ]
                [ span (Theme.text Theme.Body)
                    [ text "Sync playback" ]
                , button
                    [ class
                        (if party.syncEnabled then
                            "relative inline-flex h-6 w-11 items-center rounded-full bg-primary transition-colors"

                         else
                            "relative inline-flex h-6 w-11 items-center rounded-full bg-background-light transition-colors"
                        )
                    , onClick ToggleSync
                    ]
                    [ span
                        [ class
                            (if party.syncEnabled then
                                "inline-block h-4 w-4 transform rounded-full bg-white transition-transform translate-x-6"

                             else
                                "inline-block h-4 w-4 transform rounded-full bg-white transition-transform translate-x-1"
                            )
                        ]
                        []
                    ]
                ]

          else
            div [ class "flex items-center justify-center pt-3 border-t border-background-light" ]
                [ div [ class "flex items-center space-x-2 text-success" ]
                    [ Icon.view [ class "text-sm" ] Icon.playArrow
                    , span (Theme.text Theme.Caption)
                        [ text "Synced with host" ]
                    ]
                ]
        , div [ class "mt-3 pt-3 border-t border-background-light" ]
            [ div [ class "flex items-center justify-between" ]
                [ span (Theme.text Theme.Caption ++ [ class "text-text-secondary" ])
                    [ text "Party Code:" ]
                , div [ class "flex items-center space-x-2" ]
                    [ code [ class "bg-background px-2 py-1 rounded font-mono text-sm text-primary" ]
                        [ text party.partyId ]
                    , button
                        [ class "text-text-secondary hover:text-primary text-xs"
                        , title "Copy code"
                        ]
                        [ text "Copy" ]
                    ]
                ]
            ]
        ]


viewMemberAvatar : PartyMember -> Html Msg
viewMemberAvatar member =
    div [ class "relative" ]
        [ div
            [ class "w-8 h-8 rounded-full bg-primary flex items-center justify-center text-white text-sm"
            , title member.username
            ]
            [ text (String.left 1 member.username) ]
        , if member.isOnline then
            div [ class "absolute -bottom-0.5 -right-0.5 w-2.5 h-2.5 bg-success border-2 border-surface rounded-full" ] []

          else
            text ""
        ]
