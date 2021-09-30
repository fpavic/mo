# Mo

The player controls a hero, which is rendered on the grid. The hero can move freely on the empty tiles, but not on the wall tiles.

When other players connect to the game, your enemies, they are also rendered on the grid. Your hero is distinguishable from the enemies by green color, while enemies are blue.

While moving, if an enemy is already on a tile, your hero can still move to that tile. Your hero is rendered above the enemies.

Each hero can attack everyone else within the radius of 1 tile around him plus the tile they are standing on.

When your hero or an enemy is dead, its color changes to red and it freezes for 5 seconds. After that time it is respawned on random location.

You can restart the stored session and connected players by using RESTART button.

## To start the game:
  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000/game?name=Boban`](http://localhost:4000/game?name=Boban) from your browser.

## To run the tests
  * Run `mix tests` command

## To deploy the app on Gigalixir

Gigalixir auto-detects that we want to use Elixir Releases as we have a config/releases.exs file.

  * In the app directory run `APP_NAME=$(gigalixir create)`
  * Verify that the app was created, by running `gigalixir apps`
  * Verify that a git remote was created by running `git remote -v`
  * Build and deploy the app by running `git push gigalixir`
