-- by omnis._.
-- using item_model_addon.lua because it doesn't overwrite and to better separate compatibility between packs
-- it is what it is, you gotta make do with what you've got

local isUsingItem   = P:isUsingItem(context.player)
local l             = context.mainHand and 1 or -1

-- === FUNCTION ===
UndoPositions = {}
Positions = {}
local function addPos(tables)
    for _, t in ipairs(tables) do
        table.insert(Positions, t)
    end
end

-- === ITEMS RESOURCE PACKS ===
PackCompat = {
    refinedBuckets = { {"bucket"}, matches = true },
    freshDiscs = { {"music_disc", "disc_fragment_5"}, matches = true },
    glowing3Dtotem = { {"totem_of_undying"} },
    glowing3Darmors = { {"_helmet", "_chestplate", "_leggings", "_boots", "horse_armor"}, matches = true },
    freshSeeds = { {"_seeds"}, matches = true },
    bensBundle = { {"bundles"} },
    rvTorches = { {
        "torch", "soul_torch", "copper_torch", "redstone_torch", "lanterns", "repeater", "comparator", 
        "campfire", "soul_campfire"} },
    refinedTorches = { {
        "torch", "soul_torch", "copper_torch", "redstone_torch", "lanterns", 
        "campfire", "soul_campfire"} },
    freshFoods = { {
        "apple", "chorus_fruit", "melon_slice", "carrot", "potato", "^beetroot$",
        "bread", "cookie", "pumpkin_pie", "beef", "porkchop", "^chicken$", "mutton", "^rabbit$",
        "^cod$", "^salmon$", "^tropical_fish$", "^pufferfish$", "cooked_chicken",
        "cooked_rabbit", "cooked_cod", "cooked_salmon", "_stew", "_soup", "rotten_flesh", "^spider_eye$",
        "^dried_kelp$", "^honeycomb$", "_berries", "bowl"
    }, matches = true },
    freshOresIngots = { {
        "redstone$", "coal$", "raw", "^emerald$", "^lapis_lazuli$", "^diamond$", "quartz$",
        "amethyst_shard", "_amethyst_bud", "amethyst_cluster", "nugget", "_ingot",
        "netherite_scrap", "^flint$", "resin_clump", "echo_shard", "brick$", "pointed_dripstone"
    }, matches = true },
    freshFlowersPlants = {
        {
        "pale_hanging_moss", "_mushroom$", "_fungus", "dandelion", "poppy", "blue_orchid", "allium",
        "azure_bluet", "tulip", "oxeye_daisy", "cornflower", "lily_of_the_valley", "^torchflower$",
        "cacutus_flower", "eyeblossom", "wither_rose", "pink_petals", "wildflowers", "leaf_litter",
        "spore_blossom", "bamboo", "sugar_cane", "^vine$", "sunflower", "lilac", "peony", "pitcher_plant",
        "_dripleaf", "rose_bush", "sculk_vein", "glow_lichen", "lily_pad", "seagrass", "sea_pickle", "^kelp$",
        "_coral$", "_coral_fan", "weeping_vines", "twisting_vines", "_sapling", "mangrove_propagule", "fern",
        "_grass$", "bush", "crimson_roots", "warped_roots", "hanging_roots", "nether_sprouts"
        }, matches = true,
        withBlocks =
        {
            "saplings", "short_grass", "fern", "short_dry_grass", "bush", "dead_bush", "firefly_bush",
            "crimson_roots", "warped_roots", "nether_sprouts", "tall_grass", "large_fern", "tall_dry_grass",
        }
    },
    a3ds = {
        {
        -- Natural Blocks
        "pale_hanging_moss", "sapling", "mangrove_propagule", "_mushroom$", "_fungus$", "_grass$", "fern",
        "bush", "dandelion", "poppy", "orchid", "allium", "azure_bluet", "tulip", "oxeye_daisy", "cornflower",
        "lily_of_the_valley", "^torchflower$", "_eyeblossom", "wither_rose", "pink_petals", "wildflowers",
        "leaf_litter", "^bamboo$", "sugar_cane", "crimson_roots", "warped_roots", "nether_sprouts",
        "sunflower", "lilac", "rose_bush", "pitcher_plant", "glow_lichen", "hanging_roots", "frogspawn", "lily_pad",
        "^azalea$", "^flowering_azalea$", "weeping_vines", "twisting_vines", "^vine$", "peony",
        -- Functional Blocks
        "^bell$", "armor_stand", "item_frame", "painting", "ender_eye",
        -- Redstone Blocks
        "^redstone$", "string", "minecart", "_raft", "_boat",
        -- Tools
        "fishing_rod", "flint_and_steel", "fire_charge", "bone_meal", "shears", "brush", "name_tag", "lead", "bundle",
        "^compass$", "^map$", "writable_book", "ender_pearl", "firework_rocket", "saddle", "_harness", "on_a_stick",
        "goat_horn",
        -- Combat
        "totem_of_undying", "snowball", "^egg$", "brown_egg", "blue_egg",
        -- Ingredients
        "coal$", "raw_", "^emerald$", "^lapis_lazuli$", "^diamond$", "^quartz$", "_shard", "_nugget", "_ingot",
        "netherite_scrap", "^stick$", "flint", "^bone$", "^leather$", "rabbit_hide", "^honeycomb$", "resin_clump",
        "ink_sac", "slime_ball", "clay_ball", "prismarine_crystals", "nautilus_shell", "heart_of_the_sea", "blaze_rod",
        "breeze_rod", "nether_star", "_dye", "brick$", "paper", "^book$", "firework_star", "glowstone_dust", "gunpowder",
        "blaze_powder", "^sugar$", "rabbit_foot", "magma_cream", "ghast_tear", "banner_pattern", "_smithing_template",
        "_key", "enchanted_book"
        }, matches = true,
        naturalWithBlocks =
        {
            "saplings", "short_grass", "fern", "short_dry_grass", "bush", "dead_bush", "small_flowers",
            "firefly_bush", "crimson_roots", "warped_roots", "nether_sprouts", "tall_grass", 'large_fern',
            "tall_dry_grass", "sunflower", "lilac", "rose_bush", "peony", "pitcher_plant"
        }
    },
    w3di = {
        {
            -- Functional Blocks
            "torch", "^lantern$", "soul_lantern", "copper_lantern", "campfire", "end_crystal", "flower_pot", 
            "armor_stand", "_sign", "ender_eye",
            -- Redstone Blocks
            "redstone$", "repeater", "comparator", "lever",
            -- Tools
            "bucket", "fishing_rod", "flint_and_steel", "fire_charge", "bone_meal", "shears", "name_tag",
            "lead", "bundle", "compass", "clock", "map", "book", "wind_charge", "ender_pearl", "elytra",
            "firework_rocket", "carrot_on_a_stick", "warped_fungus_on_a_stick", "goat_horn", "music_disc",
            "_boat", "_raft",
            -- Combat
            "mace", "nautilus_armor", "totem_of_undying", "snowball", "^egg$", "brown_egg", "blue_egg",
            -- Foods & Potions
            "apple", "^chorus_fruit$", "melon_slice", "carrot", "potato", "^beetroot$",
            "bread", "cookie", "pumpkin_pie", "beef", "porkchop", "^chicken$", "mutton", "^rabbit$", 
            "^cod$", "^salmon$", "^tropical_fish$", "^pufferfish$", "cooked_chicken", 
            "cooked_rabbit", "cooked_cod", "cooked_salmon", "_stew", "_soup", "rotten_flesh", "^spider_eye$", 
            "^dried_kelp$", "^honeycomb$", "_berries", "bowl", "potion", "cake",
            -- Ingredients
            "coal$", "raw", "^emerald$", "^lapis_lazuli$", "diamond$", "quartz$", "amethyst_shard",
            "nugget", "ingot", "netherite_scrap", "stick$", "flint$", "bone$", "feather", 
            "honeycomb", "scute", "slime_ball", "clay_ball", "prismarine_crystals",
            "nautilus_shell", "heart_of_the_sea", "blaze_rod", "breeze_rod", "shulker_shell",
            "disc_fragment_5", "bowl", "brick$", "bottle", "glowstone_dust", "gunpowder",
            "dragon_breath", "blaze_powder", "sugar$", "_banner_pattern",
            -- Spawn Eggs
            "spawn_egg"
        }, matches = true
    }
}

