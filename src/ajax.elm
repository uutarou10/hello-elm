import Browser
import Http
import Html exposing (Html, pre, text)

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
  | Success String

init : () -> (Model, Cmd Msg)
init _ =
  ( Loading
  , Http.get
      { url = "https://qiita.com/api/v2/users/uutarou10"
      , expect = Http.expectString Received
      }
  )

type Msg
  = Received (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
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
    Success response ->
      pre [] [text response]
