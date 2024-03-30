ESX.RegisterServerCallback('piotreq_shop:PayForShopping', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local moneyCount = xPlayer.getAccount(data.payment).money
    local needToPay = 0
    for i = 1, #data.products, 1 do
        needToPay = needToPay + (data.products[i].price * data.products[i].count)
    end
    if (moneyCount >= needToPay) then
        xPlayer.removeAccountMoney(data.payment, needToPay)
        for j = 1, #data.products, 1 do
            exports.ox_inventory:AddItem(source, data.products[j].item, data.products[j].count)
        end
        cb(true)
    else
        cb(false)
    end
end)
