--Start of Global Scope---------------------------------------------------------

-- Viewer for showing the results.
local v = View.create()

local DELAY = 1000 -- ms between each type for demonstration purpose

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

---Draws two pixel regions on top of an image, before and after thinning.
---@param image Image
---@param thinRegion Image.PixelRegion
---@param thrRegion Image.PixelRegion
local function drawRegionOnImage(image, thinRegion, thrRegion)
  -- Thinned region draw color
  local dec = View.PixelRegionDecoration.create():setColor(255, 0, 0, 255)

  -- Thresholded region draw color
  local decThr = View.PixelRegionDecoration.create():setColor(0, 0, 255, 127)

  -- Draw image and region
  v:clear()
  v:addImage(image)
  v:present()
  Script.sleep(DELAY)

  v:addPixelRegion(thrRegion, decThr)
  v:present()
  Script.sleep(DELAY)

  v:addPixelRegion(thinRegion, dec)
  v:present()
end

---Finds lines in an image and returns those as a thin pixel region.
---@param image Image
---@return Image.PixelRegion
---@return Image.PixelRegion
local function findThinLines(image)
  -- Generate a smoothed version of the image to account for uneven lighting.
  local smoothImage = image:gauss(100)

  -- Find thin dark regions in the image by subtracting the image from
  -- the smoothed image and thresholding the difference.
  local diff = smoothImage:subtract(image)
  local thrRegion = diff:threshold(25)

  -- Thin the thresholded region to get one pixel wide lines.
  local thinRegion = thrRegion:thin()

  -- Return both thinned region and original thresholded region
  -- for illustrative purposes.
  return thinRegion, thrRegion
end

---Main function
local function main()
  -- Load image and find thin lines.
  local image = Image.load('resources/0.png'):toGray()
  local thinRegion, thrRegion = findThinLines(image)

  -- Show image with detected thin lines.
  drawRegionOnImage(image, thinRegion, thrRegion)

  print('App finished.')
end

--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register("Engine.OnStarted", main)
--End of Function and Event Scope--------------------------------------------------
