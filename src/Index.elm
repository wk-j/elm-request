import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json exposing (string, list, int, map2, field)

main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

-- MODEL

type alias License = 
  { id: Int
  , licenseKey: String }

type alias Model = 
  { licenses : List License }

init : (Model, Cmd Msg)
init = 
  Model []
  ! [getAllLicenses]

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- UPDATE

type Msg 
  = GetLicenses
  | NewLicenses (Result Http.Error (List License))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of
    GetLicenses ->
      model
      ! [getAllLicenses]
    NewLicenses (Ok licenses) ->
      ( { model | licenses = licenses } , Cmd.none)
    NewLicenses (Err _) ->
      (model, Cmd.none)

-- VIEW
view : Model -> Html Msg
view model =
    div []
        [ input
            [ placeholder "enter a movie title"
            , value (model.licenses |> List.length |> toString)
            , autofocus True
            ]
            []
        , button [ onClick GetLicenses ] [ text "Get license" ]
        , br [] []
        ]

getAllLicenses : Cmd Msg
getAllLicenses = 
  let 
    url = "http://localhost:20000/api/license/getAllLicenses?token=5b91d36c-f26c-4d15-aeab-5e56f0df15e6"
  in  
    Http.send NewLicenses (Http.get url decodeLicenses)


decodeLicense : Json.Decoder License
decodeLicense = 
  map2 License
    (field "id" int)
    (field "licenseKey" string)

decodeLicenses : Json.Decoder  (List License)
decodeLicenses =
  Json.list decodeLicense
