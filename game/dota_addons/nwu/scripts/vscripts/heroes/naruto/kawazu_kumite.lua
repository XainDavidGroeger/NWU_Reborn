--[[
  Author: LearningDave
  Date: October, 27th 2015
  -- Creates an Illusion, making use of the built in modifier_illusion
  outgoing and ingoing damage values are depending on 'naruto_kage_bunshin_mastery' ability lvl
]]
function ConjureImage( event )
 local target = event.target
 local caster = event.caster
 local player = caster:GetPlayerID()
 local ability = event.ability
 local unit_name = caster:GetUnitName()
 local origin = caster:GetAbsOrigin() + RandomVector(100)
 local duration = ability:GetLevelSpecialValueFor( "illusion_duration", ability:GetLevel() - 1 )
 local outgoingDamage = 0
 local incomingDamage = 0
 
 if event.caster:HasAbility("naruto_kage_bunshin_mastery") then
    local ability_index = event.caster:FindAbilityByName("naruto_kage_bunshin_mastery"):GetAbilityIndex()
    local kage_bunshin_mastery_ability = event.caster:GetAbilityByIndex(ability_index)
    if kage_bunshin_mastery_ability:GetLevel() > 0 then 
       outgoingDamage = ability:GetLevelSpecialValueFor( "illusion_outgoing_damage_percent", kage_bunshin_mastery_ability:GetLevel())
       incomingDamage = ability:GetLevelSpecialValueFor( "illusion_incoming_damage_percent", kage_bunshin_mastery_ability:GetLevel())
    else
       outgoingDamage = ability:GetLevelSpecialValueFor( "illusion_outgoing_damage_percent", 0)
       incomingDamage = ability:GetLevelSpecialValueFor( "illusion_incoming_damage_percent", 0)
    end 
 end



 -- handle_UnitOwner needs to be nil, else it will crash the game.
 local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
 illusion:SetPlayerID(caster:GetPlayerID())
 illusion:SetControllableByPlayer(player, true)

 -- Level Up the unit to the casters level
 local casterLevel = caster:GetLevel()
 for i=1,casterLevel-1 do
  illusion:HeroLevelUp(false)
 end

 -- Set the skill points to 0 and learn the skills of the caster
 illusion:SetAbilityPoints(0)
 for abilitySlot=0,15 do
  local ability = caster:GetAbilityByIndex(abilitySlot)
  if ability ~= nil then 
   local abilityLevel = ability:GetLevel()
   local abilityName = ability:GetAbilityName()
   local illusionAbility = illusion:FindAbilityByName(abilityName)
   if illusionAbility ~= nil then
    illusionAbility:SetLevel(abilityLevel)
   end
  end
 end

 -- Recreate the items of the caster
 for itemSlot=0,5 do
  local item = caster:GetItemInSlot(itemSlot)
  if item ~= nil then
   local itemName = item:GetName()
   local newItem = CreateItem(itemName, illusion, illusion)
   illusion:AddItem(newItem)
  end
 end

   local hp_percentage = caster:GetHealth() / (caster:GetMaxHealth() / 100)
 local bunshin_hp = illusion:GetMaxHealth() / 100 * hp_percentage
 illusion:SetHealth(bunshin_hp)
 -- Set the unit as an illusion
 -- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle 
 illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })

 -- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
 illusion:MakeIllusion()

end