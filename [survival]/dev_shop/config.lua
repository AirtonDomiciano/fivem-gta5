Config = {}

-- Localização do NPC da loja
Config.ShopLocation = {
    coords = vector4(188.29, 2772.35, 45.66, 6.22), -- Próximo ao hospital
    blip = {
        enabled = true,
        sprite = 478,
        color = 5,
        scale = 0.8,
        name = "🔧 Debug Shop"
    }
}

-- Modelo do NPC
Config.PedModel = 's_m_m_scientist_01'

-- Distância de interação
Config.InteractDistance = 3.0

-- Comando alternativo (se não quiser NPC)
Config.Command = 'debugshop' -- /debugshop para abrir sem NPC

-- Caminho das imagens dos itens
Config.IconPath = 'nui://ox_inventory/web/images/'
Config.ImagePath = 'https://cfx-nui-ox_inventory/web/images/' -- Para URLs diretas
-- Alternativas:
-- 'nui://qb-inventory/html/images/'
-- 'nui://qs-inventory/html/images/'

-- Quantidades padrão para seleção rápida
Config.QuickAmounts = {1, 5, 10, 25, 50, 100}

-- Textos
Config.Lang = {
    open_shop = '[E] Abrir Debug Shop',
    shop_title = '🔧 Debug Shop - Todos os Itens',
    search_placeholder = 'Buscar item...',
    select_amount = 'Selecionar Quantidade',
    received = 'Você recebeu %sx %s',
    error = 'Erro ao adicionar item',
    choose_amount = 'Escolha a quantidade',
    custom_amount = 'Quantidade Personalizada',
    enter_amount = 'Digite a quantidade (1-999)',
    categories_title = 'Categorias de Itens',
    all_items = 'Todos os Itens',
    back = '← Voltar',
    close = 'Fechar'
}