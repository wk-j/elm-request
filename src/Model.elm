module Model exposing (..)

import Http

type Msg 
  = GetAllLicenseRequest
  | UpdateLicenseRequest (License)
  | UpdateLicenseResult (Result Http.Error License)
  | GetAllLicensesResult (Result Http.Error (List License))
  | DeleteLicenseRequest (License)
  | DeleteLicenseResult (Result Http.Error String)
  | EditCompanyName String
  | EditProductName String
  | EditAvailable String
  | EditValidFrom String
  | EditGoodThrough String

type alias License = 
  { id: Int
  , productName: String 
  , companyName: String
  , licenseKey: String 
  , available: Int
  , validFrom: String
  , goodThrough: String
  }