ActivePacks = {}
    local a3ds              = ${a3ds}               and (table.insert(ActivePacks, "a3ds") or true)
    local w3di              = ${w3di}               and (table.insert(ActivePacks, "w3di") or true)
    local rvTorches         = ${rvTorches}          and (table.insert(ActivePacks, "rvTorches") or true)
    local refinedTorches    = ${refinedTorches}     and (table.insert(ActivePacks, "refinedTorches") or true)
    local refinedBuckets    = ${refinedBuckets}     and (table.insert(ActivePacks, "refinedBuckets") or true)
    local glowing3Dtotem    = ${glowing3Dtotem}     and (table.insert(ActivePacks, "glowing3Dtotem") or true)
    local glowing3Darmors   = ${glowing3Darmors}    and (table.insert(ActivePacks, "glowing3Darmors") or true)
    local bensBundle        = ${bensBundle}         and (table.insert(ActivePacks, "bensBundle") or true)
    local freshDiscs        = ${freshDiscs}         and (table.insert(ActivePacks, "freshDiscs") or true)
    local freshFoods        = ${freshFoods}         and (table.insert(ActivePacks, "freshFoods") or true)
    local freshSeeds        = ${freshSeeds}         and (table.insert(ActivePacks, "freshSeeds") or true)
    local freshOres         = ${freshOresIngots}    and (table.insert(ActivePacks, "freshOresIngots") or true)
    local freshFlowers      = ${freshFlowersPlants} and (table.insert(ActivePacks, "freshFlowersPlants") or true)

