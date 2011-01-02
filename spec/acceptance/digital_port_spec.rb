require_relative "../spec_helper"

feature "Digital ports" do
  scenario "reading bits" do
    configure_portb_for_input
    digital_pin_10_should_be 1

    configure_porta_for_input
    digital_pin_30_should_be 0
  end

  scenario "writing bits" do
    # Port A --> Port B
    configure_porta_for_output
    configure_portb_for_input

    write_digital_pin_36 1
    digital_pin_7_should_be 1

    write_digital_pin_36 0
    digital_pin_7_should_be 0

    # Port B --> Port CL
    configure_portb_for_output
    configure_portcl_for_input

    write_digital_pin_5 0
    digital_pin_28_should_be 0

    write_digital_pin_5 1
    digital_pin_28_should_be 1

    # Port CL -> Port CH
    configure_portcl_for_output
    configure_portch_for_input

    write_digital_pin_27 1
    digital_pin_22_should_be 1

    write_digital_pin_27 0
    digital_pin_22_should_be 0

    # Port CH -> Port A
    configure_portch_for_output
    configure_porta_for_input

    write_digital_pin_24 0
    digital_pin_34_should_be 0

    write_digital_pin_24 1
    digital_pin_34_should_be 1
  end

  scenario "reading bytes" do
    configure_porta_for_output
    configure_portcl_for_output
    configure_portb_for_input

                           # GND to pin 3 (portb bit 7)
                           # GND to pin 4 (portb bit 6)
    write_digital_pin_28 1 # map to pin 5 (portb bit 5)
                           # GND to pin 6 (portb bit 4)
    write_digital_pin_36 1 # map to pin 7 (portb bit 3)
                           # GND to pin 8 (portb bit 2)
                           # GND to pin 9 (portb bit 1)
                           # +5v to pin 10 (portb bit 0)
    digital_portb_should_be 0x29



    configure_porta_for_output
    configure_portcl_for_output
    configure_portch_for_input

    write_digital_pin_27 1 # map to pin 22 (portch bit 3)
                           # GND to pin 23 (portch bit 2)
    write_digital_pin_32 1 # map to pin 24 (portch bit 1)
                           # GND to pin 22 (portch bit 0)
  digital_portch_should_be 0x0A
  end
end
