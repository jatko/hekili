
local addon, ns = ...
local Hekili = _G[ addon ]

local class = ns.class
local state = ns.state

local addHook = ns.addHook

local addAbility = ns.addAbility
local modifyAbility = ns.modifyAbility
local addHandler = ns.addHandler

local addAura = ns.addAura
local modifyAura = ns.modifyAura

local addCastExclusion = ns.addCastExclusion
local addGearSet = ns.addGearSet
local addGlyph = ns.addGlyph
local addMetaFunction = ns.addMetaFunction
local addTalent =  ns.addTalent
local addTrait = ns.addTrait
local addResource = ns.addResource
local addStance = ns.addStance

local addSetting = ns.addSetting
local addToggle = ns.addToggle

local registerCustomVariable = ns.registerCustomVariable
local registerInterrupt = ns.registerInterrupt

local removeResource = ns.removeResource

local setArtifact = ns.setArtifact
local setClass = ns.setClass
local setPotion = ns.setPotion
local setRole = ns.setRole
local setRegenModel = ns.setRegenModel
local setTalentLegendary = ns.setTalentLegendary

local RegisterEvent = ns.RegisterEvent

local retireDefaults = ns.retireDefaults
local storeDefault = ns.storeDefault

local PTR = ns.PTR

if select(2, UnitClass('player')) == 'MAGE' then
    local function MageInit()
        Hekili:Print("Initializing Mage Class Module.")

        local function genericHasteMod( x )
            return x * haste
        end

        setClass('MAGE')
        addResource('mana', SPELL_POWER_MANA, true)
        addResource("arcane_charge", SPELL_POWER_ARCANE_CHARGES)   
    
        state.arcane_charge = setmetatable( {
                actual = nil,
                max = 4,
                active_regen = 0,
                inactive_regen = 0,
                forecast = {},
                times = {},
                values = {},
                fcount = 0,
                regen = 0,
                regenerates = false,
            }, { __index = function( t, k )
                if k == 'count' or k == 'current' then
                    return t.actual

                elseif k == 'actual' then
                    t.actual = UnitPower( "player", SPELL_POWER_ARCANE_CHARGES)
                    return t.actual
                end
            end } )

        addMetaFunction('state', 'arcane_charge', function() return arcane_charge.current end)
            
        addHook('timeToReady', function(wait, action)
            local ability = action and class.abilities[action]

            if ability and ability.spend_type == "arcane_charge" and ability.spend > state.arcane_charge.current then
                wait = 3600
            end

            return wait
        end)

        setPotion( 'prolonged_power' )

        -- Frost Talents
        addTalent('mirror_image', 55342)
        addTalent('ray_of_frost', 205021)
        addTalent('rune_of_power', 116011)
        addTalent('frost_bomb', 112948)
        addTalent('ice_nova', 157997)
        addTalent('comet_storm', 153595)
        addTalent('glacial_spike', 199786)
        addTalent('splitting_ice', 56377)

        -- Frost Auras
        addAura('fingers_of_frost', 44544, 'duration', 15, 'max_stack', 3)
        addAura('frozen_mass', 242253, 'duration', 10, 'max_stack', 1)
        addAura('brain_freeze', 190446, 'duration', 15, 'max_stack', 1)
        addAura('frost_bomb', 112948, 'duration', 12, 'max_stack', 1)
        addAura('icy_veins', 12472, 'duration', 20)
        addAura('winters_chill', 228358, 'duration', 1, 'max_stack', 1)
        addAura('rune_of_power', 116014, 'duration', 10)
        addAura('zannesu_journey', 226852, 'duration', 30, 'max_stack', 5)
        addAura('icicles', 205473, 'duration', 60, 'max_stack', 5)

        -- Arcane Talents
        addTalent('arcane_familiar', 205022)
        addTalent('amplification', 236628)
        addTalent('words_of_power', 205035)
        addTalent('shimmer', 212653)
        addTalent('slipstream', 236457)
        addTalent('mana_shield', 235463)
        addTalent('incanters_flow', 1463)
        addTalent('supernova', 157980)
        addTalent('charged_up', 205032)
        addTalent('resonance', 205028)
        addTalent('chrono_shift', 235711)
        addTalent('ring_of_frost', 113724)
        addTalent('ice_ward', 205036)
        addTalent('nether_tempest', 114923)
        addTalent('unstable_magic', 157976)
        addTalent('erosion', 205039)
        addTalent('overpowered', 155147)
        addTalent('temporal_flux', 234302)
        addTalent('arcane_orb', 153626)

        -- Arcane Traits
        addTrait('mark_of_aluneth', 224968)
        addTrait('might_of_the_guardians', 187318)
        addTrait('blasting_rod', 187258)
        addTrait('arcane_purification', 187313)
        addTrait('ancient_power', 214917)
        addTrait('force_barrier', 210716)
        addTrait('aegwynns_imperative', 187264)
        addTrait('aegwynns_fury', 187287)
        addTrait('everywhere_at_once', 187301)
        addTrait('rule_of_threes', 215463)
        addTrait('aegwynns_ascendance', 187680)
        addTrait('crackling_energy', 187310)
        addTrait('touch_of_the_magi', 210725)
        addTrait('ethereal_sensitivity', 187276)
        addTrait('sloooow_down', 210730)
        addTrait('torrential_barrage', 187304)
        addTrait('arcane_rebound', 188006)
        addTrait('aegwynns_wrath', 187321)
        addTrait('intensity_of_the_tirisgarde', 241121)
        addTrait('aegwynns_intensity', 238054)
        addTrait('aluneths_avarice', 238090)
        addTrait('time_and_space', 238126)

        addGearSet('zannesu_journey', 133970)

        addGearSet( 'tier19', 138309, 138312, 138315, 138318, 138321, 138365 )
        addGearSet( 'tier20', 147145, 147146, 147147, 147148, 147149, 147150 )

        registerCustomVariable('water_jet_expires', 0 )
        registerCustomVariable('water_jet_starts', 0 )

        -- Abilities
        addAbility('frostbolt', {
            id = 116,
            spend = 0,
            spend_type = 'mana',
            cast = 2,
            gcdType = 'spell',
            cooldown = 0,
            known = function() return spec.frost end
        })

        addAbility('water_jet', {
            id = 135029,
            spend = 0,
            spend_type = 'mana',
            cast = 1,
            gcdType = 'off',
            cooldown = 25
        })
  
        addAbility('ice_lance', {
            id = 54261,
            spend = 0,
            spend_type = 'mana',
            cast = 0,
            gcdType = 'spell',
            cooldown = 0,
            known = function() return spec.frost end
        })

        addAbility('flurry', {
            id = 44614,
            spend = 0,
            spend_type = 'mana',
            cast = 3,
            gcdType = 'spell',
            cooldown = 0,
            known = function() return spec.frost end
        })

        addAbility('ebonbolt', {
            id = 214634,
            spend = 0,
            spend_type = 'mana',
            cast = 3,
            gcdType = 'spell',
            cooldown = 45,
            known = function() return artifact.ebonbolt.enabled end
        })

        addAbility('frost_bomb', {
            id = 112948,
            spend = 0,
            spend_type = 'mana',
            cast = 1.5,
            gcdType = 'spell',
            cooldown = 0,
            talent = 'frost_bomb'
        })

        addAbility( 'icy_veins', {
            id = 12472,
            spend = 0,
            cast = 0,
            gcdType = 'off',
            cooldown = 180,
            toggle = 'cooldowns',
            known = function() return spec.frost end
        })

        addAbility( 'ice_nova', {
            id = 157997,
            spend = 0,
            cast = 0,
            gcdType = 'spell',
            cooldown = 25,
            talent = 'ice_nova'
        })

        addAbility( 'rune_of_power', {
            id = 116011,
            spend = 0,
            cast = 1.5,
            gcdType = 'spell',
            cooldown = 40,
            charges = 2,
            recharge = 40,
            toggle = 'cooldowns',
            talent = 'rune_of_power'
        })

        addAbility( 'ray_of_frost', {
            id = 205021,
            spend = 0,
            cast = 10,
            channeled = true,
            gcdType = 'spell',
            cooldown = 60,
            talent = 'ray_of_frost'
        })

        addAbility('frozen_orb', {
            id = 84714,
            spend = 0,
            cast = 0,
            gcdType = 'spell',
            cooldown = 60,
            known = function() return spec.frost end
        })

        addAbility('comet_storm', {
            id = 153595,
            spend = 0,
            cast = 0,
            gcdType = 'spell',
            cooldown = 30,
            talent = 'comet_storm'
        })

        addAbility('blizzard', {
            id = 190356,
            spend = 0,
            cast = 2,
            gcdType = 'spell',
            cooldown = 8,
            known = function() return spec.frost end
        })

        addAbility('glacial_spike', {
            id = 199786,
            spend = 0,
            cast = 3,
            gcdType = 'spell',
            talent = 'glacial_spike'
        })

        addAbility('mirror_image', {
            id = 55342,
            spend = 0,
            cast = 0,
            gcdType = 'off',
            toggle = 'cooldowns',
            cooldown = 120,
            talent = 'mirror_image'
        })

        modifyAbility('ebonbolt', 'cast', genericHasteMod)

        modifyAbility('frostbolt', 'cast', genericHasteMod)

        modifyAbility('water_jet', 'cast', genericHasteMod)

        modifyAbility('flurry', 'cast', function (x)
            if state.buff.brain_freeze.up then
                return 0.001
            else
                return genericHasteMod(x)
            end
        end)

        addHandler('ice_lance', function()
            if state.buff.fingers_of_frost.up then
                removeStack('fingers_of_frost', 1)
            end
            
            removeBuff('icicles')
        end)

        addHandler('flurry', function()
            if state.buff.brain_freeze.up then
                applyDebuff('target', 'winters_chill', 2)
            end
            if equipped.zannesu_journey then
                applyBuff('zannesu_journey', 30, 5)
            end
            if state.buff.brain_freeze.up then
                removeStack('brain_freeze', 1)
            end
            --state.lastgcd = 'flurry'
        end)

        addHandler('frostbolt', function()
            if state.now >= state.water_jet_starts and state.now <= state.water_jet_expires then
                --print(state.water_jet_expires - state.water_jet_starts)
                addStack('fingers_of_frost', 15, 1)
            end
        end)

        addHandler('ebonbolt', function()
            addStack('brain_freeze', 15, 1)
        end)

        addHandler('frost_bomb', function()
            applyDebuff('target', 'frost_bomb', 12)
        end)

        addHandler('icy_veins', function()
            applyBuff('icy_veins', 20, 1)
        end)

        addHandler('rune_of_power', function()
            applyBuff('rune_of_power', 10)
        end)

        addHandler('frozen_orb', function()
            applyBuff('frozen_mass', 10)
        end)

        addHandler('blizzard', function()
            if buff.zannesu_journey.up then
                removeBuff('zannesu_journey')
            end
        end)

        -- Arcane Auras
        addAura('arcane_charge', -100, 'duration', 3600, 'max_stack', 4)
        addAura('presence_of_mind', 205025, 'duration', 3600, 'max_stack', 2)
        addAura('arcane_missiles', 79683, 'duration', 20, 'max_stack', 3)
        addAura('evocation', 12051, 'duration', 6, 'max_stack', 1)
        addAura('arcane_power', 12042, 'duration', 15, 'max_stack', 1)
        addAura('mark_of_aluneth', 224968, 'duration', 6, 'max_stack', 1)
        addAura('arcane_familiar', 210126, 'duration', 3600, 'max_stack', 1)
        addAura('nether_tempest', 114923, 'duration', 12, 'max_stack', 1)

        addMetaFunction('state', 'time_until_burn_internal', function()
        end)

        -- Arcane Abilities
        local function gainArcaneCharge(state, n)
            if n >= 0 then
                n = max(0, min(n, 4 - state.arcane_charge.current))
                state.gain(n, 'arcane_charge')
            else
                state.spend(-n, 'arcane_charge')
            end
            state.removeBuff('arcane_charge')
            if state.arcane_charge.current > 0 then
                state.applyBuff('arcane_charge', 3600, state.arcane_charge.current)
            end
        end

        local function arcanePowerManaCost(state, x)
            if state.buff.arcane_power.up then
                local pct = 0.30
                if state.talent.overpowered.enabled then
                    pct = 0.60
                end
                return x * (1.0 - pct)
            else
                return x
            end
        end

        local function arcaneChargeManaCost(state, pct, x)
            if state.arcane_charge then
                x = x + (x * pct * state.arcane_charge.current)
            end
            return arcanePowerManaCost(state, x)
        end

        addHook('reset_precast', function()
            state.arcane_charge.actual = UnitPower("player", SPELL_POWER_ARCANE_CHARGES) 

            gainArcaneCharge(state, 0)

            return x           
        end)
            
        addHook('reset_postcast', function(x)
            return x
        end)
            
        addHook('advance', function(dt)
            if state.buff.evocation.up then
                state.gain(state.mana.max / state.buff.evocation.duration * dt, 'mana')
            end

            return dt
        end)

        addAbility('arcane_barrage', {
            id = 44425,
            spend = 0.005,
            spend_type = 'mana',
            cast = 0,
            gcdType = 'spell',
            cooldown = 4.5
        })

        modifyAbility( 'arcane_barrage', 'cooldown', genericHasteMod )

        modifyAbility( 'arcane_barrage', 'spend', function(x) return arcanePowerManaCost(state, x) end)
        
        addHandler('arcane_barrage', function()
            gainArcaneCharge(state, -state.arcane_charge.current)
        end)

        addAbility('arcane_blast', {
            id = 30451,
            spend = 0.03,
            spend_type = 'mana',
            cast = 2.25,
            gcdType = 'spell',
            cooldown = 0
        })

        addHandler('arcane_blast', function()
            gainArcaneCharge(state, 1)
            state.removeStack('presence_of_mind')
        end)

        modifyAbility( 'arcane_blast', 'cast', function(x)
            if state.buff.presence_of_mind.up then
                x = 0
            end
            if state.talent.temporal_flux.enabled then
                x = x * (1.0 - 0.05 * state.arcane_charge.current)
            end
            return genericHasteMod(x)
        end)
        
        modifyAbility('arcane_blast', 'spend', function(x)
            return arcaneChargeManaCost(state, 1.25, x)
        end)

        addAbility('presence_of_mind', {
            id = 205025,
            spend = 0,
            spend_type = 'mana',
            cast = 0,
            gcdType = 'off',
            toggle = 'cooldowns',
            cooldown = 60
        })

        addHandler('presence_of_mind', function()
            applyBuff('presence_of_mind', 3600, 2)
        end)

        addAbility('arcane_explosion', {
            id = 1449,
            spend = 0.02,
            spend_type = 'mana',
            cast = 0,
            gcdType = 'spell',
            cooldown = 0
        })

        addHandler('arcane_explosion', function()
            gainArcaneCharge(state, 1)
        end)
        
        modifyAbility('arcane_explosion', 'spend', function(x)
            return arcaneChargeManaCost(state, 1.25, x)
        end)

        addAbility('arcane_missiles', {
            id = 5143,
            spend = 0,
            spend_type = 'mana',
            cast = 2,
            channeled = true,
            gcdType = 'spell',
            cooldown = 0,
            buff = 'arcane_missiles'
        })

        addHandler('arcane_missiles', function()
            gainArcaneCharge(state, 1)
            removeStack('arcane_missiles')
        end)
        
        addAbility('evocation', {
            id = 12051,
            spend = 0,
            spend_type = 'mana',
            cast = 6,
            channeled = true,
            gcdType = 'spell',
            cooldown = 90,
            toggle = 'cooldowns'
        })

        modifyAbility('evocation', 'cast', genericHasteMod)
        
        addHandler('evocation', function()
            applyBuff('evocation', 6 * state.haste)
        end)
        
        addAbility('arcane_power', {
            id = 12042,
            spend = 0,
            spend_type = 'mana',
            gcdType = 'off',
            cast = 0,
            cooldown = 90,
            toggle = 'cooldowns'
        })

        addHandler('arcane_power', function()
            applyBuff('arcane_power', 15)
        end)
 
        addAbility('mark_of_aluneth', {
            id = 224968,
            spend = 0,
            spend_type = 'mana',
            gcdType = 'spell',
            cast = 2,
            cooldown = 60,
            toggle = 'artifact'
        })

        modifyAbility('mark_of_aluneth', 'cast', genericHasteMod)
        
        addHandler('mark_of_aluneth', function()
            applyDebuff('target', 'mark_of_aluneth', 6)
        end)

        addAbility('arcane_familiar', {
            id = 205022,
            spend = 0,
            spend_type = 'mana',
            gcdType = 'spell',
            cast = 0,
            cooldown = 10,
            talent = 'arcane_familiar'
        })

        addHandler('arcane_familiar', function()
            applyBuff('arcane_familiar', 3600)
        end)

        addAbility('supernova', {
            id = 157980,
            spend = 0,
            spend_type = 'mana',
            gcdType = 'spell',
            cast = 0,
            cooldown = 25,
            talent = 'supernova'
        })

        addAbility('charged_up', {
            id = 205032,
            spend = 0,
            spend_type = 'mana',
            gcdType = 'off',
            cast = 0,
            cooldown = 40,
            talent = 'charged_up'
        })

        addHandler('charged_up', function()
            gainArcaneCharge(state, 4)
        end)

        addAbility('nether_tempest', {
            id = 114923,
            spend = 0.015,
            spend_type = 'mana',
            gcdType = 'off',
            cast = 0,
            cooldown = 40,
            talent = 'nether_tempest'
        })

        modifyAbility('nether_tempest', 'spend', function(x) return arcanePowerManaCost(state, x) end)

        addHandler('nether_tempest', function()
            applyDebuff('target', 'nether_tempest', 12)
        end)

        addAbility('arcane_orb', {
            id = 153626,
            spend = 0.01,
            spend_type = 'mana',
            gcdType = 'spell',
            cast = 0,
            cooldown = 20,
            talent = 'arcane_orb'
        })

        modifyAbility('arcane_orb', 'spend', function(x) return arcanePowerManaCost(state, x) end)

        addHandler('arcane_orb', function()
            gainArcaneCharge(state, 1)
        end)

        addAbility('counterspell', {
            id = 2139,
            spend = 0.02,
            spend_type = 'mana',
            gcdType = 'spell',
            cast = 0,
            cooldown = 30,
            toggle = 'interrupts'
        })

        addAbility( 'time_warp', {
            id = 80353,
            spend = 0.04,
            cast = 0,
            gcdType = 'off',
            cooldown = 300,
            toggle = 'cooldowns',
            passive = true
        })

        RegisterEvent( "UNIT_AURA", function(event, unit)
            --print("UNIT_AURA")
            if unit == 'player' then
                i = 0
                --while i <= 10 do
                    --print(i)
                    --local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID = UnitAura("player", i)
                    --print(UnitAura("player", i))
                    --print(spellID)
                    --i = i + 1
                --end
            end
        end)

        RegisterEvent( "UNIT_SPELLCAST_SUCCEEDED", function(event, unit, spell, _, _, spellID)
            --print("UNIT_SPELLCAST_SUCCEEDED")
            if unit == 'pet' or unit == 'player' then
                --local _,_, _, _, _, _, _, _, _, _, buffid = UnitBuff('player', "Icy Veins")
                --print(buffid)
                --print(spellID)

                if event == 'UNIT_SPELLCAST_SUCCEEDED' then
                    if not class.castExclusions[spellID] and class.abilities[spellID] then
                        local ability = class.abilities[ spellID ]

                        if ability then
                            if ability.gcdType ~= 'off' then
                                if event == 'UNIT_SPELLCAST_SUCCEEDED' and unit == 'player' then
                                    state.player.lastoffgcd = 'none'
                                    --state.player.lastgcd = ability.key
                                    --print('gcd update '..ability.key)
                                end
                            else
                                if unit == 'pet' and class.abilities[spellID].key == 'water_jet' then
                                    state.water_jet_starts = GetTime()
                                    state.water_jet_expires = GetTime() + 4 * state.haste
                                    state.player.lastoffgcd = ability.key
                                    state.player.lastoffgcdtime = GetTime()
                                end
                            end
                        end
                    end
                end
            end
            --print(state.player.lastgcd)
        end)
    end

    storeDefault( [[Frost Mage: default]], 'actionLists', 20170901.0, [[d8YycaGEHO2gLk2hLknBi3ur(MqANQYEj7gL9lvgMa)w0GvWWrvDqHYXOKZrPkluk1svulwqlxPEkyzukphQjkezQk0KvY0LCrPKlJCDuLnkfTzuHTle8ykMMQk(Uq1HP6VQkJwi05vv1jrfDBPQtRY9OuvFgvADsHNPQsllnkOfZdr0sHcaZ(4xceejIdNhQuBbZeICmPNTaROb2lWsaWNmNJUi71Lm9SZpcIzQlzynQNLgf0I5HiAP2caZ(4xcmzIwzCgwqSWdD1FbghH(CtDj7dD4saNS1z8k3cyjJe88EsGjt0kJZWcMje5yspBbwrTcearmJpLRJJJ2yfkyMWjVTHWAuLGPC98EsqZDIRUHjNl1OBWKjALXzyv6ztJcAX8qeTuBbGzF8lbUPUiqFeJ6pcBx7)JGN3tc8Kemt4K32qynQsqSWdD1FbghH(CtDj7dD4saNS1z8k3cyjJemtiYXKE2cSIAfiykxpVNe0CN4QByY5sn6g8KuP3VAuqlMhIOLAlam7JFjqWZ7jb4JXfrc4KToJx5walzKGzcroM0ZwGvuRabZeo5TnewJQeel8qx9xGXrOp3uxY(qhUemLRN3tcAUtC1nm5CPgDd4JXfrQuj459KGM7exDdtoxQr3WI4W5Hkvsa]] )

    storeDefault( [[Frost Mage: single]], 'actionLists', 20170901.0, [[d4ZXoaGAaO1RaBcqTlKSnQsQ9bGwhkHQzty(iLUjkv9yuDBQQ)Qs7KI2R0UrSFQsmkukggL63Q68uItR0GrjLgUI6GaYPqP0XOW5qjvTqfXsbQftLLd6HOekpL0YqQEorpdLktfitgftx4Ia0RqjvUm01vOnIsi2kkH0MvX2Pk(Sc67usMgvPyEaGXrvs(MI0OrjA8OKItIuCiQs11OkLUhkjReLGdl61usDnkOQassNazQRQz6JvzrGVm8cRL95qKf3lSw5sgkWQGrbMsSM0TnMA7vSZMYOQYH7CuTkq8yFISGQPrbvfqs6eitNuv5WDoQ6gphQZsgIq59p3d8LbLmsU1vbYTInSu1tc30jWQ0qywEgpSk5jyv2)mSOj0m9XQN)CHyYJQMPpw98NletEyufmkWuI1KUTXud7QklFRy)ZSNfHY6QcgL)iKJYcQrJAsVGQcijDcKPtQQC4ohvzq345qz1scekVCwUcb14CvZ0hRUC8sEpj9Qa5wXgwQUC8sEpzvAimlpJhwL8eSkyuGPeRjDBJPg2vbJYFeYrzb1Ornzxbvfqs6eitNuv5WDoQkX46EYOKkwes3(sFMx1m9XQh4paj3h6Oxfi3k2Ws1d8hGK7dDvPHWS8mEyvYtWQGrbMsSM0TnMAyxfmk)rihLfuJg10BkOQassNaz6KQMPpw9aFz4ErWUQGr5pc5OSGAufi3k2Ws1d8LH7frvAimlpJhwL8eSkyuGPeRjDBJPg2vvoCNJQZq0Z9pN7qodLvzGWlaIbWEFgIEUd5muguh4ld3lIg10BlOQassNaz6KQMPpw1Qmq4faXOkyu(JqoklOgvbYTInSu1Qmq4faXOkneMLNXdRsEcwfmkWuI1KUTXud7QkhUZr1zi65oKZqzqDGVmCViaMnUXZH6SKHiuE)Z9aFzqjJKBnaqhyVNWypjpOwULlltcdfssNazOLw345qDwYqekV)5EGVmOKrYTgayhWEpHXEsEqTClxwMegkKKobYWwVWca7gphkhmxY9arCasbXKhSYUrn96cQkGK0jqMoPQYH7Cu1nEoul3Y1dUej14mT0Yg()cM3kc1YTC9Glrsbr)CjsaM8yFcfmTC)Z9aFzqX)xW8wra2nEouWrcE)ZD(TcHumVve2w1m9XQW0Y9p3d8LrvGCRydlvHPL7FUh4lJQGr5pc5OSGAufmkWuI1KUTXud7Q0qywEgpSk5jyJAoTGQcijDcKPtQQC4ohvNHON7qodLbf6EI7fbT06gphkhmxY9arCasbXKhaZgVhPajb1qrY3uCLZR1ifssNazaEgIEUd5muguh4ld3lcAPnsbscQHIKVP4kNxRrkKKobYamBMHON7qodLb1qrY3uCLZR1iT0odrp3HCgkdQd8LH7fbWSXnEoulF5cusjJKBnaWk2rlT8)fmVveQd8hGK7dDuq0pxIeayLHnWsmUUNmkPIfH0TV0N5SLTSTQz6JvpIri0svGCRydlvpIri0svAimlpJhwL8eSkyuGPeRjDBJPg2vbJYFeYrzb1Orn9QcQkGK0jqMoPQz6JvDIDWGeYWUQkhUZrvEkJBS(iRSbo5X6bVib9xucqdG9KWnDcK68NletEaaSRQYY3k2)m7zrOStQcgfykXAs32yQHDvWO8hHCuwqnQsdHz5z8WQKNGvbYTInSu1j2bdsitJAY6lOQassNaz6KQ0qywEgpSk5jyvZ0hREGVmUU33vfmk)rihLfuJQa5wXgwQEGVmUU33vvz5Bf7FM9SiuwxvWOatjwt62gtnSRQC4ohvzq345qDGVmUU33rbr)CjsaGvjp2NqTC8kschPcy6bf3y9rG9KWnDcK68NletEaq7g10WUGQcijDcKPtQQC4ohvzJNeUPtGuN)CHyYdaAdm)FbZBfHA5wUEWLiPGOFUejanSzlT06jHB6ei15pxiM8aGSIEvZ0hRUC8kschPxfi3k2Ws1LJxrs4yvAimlpJhwL8eSkyuGPeRjDBJPg2vbJYFeYrzb1OrnnmkOQassNaz6KQkhUZr1QMPpwfDpX9IOkqUvSHLQO7jUxevPHWS8mEyvYtWQGrbMsSM0TnMAyxfmk)rihLfuJg10GEbvfqs6eitNuv5WDoQw1m9XQh4paj3h6QcKBfByP6b(dqY9HUQ0qywEgpSk5jyvWOatjwt62gtnSRcgL)iKJYcQrJAAWUcQkGK0jqMoPQYH7CuTQz6JvxoEjVNSkqUvSHLQlhVK3twLgcZYZ4HvjpbRcgfykXAs32yQHDvWO8hHCuwqnAutdVPGQcijDcKPtQAM(yv(7JXvgp0VkneMLNXdRsEcwfi3k2Wsv(7JXvgp0Vkyu(JqoklOgvbJcmLynPBBm1WUQYH7CuTrnn82cQkGK0jqMoPQz6JvDIDWGeYqVkneMLNXdRsEcwfi3k2WsvNyhmiHmvbJYFeYrzb1OkyuGPeRjDBJPg2vvoCNJQjpwp4fjO)IsasNwAtESEWlsq)fLa0ayVZMifijOgks(MIRCETgPqs6eidWrkqsqjNfBelz4D5ifssNazylT0Yg345qnijeuoEbWFesqluYi5wZkVfy345qnijeuoEbWFesqluq0pxIeG8ug3y9r22OMgEDbvfqs6eitNuv5WDoQ6gphQd8hGKRFkLuq0pxIeGiRb5JbEJ1hzDjp2NqnuK8nfx58AnsHSgKpg4nwFK1L8yFc1qrY3uCLZR1ivatpO4gRpcSB8COCWCj3deXbifetEWkBGJuGKGAOi5BkUY51AKcjPtGmEHfQAM(y1d8LH7fb9Qa5wXgwQEGVmCViQsdHz5z8WQKNGvbJcmLynPBBm1WUkyu(JqoklOgnQPX0cQkGK0jqMoPQYH7CuL)VG5TIqDG)aKCFOJcI(5sKa0WMwA9UeJR7jJsQyriD7l9zEvZ0hRouK8nfx58Anwvz5Bf7FM9Siu2jvbYTInSuDOi5BkUY51ASkyu(JqoklOgvPHWS8mEyvYtWQGrbMsSM0TnMAy3OMgEvbvfqs6eitNuv5WDoQwfi3k2Ws1d8LH7frvAimlpJhwL8eSQz6JvpWxgUxevbJcmLynPBBm1WUkyu(JqoklOgvzXyjYTM9Vh0hjrNuvz5Bf7FM9Siu2jnQPbRVGQcijDcKPtQQC4ohv5PmUX6JSYgy)3Zsg6fwWlSqvZ0hR6e7GbjKPkqUvSHLQoXoyqczQsdHz5z8WQKNGvbJYFeYrzb1OkyuGPeRjDBJPg2nQjD7cQkGK0jqMoPQz6JvxoEfjHJvbJYFeYrzb1OkqUvSHLQlhVIKWXQ0qywEgpSk5jyvWOatjwt62gtnSRQC4ohv9FplzOxyHgnQQZiFtXoiJ9j10R9MgTa]] )

    storeDefault( [[Frost Mage: cooldowns]], 'actionLists', 20170901.0, [[dyd4eaGEjr1MieAxQuBtsP2NKcZwO5tiDtjbDBszNGSxQDRy)ssmms8BLgSKunCv0bjvogkDojLSqvslvclgulxvRtsGNcTmsYZr1JjAQcmzumDPUiPQxjjkxg56cAJsI4WaBMKA7Qe)LGtlAAss67QqFJq9zvWOLu08ieDsjvRssOUgHGZlrptsiJtsKETKu2SoWO(bahjgdBecOrgRKF5DvQEfcoqvqvQUC3iZEC4glOib4KHuPWkwPwkS3Sgr5NNTrJ6KDUd3bgI1bg1pa4iX4Rgr5NNTr5UrM94CNYsHluo87N0a5WfPeWBHo1irfvwtWFG4cQFGSZDaXAWExlruUBKzpo3PSu4cLd)(jnqo8AWQiQOWHQvFNYsHluo87WtrfTb)bQV7uJe6vGjPkteePSMG)aXfu)azN7aIvmRIriGgz8dhsyvlCUhP3Oo4mMDPXpCiHvTW5EKEJfeFdFjXDGBJfuKaCYqQuyfZQyS(WKsqVVXzhYTHu5aJ6haCKymSru(5zBuUBKzpo3PSu4cLd)(jnqoCrYAecOrgp3o3XOo4mMDPXZTZDmwFysjO334SdzSGIeGtgsLcRywfJfeFdFjXDGB3gQICGr9daosm(Qru(5zBeouT67uwkCHYHFZShhJqanYyklfUq5WnQdoJzxAmLLcxOC4gRpmPe07BC2HmwqrcWjdPsHvmRIXcIVHVK4oWTBdvvhyu)aGJeJVAecOrg1Y)3xi1ahiJ1hMuc69no7qg1bNXSlnQL)VVqQboqgli(g(sI7a3glOib4KHuPWkMvXik)8Sn62qIGdmQFaWrIXxnIYppBJgHaAKXqojKnPXnQdoJzxAmKtcztACJfeFdFjXDGBJfuKaCYqQuyfZQyS(WKsqVVXzhYTHQTdmQFaWrIXxnIYppBJgHaAKr44UmcQd)sJ6GZy2LgHJ7YiOo8lnwq8n8Le3bUnwqrcWjdPsHvmRIX6dtkb9(gNDi3gsSdmQFaWrIXxnIYppBJgHaAKry650xTCoyuhCgZU0im9C6Rwohmwq8n8Le3bUnwqrcWjdPsHvmRIX6dtkb9(gNDi3gQsDGr9daosm(Qru(5zB0ieqJmcEjyiHE)NM2Oo4mMDPrWlbdj07)00gli(g(sI7a3glOib4KHuPWkMvXy9HjLGEFJZoKB3gXtsMGyw5Go3Xq1UQUTb]] )

    storeDefault( [[Frost Mage: aoe]], 'actionLists', 20170901.0, [[dOtPgaGAsqA9qOnjIAxKQxRiAFKqA2enFrKBQiKBRq7es7LA3OSFsunksOAyK0VvzDKO0Gjr0WvuhubDksOCmO6CKOyHIslvuTyHwUspMWtrwgP0ZfCyPMQinzuz6sUOO48KIldUoeTrsaDAvTzOSDi4VOQ5Pi4ZksFNeO(MimnsKmAsK6zKqCsf4qKG6Akc19ibXkjbyBKimosGSXDQPmSokbohnH2JGjf4EHs5k5e1tbLv5kzFGPCqcDamQwv8eQkJkUoUjsS)CzY0qr9hl4uJI7utzyDucCoRjsS)CzYeApcMW2drGXFB00W4l)sJjS9qey83gnLdHd5kGGtDzkhKqhaJQvfpbUQPbmUx01TMyhdCzuTo1ugwhLaNZAIe7pxMmH2JGPO8reXE5mnm(YV0ykkFerSxot5q4qUci4uxMYbj0bWOAvXtGRAAaJ7fDDRj2XaxgvrCQPmSokboN1ej2FUmzcThbtIBek(qD7OPHXx(LgtIBek(qD7OPCiCixbeCQlt5Ge6ayuTQ4jWvnnGX9IUU1e7yGlJQuo1ugwhLaNZAIe7pxMmH2JGPxa8SdH20W4l)sJPxa8SdH2uoeoKRaco1LPCqcDamQwv8e4QMgW4Erx3AIDmWLrNyNAkdRJsGZznrI9NltZlGa)ubNoUo2EHkEYkzfpIedth7ztHnWFy8y7fk9q1IjNG2Kv4ERhRfL(l0WR0nJthyDucCjLuejgMo2ZMcBG)W4X2lu6HQftobfjzfU36XArP)cn8kDZ40bwhLaNIPCfqYrKyy6XTFgp2caIG(cTOuiQMYbj0bWOAvXtGRAAaJ7fDDRj2XatO9iysb3fS8kuOmLdHd5kGGtD5YOkHtnLH1rjW5SMiX(ZLP5fqGFQGthxhIhlEYkPKu85fqGFQGthxFQSfFl5dZ)KqsjnVac8tfC646y7fQ4jlfl5ismm942pJhBbarqFHwuMq7rWeMe5UAmnm(YV0yctICxnMYHWHCfqWPUmLdsOdGr1QINax10ag3l66wtSJbUmAcNAkdRJsGZznrI9NltCqejgMo2EHIpEJr9fg7NfMqlQ)y6Va4Lnta612ias(6hHKrO3VJsqh7W4xOfLIQAcThbty7fk(4ngnnm(YV0ycBVqXhVXOPCiCixbeCQlt5Ge6ayuTQ4jWvnnGX9IUU1e7yGlJQGCQPmSokboN1ej2FUmHqVFhLGo2HXVqlkfv1eApcMEbWlBMamnm(YV0y6faVSzcWuoeoKRaco1LPCqcDamQwv8e4QMgW4Erx3AIDmWLrvgNAkdRJsGZznrI9NltMq7rWeepw8KLPHXx(Lgtq8yXtwMYHWHCfqWPUmLdsOdGr1QINax10ag3l66wtSJbUmkUQtnLH1rjW5SMiX(ZLjtO9iyAQSfFl5dZ)KGPHXx(LgttLT4BjFy(NemLdHd5kGGtDzkhKqhaJQvfpbUQPbmUx01TMyhdCzuCCNAkdRJsGZznrI9NltMq7rWe2EHkEYY0W4l)sJjS9cv8KLPCiCixbeCQlt5Ge6ayuTQ4jWvnnGX9IUU1e7yGlxMOzq8T8rSR)ygvjukx2a]] )

    storeDefault( [[Frost Mage: Primary]], 'displays', 20170901.0, [[d8J1oaGAucwpvLnbi7cP2gvPY(ue9yuDyrZMW8rIUjkv9CI(gaopLyNu0EL2nI9Js0OqP0FvPXHsrDALEnLudMQegUI6Ga0PqPYXOW5OkflKQQLculMklh0drPqEkPLHKwhkfyIOuOMkqMmkMUWfbuVcLICzORRqBeLcARuLO2Sk2ovX0Okv9DkjFwrAEkcEgvjDBfmAusgpvjYjrchsrORrvkDpusTsucnmk1Vv11OGQcmjDcKPUQkhUZr1QSX4jhfr9xfmkWuI1KQTba2EJTrvDg5BkwFzSpPMEN3xfqESprwq10OGQcmjDcKP(RQC4ohvDJNd9zjtrO8(N7b(YGwgj36Qa6wXgwQ6jHB6eyvkimlpJhwL8eSk7FgVCcnZbS65pxiM8OQzoGvp)5cXKhgvbJcmLynPABaGHDvLvVvS)z2ZIqzDvbJYFeYrzb1OrnPwqvbMKobYu)vvoCNJQmOB8COTAjbcLxoRwHGECUkfeMLNXdRsEcwfq3k2Ws1LJxY7jRcgL)iKJYcQrvWOatjwtQ2gayyx1mhWQlhVK3tsTrn9Abvfys6eit9xv5WDoQkX46EYOKowes1(sDMxLccZYZ4HvjpbRcOBfByP6b((qY9HUQGr5pc5OSGAufmkWuI1KQTbag2vnZbS6b((qY9HoQnQP3xqvbMKobYu)vnZbS6b(YW9IWRvvoCNJQZq0Z9pN7uodTvzGWllGbqtCgIEUt5m0g0h4ld3lIQa6wXgwQEGVmCViQsbHz5z8WQKNGvbJcmLynPABaGHDvWO8hHCuwqnAutVTGQcmjDcKP(RAMdyvRYaHxwaJQkhUZr1zi65oLZqBqFGVmCViaITUXZH(SKPiuE)Z9aFzqlJKB9eOc0etySNKh0l3YLvjHHgjPtGmusPB8COplzkcL3)CpWxg0Yi5wpbVc0etySNKh0l3YLvjHHgjPtGmSJLSiqUXZH2bZLCpqe9H0qm5bRTRcOBfByPQvzGWllGrvkimlpJhwL8eSkyuGPeRjvBdamSRcgL)iKJYcQrJA6DfuvGjPtGm1FvLd35OQB8COxULRhCjs6XzkPKT8)fmVve6LB56bxIKgId5sKtM8yFcnmTC)Z9aFzqZ)xW8wraYnEo0WrcE)ZD(TcH0mVve2vfmk)rihLfuJQa6wXgwQctl3)CpWxgvPGWS8mEyvYtWQGrbMsSMuTnaWWUQzoGvHPL7FUh4lJg1eGcQkWK0jqM6VQYH7CuDgIEUt5m0g0O7jUxeusPB8CODWCj3derFinetEWsVysw6f2aX2jgPajb9urY3uCLZR1inssNazaAgIEUt5m0g0h4ld3lckPmsbsc6PIKVP4kNxRrAKKobYaeBNHON7uodTb9urY3uCLZR1iLuodrp3PCgAd6d8LH7fbqS1nEo0lF5cuslJKB9eyTxPKs()cM3kc9b((qY9HoAioKlrobwBydKeJR7jJs6yriv7l1zo7yh7QsbHz5z8WQKNGvb0TInSu9igHqlvbJYFeYrzb1OkyuGPeRjvBdamSRAMdy1JyecT0OMS5cQkWK0jqM6VkyuGPeRjvBdamSRQC4ohv5PmUXoGS2gOKhRh8IeCyr5Kga5jHB6ei95pxiM8ycETkyu(JqoklOgvb0TInSu1jwF(sitvkimlpJhwL8eSQYQ3k2)m7zrOS(RAMdyvNy95lHmETrn9McQkWK0jqM6VQzoGvpWxgx3p4QQC4ohvzq345qFGVmUUFWrdXHCjYjW6Kh7tOxoEfjHJ0bm9GIBSdiqEs4MobsF(ZfIjpM0UkGUvSHLQh4lJR7hCvbJcmLynPABaGHDvWO8hHCuwqnQsbHz5z8WQKNGvvw9wX(NzplcL11OMg2fuvGjPtGm1FvLd35OkB9KWnDcK(8NletEmPnq8)fmVve6LB56bxIKgId5sKtAyZokP0tc30jq6ZFUqm5XKSMAvkimlpJhwL8eSkGUvSHLQlhVIKWXQGr5pc5OSGAufmkWuI1KQTbag2vnZbS6YXRijCKAJAAyuqvbMKobYu)vvoCNJQvPGWS8mEyvYtWQa6wXgwQIUN4Erufmk)rihLfuJQGrbMsSMuTnaWWUQzoGvr3tCViAutdQfuvGjPtGm1FvLd35OAvkimlpJhwL8eSkGUvSHLQh47dj3h6QcgL)iKJYcQrvWOatjwtQ2gayyx1mhWQh47dj3h6AutdVwqvbMKobYu)vvoCNJQvPGWS8mEyvYtWQa6wXgwQUC8sEpzvWO8hHCuwqnQcgfykXAs12aad7QM5awD54L8EYg10W7lOQatsNazQ)QM5awL)dyCLXdhQQC4ohvRcOBfByPk)hW4kJhoufmk)rihLfuJQGrbMsSMuTnaWWUkfeMLNXdRsEc2OMgEBbvfys6eit9x1mhWQoX6ZxczOwv5WDoQM8y9GxKGdlkNKkLuM8y9GxKGdlkN0aOjY2ifijONks(MIRCETgPrs6eidqrkqsqlNfBelz6D5inssNazyhLuYw345q7ljeuoEzHFesql0Yi5wZAVfi345q7ljeuoEzHFesql0qCixICsEkJBSdi7QcOBfByPQtS(8LqMQGr5pc5OSGAufmkWuI1KQTbag2vPGWS8mEyvYtWg10W7kOQatsNazQ)QkhUZrv345qFGVpKChsPKgId5sKtIEjKpg4n2bKnL8yFc9urY3uCLZR1in6Lq(yG3yhq2uYJ9j0tfjFtXvoVwJ0bm9GIBSdiqUXZH2bZLCpqe9H0qm5bRTbksbsc6PIKVP4kNxRrAKKobYWswSkfeMLNXdRsEcwfq3k2Ws1d8LH7frvWO8hHCuwqnQcgfykXAs12aad7QM5aw9aFz4ErqTrnnaOGQcmjDcKP(RcOBfByP6urY3uCLZR1yvZCaRovK8nfx58Anwfmk)rihLfuJQGrbMsSMuTnaWWUkfeMLNXdRsEcwvz1Bf7FM9Siuw)vvoCNJQ8)fmVve6d89HK7dD0qCixICsdBkPCIsmUUNmkPJfHuTVuN5nQPbBUGQcmjDcKP(RQC4ohvRcOBfByP6b(YW9IOkfeMLNXdRsEcw1mhWQh4ld3lIQGrbMsSMuTnaWWUkyu(JqoklOgvvw9wX(NzplcL1Fv2iwHCRz)7bhqsu)nQPH3uqvbMKobYu)vvoCNJQ8ug3yhqwBd0W7zjtzjlYswSkGUvSHLQoX6ZxczQcgfykXAs12aad7QuqywEgpSk5jyvWO8hHCuwqnQAMdyvNy95lHmnQjv7cQkWK0jqM6VQzoGvxoEfjHJvvoCNJQdVNLmLLSyvaDRydlvxoEfjHJvPGWS8mEyvYtWQGrbMsSMuTnaWWUkyu(JqoklOgnAu1mhWQSHWxgS0lyFofzdyPxixYub2Of]] )

    ns.initializeClassModule = MageInit
end