-- === UNDO ADJUSTS ===
UndoAdjusts = {
    a3ds = {
        totem = { {"totem_of_undying"}, r = {10, 190, 110, "yzx"} }
    }
}
if a3ds and glowing3Dtotem then table.insert(UndoPositions, UndoAdjusts.a3ds.totem) end

-- === INDIVIDUAL RESOURCE PACK ADJUST ===
if a3ds then
    addPos({
        -- Natural Blocks
        { {"vine", "weeping_vines", "twisting_vines"}, renderAsBlock = false },
        { {"frogspawn"}, m = {-0.06, 0.04, -0.025}, r = {-4, -5.5, -2}, renderAsBlock = false },
        { {"bamboo"}, m = {0.005, nil, -0.03}, r = {-5.5, -5, -1}, s = {0.8}, renderAsBlock = false },
        { {"_mushroom$", "_fungus"}, m = {0.01, -0.03, -0.075}, r = {-5, -4, -1}, matches = true },
        { {"azalea", "flowering_azalea"}, m = {0.065, -0.095, -0.17}, r = {-6, 29, nil} },
        { {"cactus_flower"}, m = {-0.09, 0.1, 0.03}, r = {-2.5, -22.5, nil} },
        { {"sugar_cane"}, m = {0.015, nil, -0.105}, r = {nil, -5.5, nil}, s = {0.9} },
        { {"glow_lichen"}, m = {nil, -0.21, nil} },
        { {"lily_pad"}, m = {nil, -0.215, 0.02}, r = {-109, nil, nil}, s = {1, 0.4, 1} },
        { PackCompat.a3ds.naturalWithBlocks, m = {nil, nil, -0.08}, renderAsBlock = false },

        -- Functional Blocks
        { {"bell"}, m = {-0.165, -0.495, 0.17}, r = {-15.5, -4.5, -2.5} },
        { {"armor_stand"}, m = {nil, 0.03, nil} },
        { {"item_frame", "painting"}, m = {-0.03, -0.62, 0.2}, r = {-39, -6, nil} },

        -- Tools & Utilities
        { {"minecart"}, m = {nil, 0.045, nil}, matches = true },
        { {"ender_eye"}, m = {0.03, -0.005, -0.08}, r = {-4.5, -6, nil} },
        { {"ender_pearl"}, m = {0.01, -0.005, -0.08}, r = {-4.5, -6, nil} },
        { {"flint_and_steel"}, m = {0.015, 0.005, -0.095}, r = {10, 2.5, -2.5}, s = {0.9} },
        { {"bone_meal"}, m = {0.01, 0.07, -0.125}, r = {-5.5, -4, nil} },
        { {"shears"}, r = {-7, nil, 38.5} },
        { {"brush"}, m = {0.025, 0.05, -0.035}, r = {-4.5, -5.5, -1} },
        { {"lead"}, m = {0.125, -0.13, -0.215}, r = {-5.5, -4, -1}, s = {0.9} },
        { {"bundles"}, m = {0.015, 0.03, -0.055}, r = {-4, -5.5, nil} },
        { {"compass"}, m = {0.015, 0.06, -0.03}, r = {-6.5, -5, -2} },
        { {"map", "paper"}, m = {0.025, -0.02, -0.055}, r = {-6.5, -5, nil} },
        { {"writable_book"}, m = {nil, nil, -0.09} },
        { {"firework_rocket"}, m = {-0.025, -0.08, -0.16}, r = {-6, -7, nil} },
        { {"saddle"}, m = {-0.025, nil, nil} },
        { {"boats"}, r = {nil, -37.5, nil} },
        { {"goat_horn"}, m = {0.015, 0.09, nil}, r = {nil, -4, -1.5} },

        -- Combat
        { {"egg", "brown_egg", "blue_egg"}, m = {0.03, -0.01, -0.085}, r = {-6, -6, nil} },
        { {"snowball"}, m = {0.015, -0.01, -0.085}, r = {-6, -6, nil} },

        -- Ingredients
        { {"string"}, m = {0.05, -0.005, -0.075}, r = {-4.5, -4.5, nil}, renderAsBlock = false },
        { {"smithing_template"}, m = {-0.095, -0.11, -0.14}, r = {-5.5, -5, nil}, matches = true },
        { {"_key"}, m = {0.015, nil, -0.085}, r = {-7, -5.5}, matches = true },
        { {"stick", "blaze_rod", "breeze_rod"}, m = {0.02, -0.19, -0.015}, r = {-4.5, -7, -0.5} },
        { {"flint"}, m = {0.01, -0.1, -0.085}, r = {-6, -4.5, -0.5} },
        { {"bone"}, m = {0.025, -0.04, -0.035}, r = {-5, -5.5, nil} },
        { {"leather", "rabbit_hide"}, m = {-0.01, -0.03, -0.08}, r = {-5.5, -4, -1} },
        { {"honeycomb"}, m = {0.01, 0.04, -0.05}, r = {-5, -5, nil} },
        { {"ink_sac", "glow_ink_sac"}, m = {0.015, 0.015, -0.085}, r = {-4, -4.5, -1} },
        { {"clay_ball"}, m = {l == 1 and 0 or 0.06, nil, nil} },
        { {"fire_charge", "heart_of_the_sea"}, m = {0.005, 0.05, 0.005}, r = {-6, -5, nil} },
        { {"slime_ball"}, m = {0.02, 0.005, -0.09}, r = {-4, -3.5, nil} },
        { {"prismarine_shard"}, m = {0.02, nil, -0.09}, r = {-6.5, -6, -1.5} },
        { {"prismarine_crystals"}, m = {0.025, 0.01, -0.14}, r = {-7.5, -6.5, nil}, s = {1.15} },
        { {"nautilus_shell"}, m = {0.025, -0.015, -0.04}, r = {-5.5, -5, nil} },
        { {"nether_star"}, m = {0.01, -0.135, -0.035}, r = {-6, -5.5, -2} },
        { {"dyes"}, m = {0.02, nil, -0.105}, r = {-4, -5.5, nil} },
        { {"book", "enchanted_book"}, m = {-0.135, nil, 0.085}, r = {-5, -6, -2} },
        { {"firework_star", "magma_cream"}, m = {0.03, 0.01, -0.01}, r = {-4.5, -5, -1.5} },
        { {"glowstone_dust", "gunpowder", "sugar", "blaze_powder"}, m = {-0.01, -0.02, -0.095}, r = {-8.5, nil, nil} },
        { {"rabbit_foot"}, m = {-0.01, -0.005, -0.08}, r = {-5, -4.5, nil} },
        { {"ghast_tear"}, m = {0.02, -0.02, -0.05}, r = {-5, -5, -2}, s = {1.3} },
        { {"loom_patterns"}, m = {nil, nil, -0.175} },
    })
    if not freshOres then
        addPos({
            { {"resin_clump"}, m = {-0.005, -0.055, -0.095}, r = {-7, -4.5, nil}, renderAsBlock = false },
            { {"coal$"}, m = {nil, nil, -0.025}, s = {0.9}, matches = true },
            { {"raw_"}, m = {-0.005, -0.055, -0.095}, r = {-7, -4.5, nil}, matches = true },
            { {"nugget"}, m = {0.02, 0.03, -0.045}, r = {-6, -5, nil}, matches = true },
            { {"ingot", "brick$"}, m = {-0.01, 0.005, -0.07}, r = {-6, -5.5, -1.5}, s = {0.9}, matches = true },
            { {"emerald"}, m = {0.015, -0.035, -0.085}, r = {-6.5, -3.5, nil} },
            { {"lapis_lazuli"}, m = {nil, -0.06, -0.105}, r = {-6, -5.5, nil} },
            { {"diamond"}, m = {0.015, -0.055, -0.09}, r = {-7.5, -3.5, nil} },
            { {"quartz"}, m = {0.005, 0.07, -0.035}, r = {-6, -7, nil}, s = {0.7} },
            { {"amethyst_shard", "echo_shard"}, m = {0.025, -0.01, -0.055}, r = {-4.5, -5.5, nil} },
            { {"netherite_scrap"}, m = {-0.045, -0.035, -0.13}, r = {-6, -5, -1} },
            { {"redstone"}, m = {-0.01, -0.02, -0.095}, r = {-8.5, nil, nil} },
        })
    end
