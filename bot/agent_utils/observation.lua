-- Observation module
local Observation = {}

local bot = GetTeamMember(1)
local bot_player_id = bot:GetPlayerID()

local NEARBY_RADIUS = 1500
local ability1 = bot:GetAbilityByName('nevermore_shadowraze1')
local ability2 = bot:GetAbilityByName('nevermore_shadowraze2')
local ability3 = bot:GetAbilityByName('nevermore_shadowraze3')
local ability4 = bot:GetAbilityByName('nevermore_requiem')

-- Obtain damage info.
function get_damage_info()
    local damage_info = {
        bot:TimeSinceDamagedByAnyHero(),
        bot:TimeSinceDamagedByCreep(),
        bot:TimeSinceDamagedByTower(),
    }
    return damage_info
end

function get_ally_tower()
    if GetTeam() == TEAM_RADIANT then
        return GetTower(TEAM_RADIANT, TOWER_MID_1)
    else
        return GetTower(TEAM_DIRE, TOWER_MID_1)
    end
end

function get_enemy_tower()
    if GetTeam == TEAM_DIRE then
        return GetTower(TEAM_DIRE, TOWER_MID_1)
    else
        return GetTower(TEAM_RADIANT, TOWER_MID_1)
    end
end

-- Obtain towers' info.
function get_towers_info()
    local ally_tower = get_ally_tower()
    local enemy_tower = get_enemy_tower()
    return {
        enemy_tower:GetHealth(),
        ally_tower:GetHealth()
    }
end

-- Obtain bot's info (specified for Nevermore).
function get_self_info()
    local ability1_dmg = 0
    if ability1:IsFullyCastable() then
        ability1_dmg = 1
    end

    local ability2_dmg = 0
    if ability2:IsFullyCastable() then
        ability2_dmg = 1
    end

    local ability3_dmg = 0
    if ability3:IsFullyCastable() then
        ability3_dmg = 1
    end

    local ability4_dmg = 0
    if ability4:IsFullyCastable() then
        ability4_dmg = 1
    end

    -- Bot's atk, hp, mana, abilities, position x, position y
    local self_position = bot:GetLocation()
    local self_info = {
        self_position[1],
        self_position[2],
        bot:GetFacing(),
        bot:GetAttackDamage(),
        bot:GetLevel(),
        bot:GetHealth(),
        bot:GetMana(),
        ability1_dmg,
        ability2_dmg,
        ability3_dmg,
        ability4_dmg,
    }

    return self_info
end

-- Obtain enemy hero info.
function get_enemy_hero_info()
    local enemy_hero_info = { 0, 0, 0, 0, 0, 0, 0 }

    local enemy_heroes_list = bot:GetNearbyHeroes(NEARBY_RADIUS, true, BOT_MODE_NONE)
    if #enemy_heroes_list > 0 then
        local enemy = enemy_heroes_list[1]
        local enemy_position = enemy:GetLocation()
        enemy_hero_info = {
            enemy_position[1],
            enemy_position[2],
            enemy:GetAttackDamage(),
            enemy:GetLevel(),
            enemy:GetHealth(),
            enemy:GetMana(),
            enemy:GetFacing(),
        }
    end

    return enemy_hero_info
end

--- Retrieve info from the given creeps.
-- @param creeps to retrieve info from
--
function get_creeps_info(creeps)
    local creeps_info = {}
    for _, creep in pairs(creeps) do
        local position = creep:GetLocation()
        table.insert(creeps_info, {
            creep:GetHealth(),
            position[1],
            position[2]
        })
    end

    -- if creeps_info is empty:
    local creep_zero_padding = { 0, 0, 0 }
    if #creeps_info == 0 then
        table.insert(creeps_info, creep_zero_padding)
    end

    return creeps_info
end

-- Get all observations.
function Observation.get_observation()
    local enemy_creeps = get_creeps_info(bot:GetNearbyCreeps(NEARBY_RADIUS, true))
    local ally_creeps = get_creeps_info(bot:GetNearbyCreeps(NEARBY_RADIUS, false))

    local enemy_heroes_list = bot:GetNearbyHeroes(NEARBY_RADIUS, true, BOT_MODE_NONE)
    local enemy
    if #enemy_heroes_list > 0 then
        enemy = enemy_heroes_list[1]
    else
        enemy = nil
    end

    local attack_target = bot:GetAttackTarget()
    local attacking_creep = false
    local creeps = bot:GetNearbyCreeps(NEARBY_RADIUS, true)
    for _, creep in pairs(creeps) do
        attacking_creep = attacking_creep or attack_target == creep
    end
    local attacking_hero = #enemy_heroes_list > 0 and attack_target == enemy_heroes_list[1]
    local attacking_tower = attack_target == get_enemy_tower()
    print('attacking_creep: ', attacking_creep)
    print('attacking_hero: ', attacking_hero)
    print('attacking_tower: ', attacking_tower)

    local observation = {
        ['self_info'] = get_self_info(),
        ['enemy_info'] = get_enemy_hero_info(),
        ['enemy_creeps_info'] = enemy_creeps,
        ['ally_creeps_info'] = ally_creeps,
        ['tower_info'] = get_towers_info(),
        ['damage_info'] = get_damage_info(),
        ['attack_targets'] = {
            attacking_creep,
            attacking_hero,
            attacking_tower
        }
    }

    return observation
end

function Observation.is_done()
    local _end = false

    if GetGameState() == GAME_STATE_POST_GAME or
            GetHeroKills(bot_player_id) > 0 or
            GetHeroDeaths(bot_player_id) > 0 or
            DotaTime() > 120 then
        _end = true
        print('Bot: the game has ended.')
    end

    return _end
end

return Observation;
