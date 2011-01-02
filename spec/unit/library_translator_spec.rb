require_relative "../spec_helper"

describe Minilab::LibraryTranslator do
  def check_pins_and_ports(low, high, port)
    low.upto(high) do |pin|
      assert_equal port, subject.get_port_for_pin(pin), "Didn't get #{port} for pin #{pin}"
    end
  end

  it "provide :porta when asked about numbered pins on the hardware's FIRSTPORTA" do
    check_pins_and_ports(30, 37, :porta)
  end

  it "provide :portb when asked about numbered pins on the hardware's FIRSTPORTB" do
    check_pins_and_ports(3, 10, :portb)
  end

  it "provide :portcl when asked about numbered pins on the hardware's FIRSTPORTCL" do
    check_pins_and_ports(26, 29, :portcl)
  end

  it "provide :portch when asked about numbered pins on the hardware's FIRSTPORTCH" do
    check_pins_and_ports(22, 25, :portch)
  end

  it "raise an error when asked about a pin number that does not map to a port (such as the pins for ground, 5v +ve, DIO1..3, etc)" do
    [ 1, 2, "DIO0", "DIO2", nil, :thedude, 832].each do |bad_pin|
      -> { subject.get_port_for_pin(bad_pin) }.to raise_error(RuntimeError)
    end
  end

  it "get the number the library uses for the pin when asked to translate from the numbers on the board (port a pins)" do
    assert_equal 7, subject.get_library_pin_number(30)
    assert_equal 6, subject.get_library_pin_number(31)
    assert_equal 5, subject.get_library_pin_number(32)
    assert_equal 4, subject.get_library_pin_number(33)
    assert_equal 3, subject.get_library_pin_number(34)
    assert_equal 2, subject.get_library_pin_number(35)
    assert_equal 1, subject.get_library_pin_number(36)
    assert_equal 0, subject.get_library_pin_number(37)
  end

  it "get the number the library uses for the pin when asked to translate from the numbers on the board (port b pins)" do
    assert_equal 15, subject.get_library_pin_number(3)
    assert_equal 14, subject.get_library_pin_number(4)
    assert_equal 13, subject.get_library_pin_number(5)
    assert_equal 12, subject.get_library_pin_number(6)
    assert_equal 11, subject.get_library_pin_number(7)
    assert_equal 10, subject.get_library_pin_number(8)
    assert_equal 9, subject.get_library_pin_number(9)
    assert_equal 8, subject.get_library_pin_number(10)
  end
  
  it "get the number the library uses for the pin when asked to translate from the numbers on the board (port cl pins)" do
    assert_equal 19, subject.get_library_pin_number(26)
    assert_equal 18, subject.get_library_pin_number(27)
    assert_equal 17, subject.get_library_pin_number(28)
    assert_equal 16, subject.get_library_pin_number(29)
  end
  
  it "get the number the library uses for the pin when asked to translate from the numbers on the board (port ch pins)" do
    assert_equal 23, subject.get_library_pin_number(22)
    assert_equal 22, subject.get_library_pin_number(23)
    assert_equal 21, subject.get_library_pin_number(24)
    assert_equal 20, subject.get_library_pin_number(25)
  end

  it "raise an error if the pin passed in to get_library_pin_number is invalid" do
    [20, 21, nil, 12, :heynow, "uba"].each do |bad_pin|
      -> { subject.get_library_pin_number(bad_pin) }.to raise_error(RuntimeError)
    end
  end

  it "know the mapping between symbolic ports and ports in the library" do
    assert_equal FIRSTPORTA, subject.get_library_port(:porta), "wrong port"
    assert_equal FIRSTPORTB, subject.get_library_port(:portb), "wrong port"
    assert_equal FIRSTPORTCL, subject.get_library_port(:portcl), "wrong port"
    assert_equal FIRSTPORTCH, subject.get_library_port(:portch), "wrong port"
  end

  it "raise an error if asked about the library port that does not exist" do
    [:portd, :portci, "cigarette butt", nil].each do |bad_port|
      -> { subject.get_library_port(bad_port) }.to raise_error(RuntimeError)
    end
  end 
end