end

if w3di then
    addPos({
        -- Functional Blocks
        { {"end_crystal"}, m = {-0.08, -0.225, -0.04} },
        { {"flower_pot"}, m = {0.025, -0.015, -0.04}, r = {4, -5.5, 3.5} },
        { {"armor_stand"}, m = {-0.055, -0.015, -0.08}, r = {-4, -9.5, 6} },
        { {"signs"}, m = {-0.035, 0.02, -0.065}, r = {-4.5, -5, 6.5} },

        -- Redstone Blocks
        { {"repeater", "comparator"}, r = {-6.5, nil, nil}, condition = {not rvTorches} },
        { {"lever"}, r = {8.5, nil, nil} },
        { {"boats"}, r = {3.5, -8, -4.5} },

        -- Tools & Utilities
        { {"bundles"}, m = {-0.05, -0.015, -0.015}, r = {-6, -11, 2.5}, s = {0.9}, condition = {not bensBundle} },
        { {"music_discs"}, m = {-0.05, nil, -0.06}, r = {-5.5, -10.5, 2.5}, condition = {not freshDiscs} },
        { {"disc_fragment_5"}, m = {-0.065, -0.045, -0.005}, r = {-5.5, -9.5, 5.5}, condition = {not freshDiscs} },
        { {"bucket"}, m = {0.02, 0.05, -0.09}, r = {-94.5, -21, 180}, matches = true },
        { {"flint_and_steel"}, m = {0.05, -0.015, -0.145}, r = {3.5, -6, 4.5} },
        { {"shears"}, m = {nil, -0.085, -0.085}, r = {-40.5, 10, 24} },
        { {"lead"}, m = {0.075, -0.03, -0.08}, r = {nil, -26, 10} },
        { {"compasses", "clock"}, m = {-0.005, -0.03, -0.16}, r = {5.5, -9.5, 7.5} },
        { {"map"}, m = {-0.045, 0.035, -0.035}, r = {-5, -9.5, 5} },
        { {"writable_book", "written_book"}, m = {nil, nil, -0.115} },
        { {"wind_charge"}, m = {-0.02, -0.03, -0.06}, r = {-3.5, -11, 3} },
        { {"ender_eye", "ender_pearl"}, m = {-0.015, -0.01, -0.005}, r = {-4, -10, 3} },
        { {"goat_horn"}, m = {-0.015, nil, -0.15}, r = {14, -9, 5.5} },
        { {"firework_rocket"}, m = {-0.03, nil, -0.03}, r = {-6, -13.5, 4.5} },
        { {"elytra"}, m = {nil, -0.32, nil}, r = {-131.5, nil, nil} },

        -- Combat
        { {"totem_of_undying"}, m = {-0.06, nil, -0.045}, r = {-7.5, nil, nil}, condition = {not glowing3Dtotem} },
        { {"nautilus_armor", "nautilus_shell"}, m = {-0.055, 0.04, 0.01}, r = {-4.5, -9.5, 6}, matches = true },
        { {"snowball", "egg", "brown_egg", "blue_egg"}, m = {0.01, -0.015, -0.05}, r = {-6, -5.5, 3} },

        -- Foods & Drinks
        { {"bottle", "potion", "dragon_breath"}, m = {-0.055, nil, -0.035}, r = {-4.5, -7, 4}, matches = true },

        -- Ingredients
        { {"bone_meal", "gunpowder", "glowstone_dust", "sugar"}, m = {-0.1, 0.015, 0.035}, r = {-3, -11, nil} },
        { {"stick"}, m = {0.01, 0.01, -0.02}, r = {-2, -2, -1.5} },
        { {"blaze_rod", "breeze_rod"}, m = {-0.005, 0.01, -0.02}, r = {-2, -2, -1.5} },
        { {"bone"}, m = {-0.025, -0.105, -0.025}, r = {-0.5, -0.5, -1} },
        { {"honeycomb"}, m = {-0.07, -0.005, -0.065}, r = {-4.5, -9.5, 5.5} },
        { {"turtle_scute", "armadillo_scute"}, m = {-0.045, -0.005, -0.035}, r = {-7, -6, 4} },
        { {"fire_charge"}, m = {0.015, -0.035, -0.07}, r = {-5.5, -6.5, 3.5} },
        { {"slime_ball"}, m = {-0.05, -0.005, -0.015}, r = {-5.5, -6, 4.5} },
        { {"clay_ball"}, m = {-0.055, -0.01, -0.055}, r = {-6, -11, 3.5} },
        { {"prismarine_crystals"}, m = {-0.17, 0.04, 0.105}, r = {nil, 90.5, nil}, s = {1.3} },
        { {"heart_of_the_sea"}, m = {-0.045, 0.02, -0.02}, r = {-3.5, -6, 4}, s = {0.9} },
        { {"shulker_shell"}, m = {-0.035, -0.055, -0.085}, r = {-5, -10, 6} },
        { {"book", "enchanted_book"}, m = {-0.1, nil, -0.01}, r = {nil, -8.5, nil} },
        { {"fermented_spider_eye"}, m = {-0.025, -0.085, -0.045}, r = {0.5, nil, 4} },
        { {"blaze_powder"}, m = {-0.01, -0.03, -0.045}, r = {-13, -47, nil} }
    })
    if not (rvTorches or refinedTorches) then
        addPos({
            { {"copper_torch"}, m = {0.07, -0.15, -0.07}, r = {-4.5, -5, -1.5}, s = {1.35} },
            { {"torch", "redstone_torch", "soul_torch"}, m = {0.005, -0.07, -0.08}, r = {-5, nil, -1.5} },
            { {"lanterns"}, m = {0.03, -0.515, 0.04}, r = {4.5, -5.5, nil}, s = {0.7} },
        })
    end
    if not freshFoods then
        addPos({
            { {"apple", "^chorus_fruit$"}, m = {-0.05, -0.01, -0.035}, r = {-5.5, -5.5, 3}, matches = true },
            { {"melon_slice"}, m = {-0.045, -0.03, -0.105}, r = {-5, -6, nil}, matches = true },
            { {"carrot"}, m = {-0.045, -0.085, -0.08}, r = {-9.5, -9.5, 6}, matches = true },
            { {"beef", "porkchop","mutton", "rotten_flesh"}, m = {-0.05, -0.005, -0.025}, r = {-5, -6, 3.5}, matches = true },
            { {"potato", "bread"}, m = {-0.05, -0.005, -0.035}, r = {-6, -5.5, 3.5}, matches = true },
            { {"_stew", "_soup", "bowl"}, m = {0.01, -0.015, -0.105}, r = {-7, -6.5, -1}, matches = true },
            { {"spider_eye"}, m = {-0.07, -0.14, -0.115}, r = {-6, -6.5, 2} },
            { {"sweet_berries"}, m = {0.025, 0.085, -0.12}, r = {-5.5, -4.5, 7.5} },
            { {"glow_berries"}, m = {-0.06, -0.01, -0.07} },
            { {"dried_kelp"}, m = {-0.095, 0.02, -0.005}, r = {nil, -4, nil} },
            { {"beetroot"}, m = {-0.045, -0.01, -0.08}, r = {-5.5, -10, 6.5} },
            { {"chicken", "cooked_chicken"}, m = {-0.06, -0.005, -0.025}, r = {-5.5, -5.5, 3.5} },
            { {"rabbit", "cooked_rabbit"}, m = {-0.055, 0.01, 0.065}, r = {-5.5, -5.5, 4.5} },
            { {"cod", "cooked_cod"}, m = {-0.115, -0.005, -0.065}, r = {-5, -7, 5} },
            { {"salmon", "cooked_salmon"}, m = {-0.09, -0.005, -0.085}, r = {-5, -7, 5} },
            { {"tropical_fish"}, m = {-0.065, -0.005, -0.075}, r = {-3, -5, 4} },
            { {"pufferfish"}, m = {-0.075, nil, nil}, r = {-4.5, -5.5, 2.5} },
            { {"cookie"}, m = {-0.06, -0.005, -0.02}, r = {-5, -5.5, 3.5} },
            { {"cake"}, m = {-0.03, 0.125, -0.085}, r = {3.5, -22.5, 3}, s = {0.9} },
            { {"pumpkin_pie"}, m = {-0.125, nil, 0.01}, r = {-7, -6, 3} },
        })
    end
    if not freshOres then
        addPos({
            { {"coal$"}, m = {-0.045, nil, nil}, r = {-4.5, -11, 4}, matches = true },
            { {"raw_"}, m = {-0.045, nil, -0.035}, r = {-6, -6.5, 4.5}, matches = true },
            { {"nugget"}, m = {-0.06, 0.055, -0.035}, r = {-7.5, -10, 6.5}, matches = true },
            {  {"_ingot", "brick$"}, m = {-0.03, -0.005, -0.03}, r = {-8, -21.5, 4}, matches = true },
            { {"emerald"}, m = {-0.05, 0.01, -0.035}, r = {-6, -4.5, 5.5}, s = {0.85} },
            { {"lapis_lazuli"}, m = {-0.105, 0.08, 0.06}, r = {-5, -5.5, 5.5} },
            { {"diamond"}, m = {-0.045, 0.015, -0.035}, r = {-5.5, -5.5, 5.5}, s = {0.8} },
            { {"quartz"}, m = {-0.035, -0.005, 0.07}, r = {1, 79.5, 2} },
            { {"amethyst_shard"}, m = {-0.05, 0.02, -0.06}, r = {-7, -9.5, 3.5} },
            { {"netherite_scrap"}, m = {-0.05, nil, -0.08}, r = {-3, nil, nil} },
            { {"flint"}, m = {-0.05, -0.145, -0.12}, r = {4.5, -5.5, 4.5} },
            { {"redstone"}, m = {-0.1, 0.015, 0.035}, r = {-3, -11, nil} }
        })
    end
