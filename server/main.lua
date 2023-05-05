ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('fx_vehiclelock:Cars', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate
	}, function(result)
		if result[1] then
			cb(result[1].owner == xPlayer.identifier)
		else
			cb(false)
		end
	end)
end)