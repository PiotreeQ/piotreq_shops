local myCart = {}
local Zones = {}
local inZone = nil

Citizen.CreateThread(function()
    for k, v in pairs(Config.Shops) do    
        exports['ox_target']:addBoxZone({
            coords = vector3(v.bill.x, v.bill.y, v.bill.z),
            size = vector3(1.2, 1.2, 1.2),
            rotation = v.bill.w,
            debug = Config.Debug,
            options = {
                {
                    name = 'CashRegister_'..k,
                    label = 'Cash register',
                    icon = 'fa-solid fa-shopping-cart',
                    distance = 2,
                    onSelect = function()
                        local totalPrice = 0
                        local options = {}
                        for i = 1, #myCart, 1 do
                            totalPrice = totalPrice + (myCart[i].price * myCart[i].count)
                            options[#options + 1] = {
                                title = myCart[i].label,
                                description = 'x'..myCart[i].count..' ($'..(myCart[i].price * myCart[i].count)..')',
                                arrow = true,
                                onSelect = function()
                                    local input = lib.inputDialog('Remove product', {
                                        {type = 'slider', label = 'Select amount', required = true, min = 1, max = myCart[i].count}
                                    })

                                    if not input then
                                        return
                                    end

                                    local itemCount = myCart[i].count
                                    myCart[i].count = itemCount - tonumber(input[1])
                                    if myCart[i].count < 1 then
                                        table.remove(myCart, i)
                                    end
                                    lib.notify({
                                        title = 'Shop',
                                        description = 'Successfully removed '..myCart[i].label..' x'..itemCount..' from your shopping cart',
                                        type = 'success'
                                    })
                                end
                            }
                        end
                        options[#options + 1] = {
                            title = 'Pay',
                            description = 'Total: $'..totalPrice,
                            onSelect = function()
                                if (totalPrice < 1) then
                                    return
                                end

                                local payment = lib.inputDialog('Pay', {
                                    {type = 'select', label = 'Select payment', required = true, options = {
                                        {label = 'Cash', value = 'money'},
                                        {label = 'Credit Card', value = 'bank'}
                                    }}
                                })

                                if not payment then
                                    return
                                end

                                local shopData = {payment = payment[1], products = myCart}
                                ESX.TriggerServerCallback('piotreq_shop:PayForShopping', function(payed)
                                    if payed then
                                        myCart = {}
                                        lib.notify({
                                            title = 'Shop',
                                            description = 'Successfully payed for your groceries',
                                            type = 'success'
                                        })
                                    end
                                end, shopData)
                            end
                        }
                        lib.registerContext({
                            id = 'CashRegister_'..k,
                            title = 'Cash Register',
                            options = options
                        })
                        lib.showContext('CashRegister_'..k)
                    end
                }
            }
        })

        for _, shelf in pairs(v.shelfs) do
            exports['ox_target']:addBoxZone({
                coords = vector3(shelf.coords.x, shelf.coords.y, shelf.coords.z),
                size = shelf.size,
                rotation = shelf.coords.w,
                debug = Config.Debug,
                options = {
                    {
                        name = _..'_Shelf_'..k,
                        label = 'Check Shelf',
                        icon = 'fa-solid fa-shelves',
                        distance = 2,
                        onSelect = function()
                            local options = {}
                            for i = 1, #shelf.items, 1 do
                                options[#options + 1] = {
                                    title = shelf.items[i].label,
                                    description = '($'..shelf.items[i].price..')',
                                    arrow = true,
                                    onSelect = function()
                                        local input = lib.inputDialog('Amount of product', {
                                            {type = 'number', label = 'Enter amount', required = true, min = 1, default = 1, max = 50}
                                        })

                                        if not input then
                                            return
                                        end

                                        table.insert(myCart, {
                                            label = shelf.items[i].label,
                                            item = shelf.items[i].item,
                                            price = shelf.items[i].price,
                                            count = input[1]
                                        })
                                        
                                        lib.notify({
                                            title = 'Shop',
                                            description = 'Successfully added '..shelf.items[i].label..' to your shopping cart',
                                            type = 'success'
                                        })
                                    end
                                }
                            end
                            lib.registerContext({
                                id = _..'_Shelf_'..k,
                                title = 'Shopping Shelf',
                                options = options
                            })
                            lib.showContext(_..'_Shelf_'..k)
                        end
                    }
                }
            })
        end
    end
end)
