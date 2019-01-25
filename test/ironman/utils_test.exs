defmodule Ironman.UtilsTest do
  use ExUnit.Case

  alias Ironman.Test.Helpers.MoxHelpers
  alias Ironman.Utils

  @ironman_version Mix.Project.config()[:version]

  describe "version self check" do
    test "nothing when up to date" do
      MoxHelpers.expect_dep_http(:ironman, @ironman_version)
      assert :ok == Utils.check_self_version()
    end

    test "Upgrade when out of date" do
      MoxHelpers.expect_dep_http(:ironman, "0.0.0")
      MoxHelpers.expect_io("Ironman is out of date. Upgrade? Yn\n", "y")
      MoxHelpers.expect_cmd(["mix", "archive.install", "hex", "ironman", "--force"])
      assert :exit == Utils.check_self_version()
    end

    test "Dont upgrade when out of date and n pressed" do
      MoxHelpers.expect_dep_http(:ironman, "0.0.0")
      MoxHelpers.expect_io("Ironman is out of date. Upgrade? Yn\n", "n")
      MoxHelpers.expect_cmd("hi")
      assert :declined == Utils.check_self_version()
    end
  end
end
