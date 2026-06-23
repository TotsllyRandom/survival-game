# Settlers
*A 2D, Top-Down, Co-Op Survival Sim*

Devlogs:

#1 - Jun 23, 2026
I have worked on this project while I was on a trip (what I did to get away from my OTHER project (go check out Clones in a Cave (it's not finished yet!)))

I've made SO much art and made SO many errors and I'm SO mad that a lot of these things WON'T WORK!

The idea is simple. I love Catan, you love Catan, so make a survival co-op game around Catan! But here's the catch: It's a time-based worldbuilder. You act as a god and can place settlements/villages/etc on these hex tiles. The tiles will produce on the hour, every hour. (a tile with the number value "12" would produce resources at 12 am and 12 pm.) I also want to include a feature with "Settlers" (as the name suggests) where you can place a special building to make "Groups," which can hold a number (currently undecided) of settlers. These groups get an upgrade tree which, depending on the upgrades, will put them into a group of either "Scientists," who increase research/hiring speeds when placed on tiles with those buildings, "Foragers," who double resource generation on tiles they're placed on, "Knights," which can fend off attacks and run dungeons for loot, as well as "traders," who can use leftover resources to get needed ones.

So far, I have the basic systems for tile generation and placeable items set, but I'm currently working on a system to take away resources when placed, as well as limit placement on tiles already surrounding buildings. This keeps a version of Catan's "Distance Rule," which limits placement and increases strategy.

I've also made a TON of sprites. 3 for each tile, and a lot of "Placeable" tiles, 3 of each as well. I have 3 of each because I wanted to have a "Height" system, where each tile will be either low, mid, or tall. I decided to scrap this (for now?) because of clipping issues with Godot's TileMapLayer nodes.

I've spent WAY too long making these sprites, and it's 100% been over 2 hours, but I'm not entirely sure if it's been 3, so 2 will have to do. Thanks for reading, this is what I've done before making this post!
