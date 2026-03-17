-- by omnis._.
-- using item_model_addon.lua because it doesn't overwrite and to better separate compatibility between packs
-- it is what it is, you gotta make do with what you've got

-- === FUNCTION ===
Positions = {}
function Adj(tables)
    for _, t in ipairs(tables) do
        table.insert(Positions, t)
    end
end

-- === ITEMS RESOURCE PACKS ===
PackCompat = {
    rvTorches = { {"torch", "soul_torch", "copper_torch", "lanterns", "repeater", "comparator"} },
}

ActivePacks = {}
    local rvTorches = ${rvTorches} and (table.insert(ActivePacks, "rvTorches") or true)

-- === UNDO ADJUSTS ===
UndoAdjusts = {
}

-- === INDIVIDUAL RESOURCE PACK ADJUST ===
-- R&V Torches
if rvTorches then
    Adj({
        { {"torch", "soul_torch", "redstone_torch", "copper_torch"}, m = {-0.1, nil, nil} },
        { {"repeater", "comparator"}, renderAsBlock = false }
    })
end