--[[
  Author: LearningDave
  Date: November, 2nd 2015
  Applies True damage to the caster. Cant kil the caster(1hp will be set)
]]
function self_pain( keys )
	local caster = keys.caster
	local ability = keys.ability
	local damage = ability:GetAbilityDamage()
	local override_damage = false
	local health = caster:GetHealth()
	PopupDamage(caster, damage)
	if (caster:GetHealth() - damage) > 0 then
		caster:SetHealth(caster:GetHealth() - damage)
	else
		caster:SetHealth(1)
		override_damage = true
	end

	local abilityDamageType = keys.ability:GetAbilityDamageType()
	local ability_index = keys.caster:FindAbilityByName("hidan_death_possession_blood"):GetAbilityIndex()
    local death_possession_blood_ability = keys.caster:GetAbilityByIndex(ability_index)
    local death_possession_blood_ability_level = keys.caster:GetAbilityByIndex(ability_index):GetLevel()
    local returned_damage_outside_percentage = death_possession_blood_ability:GetLevelSpecialValueFor( "returned_damage_outside_percentage", ( death_possession_blood_ability:GetLevel() - 1 ) )


    if caster:HasModifier("modifier_hidan_metamorphosis") then 
    	if caster:HasModifier("modifier_hidan_in_circle") then 
    		if death_possession_blood_ability.bloodTarget ~= nil then
    			local damage = damage
    			if override_damage then
    				damage = (-1 * (health - damage))
    			end

    			local displayDamage = tonumber(string.format("%." ..  0 .. "f", damage))
				PopupDamage(death_possession_blood_ability.bloodTarget, displayDamage)

				local damageTable = {
					victim = death_possession_blood_ability.bloodTarget,
					attacker = keys.caster,
					damage = damage,
					damage_type = abilityDamageType
				}
				ApplyDamage( damageTable )
    		end
    	else
    		if death_possession_blood_ability.bloodTarget ~= nil then 
    			local damage = damage / 100 * returned_damage_outside_percentage
    			if override_damage then
    				damage = (-1 * (health - damage)) / 100 * returned_damage_outside_percentage
    			end
    			local displayDamage = tonumber(string.format("%." ..  0 .. "f", damage))
				PopupDamage(death_possession_blood_ability.bloodTarget, displayDamage)
				local damageTable = {
					victim = death_possession_blood_ability.bloodTarget,
					attacker = keys.caster,
					damage = damage,
					damage_type = abilityDamageType
				}
				ApplyDamage( damageTable )
    		end
    	end
    end


end