defmodule LogsWeb.ErrorJSONTest do
  use LogsWeb.ConnCase, async: true

  test "renders 404" do
    assert LogsWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert LogsWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
