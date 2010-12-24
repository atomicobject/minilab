require "ffi"

class MinilabHardware
  include MinilabConstants

  def setup_error_handling(reporting, handling)
    create_error_hash cbErrHandling(reporting, handling)
  end

  def declare_revision(revision)
    memory = FFI::MemoryPointer.new :float
    memory.write_float(revision)
    create_error_hash cbDeclareRevision(memory)
  end

  def get_revision
    dll_revision_number = FFI::MemoryPointer.new :float
    vxd_revision_number = FFI::MemoryPointer.new :float
    error = cbGetRevision(dll_revision_number, vxd_revision_number)
    create_error_or_value_hash(error, dll_revision_number.read_float)
  end

  def get_error_string(error)
    message = FFI::MemoryPointer.new :char, ERRSTRLEN
    new_error = cbGetErrMsg(error, message)
    if new_error != 0
      create_error_hash(new_error)
    else
      message.read_string
    end
  end

  def configure_auxport(optz)
    raise ":pin is a required parameter" if optz[:pin].nil?
    raise ":direction is a required parameter" if optz[:direction].nil?
    create_error_hash cbDConfigBit(BOARDNUM, AUXPORT, optz[:pin], optz[:direction])
  end

  def configure_port(optz)
    raise ":port is a required parameter" if optz[:port].nil?
    raise ":direction is a required parameter" if optz[:direction].nil?
    create_error_hash cbDConfigPort(BOARDNUM, optz[:port], optz[:direction])
  end

  def read_analog(channel)
    raw_data = FFI::MemoryPointer.new :ushort
    error = cbAIn(BOARDNUM, channel, BIP10VOLTS, raw_data)
    return create_error_hash(error) if error != 0

    voltage = FFI::MemoryPointer.new :float
    error = cbToEngUnits(BOARDNUM, BIP10VOLTS, raw_data.get_ushort(0), voltage)
    create_error_or_value_hash(error, voltage.read_float)
  end

  def read_digital_pin(pin)
    data = FFI::MemoryPointer.new :ushort
    error = cbDBitIn(BOARDNUM, FIRSTPORTA, pin, data)
    create_error_or_value_hash(error, data.get_ushort(0))
  end

  def read_auxport(pin)
    data = FFI::MemoryPointer.new :ushort
    error = cbDBitIn(BOARDNUM, AUXPORT, pin, data)
    create_error_or_value_hash(error, data.get_ushort(0))
  end

  def read_port(port)
    data = FFI::MemoryPointer.new :ushort
    error = cbDIn(BOARDNUM, port, data)
    create_error_or_value_hash(error, data.get_ushort(0))
  end

  def write_analog(channel, volts)
    raw_data = FFI::MemoryPointer.new :ushort
    error = cbFromEngUnits(BOARDNUM, UNI5VOLTS, volts, raw_data)
    return create_error_hash(error) if error != 0
    error = cbAOut(BOARDNUM, channel, UNI5VOLTS, raw_data.get_ushort(0))
    create_error_hash(error)
  end

  def write_digital_pin(pin, data)
    create_error_hash cbDBitOut(BOARDNUM, FIRSTPORTA, pin, data)
  end

  def write_auxport(pin, data)
    create_error_hash cbDBitOut(BOARDNUM, AUXPORT, pin, data)
  end

  private
  def create_error_or_value_hash(error, value)
    error != 0 ? { :error => error } : { :value => value }
  end

  def create_error_hash(error)
    create_error_or_value_hash(error, true)
  end

  extend FFI::Library
  ffi_lib "cbw32.dll"

  attach_function "cbErrHandling", [:int, :int], :int
  attach_function "cbDeclareRevision", [:pointer], :int
  attach_function "cbGetRevision", [:pointer, :pointer], :int
  attach_function "cbGetErrMsg", [:int, :pointer], :int
  attach_function "cbDConfigBit", [:int, :int, :int, :int], :int
  attach_function "cbDConfigPort", [:int, :int, :int], :int
  attach_function "cbAIn", [:int, :int, :int, :pointer], :int
  attach_function "cbToEngUnits", [:int, :int, :ushort, :pointer], :int
  attach_function "cbFromEngUnits", [:int, :int, :float, :pointer], :int
  attach_function "cbDBitIn", [:int, :int, :int, :pointer], :int
  attach_function "cbDIn", [:int, :int, :pointer], :int
  attach_function "cbAOut", [:int, :int, :int, :ushort], :int
  attach_function "cbDBitOut", [:int, :int, :int, :ushort], :int
end
