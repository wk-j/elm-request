import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import Api exposing (..)
import Debug

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
  , registrations: List Registration
  , currentLicense : License
  , tab : Tab
  }

init : (Model, Cmd Msg)
init = 
  { licenses = [ ], currentLicense = emptyLicense, tab = LicenseTab, registrations = [] }
  -- { licenses = [ ], currentLicense = License 0 }
  ! [getAllLicenses]

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- UPDATE

emptyLicense : License
emptyLicense = 
  License 0 "" "" "" 2 "2016/10/10" "2018/10/10"
  -- { id = 0, companyName = "", productName = "", available = 0, validFrom = "2016/10/10", goodThrough = "2018/10/10" }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of
    GetAllLicenseRequest ->
      let 
        k = Debug.log "Hello"
      in
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
      { model | licenses = licenses }
      ! [Cmd.none]

    GetAllLicensesResult (Err _) ->
      (model, Cmd.none)

    DeleteLicenseRequest license ->
      model
      ! [deleteLicense license]

    DeleteLicenseResult (Ok msg) ->
      model
      ! [getAllLicenses]

    DeleteLicenseResult (Err msg) ->
      model
      ! [Cmd.none]

    DeregisterRequest reg -> 
      model
      ! [deregister reg]

    DeregisterResult (Ok msg) ->
      model
      ! [getRegistrationStatus]
    
    DeregisterResult (Err msg) ->
      model
      ! [Cmd.none]

    GetRegistrationStatusRequest ->
      model
      ! [getRegistrationStatus]

    GetRegistrationStatusResult (Ok status) ->
      { model | registrations = status }
      ! [Cmd.none]

    GetRegistrationStatusResult (Err msg) ->
      model
      ! [Cmd.none]

    ChangeTab tab ->
      { model | tab = tab}
      ! case tab of
          RegistrationTab ->
            [getRegistrationStatus]
          LicenseTab ->
            [getAllLicenses]

    EditProductName product ->
      let current = model.currentLicense
          new = { current | productName = product }
      in
        { model | currentLicense = new }
        ! [Cmd.none]
    EditCompanyName company ->
      let current = model.currentLicense
          new = { current | companyName = company }
      in
        { model | currentLicense = new }
        ! [Cmd.none]
    EditAvailable a ->
      let current = model.currentLicense
          new = { current | available =  (toInt a) }
      in
        { model | currentLicense = new }
        ! [Cmd.none]
    EditValidFrom a ->
      let current = model.currentLicense
          new = { current | validFrom = a }
      in
        { model | currentLicense = new }
        ! [Cmd.none]
    EditGoodThrough a ->
      let current = model.currentLicense
          new = { current | goodThrough = a }
      in
        { model | currentLicense = new }
        ! [Cmd.none]

toInt : String -> Int
toInt input  =
  String.toInt input |> Result.toMaybe |> Maybe.withDefault 0


disable : License -> String
disable license = 
  if 
    license.companyName /= "" 
    && license.productName /= "" then
      ""
  else
    "disabled"

myForm : { a | currentLicense : License } -> Html Msg
myForm model =
  div [ class "ui small form segment" ]
    [ div [ class "five fields" ]
      [ div [ class "field" ]
        [ label [] [ text "Product Name" ]
        , input [ type_ "text", value model.currentLicense.productName, onInput EditProductName ] []
        ]
      , div [ class "field" ]
        [ label [] [ text "Company Name" ]
        , input [ type_ "text", value model.currentLicense.companyName, onInput EditCompanyName ] []
        ]
      , div [ class "field" ]
        [ label [] [ text "Valid From" ]
        , input [ type_ "date" , value "2016-10-10" ] []
        ]
      , div [ class "field" ]
        [ label [] [ text "Good Through" ]
        , input [ type_ "date" , value "2018-10-10" ] []
        ]
      , div [ class "field" ]
        [ label [] [ text "Available"]
        , input [ type_ "number", value <| toString model.currentLicense.available, onInput EditAvailable] []
        ]
      ]
    , div [ class ("ui blue submit button " ++ disable model.currentLicense),  onClick <| UpdateLicenseRequest (model.currentLicense) ]
      [ text "Create" ]
    ]

myRow : License -> Html Msg
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
         [ button [class "ui small red button", onClick <| DeleteLicenseRequest (license) ] 
           [text "Delete"]
         ]
    ]

myTable : List License -> Html Msg
myTable licenses = 
  table [ class "ui orange single line table" ]
    [ thead []
      [ tr []
        [ th [] [ text "#" ]
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

disableDeregis : Registration -> String
disableDeregis license =
  if license.machineKey == "-" then "disabled"
  else ""

myRegRow : Registration -> Html Msg
myRegRow license =
    tr []
    [ td [] [ text (toString license.id) ]
    , td [] [ text license.productName ]
    , td [] [ text license.companyName ]
    , td [] [ text license.licenseKey ]
    , td [] [ text license.machineKey ]
    , td [] [ text license.goodThrough ]
    , td [] 
         [ button [class ("ui small red button " ++ disableDeregis license), onClick <| DeregisterRequest (license) ] 
            [text "Deregister"]
         ]
    ]


myRegTable : List Registration -> Html Msg
myRegTable regs = 
  table [ class "ui orange single line table" ]
    [ thead []
      [ tr []
        [ th [] [ text "#" ]
        , th [] [ text "Product Name" ]
        , th [] [ text "Company Name" ]
        , th [] [ text "License Key" ]
        , th [] [ text "Machine Key" ]
        , th [] [ text "Good Through" ]
        , th [] [ ]
        ]
      ]
    , tbody []
      (regs |> List.map myRegRow)
    ]

tab : Tab -> Html Msg
tab tab = 
  let 
    active t =  
      if tab == t then "item active"
      else "item"
  in
    div [ class "ui pointing menu" ]
      [ a [ class (active LicenseTab) , onClick (ChangeTab LicenseTab)] [ text "License"]
      , a [ class (active RegistrationTab) , onClick (ChangeTab RegistrationTab) ] [ text "Registration" ]
      ]

-- VIEW
licenseTab : Model -> Html Msg
licenseTab model = 
  if model.tab == LicenseTab then
    div []
      [ myForm model
      , myTable (model.licenses)
      ]
  else
    div [] []

regTab : Model -> Html Msg
regTab model = 
  if model.tab == RegistrationTab then
    div []
      [ myRegTable (model.registrations) ]
  else
    div [] []

view : Model -> Html Msg
view model =
    div [ class "ui basic segment"]
        [ tab model.tab
        , regTab model
        , licenseTab model
        ]
