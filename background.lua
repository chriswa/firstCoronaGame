module(..., package.seeall)

-- globals
speed        = 0.1
displayGroup = display.newGroup()

-- internals
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

-- diplay the first slice
local bottomImage   = display.newImage(slices[1])
bottomImage.y       = 160
displayGroup:insert(bottomImage)

-- position the next slice above it, off-screen
local topSliceIndex = 2
local topImage      = display.newImage(slices[2])
topImage.y          = -160
displayGroup:insert(topImage)


-- every frame, slide both images down by "speed"
Runtime:addEventListener( "enterFrame", function(event)
  
  bottomImage.y = bottomImage.y + speed
  topImage.y    = topImage.y    + speed
  
  -- if the bottom image is no longer visible, we need another top image!
  if bottomImage.y > 320 + 160 then
    
    -- top image is the new bottom image
    bottomImage:removeSelf()
    bottomImage = topImage
    
    -- load the next slice above it
    topSliceIndex = (topSliceIndex % #slices) + 1
    topImage     = display.newImage(slices[topSliceIndex])
    topImage.y   = bottomImage.y - 320
    displayGroup:insert(topImage)
  end
end )

