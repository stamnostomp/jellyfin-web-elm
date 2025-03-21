module TMDBData exposing
    ( fetchTMDBData
    , TMDBResponse
    , decodeMediaType
    )

import Http
import Json.Decode as Decode exposing (Decoder, field, string, int, float, list, maybe, map, map2, map3, map6, map8, succeed)
import JellyfinAPI exposing (Category, MediaItem, MediaType(..), CastMember, CrewMember)


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
    -- First, decode the base fields
    Decode.map6
        (\id title type_ imageUrl year rating ->
            { id = id
            , title = title
            , type_ = type_
            , imageUrl = imageUrl
            , year = year
            , rating = rating
            , description = Nothing
            , backdropUrl = Nothing
            , genres = []
            , cast = []
            , directors = []
            }
        )
        (field "id" string)
        (field "title" string)
        (field "type_" mediaTypeDecoder)
        (field "imageUrl" string)
        (field "year" int)
        (field "rating" float)
    -- Then use andThen to decode the rest of the fields and create a complete item
    |> Decode.andThen (\baseItem ->
        Decode.map5
            (\description backdropUrl genres cast directors ->
                { baseItem
                | description = description
                , backdropUrl = backdropUrl
                , genres = genres
                , cast = cast
                , directors = directors
                }
            )
            (maybe (field "description" string))
            (maybe (field "backdropUrl" string))
            (field "genres" (list string))
            (field "cast" (list castMemberDecoder))
            (field "directors" (list crewMemberDecoder))
        )


castMemberDecoder : Decoder CastMember
castMemberDecoder =
    Decode.map5 CastMember
        (field "id" string)
        (field "name" string)
        (field "character" string)
        (maybe (field "profileUrl" string))
        (field "order" int)


crewMemberDecoder : Decoder CrewMember
crewMemberDecoder =
    Decode.map5 CrewMember
        (field "id" string)
        (field "name" string)
        (field "job" string)
        (field "department" string)
        (maybe (field "profileUrl" string))


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
        { url = "./data/movies.json"  -- Path to your generated TMDB JSON
        , expect = Http.expectJson toMsg tmdbResponseDecoder
        }
