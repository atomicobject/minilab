require_relative "../spec_helper"

feature "Digital screw terminals" do
  scenario "input" do
    dio1_should_be 1
    dio2_should_be 0
  end

  scenario "output" do
    write_dio0 1
    dio3_should_be 1

    write_dio0 0
    dio3_should_be 0

    write_dio0 0
    analog_input_2_should_be_about 0.0

    write_dio0 1
    analog_input_2_should_be_greater_than 0.0
  end
end
