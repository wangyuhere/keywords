every :hour, roles: [:app] do
  rake 'keywords:import', output: './log/import.log'
end
