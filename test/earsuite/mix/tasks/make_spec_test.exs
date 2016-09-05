defmodule Mix.Tasks.MakeSpecTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import Mock

  @empty_dir "test/fixtures/empty"

  test "nothing goes wrong" do 
    assert capture_io( fn ->
      Mix.Tasks.MakeSpecs.run( [@empty_dir] )
    end) == "#{@empty_dir}\n"
  end
  test "empty works too" do 
    with_mock Earsuite,
      [make_specs: fn(_) -> nil end] do
        Mix.Tasks.MakeSpecs.run( [] )
        assert called Earsuite.make_specs "."
      end
  end
end
