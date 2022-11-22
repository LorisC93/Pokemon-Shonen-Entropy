#===============================================================================
# Anger Shell
#===============================================================================
Battle::AbilityEffects::AfterMoveUseFromTarget.add(:ANGERSHELL,
  proc { |ability, target, user, move, switched_battlers, battle|
    next if !move.damagingMove?
    next if !target.droppedBelowHalfHP
    [:ATTACK,:SPECIAL_ATTACK,:SPEED].each{|stat|
      target.pbRaiseStatStageByAbility(stat, 1, target) if target.pbCanRaiseStatStage?(stat, target)
    }
    [:DEFENSE,:SPECIAL_DEFENSE].each{|stat|
      target.pbLowerStatStageByAbility(stat, 1, target) if target.pbCanLowerStatStage?(stat, target)
    }
  }
)
#===============================================================================
# Cud Chew
#===============================================================================
Battle::AbilityEffects::EndOfRoundEffect.add(:CUDCHEW,
proc { |ability, battler, battle|
    next if battler.item
    next if !battler.recycleItem
    next if !GameData::Item.get(battler.recycleItem).is_berry?
    battle.pbShowAbilitySplash(battler)
    battler.item = battler.recycleItem
    battler.setRecycleItem(nil)
    battler.pbHeldItemTriggerCheck(battler.item)
    battler.item = nil if battler.item
    battle.pbHideAbilitySplash(battler)
  }
)
#===============================================================================
# Electromorphosis
#===============================================================================
Battle::AbilityEffects::OnBeingHit.add(:ELECTROMORPHOSIS,
  proc { |ability, user, target, move, battle|
    next if target.fainted?
    # next if !move.pbContactMove?(user)
    next if target.effects[PBEffects::Charge] > 0
    battle.pbShowAbilitySplash(target)
    target.effects[PBEffects::Charge] = 2
    battle.pbDisplay(_INTL("Being hit by {1} charged {2} with power!", move.name, target.pbThis(true)))
    battle.pbHideAbilitySplash(target)
  }
)
#===============================================================================
# Sharpness
#===============================================================================
class Battle::Move
  def slicingMove?;      return @flags.any? { |f| f[/^Slicing$/i] }; end
end
# Aerial Ace, Air Cutter, Air Slash, Aqua Cutter, Behemoth Blade, Ceaseless Edge,
# Cross Poison, Cut, Fury Cutter, Kowtow Cleave, Leaf Blade, Night Slash, Psycho Cut, 
# Razor Leaf, Razor Shell, Sacred Sword, Slash, Solar Blade, Stone Axe, X-Scissor
Battle::AbilityEffects::DamageCalcFromUser.add(:SHARPNESS,
  proc { |ability, user, target, move, mults, baseDmg, type|
    echoln "#{move.name} is Slicing move"
    mults[:base_damage_multiplier] *= 1.5 if move.slicingMove?
  }
)
#===============================================================================
# Zero To Hero (Palafin)
#===============================================================================
MultipleForms.register(:PALAFIN, {
  "getFormOnLeavingBattle" => proc { |pkmn, battle, usedInBattle, endBattle|
    next if !endBattle || !usedInBattle || !pkmn.fainted?
    next 0 
  }
})
Battle::AbilityEffects::OnSwitchOut.add(:ZEROTOHERO,
  proc { |ability, battler, endOfBattle|
    next if battler.form == 1
    PBDebug.log("[Ability triggered] #{battler.pbThis}'s #{battler.abilityName}")
    battler.pbChangeForm(1)
  }
)
Battle::AbilityEffects::OnSwitchIn.add(:ZEROTOHERO,
  proc { |ability, battler, battle, switch_in|
    next if battler.form == 0
    next if battler.effects[PBEffects::ZeroToHero]
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1} underwent a heroic transformation!", battler.pbThis))
    battle.pbHideAbilitySplash(battler)
    battler.effects[PBEffects::ZeroToHero] = true
  }
)

module PBEffects
  # Starts from 300 to avoid conflicts with other plugins.
  ZeroToHero          = 301
end

class Battle::Battler
  alias paldea_pbInitEffects pbInitEffects
  def pbInitEffects(batonPass)
    paldea_pbInitEffects(batonPass)
    @effects[PBEffects::ZeroToHero] = false
  end 
end 