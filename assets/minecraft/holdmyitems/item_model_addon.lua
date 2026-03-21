-- by omnis._.
-- using item_model_addon.lua because it doesn't overwrite and to better separate compatibility between packs
-- it is what it is, you gotta make do with what you've got

local isUsingItem = P:isUsingItem(context.player)

-- === FUNCTION ===
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
        withBlocks = {
            "saplings", "short_grass", "fern", "short_dry_grass", "bush", "dead_bush", "firefly_bush",
            "crimson_roots", "warped_roots", "nether_sprouts", "tall_grass", "large_fern", "tall_dry_grass",
        }
    }
}

ActivePacks = {}
    local rvTorches         = ${rvTorches} and (table.insert(ActivePacks, "rvTorches") or true)
    local refinedTorches    = ${refinedTorches} and (table.insert(ActivePacks, "refinedTorches") or true)
    local refinedBuckets    = ${refinedBuckets} and (table.insert(ActivePacks, "refinedBuckets") or true)
    local glowing3Dtotem    = ${glowing3Dtotem} and (table.insert(ActivePacks, "glowing3Dtotem") or true)
    local glowing3Darmors   = ${glowing3Darmors} and (table.insert(ActivePacks, "glowing3Darmors") or true)
    local bensBundle        = ${bensBundle} and (table.insert(ActivePacks, "bensBundle") or true)
    local freshDiscs        = ${freshDiscs} and (table.insert(ActivePacks, "freshDiscs") or true)
    local freshFoods        = ${freshFoods} and (table.insert(ActivePacks, "freshFoods") or true)
    local freshSeeds        = ${freshSeeds} and (table.insert(ActivePacks, "freshSeeds") or true)
    local freshOres         = ${freshOresIngots} and (table.insert(ActivePacks, "freshOresIngots") or true)
    local freshFlowers      = ${freshFlowersPlants} and (table.insert(ActivePacks, "freshFlowersPlants") or true)

-- === UNDO ADJUSTS ===
UndoAdjusts = {
}

-- === INDIVIDUAL RESOURCE PACK ADJUST ===
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