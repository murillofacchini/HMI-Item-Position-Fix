-- by omnis._.

local l           = context.mainHand and 1 or -1
local itemName    = I:getName(context.item):gsub("minecraft:", "")
local AlexModel   = ${skinModel}

-- == MATCH ITEM ==
local function matched(items, matches)
    local list = type(items) == "table" and items or {items}

    local function check(i)
        if itemName == i then
            return true
        end
        if matches and itemName:match(i) then
            return true
        end
        if i:find("[%^%$%(%)%%%.%[%]%*%+%-%?]") then
            return false
        end
        return I:isIn(context.item, Tags:getFabricTag(i))
            or I:isIn(context.item, Tags:getVanillaTag(i))
    end

    for _, i in ipairs(list) do
        if check(i) then return true end
    end
    return false
end

-- == RENDER AS BLOCK ==
local function renderBlock(render, items, force)
    if force then
        renderAsBlock:put(I:getName(context.item), render)
        return
    end
    if IsItemCompat then return end

    for _, i in ipairs(items) do
        if matched(i) then
            renderAsBlock:put(I:getName(context.item), render)
            return
        end
    end
end

-- == POSITION PROCESSING ==
local function move(x, y, z)
    M:moveX(context.matrices, (x or 0) * l)
    M:moveY(context.matrices, y or 0)
    M:moveZ(context.matrices, z or 0)
end
local function rotate(x, y, z)
    M:rotateX(context.matrices, x or 0)
    M:rotateY(context.matrices, (y or 0) * l)
    M:rotateZ(context.matrices, (z or 0) * l)
end
local function scale(x, y, z)
    if x ~= nil and y == nil and z == nil then
        M:scale(context.matrices, x, x, x)
    else
        M:scale(context.matrices, x or 0, y or 0, z or 0)
    end
end

-- === ITEMS LISTS ===
local itemLists = {
    hangingPlants = {"spore_blossom", "hanging_roots", "pale_hanging_moss", "weeping_vines"},
    sprites2D = {
        -- Colored Blocks
        "glass_pane",
        -- Natural Blocks
        "small_amethyst_bud", "pitcher_pod", "lily_pad", "_seeds", "_bars", "sugar_cane",
        -- Functional Blocks
        "armor_stand", "glow_item_frame", "ender_eye", "fire_charge", "name_tag", "lead", "ladder", "sign",
        -- Redstone Blocks
        "^redstone$", "string", "tripwire_hook", "minecart",
        -- Tools
        "bundle", "compass", "^map$", "wind_charge", "ender_pearl", "_harness",
        "elytra", "saddle", "goat_horn", "firework_rocket", "brush", "clock", "music_disc",
        -- Combat
        "wolf_armor", "totem_of_undying", "arrow", "_helmet", "_chestplate", "leggings", "boots", "horse_armor",
        "snowball", "^egg$", "brown_egg", "blue_egg", "nautilus_armor",
        -- Foods
        "apple", "chorus_fruit", "melon_slice", "carrot", "potato", "^beetroot$",
        "bread", "cookie", "pumpkin_pie", "beef", "porkchop", "^chicken$", "mutton", "^rabbit$",
        "^cod$", "^salmon$", "^tropical_fish$", "^pufferfish$", "cooked_chicken",
        "cooked_rabbit", "cooked_cod", "cooked_salmon", "_stew", "_soup", "rotten_flesh", "^spider_eye$",
        "^dried_kelp$", "^honeycomb$", "_berries", "bowl", "bottle", "potion",
        -- Ingredients
        "coal$", "^emerald$", "^lapis_lazuli$", "^diamond$", "quartz$", "_shard", "netherite_scrap", "flint",
        "wheat", "feather", "^leather$", "rabbit_hide", "resin_clump", "ink_sac", "_scute", "slime_ball", "clay_ball",
        "prismarine_crystals", "nautilus_shell", "heart_of_the_sea", "phantom_membrane", "_key", "ghast_tear",
        "nether_star", "shulker_shell", "popped_chorus_fruit", "disc_fragment_5", "brick$", "^raw_iron$", "^raw_gold$",
        "^raw_copper$", "paper", "firework_star", "glowstone_dust", "book$", "gunpowder", "fermented_spider_eye",
        "^sugar$", "glistering_melon_slice", "magma_cream", "_nugget", "_ingot", "^stick$", "bone", "_dye", "blaze_powder",
        "dragon_breath", "rabbit_foot", "banner_pattern", "pottery_sherd", "smithing_template"
    },
    spawnEggsAdjust = {
        "cow", "camel", "donkey", "horse", "mule", "llama", "panda", "polar_bear", "cod", "dolphin", "squid", "nautilus",
        "salmon", "tadpole", "tropical_fish", "mooshroom", "sniffer", "iron_golem", "creaking", "guardian", "slime",
        "warden", "ravager", "ghast", "hoglin", "magma_cube", "strider", "zoglin", "enderman"
    },
    except = {
        "pink_petals", "wildflowers", "leaf_litter", "bucket", "fishing_rod", "shears", "rail", "fence", "wall",
        "bed_", "_banner$", "candle", "glow_lichen", "sniffer_egg", "sculk_vein", "^torch$", "_torch",
        "hanging_sign", "golem_statue", "comparator", "conduit", "campfire", "anvil", "brewing_stand",
        "repeater", "button", "^hopper$", "pickaxe", "axe", "shovel", "hoe", "sword", "_on_a_stick",
        "boat", "raft", "trident", "mace", "cake", "blaze_rod", "breeze_rod", "heavy_core", "item_frame", "painting",
        "^lantern$", "soul_lantern", "copper_lantern", "_head", "_skull", "pressure_plate", "trapdoor", "carpet",
        "bamboo", "^vine$", "frogspawn", "turtle_egg", "dried_ghast", "_spear", "^cauldron$"
    }
}

