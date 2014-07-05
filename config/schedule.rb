every :hour, roles: [:app] do
  rake 'keywords:all', output: './log/import.log'
end
