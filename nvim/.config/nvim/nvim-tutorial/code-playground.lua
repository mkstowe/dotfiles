local M={}

local weekdays={"Monday","Tuesday","Wednesday"}

function M.greet(name,count)
  local message="hello, "..name
  for i=1,count do
    print(message,i)
  end
  return message
end

function M.find_user(users,id)
  for _,user in ipairs(users) do
    if user.id==id then return user end
  end
  return nil
end

-- TELESCOPE_NEEDLE Lua fixture
return M
