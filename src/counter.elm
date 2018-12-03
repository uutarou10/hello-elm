module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


type alias Model =
    Int



-- initはModel型の値という意味の**型注釈**


init : Model
init =
    0


type Msg
    = Increment
    | Decrement



-- updateはMsgとModelを引数にとってModelを返す関数


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            -- Incrementだったらmodelに1を足して返す
            model + 1

        Decrement ->
            model - 1


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model) ]
        , button [ onClick Increment ] [ text "+" ]
        ]


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
