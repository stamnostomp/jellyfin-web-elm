module TMDBData exposing
    ( fetchTMDBData
    , TMDBResponse
    , decodeMediaType
    )

import Http
import Json.Decode as Decode exposing (Decoder, field, string, int, float, list, maybe, map, map2, map3, map6, succeed)
import JellyfinAPI exposing (Category, MediaItem, MediaType(..))


-- TYPES

type alias TMDBResponse =
    { categories : List Category
    }


-- DECODERS

tmdbResponseDecoder : Decoder TMDBResponse
tmdbResponseDecoder =
    Decode.map TMDBResponse
        (field "categories" (list categoryDecoder))


categoryDecoder : Decoder Category
categoryDecoder =
    Decode.map3 Category
        (field "id" string)
        (field "name" string)
        (field "items" (list mediaItemDecoder))


mediaItemDecoder : Decoder MediaItem
mediaItemDecoder =
    Decode.map6 MediaItem
        (field "id" string)
        (field "title" string)
        (field "type_" mediaTypeDecoder)
        (field "imageUrl" string)
        (field "year" int)
        (field "rating" float)


mediaTypeDecoder : Decoder MediaType
mediaTypeDecoder =
    string
        |> Decode.andThen decodeMediaType


decodeMediaType : String -> Decoder MediaType
decodeMediaType str =
    case str of
        "Movie" ->
            succeed Movie

        "TVShow" ->
            succeed TVShow

        "Music" ->
            succeed Music

        _ ->
            Decode.fail ("Unknown media type: " ++ str)


-- FETCHING DATA

fetchTMDBData : (Result Http.Error TMDBResponse -> msg) -> Cmd msg
fetchTMDBData toMsg =
    Http.get
        { url = "/data/movies.json"  -- Path to your generated TMDB JSON
        , expect = Http.expectJson toMsg tmdbResponseDecoder
        }
