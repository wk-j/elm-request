import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import Api exposing (..)

main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

-- MODEL

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
