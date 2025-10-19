-- ============================================
-- server.lua
-- ============================================

print("^3[Physical Money] Iniciando...^7")

-- ============================================
-- Hook no evento de mudança de dinheiro
-- ============================================
AddEventHandler('QBCore:Server:OnMoneyChange', function(source, moneyType, amount, actionType, reason)
    -- Só intercepta quando adiciona dinheiro ao banco
    if moneyType == 'bank' and actionType == 'add' then
        print(string.format("^3[Physical Money] Detectado +$%d ao banco (ID: %d)^7", amount, source))
        
        -- Adiciona como item físico
        CreateThread(function()
            Wait(100) -- Pequeno delay
            exports.ox_inventory:AddItem(source, 'money', amount)
            exports.qbx_core:Notify(source, string.format("💵 +$%d (físico)", amount), "success")
        end)
    end
end)

-- ============================================
-- Thread: Zera banco automaticamente
-- ============================================
CreateThread(function()
    Wait(10000) -- Aguarda 10s
    
    while true do
        Wait(5000) -- A cada 5 segundos
        
        local players = exports.qbx_core:GetQBPlayers()
        
        for src, Player in pairs(players) do
            if Player.PlayerData.money.bank > 0 then
                print(string.format("^1[Physical Money] Zerando banco: ID %d tinha $%d^7", src, Player.PlayerData.money.bank))
                
                -- Zera banco
                exports.qbx_core:SetMoney(src, 'bank', 0, 'physical_force')
            end
        end
    end
end)

-- ============================================
-- Evento: Jogador conectou
-- ============================================
AddEventHandler('QBCore:Server:OnPlayerLoaded', function(Player)
    Wait(2000)
    
    local src = Player.PlayerData.source
    print(string.format("^3[Physical Money] Jogador %d conectou^7", src))
    
    -- Converte banco existente
    if Player.PlayerData.money.bank > 0 then
        local bankAmount = Player.PlayerData.money.bank
        print(string.format("^2[Physical Money] Convertendo $%d do banco^7", bankAmount))
        
        exports.qbx_core:SetMoney(src, 'bank', 0, 'physical_convert')
        exports.ox_inventory:AddItem(src, 'money', bankAmount)
        
        exports.qbx_core:Notify(src, string.format("💵 $%d convertido para dinheiro físico", bankAmount), "info", 5000)
    end
    
    -- Converte cash existente
    if Player.PlayerData.money.cash > 0 then
        local cashAmount = Player.PlayerData.money.cash
        print(string.format("^2[Physical Money] Convertendo $%d de cash^7", cashAmount))
        
        exports.qbx_core:SetMoney(src, 'cash', 0, 'physical_convert')
        exports.ox_inventory:AddItem(src, 'money', cashAmount)
    end
end)

-- ============================================
-- Função auxiliar: Adicionar dinheiro físico
-- ============================================
local function AddPhysicalMoney(src, amount, reason)
    reason = reason or 'unknown'
    local success = exports.ox_inventory:AddItem(src, 'money', amount)
    
    if success then
        print(string.format("^2[Physical Money] +$%d para ID %d (%s)^7", amount, src, reason))
        exports.qbx_core:Notify(src, string.format("💵 +$%d", amount), "success")
        return true
    else
        exports.qbx_core:Notify(src, "❌ Inventário cheio!", "error")
        return false
    end
end

-- ============================================
-- Função auxiliar: Remover dinheiro físico
-- ============================================
local function RemovePhysicalMoney(src, amount, reason)
    reason = reason or 'unknown'
    local currentMoney = exports.ox_inventory:Search(src, 'count', 'money') or 0
    
    if currentMoney >= amount then
        exports.ox_inventory:RemoveItem(src, 'money', amount)
        print(string.format("^2[Physical Money] -$%d de ID %d (%s)^7", amount, src, reason))
        exports.qbx_core:Notify(src, string.format("💵 -$%d", amount), "error")
        return true
    else
        exports.qbx_core:Notify(src, string.format("❌ Dinheiro insuficiente! (Tem: $%d)", currentMoney), "error")
        return false
    end
end

-- ============================================
-- Exports para outros scripts
-- ============================================
exports('AddPhysicalMoney', AddPhysicalMoney)
exports('RemovePhysicalMoney', RemovePhysicalMoney)

-- ============================================
-- Comandos
-- ============================================
RegisterCommand('addcash', function(source, args)
    local amount = tonumber(args[1]) or 1000
    AddPhysicalMoney(source, amount, 'comando')
end)

RegisterCommand('removecash', function(source, args)
    local amount = tonumber(args[1]) or 100
    RemovePhysicalMoney(source, amount, 'comando')
end)

RegisterCommand('checkmoney', function(source)
    local cash = exports.ox_inventory:Search(source, 'count', 'money') or 0
    local Player = exports.qbx_core:GetPlayer(source)
    local bank = Player and Player.PlayerData.money.bank or 0
    
    exports.qbx_core:Notify(source, string.format("💵 Cash: $%d | 🏦 Bank: $%d", cash, bank), "info", 5000)
end)

RegisterCommand('givecash', function(source, args)
    local targetId = tonumber(args[1])
    local amount = tonumber(args[2])
    
    if not targetId or not amount then
        exports.qbx_core:Notify(source, "Uso: /givecash [id] [valor]", "error")
        return
    end
    
    AddPhysicalMoney(targetId, amount, 'admin_give')
    exports.qbx_core:Notify(source, string.format("✅ Deu $%d para ID %d", amount, targetId), "success")
end, true)

print("^2[Physical Money] Sistema carregado!^7")
print("^3[Physical Money] Comandos: /addcash, /removecash, /checkmoney, /givecash^7")
print("^3[Physical Money] Exports: AddPhysicalMoney, RemovePhysicalMoney^7")