-- == TAGS ==
local tags = {
    default = {
        "doors", "bars", "fences", "walls", "fence_gates", "chains", "trapdoors", "glass_panes", "banners",
        "beds", "candles", "small_flowers", "saplings", "parrot_food", "lightning_rods", "shulker_boxes",
        "wooden_shelves", "hanging_signs", "signs", "copper_golem_statues", "lanterns", "buttons", "rails",
        "chiseled_bookshelf", "pickaxes", "axes", "hoes", "shovels", "bundles", "bookshelf_books", "music_discs",
        "boats", "chest_boats", "swords", "head_armor", "chest_armor", "leg_armor", "foot_armor", "arrows",
        "ingots", "raw_materials", "nuggets", "smithing_template"
    },
    registry = {
        pressure_plates   = {"_pressure_plate"},
        carpets           = {"_carpet"},
        amethyst_cristals = {"amethyst_bud", "amethyst_cluster"},
        small_plants      = {"_grass", "_roots", "nether_sprouts"},
        mushrooms         = {"_mushroom", "_fungus$"},
        corals            = {"_coral$", "_coral_fan"},
        bushes            = {"bush"},
        tulips            = {"tulip"},
        ground_cover      = {"pink_petals", "wildflowers", "leaf_litter"},
        froglights        = {"froglight"},
        campfires         = {"campfire"},
        torches           = {"^torch$", "soul_torch", "copper_torch", "redstone_torch"},
        furnaces          = {"^furnace$", "blast_furnace", "smoker"},
        anvils            = {"anvil"},
        ender_items       = {"ender_eye", "ender_pearl"},
        minecarts         = {"minecart"},
        pistons           = {"piston"},
        ejectors          = {"dropper", "dispenser", "crafter"},
        buckets           = {"bucket"},
        horse_armors      = {"horse_armor"},
        nautilus_armors   = {"nautilus_armor"},
        eggs              = {"^egg$", "blue_egg", "brown_egg"},
        potatoes          = {"potato"},
        bowl_foods        = {"bowl", "_stew", "_soup"},
        bottles_drink     = {"potion", "bottle", "dragon_breath"},
        muttons           = {"mutton"},
        rabbits           = {"^rabbit$", "cooked_rabbit"},
        fishes            = {"cod$","cooked_cod", "salmon$", "cooked_salmon", "tropical_fish$"},
        spider_eyes       = {"spider_eye"},
        carrots           = {"carrot"},
        bricks            = {"brick$", "nether_brick", "resin_brick"},
        ink_sacs          = {"ink_sac"},
        scutes            = {"_scute"},
        balls             = {"slime_ball", "clay_ball", "magma_cream"},
        powders           = {"^redstone$", "gunpowder", "glowstone_dust", "^sugar$"},
        hanging_plants    = itemLists.hangingPlants,
        spawn_eggs_adjust = itemLists.spawnEggsAdjust,
        spawn_eggs        = {"spawn_egg"},
    }
}
local function getTag()
    for _, tag in ipairs(tags.default) do
        if I:isIn(context.item, Tags:getVanillaTag(tag)) or I:isIn(context.item, Tags:getFabricTag(tag)) then
            return tag
        end
    end
    for tag, matches in pairs(tags.registry) do
        for _, item in ipairs(matches) do
            if itemName:match(item) then
                return tag
            end
        end
    end