end

if rvTorches then
    addPos({
        { {"torch", "soul_torch", "redstone_torch", "copper_torch"}, m = {0.01, nil, -0.035}, r = {-5, -5.5, nil} },
        { {"repeater", "comparator"}, m = {-0.045, -0.02, -0.035}, r = {-6, -16, 2.5}, renderAsBlock = false },
        { {"lanterns"}, m = {0.07, -0.545, 0.06}, r = {-11.5, -5.5, nil} },
        { {"campfire", "soul_campfire"}, m = {-0.08, 0.185, 0.255}, r = {8, -9.5, -2.5} }
    })
end

if refinedTorches then
    addPos({
        { {"torch", "soul_torch", "redstone_torch", "copper_torch"}, m = {0.035, nil, -0.04}, r = {-5, -4.5, nil} },
        { {"lanterns"}, m = {-0.04, -0.48, 0.115}, r = {-8.5, 9, nil} },
    })
end

if glowing3Dtotem then
    addPos({
        { {"totem_of_undying"}, m = {-0.015, 0.115, -0.14}, r = {-3, 50, -8.5}, s = {0.85} }
    })
end

if glowing3Darmors then
    addPos({
        { {"horse_armor"}, m = {-0.075, -0.025, -0.015}, r = {-6.5, 84.5, -1}, matches = true },
        { {"head_armor"}, m = {-0.125, -0.12, -0.04}, r = {-4, 84.5, nil} },
        { {"chest_armor"}, m = {nil, -0.26, 0.085}, r = {58, 180, -15} },
        { {"leg_armor"}, m = {-0.04, -0.385, -0.205}, r = {-2, nil, 7.5} },
        { {"foot_armor"}, m = {-0.095, -0.01, -0.02}, r = {nil, 82, nil} }
    })
