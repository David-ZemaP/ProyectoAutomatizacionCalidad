module DemoblazeConstants
  BASE_URL = "https://www.demoblaze.com".freeze
  RUTA_INICIO = "/".freeze
  RUTA_CARRITO = "/cart.html".freeze
  API_CATEGORIAS = "https://api.demoblaze.com/bycat".freeze

  MENSAJE_PRODUCTO_AGREGADO = "Product added".freeze

  LOGOUT_BUTTON = "//a[@id='logout2' and contains(text(), 'Log out')]".freeze
  LOGIN_BUTTON = "//a[@id='login2' and contains(text(), 'Log in')]".freeze
  SIGNUP_BUTTON = "//a[@id='signin2' and contains(text(), 'Sign up')]".freeze

  LOGIN_FIELDS = {
    "username" => { "id" => "loginusername", "type" => "input" },
    "password" => { "id" => "loginpassword", "type" => "input" }
  }.freeze

  SIGNUP_FIELDS = {
    "username" => { "id" => "sign-username", "type" => "input" },
    "password" => { "id" => "sign-password", "type" => "input" }
  }.freeze

  CONTACT_FIELDS = {
    "contact email" => { "id" => "recipient-email", "type" => "input" },
    "contact name" => { "id" => "recipient-name", "type" => "input" },
    "message" => { "id" => "message-text", "type" => "input" }
  }.freeze

  ORDER_FIELDS = {
    "name" => { "id" => "name", "type" => "input" },
    "country" => { "id" => "country", "type" => "input" },
    "city" => { "id" => "city", "type" => "input" },
    "credit card" => { "id" => "card", "type" => "input" },
    "month" => { "id" => "month", "type" => "input" },
    "year" => { "id" => "year", "type" => "input" }
  }.freeze

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