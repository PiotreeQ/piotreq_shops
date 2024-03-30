ESX.RegisterServerCallback('piotreq_shop:PayForShopping', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local moneyCount = xPlayer.getAccount(data.payment).money
    if (moneyCount >= data.price) then
        xPlayer.removeAccountMoney(data.payment, data.price)
        for i = 1, #data.products, 1 do
            exports.ox_inventory:AddItem(source, data.products[i].item, data.products[i].count)
        end
        cb(true)
    else
        cb(false)
    end
end)