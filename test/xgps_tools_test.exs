defmodule XGPSToolsTest do
  use ExUnit.Case

  test "'CO' hex_string is 192" do
    hex_string = "C0"
    expected_int = 192
    actual = XGPS.Tools.hex_string_to_int(hex_string)
    assert expected_int == actual
  end

  test "192 is 'C0' hex_string" do
    expected_hex_string = "C0"
    int = 192
    actual = XGPS.Tools.int_to_hex_string(int)
    assert expected_hex_string == actual
  end

  test "position convert to decimal degrees - north" do
    degrees = 54
    minutes = 41.1600
    bearing = "N"

    expected = 54.686

    actual = XGPS.Tools.lat_to_decimal_degrees(degrees, minutes, bearing)
    assert expected == actual
  end

  test "position convert to decimal degrees - south" do
    degrees = 54
    minutes = 41.1600
    bearing = "S"

    expected = -54.686

    actual = XGPS.Tools.lat_to_decimal_degrees(degrees, minutes, bearing)
    assert expected == actual
  end

  test "position convert to decimal degrees - east" do
    degrees = 25
    minutes = 15.6000
    bearing = "E"

    expected = 25.26

    actual = XGPS.Tools.lon_to_decimal_degrees(degrees, minutes, bearing)
    assert expected == actual
  end

  test "position convert to decimal degrees - west" do
    degrees = 25
    minutes = 15.6000
    bearing = "W"

    expected = -25.26

    actual = XGPS.Tools.lon_to_decimal_degrees(degrees, minutes, bearing)
    assert expected == actual
  end

  test "position convert from decimal degrees - north" do
    expected_degrees = 54
    expected_minutes = 41.1600
    expected_bearing = "N"

    decimal_degrees = 54.686

    {actual_degrees, actual_minutes, actual_bearing} = XGPS.Tools.lat_from_decimal_degrees(decimal_degrees)
    assert expected_degrees == actual_degrees
    assert expected_minutes == actual_minutes
    assert expected_bearing == actual_bearing
  end

  test "position convert from decimal degrees - south" do
    expected_degrees = 54
    expected_minutes = 41.1600
    expected_bearing = "S"

    decimal_degrees = -54.686

    {actual_degrees, actual_minutes, actual_bearing} = XGPS.Tools.lat_from_decimal_degrees(decimal_degrees)
    assert expected_degrees == actual_degrees
    assert expected_minutes == actual_minutes
    assert expected_bearing == actual_bearing
  end

  test "position convert from decimal degrees - east" do
    expected_degrees = 25
    expected_minutes = 15.6000
    expected_bearing = "E"

    decimal_degrees = 25.26

    {actual_degrees, actual_minutes, actual_bearing} = XGPS.Tools.lon_from_decimal_degrees(decimal_degrees)
    assert expected_degrees == actual_degrees
    assert_in_delta(expected_minutes, actual_minutes, 0.000000000001)
    assert expected_bearing == actual_bearing
  end

  test "position convert from decimal degrees - west" do
    expected_degrees = 25
    expected_minutes = 15.6000
    expected_bearing = "W"

    decimal_degrees = -25.26

    {actual_degrees, actual_minutes, actual_bearing} = XGPS.Tools.lon_from_decimal_degrees(decimal_degrees)
    assert expected_degrees == actual_degrees
    assert_in_delta(expected_minutes, actual_minutes, 0.000000000001)
    assert expected_bearing == actual_bearing
  end

  test "generate rmc and gga for simulation" do
    lat = 4.686
    lon = 5.26
    alt = 34.5

    {:ok, date_time} = NaiveDateTime.new(2016, 7, 25, 10, 11, 12)
    expected_rmc = "$GPRMC,101112.000,A,0441.1600,N,00515.6000,E,0.0,0.0,250716,,,A*6A"
    expected_gga = "$GPGGA,101112.000,0441.1600,N,00515.6000,E,1,05,0.0,34.5,M,0.0,M,,*58"

    {actual_rmc, actual_gga} = XGPS.Tools.generate_rmc_and_gga_for_simulation(lat, lon, alt, date_time)
    assert expected_rmc == actual_rmc
    assert expected_gga == actual_gga
  end

end