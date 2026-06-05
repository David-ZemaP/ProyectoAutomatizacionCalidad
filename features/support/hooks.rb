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

RUN_ONCE_DIR = File.join(__dir__, "..", ".run_once")

Before("@first_run_only") do |scenario|
  marker = File.join(RUN_ONCE_DIR, scenario.name.gsub(/\s+/, "_").gsub(/[^\w]/, "").downcase + ".marker")
  @run_once_marker = marker

  if File.exist?(marker)
    skip_this_scenario("Ya se ejecutó: #{scenario.name}")
  end
end

After("@first_run_only") do
  FileUtils.mkdir_p(RUN_ONCE_DIR)
  File.write(@run_once_marker, "Ejecutado el: #{Time.now}")
end
