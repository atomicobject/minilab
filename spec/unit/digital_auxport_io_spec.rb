require_relative "../spec_helper"

describe Minilab::DigitalAuxportIo do
  before { @mox = create_mocks(:minilab_wrapper) }
  subject { described_class.new(@mox) }

  it "read digital data from the screw terminals" do
    expected_configuration = { :direction => DIGITALIN, :pin => get_pin_number("DIO1") }
    @minilab_wrapper.configure_auxport(expected_configuration)
    @minilab_wrapper.read_auxport(get_pin_number("DIO1")).returns 1

    assert_equal 1, subject.read_digital('DIO1')
  end

  it "raise an error when digital input pin is not valid" do
    make_sure_bad_pins_blow_up

    good_pins.each do |pin|
      expected_configuration = { :direction => DIGITALIN, :pin => get_pin_number(pin) }
      @minilab_wrapper.configure_auxport(expected_configuration)
      @minilab_wrapper.read_auxport(get_pin_number(pin)).returns 0
      -> { subject.read_digital(pin) }.should_not raise_error
    end
  end

  # Output tests
  it "write digital data to the screw terminals" do
    expected_configuration = { :direction => DIGITALOUT, :pin => get_pin_number("DIO1") }
    @minilab_wrapper.configure_auxport(expected_configuration)
    @minilab_wrapper.write_auxport(get_pin_number("DIO1"), 1)

    subject.write_digital("DIO1", 1)
  end

  it "write 1 to a digital output when the commanded value is anything not 0" do
    expected_configuration = { :direction => DIGITALOUT, :pin => get_pin_number("DIO1") }
    @minilab_wrapper.configure_auxport(expected_configuration)
    @minilab_wrapper.write_auxport(get_pin_number("DIO1"), 1)
    subject.write_digital("DIO1", 173)

    @minilab_wrapper.configure_auxport(expected_configuration)
    @minilab_wrapper.write_auxport(get_pin_number("DIO1"), 1)
    subject.write_digital("DIO1", 872)
  end

  it "raise an exception if someone tries to command a negative value" do
    -> { subject.write_digital("DIO2", -1) }.should raise_error
    -> { subject.write_digital("DIO2", -80) }.should raise_error
  end
  
  it "raise an exception when digital output pin is out of range" do
    make_sure_bad_pins_blow_up

    good_pins.each do |pin|
      expected_configuration = { :direction => DIGITALOUT, :pin => get_pin_number(pin) }
      @minilab_wrapper.configure_auxport(expected_configuration)
      @minilab_wrapper.write_auxport(get_pin_number(pin), 1)
      -> { subject.write_digital(pin, 1) }.should_not raise_error
    end
  end

  it "accept case-insensitive DIO strings as pins" do
    expected_configuration = { :direction => DIGITALOUT, :pin => get_pin_number("DIO1") }
    @minilab_wrapper.configure_auxport(expected_configuration)
    @minilab_wrapper.write_auxport(get_pin_number("DIO1"), 1)
    subject.write_digital('dio1', 1)

    expected_configuration = { :direction => DIGITALOUT, :pin => get_pin_number("DIO2") }
    @minilab_wrapper.configure_auxport(expected_configuration)
    @minilab_wrapper.write_auxport(get_pin_number("DIO2"), 1)
    subject.write_digital('dIo2', 1)

    expected_configuration = { :direction => DIGITALIN, :pin => get_pin_number("DIO0") }
    @minilab_wrapper.configure_auxport(expected_configuration)
    @minilab_wrapper.read_auxport(get_pin_number("DIO0")).returns 1
    subject.read_digital('DiO0')

    expected_configuration = { :direction => DIGITALIN, :pin => get_pin_number("DIO3") }
    @minilab_wrapper.configure_auxport(expected_configuration)
    @minilab_wrapper.read_auxport(get_pin_number("DIO3")).returns 1
    subject.read_digital('diO3')
  end

  private
  def get_pin_number(pin)
    pin.match(/(\d)$/)[0].to_i
  end

  def good_pins
    %w[ DIO0 DIO1 DIO2 DIO3 ]
  end

  def make_sure_bad_pins_blow_up
    [ 'yourmom', 'bill', nil, false, 55, 'DIO4', -1, 38 ].each do |pin|
      -> { subject.read_digital(pin) }.should raise_error
    end
  end
end
