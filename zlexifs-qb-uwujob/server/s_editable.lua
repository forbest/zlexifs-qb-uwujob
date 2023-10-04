local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("zlexif-uwu:Server:Billing", function(playerId, amount)
    local biller = QBCore.Functions.GetPlayer(source)
    local billed = QBCore.Functions.GetPlayer(tonumber(playerId))
    local amount = tonumber(amount)
    if biller.PlayerData.job.name == Config.Job then
        if billed ~= nil then
            if biller.PlayerData.citizenid ~= billed.PlayerData.citizenid then
                if amount and amount > 0 then
                    MySQL.Async.execute('INSERT INTO phone_invoices (citizenid, amount, society, sender) VALUES (@citizenid, @amount, @society, @sender)', {
                        ['@citizenid'] = billed.PlayerData.citizenid,
                        ['@amount'] = amount,
                        ['@society'] = biller.PlayerData.job.name,
                        ['@sender'] = biller.PlayerData.charinfo.firstname
                    })
                    TriggerClientEvent("qb-phone:RefreshPhone", billed.PlayerData.source)
                    TriggerClientEvent('zlexif-uwu:Client:Notify', source, Language.Notify.Send, 'success', 5000)
                    TriggerClientEvent('zlexif-uwu:Client:Notify', billed.PlayerData.source, Language.Notify.InvoiceReceived)
                else
                    TriggerClientEvent('zlexif-uwu:Client:Notify', source, Language.Notify.HigherValue, 'error', 5000)
                end
            else
                TriggerClientEvent('zlexif-uwu:Client:Notify', source, Language.Notify.InvoiceOwn, 'error', 5000)
            end
        else
            TriggerClientEvent('zlexif-uwu:Client:Notify', source, Language.Notify.PlayerOffline, 'error', 5000)
        end
    else
        TriggerClientEvent('zlexif-uwu:Client:Notify', source, Language.Notify.NoPermission, 'error', 5000)
    end
end)



CreateThread(function()
    local food = { "blueberry", "rice", "onion", "orange", "bmochi", "pmochi", "omochi", "gmochi", "bento", "riceball", "miso", "cake", "nekocookie", "nekodonut"}
    for k,v in pairs(food) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('zlexif-uwu:client:Eat', source, item.name) end) end
    
    local drinks = { "nekolatte", "sake", "pbobatea", "gbobatea", "obobatea", "bbobatea", "bobatea" }
    for k,v in pairs(drinks) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('zlexif-uwu:client:Drink', source, item.name) end) end
end)


