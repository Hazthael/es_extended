ESX.StartPayCheck = function()

	function payCheck()
		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayers	 = ESX.GetPlayerFromId(xPlayers[i])
			local job    	 = xPlayer.job.grade_name
			local salary 	 = xPlayer.job.grade_salary
			local org     	 = xPlayer.org.gradeorg_name
			local orgsalary  = xPlayer.org.gradeorg_salary

			if salary > 0 then
				if job == 'unemployed' then -- unemployed
					xPlayer.addAccountMoney('bank', salary)
					TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_help', salary), 'CHAR_BANK_MAZE', 9)
				elseif Config.EnableSocietyPayouts then -- possibly a society
					TriggerEvent('esx_society:getSociety', xPlayer.job.name, function (society)
						if society ~= nil then -- verified society
							TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
								if account.money >= salary then -- does the society money to pay its employees?
									xPlayer.addAccountMoney('bank', salary)
									account.removeMoney(salary)

									TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
								else
									TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), '', _U('company_nomoney'), 'CHAR_BANK_MAZE', 1)
								end
							end)
						else -- not a society
							xPlayer.addAccountMoney('bank', salary)
							TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
						end
					end)
				else -- generic job
					xPlayer.addAccountMoney('bank', salary)
					TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
				end
			end

			if orgsalary > 0 then
				if org == 'none' then -- unemployed
				xPlayer.addAccountMoney('bank', orgsalary)
					TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck2'), _U('received_help2', orgsalary), 'CHAR_BANK_MAZE', 9)
				elseif Config.EnableOrgPayouts then -- possibly a society
					TriggerEvent('esx_organisation:getOrganisation', xPlayer.org.name, function (organisation)
						if org ~= nil then -- verified society
							TriggerEvent('esx_addonaccount:getSharedAccount', organisation.account, function (account)
								if account.money >= orgsalary then -- does the society money to pay its employees?
									xPlayer.addAccountMoney('bank', orgsalary)
									account.removeMoney(orgsalary)
	
									TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck2'), _U('received_salary2', orgsalary), 'CHAR_BANK_MAZE', 9)
								else
									TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), '', _U('org_nomoney'), 'CHAR_BANK_MAZE', 1)
								end
							end)
						else -- not a society
							xPlayer.addAccountMoney('bank', orgsalary)
							TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck2'), _U('received_salary2', orgsalary), 'CHAR_BANK_MAZE', 9)
						end
					end)
				else -- generic job
					xPlayer.addAccountMoney('bank', orgsalary)
					TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck2'), _U('received_salary2', orgsalary), 'CHAR_BANK_MAZE', 9)
				end
			end

		end

		SetTimeout(Config.PaycheckInterval, payCheck)

	end

	SetTimeout(Config.PaycheckInterval, payCheck)

end
