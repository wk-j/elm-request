module Model exposing (..)

import Http

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
  | EditCompanyName String
  | EditProductName String
  | EditAvailable String
  | EditValidFrom String
  | EditGoodThrough String
  | ChangeTab (Tab)

type alias Registration = 
  { id: Int
  , productName: String
  , companyName: String
  , licenseKey: String
  , machingKey: String
  , goodThrough: String }

type alias License = 
  { id: Int
  , productName: String 
  , companyName: String
  , licenseKey: String 
  , available: Int
  , validFrom: String
  , goodThrough: String
  }
