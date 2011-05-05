local slices = {
  "images/background-slice-11.png",
  "images/background-slice-10.png",
  "images/background-slice-9.png",
  "images/background-slice-8.png",
  "images/background-slice-7.png",
  "images/background-slice-6.png",
  "images/background-slice-5.png",
  "images/background-slice-4.png",
  "images/background-slice-3.png",
  "images/background-slice-2.png",
  "images/background-slice-1.png",
}

local B = {
  speed         = 0.1,
  slices        = slices,
  displayGroup  = display.newGroup(),
  bottom        = null,
  top           = null,
  pixelOffset   = 0,
  nextSlice     = 3,
}

B.bottom      = display.newImage(B.slices[1])
B.bottom.y    = 160
B.displayGroup:insert(B.bottom)

B.top         = display.newImage(B.slices[2])
B.top.y       = -160
B.displayGroup:insert(B.top)

local update = function(event)
  B.bottom.y = B.bottom.y + B.speed
  B.top.y    = B.top.y    + B.speed
  if B.bottom.y > 320 + 160 then
    B.bottom:removeSelf()
    B.bottom = B.top
    B.top    = display.newImage(B.slices[B.nextSlice])
    B.displayGroup:insert(B.top)
    B.top.y      = B.bottom.y - 320
    B.nextSlice = (B.nextSlice % #B.slices) + 1
  end
end

Runtime:addEventListener( "enterFrame", update );

-- expose globals
Background = B
