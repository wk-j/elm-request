import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Debug
import Json.Encode as Encode 
import Json.Decode as Json exposing (string, list, int, map4, map, field)

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
  --, productName: String 
  --, companyName: String
  --, licenseKey: String 
  }

type alias Model = 
  { licenses : List License 
  , currentLicense : License
  }

init : (Model, Cmd Msg)
init = 
  --{ licenses = [ ], currentLicense = License 0 "" "" "" }
  { licenses = [ ], currentLicense = License 0 }
  ! [getAllLicenses]

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- UPDATE

type Msg 
  = GetAllLicenseRequest
  | UpdateLicenseRequest (License)
  | UpdateLicenseResult (Result Http.Error License)
  | GetAllLicensesResult (Result Http.Error (List License))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of
    GetAllLicenseRequest ->
      model
      ! [getAllLicenses]
    UpdateLicenseRequest license ->
      model
      ! [updateLicense license]
    UpdateLicenseResult (Ok _)  ->
      --({ model | currentLicense = License 0 "" "" "" }, Cmd.none)
     { model | currentLicense = License 0 }
     ! [getAllLicenses]
    UpdateLicenseResult (Err _) ->
      (model, Cmd.none)
    GetAllLicensesResult (Ok licenses) ->
      ( { model | licenses = licenses } , Cmd.none)
    GetAllLicensesResult (Err _) ->
      (model, Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ input [value (model.licenses |> List.length |> toString)]
            []
        , button [class "ui small blue button", onClick <| UpdateLicenseRequest (model.currentLicense)]
            [text "New"]
        ]

updateLicense : License -> Cmd Msg
updateLicense license =
  let 
    url = "http://localhost:20000/api/license/updateLicense?token=5b91d36c-f26c-4d15-aeab-5e56f0df15e6"
  in
    Http.send  
      UpdateLicenseResult 
      (Http.request 
        { method = "POST"
        , headers = [(Http.header "Content-Type" "application/json")]
        , url = url
        , body = encodeLicense license |> Http.jsonBody
        , expect = Http.expectJson decodeLicense 
        , timeout = Nothing
        , withCredentials = False
         })

getAllLicenses : Cmd Msg
getAllLicenses = 
  let 
    url = "http://localhost:20000/api/license/getAllLicenses?token=5b91d36c-f26c-4d15-aeab-5e56f0df15e6"
  in  
    Http.send GetAllLicensesResult 
     (Http.get url decodeLicenses)

encodeLicense : License -> Encode.Value
encodeLicense license =
  [("id", Encode.int license.id)]
  |> Encode.object

decodeLicense : Json.Decoder License
decodeLicense = 
  Json.map License
    (field "id" int)
    --(field "licenseKey" string)
    --(field "productName" string)
    --(field "companyName" string)

decodeLicenses : Json.Decoder  (List License)
decodeLicenses =
  Json.list decodeLicense
