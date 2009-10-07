require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"

class LibraryTranslatorTest < Test::Unit::TestCase
  include MinilabConstants

  def setup
    @target = LibraryTranslator.new
  end

  def teardown
  end

  def check_pins_and_ports(low, high, port)
    low.upto(high) do |pin|
      assert_equal port, @target.get_port_for_pin(pin), "Didn't get #{port} for pin #{pin}"
    end
  end

  # tests
  should "provide :porta when asked about numbered pins on the hardware's FIRSTPORTA" do
    check_pins_and_ports(30, 37, :porta)
  end

  should "provide :portb when asked about numbered pins on the hardware's FIRSTPORTB" do
    check_pins_and_ports(3, 10, :portb)
  end

  should "provide :portcl when asked about numbered pins on the hardware's FIRSTPORTCL" do
    check_pins_and_ports(26, 29, :portcl)
  end

  should "provide :portch when asked about numbered pins on the hardware's FIRSTPORTCH" do
    check_pins_and_ports(22, 25, :portch)
  end

  should "raise an error when asked about a pin number that does not map to a port (such as the pins for ground, 5v +ve, DIO1..3, etc)" do
    [ 1, 2, "DIO0", "DIO2", nil, :thedude, 832].each do |bad_pin|
      assert_raise(RuntimeError) { @target.get_port_for_pin(bad_pin) }
    end
  end

  should "get the number the library uses for the pin when asked to translate from the numbers on the board (port a pins)" do
    assert_equal 7, @target.get_library_pin_number(30)
    assert_equal 6, @target.get_library_pin_number(31)
    assert_equal 5, @target.get_library_pin_number(32)
    assert_equal 4, @target.get_library_pin_number(33)
    assert_equal 3, @target.get_library_pin_number(34)
    assert_equal 2, @target.get_library_pin_number(35)
    assert_equal 1, @target.get_library_pin_number(36)
    assert_equal 0, @target.get_library_pin_number(37)
  end

  should "get the number the library uses for the pin when asked to translate from the numbers on the board (port b pins)" do
    assert_equal 15, @target.get_library_pin_number(3)
    assert_equal 14, @target.get_library_pin_number(4)
    assert_equal 13, @target.get_library_pin_number(5)
    assert_equal 12, @target.get_library_pin_number(6)
    assert_equal 11, @target.get_library_pin_number(7)
    assert_equal 10, @target.get_library_pin_number(8)
    assert_equal 9, @target.get_library_pin_number(9)
    assert_equal 8, @target.get_library_pin_number(10)
  end
  
  should "get the number the library uses for the pin when asked to translate from the numbers on the board (port cl pins)" do
    assert_equal 19, @target.get_library_pin_number(26)
    assert_equal 18, @target.get_library_pin_number(27)
    assert_equal 17, @target.get_library_pin_number(28)
    assert_equal 16, @target.get_library_pin_number(29)
  end
  
  should "get the number the library uses for the pin when asked to translate from the numbers on the board (port ch pins)" do
    assert_equal 23, @target.get_library_pin_number(22)
    assert_equal 22, @target.get_library_pin_number(23)
    assert_equal 21, @target.get_library_pin_number(24)
    assert_equal 20, @target.get_library_pin_number(25)
  end

  should "raise an error if the pin passed in to get_library_pin_number is invalid" do
    [20, 21, nil, 12, :heynow, "uba"].each do |bad_pin|
      assert_raise(RuntimeError) { @target.get_library_pin_number(bad_pin) }
    end
  end

  should "know the mapping between symbolic ports and ports in the library" do
    assert_equal FIRSTPORTA, @target.get_library_port(:porta), "wrong port"
    assert_equal FIRSTPORTB, @target.get_library_port(:portb), "wrong port"
    assert_equal FIRSTPORTCL, @target.get_library_port(:portcl), "wrong port"
    assert_equal FIRSTPORTCH, @target.get_library_port(:portch), "wrong port"
  end

  should "raise an error if asked about the library port that does not exist" do
    [:portd, :portci, "cigarette butt", nil].each do |bad_port|
      assert_error RuntimeError, "Port #{bad_port} is not a valid port." do
        @target.get_library_port(bad_port)
      end
    end
  end 
end
