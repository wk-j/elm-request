module Api exposing (..)

import Model exposing (..)
import Json.Encode as Encode 
import Json.Decode as Json exposing (string, list, int, map4, map, field)
import Http

host : String
host = "http://192.168.0.20"


deleteLicense : License -> Cmd Msg
deleteLicense license =
  let 
    url = host ++ "/api/license/deleteLicense?token=5b91d36c-f26c-4d15-aeab-5e56f0df15e6"
  in
    Http.send
      DeleteLicenseResult
      (Http.request 
        { method = "POST"
        , headers = [(Http.header "Content-Type" "application/json")]
        , url = url
        , body = encodeLicense license |> Http.jsonBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
         })

updateLicense : License -> Cmd Msg
updateLicense license =
  let 
    url = host ++ "/api/license/updateLicense?token=5b91d36c-f26c-4d15-aeab-5e56f0df15e6"
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

getRegistrationStatus : Cmd Msg
getRegistrationStatus = 
  let
    url = host ++ "/api/license/getRegistrationStatus?token=5b91d36c-f26c-4d15-aeab-5e56f0df15e6"
  in
    Http.send GetRegistrationStatusResult
      (Http.get url decodeRegs)

getAllLicenses : Cmd Msg
getAllLicenses = 
  let 
    url = host ++ "/api/license/getAllLicenses?token=5b91d36c-f26c-4d15-aeab-5e56f0df15e6"
  in  
    Http.send GetAllLicensesResult 
     (Http.get url decodeLicenses)

encodeLicense : License -> Encode.Value
encodeLicense license =
  [ ("id", Encode.int license.id)
  , ("productName", Encode.string license.productName)
  , ("companyName", Encode.string license.companyName)
  , ("available", Encode.int license.available)
  , ("validFrom", Encode.string license.validFrom)
  , ("goodThrough", Encode.string license.goodThrough)
  ]
  |> Encode.object

decodeLicense : Json.Decoder License
decodeLicense = 
  Json.map7 License
    (field "id" int)
    (field "productName" string)
    (field "companyName" string)
    (field "licenseKey" string)
    (field "available" int)
    (field "validFrom" string)
    (field "goodThrough" string)

decodeLicenses : Json.Decoder  (List License)
decodeLicenses =
  Json.list decodeLicense

decodeReg : Json.Decoder Registration
decodeReg = 
  Json.map6 Registration
    (field "id" int)
    (field "productName" string)
    (field "companyName" string)
    (field "licenseKey" string)
    (field "machineKey" string)
    (field "goodThrough" string)

decodeRegs : Json.Decoder  (List Registration)
decodeRegs =
  Json.list decodeReg

