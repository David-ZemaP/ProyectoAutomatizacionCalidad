# -------------------------------------------------------------------
# Steps de verificación para login — casos borde
# -------------------------------------------------------------------

Entonces("no debería haber iniciado sesión") do
  expect(page).to have_no_css("#nameofuser", visible: true, wait: 5)
end
