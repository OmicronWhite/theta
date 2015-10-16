Changelog
=========

## 0.99.3
 - Add AOW08 - Valley (imported from AOW 2.1)
 - Add AOW09 - Infected (import from AOW 2.1)

## 0.99.2
 - Fix building `genver` on Linux
 - Update `build.sh` for new `genver` syntax
 - AOW02 updates
 - Lots of menu stuff (per usual)

## 0.99.1
 - New `Researches` array, serves similar purpose as `Classes` but for researches (duh)
 - Rework the Research Centre menu
 - The buttons in the Research Centre now enter the menu.
 - Show the version of Theta when the player joins
 - Change the default of the `theta_startcredits` CVar to `300`

### Bugs Fixed
 - [#2](https://github.com/PlusGit/theta/issues/2) Autobalance Obelisk and Tesla don't aim on player after switch (fix needs testing)

## 0.99.0
 - New versioning system.
 - Huge class menu rework:
   - Now mostly clientsided
   - Uses the `Classes` array, so adding entries is easier than ever
   - Now uses `BIGFONT`
   - Now shows information about selected class
 - Fixed the chainsaw not having a DoomEd number.

### Bugs Fixed
 - [#27](https://github.com/PlusGit/theta/issues/27) Plasma and Lazer rifle of blue team is red
