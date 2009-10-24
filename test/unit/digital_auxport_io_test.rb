require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"

class DigitalAuxportIoTest < Test::Unit::TestCase
  include MinilabConstants

  def setup
    mox = create_mocks(:minilab_wrapper)
    @target = DigitalAuxportIo.new(mox)
  end

  should "read digital data from the screw terminals" do
    expected_configuration = { :direction => DIGITALIN, :pin => get_pin_number("DIO1") }
    @minilab_wrapper.expects.configure_auxport(expected_configuration)
    @minilab_wrapper.expects.read_auxport(get_pin_number("DIO1")).returns 1

    assert_equal 1, @target.read_digital('DIO1')
  end

  should "raise an error when digital input pin is not valid" do
    make_sure_bad_pins_blow_up

    good_pins.each do |pin|
      expected_configuration = { :direction => DIGITALIN, :pin => get_pin_number(pin) }
      @minilab_wrapper.expects.configure_auxport(expected_configuration)
      @minilab_wrapper.expects.read_auxport(get_pin_number(pin)).returns 0
      assert_nothing_raised { @target.read_digital(pin) }
    end
  end

  # Output tests
  should "write digital data to the screw terminals" do
    expected_configuration = { :direction => DIGITALOUT, :pin => get_pin_number("DIO1") }
    @minilab_wrapper.expects.configure_auxport(expected_configuration)
    @minilab_wrapper.expects.write_auxport(get_pin_number("DIO1"), 1)

    @target.write_digital("DIO1", 1)
  end

  should "write 1 to a digital output when the commanded value is anything not 0" do
    expected_configuration = { :direction => DIGITALOUT, :pin => get_pin_number("DIO1") }
    @minilab_wrapper.expects.configure_auxport(expected_configuration)
    @minilab_wrapper.expects.write_auxport(get_pin_number("DIO1"), 1)
    @target.write_digital("DIO1", 173)

    @minilab_wrapper.expects.configure_auxport(expected_configuration)
    @minilab_wrapper.expects.write_auxport(get_pin_number("DIO1"), 1)
    @target.write_digital("DIO1", 872)
  end

  should "raise an exception if someone tries to command a negative value" do
    assert_raise(RuntimeError) { @target.write_digital("DIO2", -1) }
    assert_raise(RuntimeError) { @target.write_digital("DIO2", -80) }
  end
  
  should "raise an exception when digital output pin is out of range" do
    make_sure_bad_pins_blow_up

    good_pins.each do |pin|
      expected_configuration = { :direction => DIGITALOUT, :pin => get_pin_number(pin) }
      @minilab_wrapper.expects.configure_auxport(expected_configuration)
      @minilab_wrapper.expects.write_auxport(get_pin_number(pin), 1)
      assert_nothing_raised { @target.write_digital(pin, 1) }
    end
  end

  should "accept case-insensitive DIO strings as pins" do
    expected_configuration = { :direction => DIGITALOUT, :pin => get_pin_number("DIO1") }
    @minilab_wrapper.expects.configure_auxport(expected_configuration)
    @minilab_wrapper.expects.write_auxport(get_pin_number("DIO1"), 1)
    @target.write_digital('dio1', 1)

    expected_configuration = { :direction => DIGITALOUT, :pin => get_pin_number("DIO2") }
    @minilab_wrapper.expects.configure_auxport(expected_configuration)
    @minilab_wrapper.expects.write_auxport(get_pin_number("DIO2"), 1)
    @target.write_digital('dIo2', 1)

    expected_configuration = { :direction => DIGITALIN, :pin => get_pin_number("DIO0") }
    @minilab_wrapper.expects.configure_auxport(expected_configuration)
    @minilab_wrapper.expects.read_auxport(get_pin_number("DIO0")).returns 1
    @target.read_digital('DiO0')

    expected_configuration = { :direction => DIGITALIN, :pin => get_pin_number("DIO3") }
    @minilab_wrapper.expects.configure_auxport(expected_configuration)
    @minilab_wrapper.expects.read_auxport(get_pin_number("DIO3")).returns 1
    @target.read_digital('diO3')
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
      assert_raise(RuntimeError) { @target.read_digital(pin) }
    end
  end
end
