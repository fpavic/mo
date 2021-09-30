defmodule Mo.GameTest do
  use ExUnit.Case, async: false
  use Mimic

  setup :set_mimic_global
  setup_all do
    Supervisor.stop(Mo.GameSupervisor)
    Process.sleep(200)
    player_a = %Mo.Player.State{position: 10, name: "A", status: :alive}
    player_b = %Mo.Player.State{position: 11, name: "B", status: :alive}
    Mo.Game.notify(:place_hero, player_a)
    Mo.Game.notify(:place_hero, player_b)
    {:ok, %{player_a: player_a, player_b: player_b}}
  end

  test "fetch free positions" do
    free_positions = Mo.Game.fetch_free_positions()
    assert length(free_positions) == 35
  end

  test "current positions", %{player_a: player_a, player_b: player_b} do
    positions = Mo.Game.current_positions()

    assert [^player_a] = Enum.at(positions, player_a.position)
    assert [^player_b] = Enum.at(positions, player_b.position)
  end

  test "valid move", %{player_a: player_a} do
    refute Mo.Game.valid_move?(player_a, "left")
    assert Mo.Game.valid_move?(player_a, "right")
    refute Mo.Game.valid_move?(player_a, "down")
    refute Mo.Game.valid_move?(player_a, "up")
  end

  test "attack hero vicinity", %{player_a: player_a}  do
    Mo.Player
    |> expect(:kill, 1, fn _ -> :ok end)

    Mo.Game.attack_hero_vicinity(player_a)
  end

  describe "notify" do
    test "place hero" do
      pid = Process.whereis(Mo.Game)
      :erlang.trace(pid, true, [:receive])

      Mo.Game.notify(:place_hero, %Mo.Player.State{position: 1})

      assert_receive({:trace, ^pid, :receive, {:"$gen_call", _, {:place_hero, _}}})
    end
  end
end
