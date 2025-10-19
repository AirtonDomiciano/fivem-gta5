-- Sistema de cache para otimizar performance
local cachedItems = nil
local lastCacheTime = 0
local CACHE_DURATION = 600000 -- 10 minutos em ms (mais tempo para cache)

-- Callback para pegar todos os itens do ox_inventory (com cache)
lib.callback.register('qbx-debugshop:server:getAllItems', function(source)
    local currentTime = GetGameTimer()
    
    -- Verifica se o cache ainda é válido
    if cachedItems and (currentTime - lastCacheTime) < CACHE_DURATION then
        print(string.format('^3[Debug Shop] ⚡ Retornando %s itens do cache^0', #cachedItems))
        return cachedItems
    end
    
    -- Recarrega o cache se necessário
    local items = exports.ox_inventory:Items()
    local itemList = {}
    
    for itemName, itemData in pairs(items) do
        -- Categoriza baseado no tipo de item
        local category = 'Outros'
        local name = itemName:lower()
        
        -- CATEGORIZAÇÃO DETALHADA
        if itemData.weapon then
            category = '🔫 Armas'
        elseif name:find('ammo') then
            category = '📦 Munições'
        elseif name:find('armor') or name:find('vest') then
            category = '🛡️ Proteção'
        elseif name:find('bandage') or name:find('medkit') or name:find('health') or name:find('firstaid') then
            category = '💊 Médicos'
        elseif name:find('food') or name:find('burger') or name:find('sandwich') or name:find('taco') or name:find('hotdog') or name:find('bread') or name:find('donut') then
            category = '🍔 Comidas'
        elseif name:find('water') or name:find('coffee') or name:find('drink') or name:find('beer') or name:find('wine') or name:find('juice') or name:find('soda') then
            category = '🥤 Bebidas'
        elseif name:find('lockpick') or name:find('drill') or name:find('thermite') or name:find('explosive') or name:find('c4') then
            category = '🔓 Ferramentas de Crime'
        elseif name:find('phone') or name:find('radio') or name:find('tablet') or name:find('laptop') then
            category = '📱 Eletrônicos'
        elseif name:find('key') or name:find('card') or name:find('keycard') then
            category = '🔑 Chaves e Cartões'
        elseif name:find('repair') or name:find('toolbox') or name:find('wrench') or name:find('screwdriver') or name:find('hammer') then
            category = '🔧 Ferramentas'
        elseif name:find('diamond') or name:find('gold') or name:find('ruby') or name:find('emerald') or name:find('necklace') or name:find('ring') then
            category = '💎 Jóias e Metais Preciosos'
        elseif name:find('fish') then
            category = '🐟 Peixes'
        elseif name:find('weed') or name:find('joint') or name:find('coke') or name:find('meth') or name:find('oxy') then
            category = '🌿 Drogas'
        elseif name:find('zombie') then
            category = '🧟 Órgãos de Zumbi'
        elseif name:find('meat') or name:find('skin') or name:find('bone') or name:find('leather') or name:find('pelt') then
            category = '🦌 Recursos Animais'
        elseif name:find('wood') or name:find('stone') or name:find('iron') or name:find('copper') or name:find('steel') then
            category = '⛏️ Recursos de Mineração'
        elseif name:find('plastic') or name:find('rubber') or name:find('glass') or name:find('aluminum') then
            category = '♻️ Materiais Recicláveis'
        elseif name:find('seed') or name:find('plant') or name:find('fertilizer') then
            category = '🌱 Agricultura'
        elseif name:find('battery') or name:find('wire') or name:find('chip') or name:find('circuit') then
            category = '🔋 Componentes Eletrônicos'
        elseif name:find('contract') or name:find('document') or name:find('paper') or name:find('license') then
            category = '📄 Documentos'
        elseif name:find('money') or name:find('cash') or name:find('markedbills') then
            category = '💵 Dinheiro'
        elseif name:find('bag') or name:find('backpack') or name:find('case') then
            category = '🎒 Bolsas e Mochilas'
        elseif name:find('clothes') or name:find('shirt') or name:find('pants') or name:find('shoes') then
            category = '👕 Roupas'
        elseif name:find('scrap') or name:find('metal') or name:find('part') then
            category = '🔩 Peças e Sucata'
        elseif name:find('vehicle') or name:find('car') or name:find('tire') or name:find('engine') then
            category = '🚗 Veículos e Peças'
        end
        
        table.insert(itemList, {
            name = itemName,
            label = itemData.label or itemName,
            weight = itemData.weight or 0,
            category = category
        })
    end
    
    -- Ordena alfabeticamente por label
    table.sort(itemList, function(a, b)
        return a.label < b.label
    end)
    
    -- Atualiza o cache
    cachedItems = itemList
    lastCacheTime = currentTime
    
    local cacheStatus = "novo" -- Sempre novo quando chegamos aqui
    print(string.format('^2[Debug Shop] ✅ %s itens carregados (%s)^0', #itemList, cacheStatus))
    
    return itemList
end)

-- Evento para dar item ao jogador
RegisterNetEvent('qbx-debugshop:server:giveItem', function(itemName, amount)
    local src = source
    
    -- Validação básica
    if not itemName or not amount then
        lib.notify(src, {
            description = 'Dados inválidos',
            type = 'error'
        })
        return
    end
    
    -- Limita quantidade
    amount = math.min(tonumber(amount), 999)
    amount = math.max(amount, 1)
    
    -- Verifica se o item existe
    local items = exports.ox_inventory:Items()
    if not items[itemName] then
        lib.notify(src, {
            description = 'Item não existe no inventário',
            type = 'error'
        })
        return
    end
    
    -- Verifica se pode carregar
    local canCarry = exports.ox_inventory:CanCarryItem(src, itemName, amount)
    
    if not canCarry then
        lib.notify(src, {
            description = 'Inventário cheio ou item muito pesado',
            type = 'error'
        })
        return
    end
    
    -- Adiciona o item
    local success = exports.ox_inventory:AddItem(src, itemName, amount)
    
    if success then
        lib.notify(src, {
            description = string.format('✅ Você recebeu %sx %s', amount, items[itemName].label),
            type = 'success',
            duration = 3000
        })
        
        -- Log para console
        local player = exports.qbx_core:GetPlayer(src)
        if player then
            local playerName = player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname
            print(string.format('^3[Debug Shop] 📦 %s pegou %sx %s^0', playerName, amount, itemName))
        else
            print(string.format('^3[Debug Shop] 📦 Player %s pegou %sx %s^0', src, amount, itemName))
        end
    else
        lib.notify(src, {
            description = 'Erro ao adicionar item ao inventário',
            type = 'error'
        })
    end
end)

print('^2═══════════════════════════════════════^0')
print('^2║  QBX-DebugShop carregado! ✅        ║^0')
print('^2║  Comando: /debugshop                ║^0')
print('^2║  Local: Hospital (Blip no mapa)    ║^0')
print('^2═══════════════════════════════════════^0')