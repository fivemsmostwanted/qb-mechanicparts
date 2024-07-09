Config = {}

Config.Job = 'redlineperformance'

Config.CraftingMaterials = {
    engine0 = { metalscrap = 3, rubber = 2, iron = 1, plastic = 2, time = 15000 },
    engine1 = { metalscrap = 3, rubber = 2, iron = 1, plastic = 2, time = 15000 },
    engine2 = { metalscrap = 4, rubber = 2, iron = 1, plastic = 2, time = 15000 },
    engine3 = { metalscrap = 4, rubber = 2, iron = 1, plastic = 3, time = 15000 },
    engine4 = { metalscrap = 4, rubber = 2, iron = 1, plastic = 3, aluminum = 3, time = 15000 },
    brake0 = { rubber = 2, iron = 1, metalscrap = 2, time = 15000 },
    brake1 = { rubber = 2, iron = 1, metalscrap = 2, time = 15000 },
    brake2 = { rubber = 2, iron = 1, metalscrap = 2, time = 15000 },
    brake3 = { rubber = 3, iron = 2, metalscrap = 2, time = 15000 },
    transmission0 = { rubber = 2, iron = 1, metalscrap = 2, time = 15000 },
    transmission1 = { rubber = 2, iron = 1, metalscrap = 2, time = 15000 },
    transmission2 = { rubber = 2, iron = 1, metalscrap = 2, time = 15000 },
    transmission3 = { rubber = 3, iron = 2, metalscrap = 2, time = 15000 },
    suspension0 = { rubber = 2, iron = 1, metalscrap = 2, time = 15000 },
    suspension1 = { rubber = 2, iron = 1, metalscrap = 2, time = 15000 },
    suspension2 = { rubber = 2, iron = 1, metalscrap = 2, time = 15000 },
    suspension3 = { rubber = 3, iron = 2, metalscrap = 2, time = 15000 },
    suspension4 = { rubber = 3, iron = 2, metalscrap = 2, time = 15000 },
    turbo0 = { rubber = 3, iron = 2, metalscrap = 2, time = 15000 },
    turbo1 = { rubber = 3, iron = 2, metalscrap = 2, time = 15000 },
    repairkit = { metalscrap = 4, rubber = 2, plastic = 3, aluminum = 2, steel = 2, time = 15000 },
}

Config.Minigames = {
    engine0 = {
        { type = "Progress", iterations = 3, difficulty = 50 },
        { type = "CircleProgress", iterations = 3, difficulty = 60 },
    },
    engine1 = {
        { type = "Progress", iterations = 4, difficulty = 0.5 },
        { type = "CircleProgress", iterations = 4, difficulty = 0.7 },
    },
    engine2 = {
        { type = "Progress", iterations = 5, difficulty = 0.6 },
        { type = "CircleProgress", iterations = 5, difficulty = 0.8 },
    },
    engine3 = {
        { type = "Progress", iterations = 6, difficulty = 0.7 },
        { type = "CircleProgress", iterations = 6, difficulty = 0.9 },
    },
    engine4 = {
        { type = "Progress", iterations = 7, difficulty = 69 },
        { type = "CircleProgress", iterations = 7, difficulty = 70 },
        { type = "RapidLines", iterations = 12, difficulty = 85 },
    },

    -- Brakes
    brake0 = {
        { type = "Progress", iterations = 3, difficulty = 50 },
        { type = "CircleProgress", iterations = 3, difficulty = 60 },
    },
    brake1 = {
        { type = "Progress", iterations = 4, difficulty = 0.5 },
        { type = "CircleProgress", iterations = 4, difficulty = 0.7 },
    },
    brake2 = {
        { type = "Progress", iterations = 5, difficulty = 0.6 },
        { type = "CircleProgress", iterations = 5, difficulty = 0.8 },
    },
    brake3 = {
        { type = "Progress", iterations = 6, difficulty = 0.7 },
        { type = "CircleProgress", iterations = 6, difficulty = 0.9 },
    },

    -- Turbo
    turbo0 = {
        { type = "Progress", iterations = 3, difficulty = 50 },
        { type = "CircleProgress", iterations = 3, difficulty = 60 },
    },

    turbo1 = {
        { type = "Progress", iterations = 3, difficulty = 50 },
        { type = "CircleProgress", iterations = 3, difficulty = 60 },
    },
}
