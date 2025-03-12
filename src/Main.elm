module Main exposing (main)

import Browser
import Html exposing (Html, div)
import Html.Attributes exposing (class)
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


type alias Model =
    { jellyfinModel : JellyfinUI.Model
    }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        ( jellyfinModel, jellyfinCmd ) =
            JellyfinUI.init
    in
    ( { jellyfinModel = jellyfinModel }
    , Cmd.map JellyfinMsg jellyfinCmd
    )


-- UPDATE


type Msg
    = JellyfinMsg JellyfinUI.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        JellyfinMsg jellyfinMsg ->
            let
                ( updatedJellyfinModel, jellyfinCmd ) =
                    JellyfinUI.update jellyfinMsg model.jellyfinModel
            in
            ( { model | jellyfinModel = updatedJellyfinModel }, Cmd.map JellyfinMsg jellyfinCmd )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map JellyfinMsg (JellyfinUI.subscriptions model.jellyfinModel)


-- VIEW


view : Model -> Html Msg
view model =
    div [ class "min-h-screen bg-background" ]
        [ Html.map JellyfinMsg (JellyfinUI.view model.jellyfinModel)
        ]
