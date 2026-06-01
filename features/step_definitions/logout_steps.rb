Cuando("cierro sesión") do
  el = find("#logout2", wait: 10)
  page.execute_script("arguments[0].click()", el)
  sleep 1
end

Entonces("debería estar deslogueado") do
  expect(page).to have_no_css("#nameofuser", visible: true, wait: 10)
  expect(page).to have_no_css("#logout2", visible: true, wait: 10)
  expect(page).to have_css("#login2", visible: true, wait: 10)
  expect(page).to have_css("#signin2", visible: true, wait: 10)
  expect(find("#login2").text).to eq("Log in")
  expect(find("#signin2").text).to eq("Sign up")
end