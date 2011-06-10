#
# An implementation of the AES encryption algorithm. 
# For educational purposes only!
#
# This test suite may be run directly from the command line:
#
#   ruby tc_aes.rb
#
# Copyright (c) 2011 Justin Ethier
#
$:.unshift File.join(File.dirname(__FILE__), "..")
require 'test/unit'
require 'aes.rb'


class TestAES < Test::Unit::TestCase
  def setup
    @aes = AES.new
  end
  
  def test_encrypt
    data = [0x68, 0x65, 0x6c, 0x6c,
                0x6f, 0x2c, 0x20, 0x77,
                0x6f, 0x72, 0x6c, 0x64,
                0x21, 0x21, 0x21, 0x21]
    key = [0x0f, 0x15, 0x71, 0xc9,
              0x47, 0xd9, 0xe8, 0x59,
              0x0c, 0xb7, 0xad, 0xd6,
              0xaf, 0x7f, 0x67, 0x98]
    result = @aes.encrypt(data, key)

    assert_equal([0x56, 0xdd, 0x68, 0x15, 0x44, 0x65, 0x7b, 0x76, 0xe5, 0x93, 0x51, 0xf5, 0x7d, 0x95, 0xa4, 0xb3], 
                      result)
    assert_equal(data, @aes.decrypt(result, key))
    
  unpack_str = "H2" * 16
  key =          "E8E9EAEBEDEEEFF0F2F3F4F5F7F8F9FA".unpack(unpack_str).map{|b| b.to_i}
  plaintext =   "014BAF2278A69D331D5180103643E99A".unpack(unpack_str).map{|b| b.to_i}
  ciphertext = "6743C3D1519AB4F2CD9A78AB09A511BD".unpack(unpack_str).map{|b| b.to_i}
  result = @aes.encrypt(plaintext, key)
# TODO: see - http://www.hanewin.net/encrypt/aes/aes-test.htm
#    assert_equal(ciphertext, result)
#    assert_equal(plaintext, @aes.decrypt(result, key))    
  end
                  
=begin
  Key (128): E8E9EAEBEDEEEFF0F2F3F4F5F7F8F9FA 
Plaintext: 014BAF2278A69D331D5180103643E99A 
Ciphertext: 6743C3D1519AB4F2CD9A78AB09A511BD 
  
Key (192): 04050607090A0B0C0E0F10111314151618191A1B1D1E1F20 
Plaintext: 76777475F1F2F3F4F8F9E6E777707172 
Ciphertext: 5d1ef20dced6bcbc12131ac7c54788aa 
  
Key (256): 08090A0B0D0E0F10121314151718191A1C1D1E1F21222324262728292B2C2D2E 
Plaintext: 069A007FC76A459F98BAF917FEDF9521 
Ciphertext: 080e9517eb1677719acf728086040ae3 
=end
  
  def test_mix_columns
    block = [0x87, 0x6e, 0x46, 0xa6,
                0xf2, 0x4c, 0xe7, 0x8c,
                0x4d, 0x90, 0x4a, 0xd8,
                0x97, 0xec, 0xc3, 0x95]
    result = @aes.mix_columns(block)

    expected = [0x47, 0x37, 0x94, 0xed,
                      0x40, 0xd4, 0xe4, 0xa5,
                      0xa3, 0x70, 0x3a, 0xa6,
                      0x4c, 0x9f, 0x42, 0xbc]    
    assert_equal(expected, result)
    for byte in result
      printf("%02x ", byte)
    end

    inverse = @aes.inv_mix_columns(result)
    assert_equal(block, inverse)
    #for byte in block
    #  printf("%02x ", byte)
    #end
  end

  def test_mul_bytes_in_gf
    # Multiplication in GF(2^8)
    assert_equal(193, @aes.mul_bytes_in_gf(0x57, 0x83))
  end

  def test_key_schedule_128bitkey
    key = []
    16.times {|i| key << 0 }
    keys = @aes.key_schedule(key)
  
    assert_equal(  
    [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
      0x62, 0x63, 0x63, 0x63, 0x62, 0x63, 0x63, 0x63, 0x62, 0x63, 0x63, 0x63, 0x62, 0x63, 0x63, 0x63, 
      0x9b, 0x98, 0x98, 0xc9, 0xf9, 0xfb, 0xfb, 0xaa, 0x9b, 0x98, 0x98, 0xc9, 0xf9, 0xfb, 0xfb, 0xaa, 
      0x90, 0x97, 0x34, 0x50, 0x69, 0x6c, 0xcf, 0xfa, 0xf2, 0xf4, 0x57, 0x33, 0x0b, 0x0f, 0xac, 0x99, 
      0xee, 0x06, 0xda, 0x7b, 0x87, 0x6a, 0x15, 0x81, 0x75, 0x9e, 0x42, 0xb2, 0x7e, 0x91, 0xee, 0x2b, 
      0x7f, 0x2e, 0x2b, 0x88, 0xf8, 0x44, 0x3e, 0x09, 0x8d, 0xda, 0x7c, 0xbb, 0xf3, 0x4b, 0x92, 0x90, 
      0xec, 0x61, 0x4b, 0x85, 0x14, 0x25, 0x75, 0x8c, 0x99, 0xff, 0x09, 0x37, 0x6a, 0xb4, 0x9b, 0xa7, 
      0x21, 0x75, 0x17, 0x87, 0x35, 0x50, 0x62, 0x0b, 0xac, 0xaf, 0x6b, 0x3c, 0xc6, 0x1b, 0xf0, 0x9b, 
      0x0e, 0xf9, 0x03, 0x33, 0x3b, 0xa9, 0x61, 0x38, 0x97, 0x06, 0x0a, 0x04, 0x51, 0x1d, 0xfa, 0x9f, 
      0xb1, 0xd4, 0xd8, 0xe2, 0x8a, 0x7d, 0xb9, 0xda, 0x1d, 0x7b, 0xb3, 0xde, 0x4c, 0x66, 0x49, 0x41, 
      0xb4, 0xef, 0x5b, 0xcb, 0x3e, 0x92, 0xe2, 0x11, 0x23, 0xe9, 0x51, 0xcf, 0x6f, 0x8f, 0x18, 0x8e],
      keys)
    
  end

  def test_sub_bytes
    block = [0, 1]
    result = @aes.sub_bytes(block)
    assert_equal(block, @aes.inv_sub_bytes([99, 124]))
  end

  def test_shift_rows
    block = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
    result = @aes.shift_rows(block)
    assert_equal([1,6,11,16,5,10,15,4,9,14,3,8,13,2,7,12], result)
  end

  def test_inv_shift_rows
    block = [1,6,11,16,5,10,15,4,9,14,3,8,13,2,7,12]
    block = @aes.inv_shift_rows(block)
    expected = []
    for i in 1..16
      expected << i
    end
    assert_equal(expected, block)
  end
end