end

if bensBundle then
    addPos({
        { {"bundles"}, m = {-0.045, 0.095, -0.035}, r = {-0.5, 23, -4} }
    })
end

if freshDiscs then
    addPos({
        { {"music_disc"}, m = {0.015, -0.015, -0.08}, r = {-5.5, -5.5, -0.5}, matches = true },
        { {"disc_fragment_5"}, m = {-0.015, nil, -0.055} }
    })
end

if freshFoods then
    addPos({
        { {"spider_eye"}, m = {-0.01, -0.13, -0.19}, r = {-5.5, 1.5, 34.5}, condition = {not isUsingItem} },
        { {"spider_eye"}, m = {0.08, -0.015, -0.065}, r = {-5.5, 1.5, 34.5}, condition = {isUsingItem} },
        { {"_soup", "_stew", "bowl"}, m = {0.07, -0.025, -0.03}, r = {1.5, -4.5, -1}, matches = true },
        { {"beef", "porkchop", "mutton"}, m = {0.06, 0.005, -0.13}, r = {-1.5, -5.5, -1}, s = {1.15}, matches = true },
        { {"apple"}, m = {0.075, 0.015, -0.07}, r = {2, -0.5, nil}, matches = true },
        { {"melon_slice"}, m = {0.03, nil, -0.055}, r = {2, -0.5, nil}, matches = true },
        { {"carrot"}, m = {-0.04, -0.035, -0.05}, r = {nil, -5, 3}, matches = true },
        { {"potato"}, m = {0.025, -0.01, -0.105}, r = {-5, -5, nil}, s = {1.15}, matches = true },
        { {"sweet_berries"}, m = {-0.035, nil, -0.055}, r = {nil, -4, nil} },
        { {"glow_berries"}, m = {0.015, -0.055, -0.095} },
        { {"chorus_fruit"}, m = {0.1, -0.055, -0.085}, r = {nil, -5.5, nil} },
        { {"beetroot"}, m = {-0.01, -0.12, -0.165}, r = {1.5, -5.5, nil} },
        { {"dried_kelp"}, m = {0.035, -0.025, -0.09}, r = {nil, 7.5, -1.5} },
        { {"chicken", "cooked_chicken"}, m = {0.065, -0.04, -0.15} },
        { {"rabbit"}, m = {0.1, -0.045, -0.095}, r = {nil, -6, nil} },
        { {"cooked_rabbit"}, m = {-0.025, -0.11, -0.055}, r = {-0.5, -7.5, nil} },
        { {"cod", "cooked_cod", "tropical_fish"}, m = {0.065, -0.04, -0.09}, r = {1.5, -5, -1.5} },
        { {"salmon"}, m = {-0.005, -0.04, -0.09}, r = {1.5, -5, -1.5} },
        { {"cooked_salmon"}, m = {-0.005, -0.04, -0.13}, r = {1.5, -5, -1.5} },
        { {"pufferfish"}, m = {0.075, 0.005, -0.065}, r = {15, 7.5, 9} },
        { {"bread"}, m = {0.07, -0.04, -0.085}, r = {1, nil, nil} },
        { {"cookie"}, m = {0.07, 0.005, -0.075} },
        { {"cake"}, m = {-0.05, 0.025, 0.015} },
        { {"pumpkin_pie"}, m = {0.06, 0.02, -0.175}, r = {4.5, 3, 5.5} },
        { {"rotten_flesh"}, m = {0.085, -0.19, -0.035}, r = {-40.5, nil, 3.5}, s = {1.15} },
    })
