module DemoblazeConstants
  ORDER_FIELD_IDS = {
    "name" => "name",
    "country" => "country",
    "city" => "city",
    "credit card" => "card",
    "month" => "month",
    "year" => "year"
  }.freeze

  CONTACT_FIELD_IDS = {
    "contact email" => "recipient-email",
    "contact name" => "recipient-name",
    "message" => "message-text"
  }.freeze

  LOGIN_FIELD_IDS = {
    "username" => "loginusername",
    "password" => "loginpassword"
  }.freeze

  SIGNUP_FIELD_IDS = {
    "username" => "sign-username",
    "password" => "sign-password"
  }.freeze
end