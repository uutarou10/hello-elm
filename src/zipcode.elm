module Main exposing (main)

import Browser
import Html exposing (Html, button, div, form, h1, hr, input, p, text)
import Html.Attributes exposing (placeholder, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Http
import Json.Decode exposing (Decoder, field, map5, string)


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "" None, Cmd.none )


type alias Model =
    { input : String
    , status : Status
    }


type Status
    = None
    | Fail
    | Loading
    | Success Address


type alias Address =
    { pref : String
    , address : String
    , city : String
    , town : String
    , fullAddress : String
    }


type Msg
    = Search
    | Input String
    | Receive (Result Http.Error Address)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input str ->
            ( { model | input = str }, Cmd.none )

        Search ->
            ( model, request model.input )

        Receive result ->
            case result of
                Ok address ->
                    ( { model | status = Success address }, Cmd.none )

                Err _ ->
                    ( { model | status = Fail }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Zip code search" ]
        , div []
            [ form [ onSubmit Search ]
                [ input
                    [ placeholder "Input zip code"
                    , value model.input
                    , onInput Input
                    ]
                    []
                , button [ type_ "submit" ] [ text "Search" ]
                ]
            ]
        , hr [] []
        , resultView model
        ]


resultView : Model -> Html Msg
resultView model =
    case model.status of
        None ->
            text ""

        Fail ->
            text "Faild... Please retry."

        Loading ->
            text "Loading..."

        Success address ->
            p [] [ text address.fullAddress ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- http


request : String -> Cmd Msg
request zipCode =
    Http.get
        { url = "https://api.zipaddress.net/?zipcode=" ++ zipCode
        , expect = Http.expectJson Receive decoder
        }


decoder : Decoder Address
decoder =
    field "data"
        (map5 Address
            (field "pref" string)
            (field "address" string)
            (field "city" string)
            (field "town" string)
            (field "fullAddress" string)
        )