end

if freshSeeds then
    addPos({
        { {"_seeds"}, m = {0.045, -0.115, -0.055}, r = {-8.5, 25, 5}, s = {1.05}, matches = true }
    })
end

if freshOres then
    addPos({
        { {"coal$"}, m = {0.065, -0.005, -0.13}, matches = true },
        { {"raw_"}, m = {nil, -0.07, -0.14}, matches = true },
        { {"_nugget"}, m = {0.07, -0.095, -0.095}, r = {-5.5, -5.5, nil}, matches = true },
        { {"_ingot", "brick$"}, m = {0.025, -0.05, -0.155}, r = {-6.5, 5, nil}, s = {1.2}, matches = true },
        { {"amethyst_bud", "amethyst_cluster"}, m = {0.025, -0.06, -0.055}, r = {-5, -6, nil}, matches = true },
        { {"diamond"}, m = {0.03, 0.01, -0.165}, r = {11.5, 13, -3} },
        { {"emerald"}, m = {0.025, -0.03, -0.23}, r = {12.5, 13, -2} },
        { {"lapis_lazuli"}, m = {0.005, -0.14, -0.225}, r = {nil, -4.5, nil}, s = {1.1} },
        { {"quartz"}, m = {0.025, -0.07, -0.11}, r = {-6, -5.5, nil}, s = {1.2} },
        { {"amethyst_shard", "echo_shard"}, m = {-0.055, -0.15, -0.03}, r = {7, -5, nil} },
        { {"netherite_scrap"}, m = {0.05, -0.09, -0.17}, r = {-5.5, -1, -16.5}, s = {1.3} },
        { {"flint"}, m = {0.035, 0.07, -0.115}, r = {15, 12.5, -8}, s = {1.15} },
        { {"resin_clump"}, m = {nil, 0.01, -0.12}, s = {1.2} },
        { {"redstone"}, m = {0.08, -0.135, -0.175}, r = {-17, nil, nil}, s = {1.15} },
        { {"pointed_dripstone"}, m = {0.125, -0.05, -0.075}, r = {-4.5, -4.5, -1.5} }
    })
