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
  { licenses = [ ], currentLicense = emptyLicense }
  -- { licenses = [ ], currentLicense = License 0 }
  ! [getAllLicenses]

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- UPDATE

emptyLicense : License
emptyLicense = 
  License 0 "" "" "" 0 "" ""

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
      { model | currentLicense = emptyLicense }
     ! [getAllLicenses]
    UpdateLicenseResult (Err _) ->
      (model, Cmd.none)
    GetAllLicensesResult (Ok licenses) ->
      ( { model | licenses = licenses } , Cmd.none)
    GetAllLicensesResult (Err _) ->
      (model, Cmd.none)

myForm : { a | currentLicense : License } -> Html Msg
myForm model =
  div [ class "ui small form" ]
    [ div [ class "five fields" ]
      [ div [ class "field" ]
        [ label [] [ text "Product Name" ]
        , input [ type_ "text" ] []
        ]
      , div [ class "field" ]
        [ label [] [ text "Company Name" ]
        , input [ type_ "text" ] []
        ]
      , div [ class "field" ]
        [ label [] [ text "Valid From" ]
        , input [ type_ "text" ] []
        ]
      , div [ class "field" ]
        [ label [] [ text "Good Through" ]
        , input [ type_ "text" ] []
        ]
      , div [ class "field" ]
        [ label [] [ text "Available" ]
        , input [ type_ "text" ] []
        ]
      ]
    , div [ class "ui green submit button",  onClick <| UpdateLicenseRequest (model.currentLicense) ]
      [ text "Create" ]
    ]

myRow : License -> Html msg
myRow license =
    tr []
    [ td [] [ text (toString license.id) ]
    , td [] [ text license.productName ]
    , td [] [ text license.companyName ]
    , td [] [ text license.licenseKey ]
    , td [] [ text (toString license.available) ]
    , td [] [ text license.validFrom ]
    , td [] [ text license.goodThrough ]
    , td [] 
         [ button [class "ui small red button"] 
           [text "Delete"]
         ]
    ]

myTable : List License -> Html msg
myTable licenses = 
  table [ class "ui single line table" ]
    [ thead []
      [ tr []
        [ th [] [ text "Id" ]
        , th [] [ text "Product Name" ]
        , th [] [ text "Company Name" ]
        , th [] [ text "License Key" ]
        , th [] [ text "Available" ]
        , th [] [ text "Valid From" ]
        , th [] [ text "Good Through" ]
        , th [] [ text "" ]
        ]
      ]
    , tbody []
      (licenses |> List.map myRow)
    ]


-- VIEW

view : Model -> Html Msg
view model =
    div [ class "ui basic segment"]
        [ myForm model
        , myTable (model.licenses)
        ]
