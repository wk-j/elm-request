module Api exposing (..)

import Model exposing (..)
import Json.Encode as Encode 
import Json.Decode as Json exposing (string, list, int, map4, map, field, dict)
import Http
import Dict

host : String
-- host = "http://192.168.0.20"
host = "http://localhost:20000"

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

deregister : Registration -> Cmd Msg
deregister license =
  let 
    url = host ++ "/api/license/deregister?token=5b91d36c-f26c-4d15-aeab-5e56f0df15e6"
  in
    Http.send  
      DeregisterResult 
      (Http.request 
        { method = "POST"
        , headers = [(Http.header "Content-Type" "application/json")]
        , url = url
        , body = encodeDeregister license |> Http.jsonBody
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
     
toObject : Dict.Dict comparable String -> List ( comparable, Encode.Value )
toObject dict = 
  let 
    l = dict |> Dict.toList
  in 
    l |> List.map (\(k, v) -> (k, Encode.string v))

encodeLicense : License -> Encode.Value
encodeLicense license =
  [ ("id", Encode.int license.id)
  , ("productName", Encode.string license.productName)
  , ("companyName", Encode.string license.companyName)
  , ("available", Encode.int license.available)
  , ("validFrom", Encode.string license.validFrom)
  , ("goodThrough", Encode.string license.goodThrough)
  , ("properties", Encode.object (toObject license.properties) )  
  ]
  |> Encode.object

encodeDeregister : Registration -> Encode.Value
encodeDeregister license = 
  [ ("licenseKey", Encode.string license.licenseKey)
  , ("machineKey", Encode.string license.machineKey)
  ]
  |> Encode.object

decodeLicense : Json.Decoder License
decodeLicense = 
  Json.map8 License
    (field "id" int)
    (field "productName" string)
    (field "companyName" string)
    (field "licenseKey" string)
    (field "available" int)
    (field "validFrom" string)
    (field "goodThrough" string)
    (field "properties" (dict string))

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
