---------- Assembly Machines & Automation Technologies -------------------------

-- Remove normal recipes from assembling machines
function remove_crafting_category(machine, category)
    for i = #machine.crafting_categories, 1, -1 do
        if machine.crafting_categories[i] == category then
            table.remove(machine.crafting_categories, i)
        end
    end
end

for i = 1, 3 do
    local machine = data.raw["assembling-machine"]["assembling-machine-" .. i]
    remove_crafting_category(machine, "crafting")
end

---------- Mining --------------------------------------------------------------

-- Remove burner mining drill
data.raw["item"]["burner-mining-drill"] = nil
data.raw["recipe"]["burner-mining-drill"] = nil
data.raw["mining-drill"]["burner-mining-drill"] = nil

-- Make electric mining drill only mine uranium ore
data.raw["mining-drill"]["electric-mining-drill"].resource_categories = {
    "mining-drill-minable"
}
data.raw["resource-category"]["mining-drill-minable"] = {
    type = "resource-category",
    name = "mining-drill-minable"
}
data.raw["resource"]["uranium-ore"].category = "mining-drill-minable"

-- Move the unlock of electric mining drill to uranium mining technology
table.insert(
    data.raw["technology"]["uranium-mining"].effects,
    1,
    data.raw["technology"]["electric-mining-drill"].effects[1]
)
data.raw["technology"]["electric-mining-drill"] = nil

---------- Robots --------------------------------------------------------------

-- Construction robots
data.raw["item"]["construction-robot"] = nil
data.raw["recipe"]["construction-robot"] = nil
data.raw["construction-robot"]["construction-robot"].minable = nil
data.raw["technology"]["construction-robotics"] = nil

-- Logistics robots
data.raw["item"]["logistic-robot"] = nil
data.raw["recipe"]["logistic-robot"] = nil
data.raw["logistic-robot"]["logistic-robot"].minable = nil
data.raw["technology"]["logistic-robotics"] = nil

-- Logistic chests
data.raw["technology"]["logistic-system"] = nil
local logistic_chests = data.raw["logistic-container"]
for _, chest in pairs(logistic_chests) do
    local name = chest.name
    data.raw["item"][name] = nil
    data.raw["recipe"][name] = nil
    chest.minable = nil
end

-- Roboports & Personal roboports
data.raw["item"]["roboport"] = nil
data.raw["recipe"]["roboport"] = nil
data.raw["roboport"]["roboport"].minable = nil
data.raw["roboport-equipment"] = {}
data.raw["item"]["personal-roboport-equipment"] = nil
data.raw["recipe"]["personal-roboport-equipment"] = nil
data.raw["technology"]["personal-roboport-equipment"] = nil
data.raw["item"]["personal-roboport-mk2-equipment"] = nil
data.raw["recipe"]["personal-roboport-mk2-equipment"] = nil
data.raw["technology"]["personal-roboport-mk2-equipment"] = nil

-- Shortcuts
local shortcuts = data.raw["shortcut"]
for _, shortcut in pairs(shortcuts) do
    if shortcut.technology_to_unlock == "construction-robotics" or
        shortcut.technology_to_unlock == "personal-roboport-equipment" then
        data.raw["shortcut"][shortcut.name] = nil
    end
end

-- Tips and Tricks
data.raw["tips-and-tricks-item"]["copy-paste-requester-chest"] = nil
data.raw["tips-and-tricks-item-category"]["logistic-network"] = nil
for tip_id, tip in pairs(data.raw["tips-and-tricks-item"]) do
    if tip.category == "logistic-network" then
        data.raw["tips-and-tricks-item"][tip_id] = nil
    end
end
data.raw["tips-and-tricks-item-category"]["ghost-building"] = nil
for tip_id, tip in pairs(data.raw["tips-and-tricks-item"]) do
    if tip.category == "ghost-building" then
        data.raw["tips-and-tricks-item"][tip_id] = nil
    end
end

-- Others
data.raw["dont-build-entity-achievement"] = nil
for i = 1, 6 do
    data.raw["technology"]["worker-robots-speed-" .. i] = nil
    data.raw["technology"]["worker-robots-storage-" .. i] = nil
end

---------- Automated Rail Transportation ---------------------------------------

data.raw["technology"]["automated-rail-transportation"] = nil

-- Train Stop
data.raw["item"]["train-stop"] = nil
data.raw["recipe"]["train-stop"] = nil
data.raw["train-stop"]["train-stop"].minable = nil

-- Rail Signal
data.raw["item"]["rail-signal"] = nil
data.raw["recipe"]["rail-signal"] = nil
data.raw["rail-signal"]["rail-signal"].minable = nil

-- Rail Chain Signal
data.raw["item"]["rail-chain-signal"] = nil
data.raw["recipe"]["rail-chain-signal"] = nil
data.raw["rail-chain-signal"]["rail-chain-signal"].minable = nil

-- Tips and Tricks
data.raw["tips-and-tricks-item"]["train-stops"] = nil
data.raw["tips-and-tricks-item"]["train-stop-same-name"] = nil
data.raw["tips-and-tricks-item"]["rail-signals-basic"] = nil
data.raw["tips-and-tricks-item"]["rail-signals-advanced"] = nil

---------- Others --------------------------------------------------------------

-- Make engine unit craftable in hand
data.raw["recipe"]["engine-unit"].category = nil

-- Other Tips and Tricks
data.raw["tips-and-tricks-item"]["z-dropping"].dependencies =
    data.raw["tips-and-tricks-item"]["entity-transfers"].dependencies
data.raw["tips-and-tricks-item"]["entity-transfers"] = nil
