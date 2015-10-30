--[[
  Author: LearningDave
  Date: October, 30th 2015
  Destroys the targeted tree
]]
function cutTree( keys )
	keys.target:RemoveSelf()
end
--[[
  Author: LearningDave
  Date: October, 30th 2015
  Does apply extra damage to the target and pops it up, the damage value depends on the caster's damage and if he's a melee or range attacker.
]]
function kunaiBuff( keys )
	if not keys.target:IsHero() and not keys.target:IsBuilding() then
		local caster = keys.caster
		local target = keys.target
		local bonus_damage_melee = keys.ability:GetLevelSpecialValueFor("bonus_damage_melee", keys.ability:GetLevel() - 1 )
		local bonus_damage_range = keys.ability:GetLevelSpecialValueFor("bonus_damage_range", keys.ability:GetLevel() - 1 )
		local bonus_percentage = 0
		if caster:IsRangedAttacker() then 
	 		bonus_percentage = bonus_damage_range
	 	else
	 		bonus_percentage = bonus_damage_melee
		end

		local extra_damage = keys.caster:GetAverageTrueAttackDamage() / 100 * bonus_percentage
		PopupDamage(target, extra_damage)
		local damageTable = {
				victim = target,
				attacker = caster,
				damage = damage,
				damage_type = abilityDamageType
			}
		ApplyDamage( damageTable )
	end
end