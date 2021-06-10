ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("wht-name:check", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = exports.ghmattimysql:executeSync("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {
     ["@identifier"] = xPlayer.identifier
 })
 local isim = result[1].firstname
 local soyisim = result[1].lastname
 cb(isim, soyisim)
end)

ESX.RegisterServerCallback("checkmoney", function(source, cb) 
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getAccount("bank").money > Config.Para then
        xPlayer.removeAccountMoney('bank', Config.Para)
        xPlayer.addInventoryItem("weapon_battleaxe", 1)
        TriggerClientEvent('inventory:client:ItemBox', source, ESX.GetItems()['weapon_battleaxe'], "add",1)
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent("wht-ver")
AddEventHandler("wht-ver", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local sans = math.random(2,3)
    xPlayer.addInventoryItem("kereste", sans)
    TriggerClientEvent('inventory:client:ItemBox', source, ESX.GetItems()['kereste'], "add",sans)
end)