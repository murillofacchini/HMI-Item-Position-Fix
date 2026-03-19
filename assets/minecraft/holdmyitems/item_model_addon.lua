-- by omnis._.
-- using item_model_addon.lua because it doesn't overwrite and to better separate compatibility between packs
-- it is what it is, you gotta make do with what you've got
global.ItemName = "";
-- === FUNCTION ===
Positions = {}
function Adj(tables)
    for _, t in ipairs(tables) do
        table.insert(Positions, t)
    end
end

-- === ITEMS RESOURCE PACKS ===
PackCompat = {
    rvTorches = { {"torch", "soul_torch", "copper_torch", "redstone_torch", "lanterns", "repeater", "comparator", "campfire", "soul_campfire"} },
    refinedTorches = { {"torch", "soul_torch", "copper_torch", "redstone_torch", "lanterns", "campfire", "soul_campfire"} },
    refinedBuckets = { {"bucket"}, matches = true }
}

ActivePacks = {}
    local rvTorches         = ${rvTorches} and (table.insert(ActivePacks, "rvTorches") or true)
    local refinedTorches    = ${refinedTorches} and (table.insert(ActivePacks, "refinedTorches") or true)
    local refinedBuckets    = ${refinedBuckets} and (table.insert(ActivePacks, "refinedBuckets") or true)

-- === UNDO ADJUSTS ===
UndoAdjusts = {
}

-- === INDIVIDUAL RESOURCE PACK ADJUST ===
-- R&V Torches
if rvTorches then
    Adj({
        { {"torch", "soul_torch", "redstone_torch", "copper_torch"}, m = {0.01, nil, -0.035}, r = {-5, -5.5, nil} },
        { {"repeater", "comparator"}, m = {-0.045, -0.02, -0.035}, r = {-6, -16, 2.5}, renderAsBlock = false },
        { {"lanterns"}, m = {0.07, -0.545, 0.06}, r = {-11.5, -5.5, nil} },
        { {"campfire", "soul_campfire"}, m = {-0.08, 0.185, 0.255}, r = {8, -9.5, -2.5} }
    })
end

-- Refined Torches
if refinedTorches then
    Adj({
        { {"torch", "soul_torch", "redstone_torch", "copper_torch"}, m = {0.035, nil, -0.04}, r = {-5, -4.5, nil} },
        { {"lanterns"}, m = {-0.04, -0.48, 0.115}, r = {-8.5, 9, nil} },
    })
end