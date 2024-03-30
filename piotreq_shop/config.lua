Config = {}

Config.Debug = false

Config.Shops = {
    ['GroveStreet'] = {
        zone = vector4(-49.5985, -1755.4670, 29.4210, 59.5403),
        bill = vector4(-47.7613, -1757.1411, 29.4210, 231.1160),
        shelfs = {
            {
                coords = vector4(-48.5985, -1755.2684, 29.4210, 49.7679),
                size = vector3(1.5, 1.5, 1.5),
                items = {
                    {item = 'burger', label = 'Burger', price = 10},
                    {item = 'water', label = 'Water', price = 10},
                    {item = 'cigarettes', label = 'Cigarettes', price = 20},
                }
            },
            {
                coords = vector4(-52.2895, -1753.3188, 29.4210, 13.7259),
                size = vector3(1.5, 1.5, 1.5),
                items = {
                    {item = 'chips', label = 'Chips', price = 30},
                    {item = 'fries', label = 'Fries', price = 30},
                }
            },
        }
    },
}