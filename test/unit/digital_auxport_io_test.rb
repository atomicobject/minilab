require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"

class DigitalAuxportIoTest < Test::Unit::TestCase
  include MinilabConstants
  def setup
    mox = create_mocks(:minilab_hardware, :result_verifier)
    @target = DigitalAuxportIo.new(mox)
    
    @good_pins = ['DIO0', 'DIO1', 'DIO2', 'DIO3']
    @bad_pins = ['yourmom', 'bill', nil, false, 55, 'DIO4', -1, 38]
  end

  # Input tests
  should "read digital data from the screw terminals" do
    expect_read_auxport_and_verification('DIO1', 1)
    assert_equal 1, @target.read_digital('DIO1')

    expect_read_auxport_and_verification('DIO2', 0)
    assert_equal 0, @target.read_digital('DIO2')
  end

  should "raise an exception when digital input pin is not valid" do
    make_sure_bad_pins_blow_up

    @good_pins.each do |pin|
      expect_read_auxport_and_verification(pin, 1)
      assert_nothing_raised { @target.read_digital(pin) }
    end
  end

  # Output tests
  should "write digital data to the screw terminals" do
    expect_write_auxport_and_verification('DIO1', 1)
    @target.write_digital('DIO1', 1)

    expect_write_auxport_and_verification('DIO1', 0)
    @target.write_digital('DIO1', 0)

    expect_write_auxport_and_verification('DIO3', 1)
    @target.write_digital('DIO3', 1)
  end

  should "write 1 to a digital output when the commanded value is anything not 0" do
    expect_write_auxport_and_verification('DIO2', 1)
    @target.write_digital('DIO2', 173)

    expect_write_auxport_and_verification('DIO2', 1)
    @target.write_digital('DIO2', 2902)
  end

  should "raise an exception if someone tries to command a negative value" do
    assert_raise(RuntimeError) { @target.write_digital('DIO2', -10) }
    assert_raise(RuntimeError) { @target.write_digital('DIO2', -80) }
  end
  
  should "raise an exception when digital output pin is out of range" do
    make_sure_bad_pins_blow_up

    @good_pins.each do |pin|
      expect_write_auxport_and_verification(pin, 1)
      assert_nothing_raised { @target.write_digital(pin, 1) }
    end
  end

  should "accept case-insensitive DIO strings as pins" do
    expect_write_auxport_and_verification('dio1', 1)
    @target.write_digital('dio1', 1)

    expect_write_auxport_and_verification('dIo2', 1)
    @target.write_digital('dIo2', 1)

    expect_read_auxport_and_verification('DiO0', 0)
    @target.read_digital('DiO0')

    expect_read_auxport_and_verification('diO3', 0)
    @target.read_digital('diO3')
  end

  private
  def get_pin_number(pin)
    pin.match(/(\d)$/)[0].to_i
  end

  def expect_read_auxport_and_verification(pin, value)
    pin = get_pin_number(pin)
    configuration = { :direction => DIGITALIN, :pin => pin }
    result1 = { :dell => 4, :keyboard => 7 }
    @minilab_hardware.expects.configure_auxport(configuration).returns(result1)
    @result_verifier.expects.verify(result1, "configure_auxport_in")

    result2 = { :value => value }
    @minilab_hardware.expects.read_auxport(pin).returns(result2)
    @result_verifier.expects.verify(result2, "read_auxport")
  end

  def expect_write_auxport_and_verification(pin, value)
    pin = get_pin_number(pin)
    configuration = { :direction => DIGITALOUT, :pin => pin }
    result1 = { :stand => 2 }
    @minilab_hardware.expects.configure_auxport(configuration).returns(result1)
    @result_verifier.expects.verify(result1, "configure_auxport_out")

    result2 = { :card => "numerous" }
    @minilab_hardware.expects.write_auxport(pin, value).returns(result2)
    @result_verifier.expects.verify(result2, "write_auxport")
  end

  def make_sure_bad_pins_blow_up
    @bad_pins.each do |pin|
      assert_raise(RuntimeError) { @target.read_digital(pin) }
    end
  end
end