end

-- === ITEM TYPE CHECKING ===
local isException   = matched(itemLists.hangingPlants) or matched(itemLists.except, true) or IsItemCompat
local is2D          = matched(itemLists.sprites2D, true) or matched("spawn_egg", true)
local general2D     = not isException and is2D
local general3D     = not (isException or is2D) or matched({"_bulb", "crafting_table", "waxed.*rod", "waxed.*chest", "waxed.*chain", "waxed.*door"}, true)

-- === NOT RENDER AS BLOCK ===
renderBlock(
    false,
    {"weeping_vines", "vine", "ladder", "signs", "tripwire_hook", "string", "bars", "resin_clump", "glass_panes", "sugar_cane"}
)

-- === GENERAL ADJUST ===
if general3D then
    move(0.05, -0.075, -0.1)
    rotate(-4, 18, -1)
elseif general2D then
    move(0.03, 0.04, -0.075)
    rotate(-6.5, -5.5, -1)
end

if not AlexModel then
    move(0.035, nil, nil)
end

local poses = {
    -- Building Blocks
    doors                       = { m = {0.01, -0.445, 0.345},    r = {2.5, -113, 3.5}, s = {1.15} },
    bars                        = { m = {nil, nil, -0.01} },
    fences                      = { m = {0.175, -0.085, -0.075},  r = {-3.5, -5.5, -1} },
    walls                       = { m = {0.175, -0.085, -0.075},  r = {-3.5, -5.5, -1} },
    fence_gates                 = { m = {0.17, -0.185, -0.09},    r = {-4.5, -5, -1.5} },
    chains                      = { m = {0.06, nil, -0.01} },
    trapdoors                   = { m = {0.18, -0.08, -0.065},    r = {-7.5, -6, nil} },
    pressure_plates             = { m = {0.18, -0.08, -0.065},    r = {-7.5, -6, nil} },
    -- Colored Blocks
    carpets                     = { m = {0.18, -0.08, -0.065},    r = {-7.5, -6, nil} },
    glass_panes                 = { m = {-0.01, 0.01, nil},       s  = {0.75} },
    banners                     = { m = {0.045, 0.06, 0.02},      r = {-5, -95, nil},   s = {1.25} },
    beds                        = { m = {-0.225, -0.015, -0.005}, r = {7.5, 95, nil} },
    candles                     = { m = {0.37, -0.175, -0.215},   r = {-5.5, -6.5, -1}, s = {2.2} },
    -- Natural Blocks
    hanging_plants              = { m = {0.105, -0.59, -0.025} },
    amethyst_cristals           = { m = {0.04, nil, -0.005} },
    small_amethyst_bud          = { m = {nil, -0.03, 0.015} },
    small_plants                = { m = {0.05, nil, nil} },
    fern                        = { m = {0.06, nil, -0.01} },
    large_fern                  = { m = {0.06, nil, -0.01} },
    pointed_dripstone           = { m = {0.06, nil, -0.01} },
    mushrooms                   = { m = {0.08, nil, -0.04},       s  = {1.3} },
    corals                      = { m = {0.055, nil, -0.025} },
    cobweb                      = { m = {0.055, nil, -0.025} },
    bushes                      = { m = {0.055, nil, -0.025} },
    lilac                       = { m = {0.055, nil, -0.025} },
    peony                       = { m = {0.055, nil, -0.025} },
    pitcher_plant               = { m = {0.055, nil, -0.025} },
    torchflower                 = { m = {0.01, 0.035, 0.07},      r = {nil, -35, nil} },
    aliumove                    = { m = {0.1, nil, -0.045},       s  = {1.4} },
    tulips                      = { m = {0.1, nil, -0.045},       s  = {1.4} },
    wither_rose                 = { m = {0.08, nil, -0.065},      s  = {1.4} },
    small_flowers               = { m = {0.09, nil, -0.055},      s  = {1.4} },
    saplings                    = { m = {0.075, nil, -0.045},     s  = {1.25} },
    cactus_flower               = { m = {0.07, nil, -0.03},       s  = {1.2} },
    bamboo                      = { m = {0.49, -0.115, -0.26},    r = {-5, -5.5, -0.5},    s = {3, 1.2, 2.5} },
    sugar_cane                  = { m = {-0.06, -0.07, nil} },
    twisting_vines              = { m = {0.085, nil, nil} },
    vine                        = { m = {-0.11, -0.245, 0.08},    r = {-5, 84.5, -1.5},    s = {1, 1, 0.3} },
    glow_lichen                 = { m = {-0.11, -0.245, 0.08},    r = {-5, 84.5, -1.5},    s = {1, 1, 0.3} },
    sculk_vein                  = { m = {-0.11, -0.245, 0.08},    r = {-5, 84.5, -1.5},    s = {1, 1, 0.3} },
    sunflower                   = { m = {l == 1 and -0.08 or -0.02, nil, l == 1 and 0.33 or -0.07}, r = {nil, l == 1 and -131.5 or 30, nil} },
    small_dripleaf              = { m = {0.06, nil, -0.015} },
    big_dripleaf                = { m = {0.065, nil, -0.09} },
    chorus_plant                = { m = {0.06, -0.145, -0.09},    s  = {1.65} },
    frogspawn                   = { m = {0.17, -0.08, -0.08},     r = {-6.5, -5.5, -1} },
    turtle_egg                  = { m = {0.25, -0.165, -0.19},    r = {-5.5, -5.5, -0.5},  s = {1.7} },
    sniffer_egg                 = { m = {0.175, -0.08, -0.05},    r = {-6.5, -5.5, -1} },
    dried_ghast                 = { m = {-0.2, -0.06, 0.27},      r = {-4, 175, nil},      s = {1.25} },
    parrot_food                 = { m = {-0.025, -0.07, -0.01} },
    beetroot_seeds              = { m = {nil, 0.035, nil} },
    torchflower_seeds           = { m = {nil, -0.03, nil} },
    pitcher_pod                 = { m = {-0.04, nil, -0.01} },
    cocoa_beans                 = { m = {0.18, -0.275, 0.145},    r = {0.5, -21.5, -1},    s = {1.7} },
    nether_wart                 = { m = {0.105, 0.015, 0.085},    r = {nil, -23.5, nil} },
    seagrass                    = { m = {0.08, 0.015, 0.085},     r = {nil, -23.5, nil} },
    kelp                        = { m = {0.08, 0.015, 0.085},     r = {nil, -23.5, nil} },
    lily_pad                    = { m = {-0.02, -0.01, -0.035},   r = {90, nil, nil},      s = {1, 1, 0.385} },
    sea_pickle                  = { m = {0.155, nil, 0.05},       r = {nil, -23.5, nil},   s = {1.5} },
    ground_cover                = { m = {nil, -0.19, -0.05},      r = {-72.5, 0.5, -1} },
    -- Functional Blocks
    froglights                  = { m = {-0.04, nil, 0.025} },
    shulker_boxes               = { m = {-0.04, nil, 0.025} },
    campfires                   = { m = {0.21, -0.085, -0.095},   r = {-4, -5.5, -1},      s = {1.25} },
    lightning_rods              = { m = {0.18, -0.1, 0.02},       r = {-1, -23, nil},      s = {1.3} },
    torches                     = { m = {0.08, -0.15, -0.075},    r = {-4.5, -5, -1},      s = {1.38} },
    end_rod                     = { m = {0.195, -0.025, 0.03},    r = {nil, -24, nil},     s = {1.5} },
    grindstone                  = { m = {0.215, 0.365, -0.08},    r = {90, nil, 22.5},     s = {1.35} },
    furnaces                    = { m = {-0.305, nil, 0.27},      r = {-180, nil, 180} },
    lectern                     = { m = {-0.305, nil, 0.27},      r = {-180, nil, 180} },
    barrel                      = { m = {-0.305, nil, 0.27},      r = {-180, nil, 180} },
    anvils                      = { m = {-0.11, -0.08, -0.13},    r = {10, 84.5, -16} },
    brewing_stand               = { m = {-0.11, -0.08, -0.13},    r = {10, 84.5, -16} },
    end_crystal                 = { m = {-0.125, -0.065, 0.23},   r = {nil, -29.5, nil} },
    conduit                     = { m = {0.22, -0.22, -0.1},      r = {-5.5, -6, -1},      s = {1.3} },
    scaffolding                 = { m = {0.13, -0.265, 0.025},    r = {nil, -23, nil} },
    flower_pot                  = { m = {0.19, -0.035, 0.05},     r = {-1.5, -24, nil},    s = {1.4} },
    wooden_shelves              = { m = {-0.315, -0.005, 0.28},   r = {0.5, 157, nil} },
    hanging_signs               = { m = {0.06, -0.745, 0.19},     r = {-29, -5.5, -1} },
    signs                       = { m = {-0.02, nil, 0.015} },
    ender_items                 = { m = {-0.045, nil, 0.03} },
    copper_golem_statues        = { m = {-0.005, 0.515, -0.385},  r = {175.5, -131.5, -3}, s = {1.4} },
    lanterns                    = { m = {0.035, -0.585, 0.095},   r = {-21.5, nil, nil} },
    glow_item_frame             = { m = {nil, -0.53, 0.225},      r = {-37, nil, nil} },
    item_frame                  = { m = {-0.01, -0.535, 0.175},   r = {-29, nil, nil} },
    painting                    = { m = {-0.025, -0.62, 0.155},   r = {-25, nil, nil} },
    bell                        = { m = {-0.105, -0.61, 0.19},    r = {-18.5, -27.5, -7.5}, s = {1.2} },
    armor_stand                 = { m = {0.015, 0.03, nil} },
    cauldron                    = { m = {0.165, -0.16, -0.07},    r = {-5.5, -4.5, nil} },
    -- Redstone Blocks
    minecarts                   = { m = {-0.055} },
    pistons                     = { m = {-0.33, 0.03, 0.29},      r = {nil, 180, nil} },
    repeater                    = { m = {0.2, -0.075, -0.065},    r = {-5.5, -6, -0.5},     s = {1.25} },
    comparator                  = { m = {0.2, -0.075, -0.065},    r = {-5.5, -6, -0.5},     s = {1.25} },
    lever                       = { m = {-0.47, -0.06, -0.1},     r = {nil, 100, nil},      s = {2} },
    buttons                     = { m = {0.235, -0.105, -0.115},  r = {-7, -6, -0.5},       s = {1.4} },
    hopper                      = { m = {0.18, -0.09, -0.085},    r = {-5.5, -5.5, nil} },
    string                      = { m = {-0.05, -0.005, 0.015} },
    rails                       = { m = {0.165, -0.085, -0.09},   r = {-5.5, -5, -1.5} },
    crafter                     = { m = {-0.305, nil, 0.27},      r = {-180, nil, 180} },
    chiseled_bookshelf          = { m = {-0.305, nil, 0.27},      r = {-180, nil, 180} },
    -- Tools & Utilities
    buckets                     = { m = {0.01, -0.15, -0.15},     r = {nil, -7, nil}, s = {1.5} },
    fishing_rod                 = { m = {0.02, 0.04, -0.035},     r = {nil, -5.5, nil} },
    carrot_on_a_stick           = { m = {0.02, 0.04, -0.035},     r = {nil, -5.5, nil} },
    warped_fungus_on_a_stick    = { m = {0.02, 0.075, -0.07},     r = {nil, -5.5, nil} },
    pickaxes                    = { m = {0.025, -0.115, -0.04},   r = {nil, -8.5, nil} },
    axes                        = { m = {0.025, -0.115, -0.04},   r = {nil, -8.5, nil} },
    hoes                        = { m = {0.025, -0.115, -0.04},   r = {nil, -8.5, nil} },
    shovels                     = { m = {-0.04, -0.195, -0.01},   r = {13, 2.5, -9.5} },
    flint_and_steel             = { m = {-0.105, nil, nil} },
    fire_charge                 = { m = {-0.025, -0.035, 0.03} },
    shears                      = { m = {0.03, -0.075, -0.065},   r = {-55, -4, 50} },
    brush                       = { m = {nil, nil, 0.1},          s = {0.7} },
    bundles                     = { m = {-0.05, nil, 0.02} },
    recovery_compass            = { m = {-0.01, nil, nil} },
    compass                     = { m = {-0.005, -0.04, -0.005} },
    spyglass                    = { m = {-0.12, nil, 0.015},      r = {nil, -24.5, nil} },
    map                         = { m = {nil, -0.035, nil} },
    paper                       = { m = {nil, -0.035, nil} },
    bookshelf_books             = { m = {-0.065, -0.035, nil} },
    music_disc_11               = { m = {-0.01, -0.07, -0.005} },
    music_discs                 = { m = {-0.01, -0.07, 0.02} },
    wind_charge                 = { m = {-0.01, -0.07, 0.02} },
    elytra                      = { m = {nil, -0.07, nil} },
    firework_rocket             = { m = {-0.06, nil, 0.025} },
    saddle                      = { m = {-0.06, -0.04, 0.01} },
    boats                       = { m = {-0.04, 0.115, 0.025} },
    chest_boats                 = { m = {-0.04, 0.115, 0.025} },
    goat_horn                   = { m = {0.025, -0.04, nil} },
    -- Combat
    horse_armors                = { m = {0.02, -0.04, nil} },
    nautilus_armors             = { m = {-0.04, -0.075, -0.005} },
    swords                      = { m = {0.025, nil, -0.025},     r = {nil, -5, nil} },
    mace                        = { m = {0.025, -0.06, -0.025},   r = {nil, -5, nil} },
    trident                     = { m = {-0.03, nil, nil} },
    shield                      = { m = {-0.035, 0.06, 0.005},    r = {-1.5, -22.5, nil}, s = {0.8, 1, 1} },
    head_armor                  = { m = {nil, -0.11, -0.005} },
    foot_armor                  = { m = {nil, -0.11, -0.005} },
    leg_armor                   = { m = {nil, -0.035, -0.005} },
    wolf_armor                  = { m = {-0.005, -0.285, -0.015} },
    snowball                    = { m = {nil, -0.06, nil} },
    eggs                        = { m = {nil, -0.06, nil} },
    arrows                      = { m = {nil, nil, 0.02} },
    bow                         = { m = {-0.03, nil, 0.07},       r = {nil, -25.5, -10.5} },
    crossbow                    = { m = {-0.12, 0.085, 0.065},    r = {nil, -11, nil} },
    -- Foods & Drinks
    potatoes                    = { m = {nil, -0.04, 0.015} },
    bowl_foods                  = { m = {nil, -0.075, -0.015} },
    bottles_drink               = { m = {-0.025, nil, nil} },
    muttons                     = { m = {l == 1 and 0 or -0.07, nil, nil} },
    sweet_berries               = { m = {0.19, 0.08, nil},        r = {nil, nil, 51} },
    chorus_fruit                = { m = {-0.04, nil, nil} },
    carrots                     = { m = {nil, -0.075, nil} },
    beetroot                    = { m = {nil, -0.105, nil} },
    rabbits                     = { m = {nil, -0.105, nil} },
    fishes                      = { m = {nil, -0.065, nil} },
    pufferfish                  = { m = {-0.025, -0.045, -0.01} },
    bread                       = { m = {nil, 0.03, 0.01} },
    cookie                      = { m = {nil, -0.035, nil} },
    spider_eyes                 = { m = {-0.055, -0.04, nil} },
    cake                        = { m = {0.2, -0.095, -0.085},    r = {-6.5, -5, -1}, s = {1.2} },
    lingering_potion            = { m = {-0.025, nil, 0.03} },
    splash_potion               = { m = {-0.025, nil, 0.03} },
    ominous_bottle              = { m = {0.015, nil, nil} },
    -- Ingredients
    ingots                      = { m = {-0.065, -0.075, nil} },
    bricks                      = { m = {-0.065, -0.075, nil} },
    raw_materials               = { m = {nil, -0.035, -0.01} },
    emerald                     = { m = {nil, -0.035, nil} },
    lapis_lazuli                = { m = {nil, -0.035, nil} },
    amethyst_shard              = { m = {nil, -0.05, nil} },
    nuggets                     = { m = {0.02, -0.07, -0.01} },
    blaze_rod                   = { m = {0.02, -0.24, -0.005},    r = {9, -7, nil} },
    breeze_rod                  = { m = {0.02, -0.24, -0.005},    r = {9, -7, nil} },
    stick                       = { m = {-0.01, -0.28, nil},      r = {15.5, nil, nil} },
    bone                        = { m = {nil, -0.39, nil},        r = {15.5, nil, nil} },
    ink_sacs                    = { m = {nil, -0.075, -0.01} },
    honeycomb                   = { m = {0.01, -0.04, nil} },
    resin_clump                 = { m = {-0.01, -0.075, nil} },
    scutes                      = { m = {nil, -0.105, -0.01} },
    disc_fragment_5             = { m = {nil, -0.105, -0.01} },
    balls                       = { m = {nil, -0.04, nil} },
    prismarine_shard            = { m = {-0.03, nil, nil} },
    prismarine_crystals         = { m = {-0.03, -0.075, nil} },
    nether_star                 = { m = {-0.02, nil, nil} },
    heavy_core                  = { m = {0.275, -0.12, -0.125},   r = {-5.5, -5, -1.5}, s = {1.75} },
    popped_chorus_fruit         = { m = {-0.005, -0.035, -0.015} },
    echo_shard                  = { m = {nil, nil, -0.01} },
    firework_star               = { m = {nil, -0.04, -0.01} },
    powders                     = { m = {-0.02, -0.02, 0.015} },
    rabbit_foot                 = { m = {-0.02, -0.02, 0.015} },
    ghast_tear                  = { m = {nil, -0.105, nil} },
    smithing_template           = { m = {-0.02, nil, 0.02} },
    -- Spawn Eggs
    spawn_eggs_adjust           = { m = {-0.005, 0.03, nil} },
    spawn_eggs                  = { m = {-0.01, -0.04, nil} }
}

if not IsItemCompat then
    local entry = poses[itemName] or poses[getTag()]
    if entry then
        if entry.m then move(entry.m[1], entry.m[2], entry.m[3])   end
        if entry.r then rotate(entry.r[1], entry.r[2], entry.r[3]) end
        if entry.s then scale(entry.s[1], entry.s[2], entry.s[3])  end
    end
end