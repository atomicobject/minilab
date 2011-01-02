require_relative "../spec_helper"

feature "Analog" do
  scenario "inputs" do
    analog_input_4_should_be_about 5.0

    analog_input_1_should_be_about 0.0
  end

  scenario "outputs" do
    write_analog_1 5.0
    analog_input_0_should_be_about 5.0

    write_analog_1 0.0
    analog_input_0_should_be_about 0.0

    write_analog_1 2.77
    analog_input_0_should_be_about 2.77

    write_analog_1 3.19
    analog_input_0_should_be_about 3.19

    write_analog_0 5.0
    analog_input_6_should_be_about 5.0

    write_analog_0 0.0
    analog_input_6_should_be_about 0.0

    write_analog_0 3.75
    analog_input_6_should_be_about 3.75

    write_analog_0 1.88
    analog_input_6_should_be_about 1.88
  end
end
