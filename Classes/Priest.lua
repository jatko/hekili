
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
            id = 205448,
            spend_type = 'mana',
            cast = 0,
            gcdType = 'spell',
            cooldown = 4.5,
            known = function()
                return state.buff.voidform.up
            end,
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

        addMetaFunction('state', 'current_insanity_drain', function()
                -- Lose insanity during Voidform
                local drain_multiplier = 1.0
                local base_drain_per_sec = -3000 / -500
                local stack_drain_multiplier = 2.0 / 3.0
                local stacks = floor(state.buff.insanity_drain_stacks.value)
                local drain = drain_multiplier * (base_drain_per_sec + (stacks - 1) * stack_drain_multiplier)

                return drain
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
                local drain = state.current_insanity_drain

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

    storeDefault( [[Shadow Priest: Primary]], 'displays', 20170901.0, [[ d0J0gaGEf0lrKSlQI0RveMPc0JjYSLYVHCtKKMMkP(Mc4Ws2PuTxXUP0(HI(PkmmfACQKCAunucnyeXWrXbjvxwvhJOohsQwiv1sjOwmPSCsEOkXtbltrADuLyIuf1urPjRIMUsxurDvePEMIORJWgjWwPkcBgP2os8rQs9CQ8zO03PWirsSnKugnunEOWjru3IQKUgvHZtr3wLATufrhNGCKdBaPIz5iRaKDH1S9boin7GK7ZbKkMLJScq2f4d)0LNgqvwS)f8xAI4hqRXho07gYiAbmpOPD)EPywoY6sFmagh00UFVumlhzDPpgqiIN4pjlHSaF4N(1JbU5w950NmGqepXFEPywoY6IFaZdAA3VSLc7VU0hd4WrgGbFLW1NJFahoYqNyrXpGdhzag8vcxNyrXpWwkS)QBLWrQa(hSShuvyYEtf2aMra18G6uFC6KuFaQnWaEqTRgdTxV(6aMh00UFjLVlDVkhWHJmylf2FDXpWeA6wjCKka7HOWK9MkSb42tUuTiLUvchPcimzVPcBaPIz5iRUvchPc4FWYEq1aaZlXRgFyTCKn9PECvahoYayJFaHiEI3ZC1lTCKnGWK9MkSbSe3KLqwx6xfWX8TMGw5WVGAivyduPlhqLUCaSPlhqlD5SbC4iJlfZYrwx8dGXbnT7xDcvL(yGIqvSMmFancA6a3fg6elk9XaAn(WHE3qg6Tw0cung8cWrgIuMtxoq1yWRlOBTAfPmNUCap)0frBJwGQzuMorkIXpafUJRXB81K1K5dOfqQywoYQ34yTbUm3zNfoWj3X0ktwtMpWzavzX(SMmFGsJ34RzGIqvuLB)4hycnbi7c8HF6Ytdung8ITuy)vKIy6YbuFlWL5o7SWbCmFRjOvo8OfOAm4fBPW(RiL50LdieXt8NKTNCPArkx8d0R7paGxNidmjruXF36fmjruXVlLzGTuy)vaYUWA2(ahKMDqY95aNpDr0wDXbda41jYatsev83TEbtsoF6IOTbMqtaYUWA2(ahKMDqY95ayebEm5KdmovEYRUsMAYJthi0E1JXavJbV0BgLPtKIy6YbOr2nGUIxnmjPxkfYiaJIFxktbi7c8HF6YtdWOEj0TwT6IdgaWRtKbMKiQ4VB9cMKC(0frBdung8cWrgIuetxoWDHH(C6JbUlma20LdSLc7VIuMJwaH)2xUpW0r5bgP(OSNkhWHJmePig)aoCKbPEtnU9KBX6IFGTuy)vKIy0ciHU1QvKYC0cung8sVzuMorkZPlhycnbi7gqxXRwahoYGS9Klvls5IFaZdAA3V6eQk9XavZOmDIuMJFahoYqFo(bC4idrkZXpGe6wRwrkIrlqrOkDReosfW)GL9GQdolGnq1yWRlOBTAfPiMUCaHi4st4j4oynBFGkWn3cSPpgylf2FfGSlWh(PlpnqrOkYwAeRjZhqJGMoGuXSCKvaYUb0v8QHjj9sPqgbkcvbmFRr2ZPpgy2wAT)m(bC8BM2RFmN(0aoCKHoHQiBPrrlagh00UFzlf2FDPpgylf2FfGSBaDfVAyssVukKraZdAA3VKTNCPArkx6JbW4GM29lz7jxQwKYL(yaHiEIxVXXAVF7gqkaJIFxktYsilWh(PF9yaUeYcmLe3InDpcWLqwpjcDNUShbeI4j(tbi7c8HF6YtdGXbnT7xs57sxoGqepXFskFx8dCZT6elk9XafHQiTLVbyAL5RYMa ]])

    storeDefault( [[Shadow Priest: default]], 'actionLists', 20170901.0, [[dOZagaGEvuQxQIc7cW2KKA2sCtb0HP6BsIBtHDcv7vz3q2Va1OuHgMu9BuEoLgQa0GfidNIoOuQtPcogOoNkQSqKILcLwmswoIhQIQEkXYKuRta8Ajjtfetgvtx0fHIELG8mqcxxLCAvTvqsBwLA7sjtdPkNePYNbP(ou4XcTkPy0Qi)fOlbs0TurjxdP05fuJdPQUmPdPIIEWdYemrovr5JAcUBOtKtoNHrWbfqYR2mabhexV9RsobRwu3QdVUdxPFUoma8eXuJVx(Z2ZNHgEnT0Fs7y(mKDqgo8GmbtKtvu(OzIejVzo5iCp0X6ZQUj9IIsaJhXPuexjapOICQIYBSAcsXqxwG8vsDhKEMXdnwnbPyOllq(kb(CG1MXqhRoeTnPxuucy8ioLI4kb4bvKtvu(HgRMGum0LfiFLu3bPNzmuDJtY)2JjqXTNaz3GpY6OpddqCuvhM0M6lFgEslN8ovrNqhI)rpzKjigsNeiJdvNG7g6KihmFdDcUBOtICW8n0jy1I6wD41D4kW9jyvl7Iev7GSCY5DZ8zOjcK2N)mKLdVEqMGjYPkkF0mjqghQob3n0jCwcAXWeKBcDKprIK3mNaf0VbgOU5iCOoqV6gNK)ThtGKbMNuqt)raehv1HMJWH6a1HSPNagUnvsyqINpcAOeU6EVFOPduH2j4UHoHZsqlgMGCtOJ8jy1I6wD41D4kW9jyvl7Iev7GSCcDi(h9KrMGyiDsBQV8z4jTCY7ufD5WHIbzcMiNQO8rZKazCO6eC3qNWzjyReKBcDKprIK3mNubUbgOU5iCOoqDt6ffLawhv8WiGhurovr5hAochQd0PTXj5F7XeizxXtGSBqUtQcPwlaXrvDO5iCOoqDiB6jGHBtLegK45JGgkHRU37hA6a0ob3n0jCwc2kb5Mqh5tWQf1T6WR7WvG7tWQw2fjQ2bz5e6q8p6jJmbXq6K2uF5ZWtA5K3Pk6YHtVbzcMiNQO8rZKazCO6eC3qNyvNaYnHoYNirYBMtOFV5iCOoqN2gNK)ThtGwSNdgzeYLz(meaXrvDycUBOtSQta5Mqh5tWQf1T6WR7WvG7tWQw2fjQ2bz5e6q8p6jJmbXq6K2uF5ZWtA5K3Pk6YHt7GmbtKtvu(OzIejVzo5mPUUVbSNCodJBgXa4YCcUBOtSNCodJBgXysBQV8z4j2toNHXnJymbRAzxKOAhKLtWQf1T6WR7WvG7tOdX)ONmYeedPlhE1dYemrovr5JMjsK8M5eQR7BGwSNFZigaxMtWDdDsR7jyvl7Iev7GSCsBQV8z4jrVua9y(mey5T5e6q8p6jJmbXq6eSArDRo86oCf4(KazCC3qNiNCodJGdkGKxTzacoOw3lhELbzcMiNQO8rZejsEZCYeC3qNy4pAcw1YUir1oilN0M6lFgEs0lfqpMpdbwEBoHoe)JEYitqmKobRwu3QdVUdxbUpjqgh3n0jYjNZWi4Gci5vBgGGdYWF0YLtKi5nZjl3a]] )

    storeDefault( [[Shadow Priest: vf]], 'actionLists', 20170901.0, [[d8JiqaqyQwVGs1MukTlcETuu7di1TjX2as0SfA(KKUPuKopQY3qfoTODkWEvTBf7hvuJcqgMs1VH8COgkqs1Gjs1WvIdsKCka1XiQZbKKfcelLiwmHwokpeiHvrsSmsQ1bKuojQQMkqnzqtxYfrv5vcQ6YixxjDiurEMueBwq2oQ0Jj14euYNLcZtPOVlLMMGkJgGXtKsDjbLYTisX1ukCpbfRKiL8uk)vQ(Yh8n(gxmsWlElWvOBgahIA5S0b1zjHlqnolDUHUjHIKJPhOExMJDq1UAb5B2cPtpMHDVs08a1Bew3KsxjAWh8dKp4B8nUyKGhKBMMLl1TBbUcDJlkHDruSUjLygZI3nUOe2frX6MecJwzAcFWVUjHIKJPhOExMd59B8pWu7fIDBqd96bQp4B8nUyKGhKBMMLl1TYJ0ucyaoe121mhdqGgxmsqolTUf4k0nmahIA7AMJbCtkXmMfVByaoe121mhd4g)dm1EHy3g0q3KqrYX0duVlZH8(njegTY0e(GF96bn5GVX34IrcEqUzAwUu3GOsadWHO2ElIb7lEocmsXZbd6ne2ylevcCDLLKL6EHw1aeyKINdg0BiSXwG4u5rAkb8kJrdKy9c1vC4qySanUyKGaFlWvOBCrjSxigJM6MeksoMEG6DzoK3VX)atTxi2Tbn0njegTY0e(GFDtkXmMfVBCrjSxigJM61dc3bFJVXfJe8GClWvOBk5afPbsSBsimALPj8b)6MuIzmlE3uYbksdKy34FGP2le72Gg6MeksoMEG6DzoK3VzAwUu30iueIAh8wX1qHeYb7tw86qMNthxUUzSaxpUsGomCDw6Irsqd7vQqsttE9Gno4B8nUyKGhKBbUcDBb1sSEoHwXjAUjHWOvMMWh8RBsjMXS4DBb1sSEoHwXjAUX)atTxi2Tbn0njuKCm9a17YCiVFZ0SCPUPrOie1o4TIRHcjKd2NS41HmpNoUCDZybUECLaDy46S0fJKGg2RuHE9aq5bFJVXfJe8GClWvOBIedtSMZPXn(hyQ9cXUnOHUjLygZI3nrIHjwZ504MecJwzAcFWVUjHIKJPhOExMd59BMMLl1nncfHO2b)6bCCW34BCXibpi3cCf6ggGdrT9wed2HKxaUX)atTxi2Tbn0nPeZyw8UHb4quBVfXGDi5fGBsimALPj8b)6MeksoMEG6DzoK3VzAwUu3aY1vYL60qkjH3mmHtvvbQ8inLaJ8fI1rH6y0AelqJlgj4wxxjxQtdPKeEZWOgyG3QxzmAQEoyFYIxhY8CuPHgc6CW(Kfpb9kJrtTfOCW(Kfpb9kJrtjnaPxzmAQEoyFYIxhY8CuPHgcC4bsEJWlVHkLhPPeyKVqSokuhJwJybACXibbg4nL33F9GW6GVX34IrcEqUf4k0nLCGDXOJRB8pWu7fIDBqdDtkXmMfVBk5a7Irhx3Kqy0ktt4d(1njuKCm9a17YCiVFZ0SCPU56k5sDAiLKWBgMWXzP1RhaQo4B8nUyKGhKBbUcDddWHO2ElIb7qYlaCw6QVX)atTxi2Tbn0nPeZyw8UHb4quBVfXGDi5fGBsimALPj8b)6MeksoMEG6DzoK3VzAwUu3aY1vYL60qkjH3mmHtvvbQ8inLaJ8fI1rH6y0AelqJlgj4wxxjxQtdPKeEZWOgyG3QrOie1ocyaoe12BrmyhsEbqqdWzniCyu)6bY7h8n(gxmsWdYTaxHUHb4quBOKg4n(hyQ9cXUnOHUjLygZI3nmahIAdL0aVjHWOvMMWh8RBsOi5y6bQ3L5qE)MPz5sDJtLhPPeuYbksdKyc04IrcUvCnuibUOegcXueWLRBg0YB86bYYh8n(gxmsWdYTaxHUHb4quBVfXGDUOeEtcHrRmnHp4x3KsmJzX7ggGdrT9wed25Is4n(hyQ9cXUnOHUjHIKJPhOExMd59BMMLl1TYJ0ucyaoe12BrmyNlkHc04IrcUfOCW(Kfpb9kJrtjnaPxzmAQEoyFYIxhY8CuPHgcC4vVbWBkVV)6bYQp4B8nUyKGhKBn1L2PYQcyN1Gk8n5BMMLl1TYJ0uckjMy8eOXfJeClevcyaoe12BrmyFXZrGrkEo4nBOH3KsmJzX7ggGdrT9wed2x8CUX)atTxi2Tbn0TMI4MtJhiFlWvOByaoe12BrmyFXZ5gOGNosGDwdQWhKBsOi5y6bQ3L5qE)MecJwzAcFWVUzaqTnfbZqjXWhKBGcaKU5MI4sk0uhKxpqUjh8n(gxmsWdYn(hyQ9cXUnOHUf4k0nUUYsYsDVqRAa3maO2MIGzOKy4lEtkXmMfVBCDLLKL6EHw1aUjHWOvMMWh8RBsOi5y6bQ3L5qE)MPz5sDR8inLGsIjgpbACXib3ceevcCDLLKL6EHw1aeyKINdEZMOsdnuvvHOsadWHO2ElIb7lEocmsXZbVztuPHgc82YznOsOsfQxOomjqVHkn0WxpqoCh8n(gxmsWdYTaxHUHb4quBVfXG9fpholD13Kqy0ktt4d(1nPeZyw8UHb4quBVfXG9fpNB8pWu7fIDBqdDtcfjhtpq9UmhY73mnlxQBCQ8inLGsIjgpbACXib3YPk1nNtJTa56k5sDAiLKWBUHQQwEKMsWxXlPorR4oEjzzHfOXfJeuvvlpstjGb4qulVEo4SbGsGgxmsqvv1zvgY1LaEbaXOokuphSpzXtG5tZa)6bYBCW34BCXibpi3mnlxQBCQ8inLGsIjgpbACXib3YPk1nNtJTa56k5sDAiLKWBgovvT8inLa2NOZBeOXfJeuvvbQ8inLGVIxsDIwXD8sYYclqJlgj4wNvzixxcRtKCmGEbG6yaoe1Ify(0mWaFtcfjhtpq9UmhY734FGP2le72Gg6MecJwzAcFWVUf4k0nUUYsYsDVqRAaCw6QF9azq5bFJVXfJe8GCRPU0ovwva7SguHVjFZ0SCPU56k5sDAiLKWGwElNkpstjOKyIXtGgxmsWTCQsDZ50ylqajh(DHD1QiUgkKaxucdHykc4Y1ndSkCDw6IrsaIQo3QdxAOHQuoRbvcvQq9c1Hjf2aQHgQcqYBakdpxNLUyKeWKZ6WLgAOka56k5sDAiLKWsJmWadmWGw(MuIzmlE346kljl19cTQbCJ)bMAVqSBdAOBbUcDJRRSKSu3l0QgaNLEtUbk4PJeyN1Gk8b5MeksoMEG6DzoK3VjHWOvMMWh8RBgauBtrWmusm8b51dK54GVX34IrcEqUf4k0nmahIA7TigSV45WzP3KBsimALPj8b)6MuIzmlE3WaCiQT3IyW(INZn(hyQ9cXUnOHUjHIKJPhOExMd59BMMLl1nxxjxQtdPKeg0YB5u5rAkbLetmEc04IrcULtvQBoNgBbci5WVlSRwfX1qHe4IsyietraxUUzGvHRZsxmscqu1XTlD4sdnuLYznOsOsfQxOomPWgqn0qvaswoScpxNLUyKeWKZ6WLgAOka56k5sDAiLKWsJmWadmWGw(1dKdRd(gFJlgj4b5wGRq3uYb2dfDE3Kqy0ktt4d(1nPeZyw8UPKdShk68UX)atTxi2Tbn0njuKCm9a17YCiVFZ0SCPU96bYGQd(gFJlgj4b5wGRq3WaCiQT3IyW(INdNLE4UjHWOvMMWh8RBsjMXS4Dtjhypu05DJ)bMAVqSBdAOBsOi5y6bQ3L5qE)MPz5sD71RBMMLl1Tx)a]] )

    storeDefault( [[Shadow Priest: main]], 'actionLists', 20170901.0, [[d8dBnaWysTEHKYMuGDrOTjKK9POQomvphvZwW8fsDtjHZRe3grNwQDQq7v1UHSFLkQrPOmme63iTkjrdvPImyHez4sQdsuCuHKQJrIZHGyHsslLOAXK0Yr5HeepLYYeI1jKOojrPPQKMmutx0fjs9keuDzW1vkpJG04uQWMjO2or8ne4VsmnLQmpIKVRiFMaJwOgVIQCjeuUfcsxtPQUNIkhsPsNsb9AHe(kF9M0ixna4REB0jHBwSJPt7CuANynWZO8ohLi9gDtoeaNdFmcrfcisieJiQCZQbD7HoQ5ztrFmY(74Mm6SPi(x)OYxVjnYvda(vVvHpVMCJC1zcGKFt5MPzDDEl9aGsrYMdSfra5QbapattrESJPtLjkdxQ9gjYasVrCPeOX3KrTdDUCJh7y6uzIYWLAVr3KfHBTNu2n9Ioa3QGkPrc(OYTrNeUXJDmDQmrz4sT3OBczrhGvNjas(REtoeaNdFmcrfcuiEtoWPBmnW)6ZBcjg0rrfujajGYREZIPtvqXTWnW4V6Zpg5R3Kg5Qba)Q3QWNxtUrU6mbqYVPCZ0SUoVLEaqPizZb2IiGC1aGhmdttrjozDZADjPB6yrgq6nIlLqRuGghD0yAkYJDmDQmrz4sT3irgq6nIlLqRuGgp8MmQDOZLBsCY6M16ss30X3KfHBTNu2n9Ioa3gDs4MeNSUzTUK0nD8nHSOdWQZeaj)vVjhcGZHpgHOcbkeVjh40nMg4F95nlMovbf3c3aJ)Qp)Oq)6nPrUAaWV6ntZ6682UPhauks2CGTicixna4byAkYJDmDQmrz4sT3irgq6nIl1mHs4Z2JWe6WHvkqJVn6KWnESJPtLjkdxQ9gf5MmQDOZLB8yhtNktugUu7n6MSiCR9KYUHOi4MCiaoh(yeIkeOq8MCGt3yAG)1Np)4EF9M0ixna4x9MPzDDEB30dakfjBoWwebKRga8amnfL4K1nR1LKUPJfzaP3iUuZ2JWNThHj0HdRuGgFB0jHBsCY6M16ss30XrUjJAh6C5MeNSUzTUK0nD8nzr4w7jLDdrrWn5qaCo8XieviqH4n5aNUX0a)RpF(X9)6nPrUAaWV6ntZ6682TrNeUjH24cW2QZMIUjJAh6C5MeAJlaBRoBk6MSiCR9KYUHOi4MCiaoh(yeIkeOq8MCGt3yAG)1Np)yu91BsJC1aGF1BMM115T0dakf5XoMov0mNhlcixna4BJojCJh7y6urZCE8nzu7qNl34XoMov0mNhFtweU1Esz3queCtoeaNdFmcrfcuiEtoWPBmnW)6ZNFKGVEtAKRga8REZ0SUoVnZ1zlbkaciBGl1C7fD0ZspaOuKbEnWkuHlC6wGlcixna4bUoBjqbqazdCPMlYWHd0uAatNqI8yhtNktugUGbpJf1XotaWNlYGgXDuNlI6ngdqPuZnBh7tOk7xz6baLImWRbwHkCHt3cCXUaixna4H3gDs4gp2X0PYeLHlyWZ4BYO2HoxUXJDmDQmrz4cg8m(MSiCR9KYUHOi4MCiaoh(yeIkeOq8MCGt3yAG)1Np)4o(6nPrUAaWV6ntZ668MRZwcuaeq2axQ52Bq6baLIbqGRxkuHlzmuKqBSiGC1aGhmRrCh15IOEJXauk1C7qj6ON1iUJ6CruVXyakLAoc2xmYG0dakffMYsgW5fQWLmgkKnclcixna4HdVn6KWnYgHlQbNN3KrTdDUCJSr4IAW55nzr4w7jLDdrrWn5qaCo8XieviqH4n5aNUX0a)RpF(rc5R3Kg5Qba)Q3mnRRZBUoBjqbqazdCPMBVb7MEaqPyae46Lcv4sgdfj0glcixna4OJEwJ4oQZfr9gJbOuQ5iKOk6ON1iUJ6CruVXyakLAoczFXidspaOuuyklzaNxOcxYyOq2iSiGC1aGho82Otc3iBeUOgCEg5MmQDOZLBKncxudopVjlc3ApPSBikcUjhcGZHpgHOcbkeVjh40nMg4F95ZpQq8R3Kg5Qba)Q3QWNxtUrU6mbqYVPCZ0SUoVTB6baLIKnhylIaYvdaEWUzRJIgjyq6mbqkMnjusAb3W8vioyMRZwcuaeq2axQ9hml9aGsrFJx36MUXl86M1jxeqUAaWrhD6baLI8yhtNwknI3cItra5QbapC4nzu7qNl34XoMovMOmCP2B0nzr4w7jLDtVOdWTrNeUXJDmDQmrz4sT3iHEtil6aS6mbqYF1BYHa4C4JriQqGcXBYboDJPb(xFEZIPtvqXTWnW4V6ZpQO81BsJC1aGF1Bv4ZRj3ixDMai53uUzAwxN3CD2sGcGaYg4ZxzWUPhauks2CGTicixna4b7MTokAKGbZK4S2vdGiMMfjzbxlqJRmDMaifZMekjTGBGWMjqJRCMY(rfHlXzTRgaro4ScUwGgx5mxNTeOaiGSboHQmC4WHZx5MmQDOZLBsCY6M16ss30X3KfHBTNu2n9Ioa3gDs4MeNSUzTUK0nDCKBczrhGvNjas(REtoeaNdFmcrfcuiEtoWPBmnW)6ZBwmDQckUfUbg)vVjeVoBk6wu)5hvI81BsJC1aGF1Bv4ZRj3ixDMai53uUzAwxN3CD2sGcGaYg4ZxzWUPhauks2CGTicixna4b7MTokAKGbZK4S2vdGiMMf(uDbxlqJRmDMaifZMekjTGBGWMjqJRCMIYoiCjoRD1aiYbNvW1c04kN56SLafabKnWjuLHdhoC(kk3KrTdDUCJh7y6uzIYWLAVr3KfHBTNu2n9Ioa3gDs4gp2X0PYeLHl1EJ27Mqw0by1zcGK)Q3KdbW5WhJquHafI3KdC6gtd8V(8MftNQGIBHBGXF1BcXRZMIUTtp)OIq)6nPrUAaWV6ntZ668w6baLI8yhtNktugUiH2yra5QbapywJ4oQZfr9gJbOuQ5iyFcvHyLPhaukgabUEPqfUKXqrcTXIDbqUAaWdVn6KWnESJPtLjkdxKqB8nzu7qNl34XoMovMOmCrcTX3KfHBTNu2nefb3KdbW5WhJquHafI3KdC6gtd8V(85hv27R3Kg5Qba)Q3mnRRZB3gDs4gzJWfHd(Ynzu7qNl3iBeUiCWxUjlc3ApPSBikcUjhcGZHpgHOcbkeVjh40nMg4F95ZN3mnRRZBp)b]] )

    ns.initializeClassModule = PriestInit
end
