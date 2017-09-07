import Html exposing (beginnerProgram, div, button, text)
import Html.Events exposing (onClick)
import Api exposing (..)

main : Program Never number Msg
main =
  beginnerProgram { model = 0, view = view, update = update }

view : a -> Html.Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (toString model) ]
    , div [] [ text (toString getAllLicenses)]
    , button [ onClick Increment ] [ text "+" ]
    ]

type Msg = Increment | Decrement

update : Msg -> number -> number
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1
