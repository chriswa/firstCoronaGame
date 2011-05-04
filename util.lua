--
function normalize2dVector(x, y, finalMagnitude)
  local magnitude = math.sqrt(x*x + y*y)
  if magnitude == 0 then return 0, 0 end
  local factor = finalMagnitude / magnitude
  return x*factor, y*factor
end
