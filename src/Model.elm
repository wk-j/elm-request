module Model exposing (..)

import Http
import Dict

type Tab = LicenseTab | RegistrationTab

type Msg 
  = GetAllLicenseRequest
  | GetAllLicensesResult (Result Http.Error (List License))
  | UpdateLicenseRequest (License)
  | UpdateLicenseResult (Result Http.Error License)
  | DeleteLicenseRequest (License)
  | DeleteLicenseResult (Result Http.Error String)
  | GetRegistrationStatusRequest
  | GetRegistrationStatusResult (Result Http.Error (List Registration))
  | DeregisterRequest (Registration)
  | DeregisterResult (Result Http.Error String)
  | EditCompanyName String
  | EditProductName String
  | EditAvailable String
  | EditValidFrom String
  | EditGoodThrough String
  | ChangeTab (Tab)
  | SelectLicense License
  | EditPropertyValue String String

type alias Registration = 
  { id: Int
  , productName: String
  , companyName: String
  , licenseKey: String
  , machineKey: String
  , goodThrough: String }

type alias License = 
  { id: Int
  , productName: String 
  , companyName: String
  , licenseKey: String 
  , available: Int
  , validFrom: String
  , goodThrough: String
  , properties: (Dict.Dict String String)
  }
