require 'test/unit'
require './models/pedometer.rb'

class PedometerTest < Test::Unit::TestCase

  # -- Creation Tests -------------------------------------------------------

  def test_create
    input = "0.123,-0.123,5;"
    pedometer = Pedometer.new(input)
    
    assert_equal 0, pedometer.steps
    assert_equal 0, pedometer.distance
    assert_equal input, pedometer.raw_data
    assert_equal [[0.123, 0.123, 5.0]], pedometer.parsed_data
  end

  def test_create_nil_input
    message = "Bad Input. Ensure data is a series of comma separated x,y,z coordiantes separated by semi colons."
    assert_raise_with_message(RuntimeError, message) do
      Pedometer.new(nil)      
    end
  end

  def test_create_empty_input
    message = "Bad Input. Ensure data is a series of comma separated x,y,z coordiantes separated by semi colons."
    assert_raise_with_message(RuntimeError, message) do
      Pedometer.new('')
    end
  end

  def test_create_bad_input_strings
    message = "Bad Input. Ensure data is a series of comma separated x,y,z coordiantes separated by semi colons."
    assert_raise_with_message(RuntimeError, message) do
      Pedometer.new("0.123,-0.123,5;a,b,c;")
    end
  end

  def test_create_bad_input_too_many_values
    message = "Bad Input. Ensure data is a series of comma separated x,y,z coordiantes separated by semi colons."
    assert_raise_with_message(RuntimeError, message) do
      Pedometer.new("0.123,-0.123,5;0.123,-0.123,5,9;")
    end
  end

  def test_create_bad_input_too_few_values
    message = "Bad Input. Ensure data is a series of comma separated x,y,z coordiantes separated by semi colons."
    assert_raise_with_message(RuntimeError, message) do
      Pedometer.new("0.123,-0.123,5;0.123,-0.123;")
    end
  end

  # -- Measurement Tests ----------------------------------------------------

  def test_measure_steps
    pedometer = Pedometer.new(File.read('test/data/results-0-steps.txt'))
    pedometer.measure_steps
    assert_equal 0, pedometer.steps

    pedometer = Pedometer.new(File.read('test/data/results-15-steps.txt'))
    pedometer.measure_steps
    assert_equal 15, pedometer.steps
  end

  def test_measure_distance_before_steps
    pedometer = Pedometer.new(File.read('test/data/results-0-steps.txt'))
    pedometer.measure_distance
    assert_equal 0, pedometer.distance
    
    pedometer = Pedometer.new(File.read('test/data/results-15-steps.txt'))
    pedometer.measure_distance
    assert_equal 0, pedometer.distance
  end

  def test_measure_distance_after_steps
    pedometer = Pedometer.new(File.read('test/data/results-0-steps.txt'))
    pedometer.measure_steps
    pedometer.measure_distance
    assert_equal 0, pedometer.distance
    
    pedometer = Pedometer.new(File.read('test/data/results-15-steps.txt'))
    pedometer.measure_steps
    pedometer.measure_distance
    assert_equal 0.0135, pedometer.distance
  end

  def test_measure
    pedometer = Pedometer.new(File.read('test/data/results-0-steps.txt'))
    pedometer.measure
    assert_equal 0, pedometer.steps
    assert_equal 0, pedometer.distance
    
    pedometer = Pedometer.new(File.read('test/data/results-15-steps.txt'))
    pedometer.measure
    assert_equal 15, pedometer.steps
    assert_equal 0.0135, pedometer.distance
  end

end