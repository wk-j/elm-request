module Model exposing (..)

type alias License = 
  { id: Int
  , productName: String 
  , companyName: String
  , licenseKey: String 
  , available: Int
  , validFrom: String
  , goodThrough: String
  }
