module Api exposing (..)

import Model exposing (..)
import Json.Encode as Encode 
import Json.Decode as Json exposing (string, list, int, map4, map, field)
import Http

host : String
host = "http://192.168.0.20"

type Msg 
  = GetAllLicenseRequest
  | UpdateLicenseRequest (License)
  | UpdateLicenseResult (Result Http.Error License)
  | GetAllLicensesResult (Result Http.Error (List License))

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

getAllLicenses : Cmd Msg
getAllLicenses = 
  let 
    url = host ++ "/api/license/getAllLicenses?token=5b91d36c-f26c-4d15-aeab-5e56f0df15e6"
  in  
    Http.send GetAllLicensesResult 
     (Http.get url decodeLicenses)

encodeLicense : License -> Encode.Value
encodeLicense license =
  [("id", Encode.int license.id)]
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
