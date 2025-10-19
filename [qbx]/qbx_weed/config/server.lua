---@type WeedServerConfig
return {
    randomGrowAmount = { -- Quantidade aleatória de progresso para dar no intervalo ao cultivar uma planta com saúde acima de 50 (configuração para sobrevivência zumbi)
        min = 2, -- Aumentar crescimento mínimo (era 1)
        max = 5  -- Aumentar crescimento máximo (era 3)
    },
    randomHarvestAmount = { -- A quantidade aleatória de erva para dar para uma colheita (configuração para sobrevivência zumbi)
        min = 8,  -- Reduzir colheita mínima (era 12)
        max = 12  -- Reduzir colheita máxima (era 16)
    },
    plantFoodCheckInterval = 576, -- Quantos segundos leva para a comida da planta ser verificada. Padrão 1152 segundos (19.2 minutos) (configuração para sobrevivência zumbi)
    plantGrowInterval = 288, -- Quantos segundos leva para a planta crescer. Padrão 576 segundos (9.6 minutos) (configuração para sobrevivência zumbi)
    outsidePlantsRefreshInterval = 25, -- A quantidade de segundos que leva para atualizar plantas externas. Padrão 25 segundos
}
