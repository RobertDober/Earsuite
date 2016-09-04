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

    test ".anything -> Badaboum" do 
      catch_error associated_file("hello.xe")
    end
  end
  
end
