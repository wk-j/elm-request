module Api exposing (..)

import Http
import Json.Decode as Decode exposing (list, int,string, field, map2)

type alias QLicense = { id: Int, licenseKey: String }

licenseDecord = map2 QLicense  (field "id" int) (field "licenseKey" string)

getAllLicenses = 
    Http.get "http://localhost:20000/api/license/getAllLicenses?token=5b91d36c-f26c-4d15-aeab-5e56f0df15e6" (list licenseDecord)