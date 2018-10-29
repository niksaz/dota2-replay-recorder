----------------------------------------------------------------------------------------------------
offset = 1;
function Think()
    if (GetTeam() == TEAM_RADIANT) then
        print("selecting radiant");
        SelectHero(0 + offset, "npc_dota_hero_enigma");
        SelectHero(1 + offset, "npc_dota_hero_sven");
        SelectHero(2 + offset, "npc_dota_hero_sven");
        SelectHero(3 + offset, "npc_dota_hero_sven");
    elseif (GetTeam() == TEAM_DIRE) then
        print("selecting dire");
        SelectHero(4 + offset, "npc_dota_hero_sven");
        SelectHero(5 + offset, "npc_dota_hero_sven");
        SelectHero(6 + offset, "npc_dota_hero_sven");
        SelectHero(7 + offset, "npc_dota_hero_lina");
        SelectHero(8 + offset, "npc_dota_hero_sven");
        SelectHero(9 + offset, "npc_dota_hero_sven");
    end
end

function UpdateLaneAssignments()
    if (GetTeam() == TEAM_RADIANT) then
        print("updating lane assignments radiant");
        return {
            [0 + offset] = LANE_TOP,
            [1 + offset] = LANE_TOP,
            [2 + offset] = LANE_TOP,
            [3 + offset] = LANE_TOP
        }
    elseif (GetTeam() == TEAM_DIRE) then
        print("updating lane assignments dire");
        return {
            [4 + offset] = LANE_TOP,
            [5 + offset] = LANE_TOP,
            [6 + offset] = LANE_TOP,
            [7 + offset] = LANE_MID,
            [8 + offset] = LANE_TOP,
            [9 + offset] = LANE_TOP
        }
    end
end

----------------------------------------------------------------------------------------------------
