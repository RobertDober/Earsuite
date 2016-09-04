defmodule Earsuite.Tools.AssociationTest do
  use ExUnit.Case

  import Earsuite.Tools, only: [associated_file: 1, associate_files: 2]

  describe "associated_file" do
    test ".exs? -> .md" do 
      assert "hello.md" == associated_file("hello.ex")
      assert "hello.md" == associated_file("hello.exs")
    end

    test ".md -> .html" do 
      assert "hellO.World.html" == associated_file("hellO.World.md")
    end

    ~w(xe xs dm efz ae html htm Ex EX MD Exs eX)
    |> Enum.each( fn extension ->
      test ".#{extension} -> Badaboum" do 
        assert_raise CondClauseError, fn ->
          associated_file("hello.#{unquote extension}")
        end
      end
    end)
  end

  describe "associated_files" do
    test "is just a map" do 
      f = fn :a -> :b
             :b -> :c
             :c -> :d end
      assert [:b, :c, :d] == associate_files([:a, :b, :c], f) |> Enum.to_list()
    end
  end
  
end
