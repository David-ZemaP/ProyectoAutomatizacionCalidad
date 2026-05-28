Before do
  page.execute_script("localStorage.clear()")
rescue
end

Before("@products") do
  unless page.has_css?("#tbodyid", wait: 5)
    visit "/"
    expect(page).to have_css("#tbodyid", wait: 10)
  end
end

Before("@add_to_cart") do
  @initial_cart_count = 0
  if page.has_css?("#cartur", wait: 3)
    cart_text = find("#cartur").text
    if cart_text.match?(/\((\d+)\)/)
      @initial_cart_count = cart_text.match(/\((\d+)\)/)[1].to_i
    end
  end
end

Before("@navigation") do
  unless page.has_css?("#next2", wait: 5)
    visit "/"
    expect(page).to have_css("#next2", wait: 10)
  end
end

Before("@smoke") do
  visit "/" unless page.has_css?("#navbarExample", wait: 3)
end
