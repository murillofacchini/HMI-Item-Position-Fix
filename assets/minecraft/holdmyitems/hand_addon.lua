-- by omnis._.

-- ===== CONTEXTS =====
local itemName = I:getName(context.item):gsub("minecraft:", "")
local matrices = context.matrices
local l = context.bl and 1 or -1

-- ===== PACK COMPATIBILITY =====
local activePacks = {}
if ${w3di}              then table.insert(activePacks, "w3di") end
if ${rvTorchs}          then table.insert(activePacks, "rvTorchs") end
if ${freshOresIngots}   then table.insert(activePacks, "freshOresIngots") end

-- ===== UTILITY FUNCTIONS =====
local function packActive(pack)
    for _, p in ipairs(activePacks) do
        if p == pack then return true end
    end
    return false
end

local function pose(transforms, force)
    for _, tab in ipairs(transforms) do
        for _, i in ipairs(tab[1]) do
            if itemName:match(i) then
                if tab.m then
                    if tab.m[1] then M:moveX(matrices, tab.m[1] * l) end
                    if tab.m[2] then M:moveY(matrices, tab.m[2]) end
                    if tab.m[3] then M:moveZ(matrices, tab.m[3]) end
                end
                if tab.r then
                    if tab.r[1] then M:rotateX(matrices, tab.r[1] * l) end
                    if tab.r[2] then M:rotateY(matrices, tab.r[2]) end
                    if tab.r[3] then M:rotateZ(matrices, tab.r[3]) end
                end
                if tab.s then
                    if tab.s[1] or tab.s[2] or tab.s[3] then M:scale(matrices, tab.s[1], tab.s[2], tab.s[3]) end
                end
            end
        end
    end
end

-- ===== PACK ADJUSTMENTS =====
if packActive("w3di") then
    -- R&V Torches
    if packActive("rvTorchs") then
        pose({
            { {"^torch", "soul_torch"}, m = {nil, nil, -0.05}, r = {nil, nil, -10} },
        })
    end
    
    -- Fresh Ores & Ingots
    if packActive("freshOresIngots") then
        pose({
            { {"^diamond$", "emerald$", "lapis_lazuli$", "quartz$", "nugget", "amethyst_shard", "ingot", "brick$", "netherite_scrap", "redstone", "raw", "coal$", "flint$"},
              m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} }
        })
    end
end

-- ===== HANGING PLANTS ADJUSTMENTS =====
pose({
    { {"weeping_vines", "hanging_roots", "pale_hanging_moss", "spore_blossom"}, m = {nil, 0.35, -0.05} },
})