-- Sistema de logging melhorado
local function LogInfo(message)
    print('^2[QBX-ZombieLoot] ' .. message .. '^0')
end

local function LogError(message)
    print('^1[QBX-ZombieLoot ERROR] ' .. message .. '^0')
end

-- Callback para gerar loot aleatório
lib.callback.register('qbx-zombieloot:server:generateLoot', function(source, category)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then
        LogError('Jogador não encontrado: ' .. tostring(source))
        return {}
    end
    
    if not category or type(category) ~= 'string' then
        LogError('Categoria inválida: ' .. tostring(category))
        return {}
    end
    
    if not Config.Categories[category] then
        LogError('Categoria não existe: ' .. category)
        return {}
    end
    
    local categoryData = Config.Categories[category]
    local generatedLoot = {}
    local itemCount = math.random(categoryData.minItems, categoryData.maxItems)
    
    -- Gera itens aleatórios baseado nas chances
    for i = 1, itemCount do
        local totalChance = 0
        for _, lootItem in ipairs(categoryData.loot) do
            totalChance = totalChance + lootItem.chance
        end
        
        local roll = math.random() * totalChance
        local currentChance = 0
        
        for _, lootItem in ipairs(categoryData.loot) do
            currentChance = currentChance + lootItem.chance
            if roll <= currentChance then
                local amount = math.random(lootItem.amount[1], lootItem.amount[2])
                table.insert(generatedLoot, {
                    name = lootItem.item,
                    label = lootItem.label,
                    amount = amount
                })
                break
            end
        end
    end
    
    return generatedLoot
end)

-- Callback para pegar item com verificação (retorna se teve sucesso)
lib.callback.register('qbx-zombieloot:server:takeItemWithCheck', function(source, itemName, amount)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    
    if not Player then
        LogError('Jogador não encontrado para takeItemWithCheck: ' .. tostring(src))
        return false
    end
    
    if not itemName or type(itemName) ~= 'string' then
        LogError('Item name inválido: ' .. tostring(itemName))
        return false
    end
    
    if not amount or type(amount) ~= 'number' or amount <= 0 then
        LogError('Amount inválido: ' .. tostring(amount))
        return false
    end
    
    -- Verifica se o inventário pode receber o item
    local canCarry = exports.ox_inventory:CanCarryItem(src, itemName, amount)
    
    if not canCarry then
        lib.notify(src, {
            description = Config.Lang.inventory_full,
            type = 'error'
        })
        return false
    end
    
    -- Adiciona item ao inventário
    local success = exports.ox_inventory:AddItem(src, itemName, amount)
    
    if success then
        lib.notify(src, {
            description = string.format(Config.Lang.received_item, amount, itemName),
            type = 'success'
        })
        return true
    else
        lib.notify(src, {
            description = 'Erro ao adicionar item',
            type = 'error'
        })
        return false
    end
end)

-- Evento para pegar um item específico (mantido para compatibilidade)
RegisterNetEvent('qbx-zombieloot:server:takeItem', function(itemName, amount)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    
    if not Player then
        LogError('Jogador não encontrado para takeItem: ' .. tostring(src))
        return
    end
    
    if not itemName or type(itemName) ~= 'string' then
        LogError('Item name inválido no takeItem: ' .. tostring(itemName))
        return
    end
    
    if not amount or type(amount) ~= 'number' or amount <= 0 then
        LogError('Amount inválido no takeItem: ' .. tostring(amount))
        return
    end
    
    local canCarry = exports.ox_inventory:CanCarryItem(src, itemName, amount)
    
    if not canCarry then
        lib.notify(src, {
            description = Config.Lang.inventory_full,
            type = 'error'
        })
        return
    end
    
    -- Adiciona item ao inventário
    local success = exports.ox_inventory:AddItem(src, itemName, amount)
    
    if success then
        lib.notify(src, {
            description = string.format(Config.Lang.received_item, amount, itemName),
            type = 'success'
        })
    else
        lib.notify(src, {
            description = 'Erro ao adicionar item',
            type = 'error'
        })
    end
end)

-- Evento para pegar todos os itens
RegisterNetEvent('qbx-zombieloot:server:takeAll', function(lootData)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    
    if not Player then
        LogError('Jogador não encontrado para takeAll: ' .. tostring(src))
        return
    end
    
    if not lootData or type(lootData) ~= 'table' then
        LogError('LootData inválido: ' .. tostring(lootData))
        return
    end
    
    local itemsReceived = 0
    local itemsFailed = 0
    
    for _, item in ipairs(lootData) do
        -- Verifica se pode carregar antes de adicionar
        local canCarry = exports.ox_inventory:CanCarryItem(src, item.name, item.amount)
        
        if canCarry then
            local success = exports.ox_inventory:AddItem(src, item.name, item.amount)
            
            if success then
                itemsReceived = itemsReceived + 1
            else
                itemsFailed = itemsFailed + 1
            end
        else
            itemsFailed = itemsFailed + 1
        end
        
        -- Pequeno delay para evitar sobrecarga
        Wait(50)
    end
    
    if itemsReceived > 0 then
        lib.notify(src, {
            description = string.format('Você coletou %s itens', itemsReceived),
            type = 'success'
        })
    end
    
    if itemsFailed > 0 then
        lib.notify(src, {
            description = string.format('%s itens não couberam no inventário', itemsFailed),
            type = 'warning'
        })
    end
end)

-- NOTA: Sistema de shop do ox_inventory desabilitado devido a incompatibilidade
-- com RegisterShop. Usando sistema ox_lib como fallback.

--[[ 
Eventos para sistema de shop do ox_inventory (DESABILITADO)
RegisterNetEvent('qbx-zombieloot:shop:buy', function(shopId, itemName, amount)
    -- Código comentado devido à incompatibilidade com RegisterShop
end)

lib.callback.register('qbx-zombieloot:getShopData', function(source, pedId, availableItems)
    -- Código comentado devido à incompatibilidade com RegisterShop
end)
--]]

-- Inicialização do sistema
CreateThread(function()
    Wait(1000) -- Aguarda outros resources carregarem
    LogInfo('Sistema carregado com sucesso!')
    LogInfo('Versão: 1.0.0')
    LogInfo('Dependências: qbx_core, ox_lib, ox_inventory')
    
    -- LogInfo('Dependências: qbx_core, ox_lib, ox_inventory')
end)