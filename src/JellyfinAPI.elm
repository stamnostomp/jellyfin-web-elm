module JellyfinAPI exposing
    ( getCategories
    , getMediaDetail
    , searchMedia
    , MediaItem
    , MediaType(..)
    , Category
    , MediaDetail
    , ServerConfig
    , defaultServerConfig
    )

import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode


-- TYPES

type MediaType
    = Movie
    | TVShow
    | Music


type alias MediaItem =
    { id : String
    , title : String
    , type_ : MediaType
    , imageUrl : String
    , year : Int
    , rating : Float
    }


type alias MediaDetail =
    { id : String
    , title : String
    , type_ : MediaType
    , imageUrl : String
    , year : Int
    , rating : Float
    , description : String
    , directors : List String
    , actors : List String
    , duration : Int -- in minutes
    , genres : List String
    }


type alias Category =
    { id : String
    , name : String
    , items : List MediaItem
    }


type alias ServerConfig =
    { baseUrl : String
    , apiKey : Maybe String
    , userId : Maybe String
    }


-- INIT

defaultServerConfig : ServerConfig
defaultServerConfig =
    { baseUrl = "http://localhost:8096"
    , apiKey = Nothing
    , userId = Nothing
    }


-- API FUNCTIONS

{-| Get categories of media (e.g., Recently Added, Continue Watching)
-}
getCategories : ServerConfig -> (Result Http.Error (List Category) -> msg) -> Cmd msg
getCategories config toMsg =
    -- In a real implementation, this would make HTTP requests to Jellyfin server
    -- For now, we'll simulate success with mock data
    Cmd.none


{-| Get detailed information about a specific media item
-}
getMediaDetail : ServerConfig -> String -> (Result Http.Error MediaDetail -> msg) -> Cmd msg
getMediaDetail config mediaId toMsg =
    -- In a real implementation, this would fetch details from Jellyfin server
    -- For now, we'll simulate success with mock data
    Cmd.none


{-| Search media items by query
-}
searchMedia : ServerConfig -> String -> (Result Http.Error (List MediaItem) -> msg) -> Cmd msg
searchMedia config query toMsg =
    -- In a real implementation, this would search the Jellyfin server
    -- For now, we'll simulate success with mock data
    Cmd.none


-- DECODERS

mediaTypeDecoder : Decoder MediaType
mediaTypeDecoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "Movie" ->
                        Decode.succeed Movie

                    "TVShow" ->
                        Decode.succeed TVShow

                    "Music" ->
                        Decode.succeed Music

                    _ ->
                        Decode.fail ("Unknown media type: " ++ str)
            )


mediaItemDecoder : Decoder MediaItem
mediaItemDecoder =
    Decode.map6 MediaItem
        (Decode.field "Id" Decode.string)
        (Decode.field "Name" Decode.string)
        (Decode.field "Type" mediaTypeDecoder)
        (Decode.field "ImageTags" (Decode.map (\_ -> "placeholder.jpg") (Decode.dict Decode.string)))
        (Decode.field "ProductionYear" Decode.int)
        (Decode.field "CommunityRating" (Decode.maybe Decode.float)
            |> Decode.map (Maybe.withDefault 0.0)
        )


-- We need to break this down since Elm only provides up to map8
mediaDetailDecoder : Decoder MediaDetail
mediaDetailDecoder =
    let
        baseDetailDecoder =
            Decode.map8
                (\id title type_ imageUrl year rating description directors ->
                    { id = id
                    , title = title
                    , type_ = type_
                    , imageUrl = imageUrl
                    , year = year
                    , rating = rating
                    , description = description
                    , directors = directors
                    , actors = [] -- Will be filled in later
                    , duration = 0 -- Will be filled in later
                    , genres = [] -- Will be filled in later
                    }
                )
                (Decode.field "Id" Decode.string)
                (Decode.field "Name" Decode.string)
                (Decode.field "Type" mediaTypeDecoder)
                (Decode.field "ImageTags" (Decode.map (\_ -> "placeholder.jpg") (Decode.dict Decode.string)))
                (Decode.field "ProductionYear" Decode.int)
                (Decode.field "CommunityRating" (Decode.maybe Decode.float)
                    |> Decode.map (Maybe.withDefault 0.0)
                )
                (Decode.field "Overview" (Decode.maybe Decode.string)
                    |> Decode.map (Maybe.withDefault "No description available.")
                )
                (Decode.field "People" (Decode.list (Decode.field "Name" Decode.string))
                    |> Decode.map (List.filter (\_ -> True)) -- This would filter for directors in real impl
                )

        -- Decoder for the remaining fields
        remainingDecoder baseDetail =
            Decode.map3
                (\actors duration genres ->
                    { baseDetail
                        | actors = actors
                        , duration = duration
                        , genres = genres
                    }
                )
                (Decode.field "People" (Decode.list (Decode.field "Name" Decode.string))
                    |> Decode.map (List.filter (\_ -> True)) -- This would filter for actors in real impl
                )
                (Decode.field "RunTimeTicks" Decode.int
                    |> Decode.map (\ticks -> ticks // 600000000) -- Convert ticks to minutes
                )
                (Decode.field "Genres" (Decode.list Decode.string))
    in
    baseDetailDecoder
        |> Decode.andThen remainingDecoder


categoryDecoder : Decoder Category
categoryDecoder =
    Decode.map3 Category
        (Decode.field "Id" Decode.string)
        (Decode.field "Name" Decode.string)
        (Decode.field "Items" (Decode.list mediaItemDecoder))


-- ENCODERS

mediaTypeToString : MediaType -> String
mediaTypeToString mediaType =
    case mediaType of
        Movie -> "Movie"
        TVShow -> "Series"
        Music -> "Audio"


-- HTTP HELPERS

buildUrl : ServerConfig -> String -> String
buildUrl config path =
    config.baseUrl ++ path ++ buildAuthParams config


buildAuthParams : ServerConfig -> String
buildAuthParams config =
    case ( config.apiKey, config.userId ) of
        ( Just key, Just userId ) ->
            "?api_key=" ++ key ++ "&userId=" ++ userId

        ( Just key, Nothing ) ->
            "?api_key=" ++ key

        _ ->
            ""
