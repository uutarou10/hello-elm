import Html exposing (Html, div, input, p, text)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)
import Browser

type alias Model =
  { content: String
  }

-- initはModel型の変数?
init : Model
init =
  { content = ""
  }

type Msg =
  Change String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Change str ->
      { model | content = str }

view : Model -> Html Msg
view model =
  div []
  [ input [value model.content, onInput Change ] []
  , p [] [text model.content]
  ]

main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }
