
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

if select(2, UnitClass('player')) == 'PRIEST' then
    local function PriestInit()
        Hekili:Print("Initializing Priest Class Module.")

        setClass('PRIEST')
        addResource('insanity', SPELL_POWER_INSANITY)
        addResource('mana', SPELL_POWER_MANA)

        state.insanity.regenerates = false

        setPotion( 'prolonged_power' )

        -- Talents
        addTalent('twist_of_fate', 109142)
        addTalent('fortress_of_the_mind', 193195)
        addTalent('shadow_word_void', 205351)
        addTalent('mania', 193173)
        addTalent('body_and_soul', 64129)
        addTalent('masochism', 193063)
        addTalent('mind_bomb', 205369)
        addTalent('psychic_voice', 196704)
        addTalent('dominant_mind', 205367)
        addTalent('lingering_insanity', 199849)
        addTalent('reaper_of_souls', 199853)
        addTalent('void_ray', 205371)
        addTalent('sanlayn', 199855)
        addTalent('auspicious_spirits', 155271)
        addTalent('shadowy_insight', 162452)
        addTalent('power_infusion', 10060)
        addTalent('misery', 238558)
        addTalent('mindbender', 123040)
        addTalent('legacy_of_the_void', 193225)
        addTalent('shadow_crash', 60833)
        addTalent('surrender_to_madness', 193223)

        addAura('surrender_to_madness', 193223, 'max_stack', 1)
        addAura('voidform', 194249, 'duration', 99999, 'max_stack', 100)
        addAura('shadowform', 232698, 'duration', 99999)
        addAura('lingering_insanity', 197937, 'duration', 99999, 'max_stack', 999)
        addAura('power_infusion', 10060, 'duration', 20, 'max_stack', 1)
        addAura('shadow_word_pain', 589, 'duration', 18, 'max_stack', 1)
        addAura('vampiric_touch', 34914, 'duration', 24, 'max_stack', 1)
        addAura( 'insanity_drain_stacks', 0, 'duration', 9999999)
        addAura('void_torrent', 205065, 'duration', 4)

        addGearSet('tier19', 138313, 138319, 138322, 138310, 138316, 138370)
        addGearSet('tier20', 147163, 147164, 147165, 147166, 147167, 147168)
        addGearSet('mangazas_madness', 132864)


        --addTalent('shadowy_inspiration', 196269)


        --addAura('fingers_of_frost', 44544, 'duration', 15, 'max_stack', 3)
        
        --addGearSet('zannesu_journey', 133970)

        --addGearSet( 'tier19', 138309, 138312, 138315, 138318, 138321, 138365 )
        
        --registerCustomVariable('water_jet_expires', 0 )
        
        -- Abilities
        addAbility('shadowfiend', {
            id = 34433,
            spend_type = 'mana',
            cast = 0,
            toggle = 'cooldowns',
            gcdType = 'off',
            cooldown = 180,
            usable = function() return not state.talent.mindbender.enabled end
        })

        addAbility('mindbender', {
            id = 200174,
            spend_type = 'mana',
            cast = 0,
            gcdType = 'off',
            cooldown = 60,
            talent = 'mindbender'
        })

        addAbility('shadow_word_pain', {
            id = 589,
            spend_type = 'mana',
            cast = 0,
            gcdType = 'spell',
            cooldown = 0
        })

        addAbility('vampiric_touch', {
            id = 34914,
            spend_type = 'mana',
            cast = 1.5,
            gcdType = 'spell',
            cooldown = 0
        })

        addAbility('shadowform', {
            id = 232698,
            spend_type = 'mana',
            cast = 0,
            gcdType = 'spell',
            cooldown = 0,
            usable = function()
                return not state.buff.voidform.up
            end
        })

        addAbility('void_bolt', {
            id = 228266,
            spend_type = 'mana',
            cast = 0,
            gcdType = 'spell',
            cooldown = 4.5,
            usable = function()
                return state.buff.voidform.up
            end
        })

        addAbility('void_torrent', {
            id = 205065,
            spend_type = 'mana',
            cast = 0,
            gcdType = 'spell',
            channeled = true,
            cast = 4,
            cooldown = 60,
            usable = function()
                return state.buff.voidform.up
            end
        })

        addAbility('power_infusion', {
            id = 10060,
            spend_type = 'mana',
            spend = 0,
            cast = 0,
            gcdType = 'off',
            toggle = 'cooldowns',
            cooldown = 120
        })

        addAbility('mind_flay', {
            id = 15407,
            spend_type = 'mana',
            cast = 3,
            gcdType = 'spell',
            cooldown = 0,
            channeled = true,
            break_channel = true,
        })

        addAbility('mind_blast', {
            id = 8092,
            spend_type = 'mana',
            cast = 1.5,
            gcdType = 'spell',
            cooldown = 8
        })

        addAbility('surrender_to_madness', {
            id = 193223,
            toggle = 'cooldowns',
            gcdType = 'off',
            cooldown = 600
        })

        addAbility('dispel_magic', {
            id = 528,
            cast = 0,
            cooldown = 0,
            spend_type = 'mana',
            spend = 6400,
            gcdType = 'spell'
        })

        addAbility('shadow_word_void', {
            id = 205351,
            cast = 1.5,
            charges = 3,
            recharge = 20,
            spend = 0,
            spend_type = 'mana',
            gcdType = 'spell'
        })

        addAbility('shadow_word_death', {
            id = 32379,
            cast = 0,
            charges = 2,
            recharge = 9,
            spend = 0,
            spend_type = 'mana',
            gcdType = 'spell',
            usable = function()
                if state.talent.reaper_of_souls.enabled then
                    return state.target.health_pct <= 35
                else
                    return state.target.health_pct <= 20
                end
            end
        })

        addAbility('void_eruption', {
            id = 228260,
            cast = 2,
            cooldown = 1.5,
            usable = function()
                if state.buff.voidform.up then
                    return false
                end
                local req_insanity = 100
                if state.talent.legacy_of_the_void.enabled then
                    req_insanity = 65
                end
                return (state.insanity.current >= req_insanity)
            end
        })

        addAbility('shadow_crash', {
            id = 205385,
            cast = 0,
            gcdType = 'spell',
            spend_type = 'mana',
            spend = 0,
            cooldown = 30,
        })

        addHook('gain', function(amt, resource)
            local mod = 0.0
            
            if resource == 'insanity' then
                if state.buff.power_infusion.up then
                    mod = mod + 0.25
                end

                if state.buff.surrender_to_madness.up then
                    mod = mod + 1.0
                end

                --state.insanity.actual = max(0, min(state.insanity.max, state.insanity.actual + (mod * amt)))
            end
        end)

        modifyAbility("vampiric_touch", "cast", function(x)
            return x * spell_haste
        end)
        
        modifyAbility("mind_flay", "cast", function(x)
            return x * spell_haste
        end)
        
        modifyAbility("shadow_word_void", "cast", function(x)
            return x * spell_haste
        end)
        
        modifyAbility("mind_blast", "cast", function(x)
            return x * spell_haste
        end)

        modifyAbility("mind_blast", "cooldown", function(x)
            return x * spell_haste
        end)
        
        modifyAbility("void_bolt", "cooldown", function(x)
            return x * spell_haste
        end)
        
        registerCustomVariable('mind_flay_starts', 0)
        registerCustomVariable('mind_flay_ends', 0)
        registerCustomVariable('shadowform_toggle', 0)
        registerCustomVariable('mindbender_starts', 0)
        registerCustomVariable('mindbender_expires', 0)
        
        addHandler('power_infusion', function()
            applyBuff('power_infusion', 20)
        end)

        addHandler('void_torrent', function()
            applyBuff('void_torrent', 4)
        end)

        addHandler('shadowform', function()
            if state.shadowform_toggle == 0 then
                if not state.buff.voidform.up then
                    applyBuff('shadowform')
                end
                state.shadowform_toggle = 1
            else
                if not state.buff.voidform.up then
                    removeBuff('shadowform')
                end
                state.shadowform_toggle = 0
            end
        end)

        addHandler('shadow_crash', function()
            gain(15, 'insanity')
        end)

        addHandler('void_bolt', function()
            gain(15, 'insanity')
        end)

        addHandler('shadow_word_void', function()
            state.gain(16, 'insanity')
        end)

        addHandler('mind_flay', function()
            state.mind_flay_starts = state.now + state.offset
            state.mind_flay_ends = state.mind_flay_starts + class.abilities.mind_flay.cast
        end)

        addHandler('shadow_word_pain', function()
            state.gain(4, 'insanity')

            applyDebuff('target', 'shadow_word_pain', 18)
        end)

        addHandler('vampiric_touch', function()
            state.gain(6, 'insanity')

            applyDebuff('target', 'vampiric_touch', 24)

            if state.talent.misery.enabled then
                applyDebuff('target', 'shadow_word_pain', 18)
            end
        end)

        addHandler('mind_blast', function()
            local gain = 18
            
            if state.talent.fortress_of_the_mind.enabled then
                gain = gain * 1.20
            end

            state.gain(gain, 'insanity')
        end)

        addHandler('shadow_word_death', function()
            local gain = 15
            if state.talent.reaper_of_souls.enabled then
                gain = 30
            end
            state.gain(gain, 'insanity')
        end)

        addHandler('surrender_to_madness', function()
            applyBuff('surrender_to_madness', 180)
        end)

        addHandler('void_eruption', function()
            applyBuff('voidform', 99999, 1, 1)
            applyBuff('insanity_drain_stacks', 99999, 1, 1)
            removeBuff('shadowform')
        end)

        --[[
        addAbility('frostbolt', {
            id = 116,
            spend = 0,
            spend_type = 'mana',
            cast = 2,
            gcdType = 'spell',
            cooldown = 0,
            known = function() return spec.frost end
        })

        modifyAbility('ebonbolt', 'cast', function (x)
            return x * haste
        end)

        addHandler('ice_lance', function()
            if state.buff.fingers_of_frost.up then
                removeStack('fingers_of_frost', 1)
            end
            
            removeBuff('icicles')
        end)

        --]]

        --RegisterEvent("UNIT_SPELLCAST_START", function() print(state.palyer.lastgcd) end)

        RegisterEvent( "UNIT_SPELLCAST_SUCCEEDED", function(event, unit, spell, _, _, spellID)
            print(spellID)
            local _,_, _, _, _, _, _, _, _, _, buffid = UnitBuff('player', "Power Infusion")
            local _,_, _, a, _, _, _, _, _, _, buffid2, _, _, _, _, _, b = UnitBuff('player', "Void Torrent")


            local _,_, _, _, _, _, _, _, _, _, debuffid = UnitDebuff('target', "Shadow Word: Pain")
            local _,_, _, _, _, _, _, _, _, _, debuffid2 = UnitDebuff('target', "Vampiric Touch")

            print("Buffs")
            print(buffid2)
            print(a)
            print(b)
        end)
            
        addHook( 'reset_precast', function (t)
            Hekili:Debug('reset_precast')

            -- Blizzard bug workaround?
            local a, b = GetPowerRegen()

            state.insanity.active_regen = 0.0
            state.insanity.inactive_regen = 0.0
            state.shadowform_toggle = GetShapeshiftForm()
            
            local _,_, _, stacks = UnitBuff('player', "Voidform")

            if stacks ~= nil then
                state.applyBuff('insanity_drain_stacks', 9999999, stacks, stacks)
            else
                state.removeBuff('insanity_drain_stacks')
            end

            Hekili:Debug('Regen: %f %f %d', a, b, state.shapeshift_toggle)

            return t
        end)

        addHook('advance', function(dt)                
            if ns.debug then
                local a, b = GetPowerRegen()
                Hekili:Debug('Regen: %f %f %d', a, b, state.shapeshift_toggle)
            end 

            local haste_mod = 0.0

            -- Increase voidform stacks
            if state.buff.voidform.up then
                state.addStack('voidform', 99999, dt)
                state.applyBuff('insanity_drain_stacks', 99999, state.buff.insanity_drain_stacks.count + dt, state.buff.insanity_drain_stacks.value + dt)

                -- Lose insanity during Voidform
                local drain_multiplier = 1.0
                local base_drain_per_sec = -3000 / -500
                local stack_drain_multiplier = 2.0 / 3.0
                local stacks = floor(state.buff.insanity_drain_stacks.value)
                local drain = drain_multiplier * (base_drain_per_sec + (stacks - 1) * stack_drain_multiplier)

                haste_mod = haste_mod + dt
                --state.insanity.active_regen = -drain
                --state.insanity.inactive_regen = -drain

                state.insanity.active_regen = 0.0
                state.insanity.inactive_regen = 0.0
                local loss_dt = dt
                if state.buff.void_torrent.up then
                    loss_dt = max(0.0, dt - state.buff.void_torrent.remains)
                end
                local loss = min(state.insanity.current, drain * loss_dt)
                state.spend(loss, 'insanity')
            end

            if state.buff.voidform.up and state.insanity.current <= 0 then
                Hekili:Debug('Removing voidform')
                local haste_stacks = floor(state.buff.voidform.count)
                if state.talent.lingering_insanity.enabled then
                    state.applyBuff('lingering_insanity', 60, haste_stacks)
                end
                state.removeBuff('voidform')
                state.removeBuff('insanity_drain_stacks')
                if state.shadowform_toggle == 1 then
                    state.applyBuff('shadowform')
                end
            end

            if state.buff.lingering_insanity.up then
                haste_mod = haste_mod + floor(state.buff.lingering_insanity.count)

                state.removeStack('lingering_insanity', 2 * dt)
            end

            state.stat.mod_haste_pct = state.stat.mod_haste_pct + haste_mod

            -- Gain insanity from mind flay
            local mind_flay_duration = (state.mind_flay_ends - state.mind_flay_starts)
            if mind_flay_duration > 0.0 then
                local remains = state.mind_flay_ends - state.now
                local insanity_per_sec = 14.0 / mind_flay_duration
                local ticks = max(0, min(dt, remains))
                local gain = insanity_per_sec * ticks
                
                if ns.debug then
                    Hekili:Debug('Remains: %f IPS: %f Gain: %f Dt: %f Now: %f ', remains, insanity_per_sec, gain, dt, state.now)
                end

                if state.talent.fortress_of_the_mind.enabled then
                    gain = gain * 1.20
                end

                if gain > 0 then
                    state.gain(gain, 'insanity')
                end

                
                Hekili:Debug('Gain: %f', gain)

            end

            Hekili:Debug('Regen: %f %f', state.insanity.active_regen, state.insanity.inactive_regen)

            if state.buff.insanity_drain_stacks.up then
                Hekili:Debug('Insanity drain stacks: %f', state.buff.insanity_drain_stacks.value)
            else
                Hekili:Debug("No insanity drain")
            end

            return dt
        end)
    end

    --storeDefault( [[Frost Mage: aoe]], 'actionLists', 20170901.0, [[dOtPgaGAsqA9qOnjIAxKQxRiAFKqA2enFrKBQiKBRq7es7LA3OSFsunksOAyK0VvzDKO0Gjr0WvuhubDksOCmO6CKOyHIslvuTyHwUspMWtrwgP0ZfCyPMQinzuz6sUOO48KIldUoeTrsaDAvTzOSDi4VOQ5Pi4ZksFNeO(MimnsKmAsK6zKqCsf4qKG6Akc19ibXkjbyBKimosGSXDQPmSokbohnH2JGjf4EHs5k5e1tbLv5kzFGPCqcDamQwv8eQkJkUoUjsS)CzY0qr9hl4uJI7utzyDucCoRjsS)CzYeApcMW2drGXFB00W4l)sJjS9qey83gnLdHd5kGGtDzkhKqhaJQvfpbUQPbmUx01TMyhdCzuTo1ugwhLaNZAIe7pxMmH2JGPO8reXE5mnm(YV0ykkFerSxot5q4qUci4uxMYbj0bWOAvXtGRAAaJ7fDDRj2XaxgvrCQPmSokboN1ej2FUmzcThbtIBek(qD7OPHXx(LgtIBek(qD7OPCiCixbeCQlt5Ge6ayuTQ4jWvnnGX9IUU1e7yGlJQuo1ugwhLaNZAIe7pxMmH2JGPxa8SdH20W4l)sJPxa8SdH2uoeoKRaco1LPCqcDamQwv8e4QMgW4Erx3AIDmWLrNyNAkdRJsGZznrI9NltZlGa)ubNoUo2EHkEYkzfpIedth7ztHnWFy8y7fk9q1IjNG2Kv4ERhRfL(l0WR0nJthyDucCjLuejgMo2ZMcBG)W4X2lu6HQftobfjzfU36XArP)cn8kDZ40bwhLaNIPCfqYrKyy6XTFgp2caIG(cTOuiQMYbj0bWOAvXtGRAAaJ7fDDRj2XatO9iysb3fS8kuOmLdHd5kGGtD5YOkHtnLH1rjW5SMiX(ZLP5fqGFQGthxhIhlEYkPKu85fqGFQGthxFQSfFl5dZ)KqsjnVac8tfC646y7fQ4jlfl5ismm942pJhBbarqFHwuMq7rWeMe5UAmnm(YV0yctICxnMYHWHCfqWPUmLdsOdGr1QINax10ag3l66wtSJbUmAcNAkdRJsGZznrI9NltCqejgMo2EHIpEJr9fg7NfMqlQ)y6Va4Lnta612ias(6hHKrO3VJsqh7W4xOfLIQAcThbty7fk(4ngnnm(YV0ycBVqXhVXOPCiCixbeCQlt5Ge6ayuTQ4jWvnnGX9IUU1e7yGlJQGCQPmSokboN1ej2FUmHqVFhLGo2HXVqlkfv1eApcMEbWlBMamnm(YV0y6faVSzcWuoeoKRaco1LPCqcDamQwv8e4QMgW4Erx3AIDmWLrvgNAkdRJsGZznrI9NltMq7rWeepw8KLPHXx(Lgtq8yXtwMYHWHCfqWPUmLdsOdGr1QINax10ag3l66wtSJbUmkUQtnLH1rjW5SMiX(ZLjtO9iyAQSfFl5dZ)KGPHXx(LgttLT4BjFy(NemLdHd5kGGtDzkhKqhaJQvfpbUQPbmUx01TMyhdCzuCCNAkdRJsGZznrI9NltMq7rWe2EHkEYY0W4l)sJjS9cv8KLPCiCixbeCQlt5Ge6ayuTQ4jWvnnGX9IUU1e7yGlxMOzq8T8rSR)ygvjukx2a]] )

    --storeDefault( [[Frost Mage: Primary]], 'displays', 20170901.0, [[d4tLhaGEvWljk1UuPk9AvQCyjZukPFd1SLQTjf1nHuDzv9nPqNgLDsL9k2nP2ps1pHKHPGXruOLPszOK0GrudhHdsrhvLQQJrHZruWcvOLsu1IPKLt4HQqpf8yu1ZPQjkf0urYKrktxPlQsUkrjptkX1HyJiYwvPQSzISDuPpkf5ZQOPjLY3vuJukW6ikA0Ky8qkNevClPu5AsPQZtPUTISwvQIJtu5yeQa8fXYWAsy9cRD)dGswuTYXDfylX5VQCvJvarPp)Jkp)DzmGvND4qtD8CScyJssY)7XIyzyTpUHaOHssY)7XIyzyTpUHaec2ujS5WJ1a7Whx7BoWetBEfxlbKd5rEAhlILH1(mgWgLKK)xQsC(RpUHa3pYJ8(qfNrOcCPlR(tlJbm5xgwtNCRm)gNraxn9bijW(Loz0RZxM0jdm9z)PtMQeN)gq(V)L)J72GrZgddTea4fmInq2Sb8k4zyMT8kMxzmaAOKK8)svIZF9XneGXJ1arXZ0NX1(aBjo)1uZRGfbgrrrHcD550udOcyhx7mU14922qJn3YGmCBOnJaOfsnlJTiJn2wJTVXMBBWqgU1yKAxBngWRGNPkX5V(mg4oltnVcweGcLQ8CAQbub4Xtw1QY9kwb4lILH1MAEfSiWikkkuOhaiEEw1zhQLH1X1CBb8k4zGkJbKd5r(gYep)YW6aYZPPgqfqJmXHhR9X1sapX37K6Lx5iUJfHkqfNraR4mcCgNrarCgzd4vWZhlILH1(mganuss(FnrevCdbkerrzt8bSqKKcmvOzIS44gcuDcLYSpx2EvUxXzeO6ekfOGNv5EfNrGQtOuhXtw1QY9koJaUA6dqsG9lDYOxNVmPtwvWMkHDGQpx2EvUQzmaxMNzX6S1MYM4dyfGViwgwB2zN6ahVCuxYhGgZt0lBkBIpqfqu6ZNYM4duwSoBTduiIcDM(ZyGjM2ezXXne4olsy9cSdFCg3cGgkjj)VC00y81If(4gcuDcLIQeN)QYvnoJasy9gWuWQoDYUsiWZbeFpWXlh1L8b8eFVtQxELyfO6ekfvjo)vL7vCgb2sC(ljSEdykyvNozxje45aYH8ipnoAAm(AXcFgd4vWZMiloJbkerzQ5vWIaJOOOqHERxKOcSL48xsy9cRD)dGswuTYXDfa9cn2eYeDYuSPpUwgcq7LkK(AQ2AascSFPtg968LjDY0EPcPVbaEbJydeO6ekLzFUS9QCvJZiaAOKK8)k7rFCgbieSPsytcRxGD4JZ4wacXZJNSQ1uT1aKey)sNm615lt6KP9sfsFduiIIJwctzt8bSqKKcmvOzEf3qaQQ)6Lo5MeyeI4gcSL48xvUxXkGQGnvcB6KpweldRdq7LkK(gq(V)L)J72GrZgddTe4olsy9cRD)dGswuTYXDfqoeg)D3hZdRD)dub8k4zterXrlHJvaBuss(FnrevCdbQoHsbk4zvUQXzeWRGN5OPX4Rfl8zmGxbpBELXavFUS9QCVYyGcruaX37CAyCdb8k4zvUxzmapEYQwvUQXkGxbpl732IPPX0N(mgWRGNv5QMXa3zrcR3aMcw1dmX0avCdb2sC(ljSEb2HpoJBbSrjj5)v2J(4ANra(IyzynjSEdykyvNozxje45avNqPoINSQvLRACgbU0Lv)PLXaE2er)nrDf3Tan8LkK(gRawD2Hdn1XZM9EScWxeldRjH1lWo8XzClWuHgqfNravbBQe20jFSiwgwtNSjIOceqoKh5n7St90R3a8bKd5rEAC4XAGD4JRTHamnngFTyHPMxblcipNMAavagpwFpy8uC3gcihYJ80iH1lWo8XzClGxbpdZSLxXezXzmGCipYtt2J(mgWgLKK)xoAAm(AXcFCdbkerjlnBdq0l7xKnb]] )

    ns.initializeClassModule = PriestInit
end
