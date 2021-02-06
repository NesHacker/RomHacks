# Overview
After quite a bit of exploration and experimentation I found a large empty
region in Bank `$06` (see "The Great Void" above for specifics). Once I found
this spot my plan of attack to perform the hack became clear:

* Isloate my new code in Bank `$06` as indexed "hack" functions that can be
   called from other banks.
* Identify the major events I'd like to change and generate a list of hack
   functions that I will need to write to change the default behavior.
* Determine and document the memory state associated with the major events.
* Isolate the codepaths that lead to each of the events and implement small
   hook routines that call into my hack functions.
* Flesh out the hack functions and implement the changes.

I did some further experimentation and found that while executing the code for
shops, the game didn't seem to touch the zero page range from `$00` to `$0D` so
I decided I would use those bytes as temporary state for my code.

After working through the problem on paper and doing more experiementation and
tracing inside FCEUX I decided on splitting the hack into five basic functions:

1. `cleanupZeroPage` - Cleans up the temporary memory state on shop exit.
2. `initializePriceQuantity` - Initializes the zero page memory state when an
   item is selected to be bought.
3. `changeQuantity` - Updates the quantity of number of items to buy when the
   player presses left or right on the D-pad.
4. `renderQuantityAndTotal`- Updates the graphics to display the currently
   selected quantity and gold total for all items.
5. `buyItems` - Perform the buying logic by adding the items to the player's
   inventory and removing the correct amount of gold.
