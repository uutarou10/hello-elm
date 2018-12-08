module Main exposing (Model(..), Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (Html, div, img, p, text)
import Html.Attributes exposing (src)
import Http
import Json.Decode exposing (Decoder, field, map2, string)


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type Model
    = Fail
    | Loading
    | Success QiitaUser


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , Http.get
        { url = "https://qiita.com/api/v2/users/uutarou10"
        , expect = Http.expectJson Received qiitaUserDecode
        }
    )


type Msg
    = Received (Result Http.Error QiitaUser)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Received result ->
            case result of
                Ok string ->
                    ( Success string
                    , Cmd.none
                    )

                Err _ ->
                    ( Fail
                    , Cmd.none
                    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    case model of
        Fail ->
            text "hoge"

        Loading ->
            text "Loading..."

        Success qiitaUser ->
            div []
                [ img [ src qiitaUser.profileImageUrl ] []
                , p [] [ text qiitaUser.id ]
                ]


type alias QiitaUser =
    { id : String
    , profileImageUrl : String
    }


qiitaUserDecode : Decoder QiitaUser
qiitaUserDecode =
    map2 QiitaUser
        (field "id" string)
        (field "profile_image_url" string)
