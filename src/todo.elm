module Main exposing (Filter(..), Model, Msg(..), Todo, init, main, subscriptions, update, view)

import Browser
import Html exposing (Html, button, div, input, label, li, p, text, ul)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- Model


type alias Model =
    { todos : List Todo
    , filter : Filter
    , lastId : Int
    , input : String
    }


type alias Todo =
    { id : Int
    , title : String
    , isDone : Bool
    }


type Filter
    = All
    | Completed
    | NotCompleted


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model [ Todo 0 "牛乳を買う" False ] All 0 "", Cmd.none )



-- Update


type Msg
    = AddTodo
    | ToggleStatus Int
    | ChangeFilter Filter
    | ChangeInput String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddTodo ->
            let
                newTodo =
                    Todo (model.lastId + 1) model.input False
            in
            ( { model | input = "", todos = newTodo :: model.todos }, Cmd.none )

        ToggleStatus id ->
            let
                newTodos =
                    List.map
                        (\t ->
                            if t.id == id then
                                { t | isDone = not t.isDone }

                            else
                                t
                        )
                        model.todos
            in
            ( { model | todos = newTodos }, Cmd.none )

        ChangeFilter filter ->
            ( { model | filter = filter }, Cmd.none )

        ChangeInput input ->
            ( { model | input = input }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ input
            [ onInput ChangeInput
            , value model.input
            ]
            []
        , button [ onClick AddTodo ] [ text "ADD" ]
        , div []
            [ label []
                [ input
                    [ type_ "radio"
                    , name "filter"
                    , checked <| model.filter == All
                    , onClick <| ChangeFilter All
                    ]
                    []
                , text "All"
                , label []
                    [ input
                        [ type_ "radio"
                        , name "filter"
                        , checked <| model.filter == Completed
                        , onClick <| ChangeFilter Completed
                        ]
                        []
                    , text "Completed"
                    ]
                , label []
                    [ input
                        [ type_ "radio"
                        , name "filter"
                        , checked <| model.filter == NotCompleted
                        , onClick <| ChangeFilter NotCompleted
                        ]
                        []
                    , text "NotCompleted"
                    ]
                ]
            ]
        , p [] [ text <| (String.fromInt <| List.length model.todos) ++ "todo(s)" ]
        , todoList model
        ]


todoList : Model -> Html Msg
todoList model =
    let
        todos =
            List.filter
                (\t ->
                    case model.filter of
                        All ->
                            True

                        Completed ->
                            t.isDone == True

                        NotCompleted ->
                            t.isDone == False
                )
                model.todos
    in
    ul [] <|
        List.map
            (\todo ->
                li [ onClick <| ToggleStatus todo.id ]
                    [ text
                        (todo.title
                            ++ (if todo.isDone then
                                    "(DONE)"

                                else
                                    "(NOT DONE)"
                               )
                        )
                    ]
            )
            todos
