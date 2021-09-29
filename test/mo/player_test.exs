defmodule Mo.PlayerTest do
  use ExUnit.Case
  use Mimic

  setup :set_mimic_global
  setup_all ctx do
    spawn_player_process("X")
    {:ok, ctx}
  end

  test "initialization" do
    assert %Mo.Player.State{name: "X", status: :alive} = Mo.Player.state("X")
  end

  test "moving the player when move valid" do
    %Mo.Player.State{position: first_position} = Mo.Player.state("X")

    Mo.Game
    |> expect(:valid_move?, 6, fn _, _ -> true end)
    |> expect(:notify, 12, fn _, _-> :ok end)

    Mo.Player.move("X", "up")
    Mo.Player.move("X", "up")
    Mo.Player.move("X", "down")
    Mo.Player.move("X", "left")
    Mo.Player.move("X", "left")
    Mo.Player.move("X", "right")

    %Mo.Player.State{position: final_position} = Mo.Player.state("X")

    assert first_position - final_position == 10
  end

  test "not moving the player when move invalid" do
    %Mo.Player.State{position: first_position} = Mo.Player.state("X")

    Mo.Game
    |> expect(:valid_move?, 1, fn _, _ -> false end)

    Mo.Player.move("X", "up")
    %Mo.Player.State{position: final_position} = Mo.Player.state("X")

    assert first_position == final_position
  end

  test "kiling the player" do
    spawn_player_process("Y")

    assert %Mo.Player.State{status: :alive} = Mo.Player.state("Y")

    Mo.Player.kill(%Mo.Player.State{name: "Y"})

    assert %Mo.Player.State{status: :dead} = Mo.Player.state("Y")
  end

  test "attacking other players" do
    Mo.Game
    |> expect(:attack_hero_vicinity, 1, fn _-> :ok end)

    Mo.Player.move("X", "attack")
  end

  defp spawn_player_process(name) do
    DynamicSupervisor.start_child(Mo.PlayerSupervisor, {Mo.Player, hero_name: name, name: {:via, Registry, {Mo.PlayerRegistry, name}}})
  end
end
