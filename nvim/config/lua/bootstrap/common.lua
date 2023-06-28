local M = {}

function M.run(name, body_fn)
  print("[BEGIN] " .. name)
  body_fn()
  print("[END]   " .. name)
end

return M

