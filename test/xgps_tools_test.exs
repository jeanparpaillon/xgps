defmodule XGPSToolsTest do
  use ExUnit.Case

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

  test "Parse sentence - no start" do
    input = "fake input"
    {sentences, rest} = XGPS.Tools.extract_sentences(input)
    assert sentences == []
    assert rest == ""
  end

  test "Parse sentence - start but no end" do
    input = "noisy $sentence"
    {sentences, rest} = XGPS.Tools.extract_sentences(input)
    assert [] = sentences
    assert "$sentence" == rest
  end

  test "Parse sentence - single sentence" do
    input = "$sentence\r\n"
    {sentences, rest} = XGPS.Tools.extract_sentences(input)
    assert ["$sentence\r\n"] == sentences
    assert "" == rest
  end

  test "Parse sentence - single sentence + partial" do
    input = "$sentence1\r\n$sen"
    {sentences, rest} = XGPS.Tools.extract_sentences(input)
    assert ["$sentence1\r\n"] == sentences
    assert "$sen" == rest
  end

  test "Parse sentence - two sentences" do
    input = "$sentence1\r\n$sentences2\r\n"
    {sentences, rest} = XGPS.Tools.extract_sentences(input)
    assert ["$sentence1\r\n", "$sentences2\r\n"] == sentences
    assert "" == rest
  end

  test "Parse sentence - two sentences - with noise before and after" do
    input = "noise$sentence1\r\n$sentences2\r\nmore noise"
    {sentences, rest} = XGPS.Tools.extract_sentences(input)
    assert ["$sentence1\r\n", "$sentences2\r\n"] == sentences
    assert "" == rest
  end
end