end

if freshFlowers then
    addPos({
        { PackCompat.freshFlowersPlants.withBlocks, m = {0.055, -0.075, -0.09}, r = {10.5, -6, -2.5} },
        { {"^dead.*fan$"}, m = {nil, -0.06, -0.165}, r = {16, 36.5, -17}, matches = true },
        { {"^dead.*coral$"}, m = {0.055, -0.075, -0.09}, r = {10.5, -6, -2.5}, matches = true },
        { {"_coral$", "_coral_fan"}, m = {0.155, -0.06, -0.055}, r = {-6, -5, nil}, matches = true },
        { {"_mushroom$", "_fungus"}, m = {0.02, -0.03, -0.035}, r = {-5.5, -5.5, -2}, matches = true },
        { {"small_flowers"}, m = {-0.005, -0.015, -0.015}, r = {-9.5, nil, nil} },
        { {"wildflowers", "leaf_litter", "pink_petals"}, m = {nil, -0.19, -0.05}, r = {-72.5, 0.5, -1} },
        { {"bamboo"}, m = {0.02, 0.02, -0.025}, r = {-6, -5.5, -2} },
        { {"sugar_cane"}, m = {-0.005, 0.02, -0.025}, r = {-6, -5.5, -2} },
        { {"twisting_vines"}, m = {0.035, nil, 0.035} },
        { {"vine", "sculk_vein", "glow_lichen"}, m = {-0.14, nil, 0.115}, r = {-9, -12, nil} },
        { {"rose_bush", "peony", "lilac", "pitcher_plant"}, m = {nil, nil, -0.03}, r = {-7, nil, nil} },
        { {"big_dripleaf"}, m = {-0.02, nil, -0.015} },
        { {"small_dripleaf"}, m = {nil, nil, -0.03} },
        { {"lily_pad"}, m = {0.14, -0.1, -0.075}, r = {-5.5, -6.5, nil} },
        { {"sea_pickle"}, m = {0.025, -0.025, -0.04}, r = {-5, -7, nil} },
        { {"seagrass"}, m = {0.225, -0.17, -0.18}, r = {-11, -11.5, nil} },
    })
end