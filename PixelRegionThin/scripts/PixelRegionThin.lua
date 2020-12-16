--[[----------------------------------------------------------------------------

  Application Name:
  PixelRegionThin
                                                                                             
  Summary:
  Detecting thin lines by comparison with a smoothed version of the image.
  Line regions are thinned to be one pixel wide.
   
  How to Run:
  Starting this sample is possible either by running the app (F5) or
  debugging (F7+F10). Setting breakpoint on the first row inside the 'main'
  function allows debugging step-by-step after 'Engine.OnStarted' event.
  Results can be seen in the viewer on the DevicePage.
  
  More Information:
  Tutorial "Algorithms - Filtering and Arithmetic".

------------------------------------------------------------------------------]]

--Start of Global Scope---------------------------------------------------------

-- Viewer for showing the results.
local v = View.create("viewer2D1")

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

-- Draws two pixel regions on top of an image, before and after thinning.
local function drawRegionOnImage(image, thinRegion, thrRegion)
  -- Thinned region draw color
  local dec = View.PixelRegionDecoration.create()
  dec:setColor(255, 0, 0, 255)

  -- Thresholded region draw color
  local decThr = View.PixelRegionDecoration.create()
  decThr:setColor(0, 0, 255, 127)

  -- Draw image and region
  v:clear()
  local vId = v:addImage(image)
  v:addPixelRegion(thrRegion, decThr, nil, vId)
  v:addPixelRegion(thinRegion, dec, nil, vId)
  v:present()
end

-- Finds lines in an image and returns those as a thin pixel region.
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

-- Main function
local function main()
  -- Load image and find thin lines.
  local image = Image.load('resources/0.png'):toGray()
  local thinRegion, thrRegion = findThinLines(image)

  -- Show image with detected thin lines.
  drawRegionOnImage(image, thinRegion, thrRegion)
end

--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register("Engine.OnStarted", main)
--End of Function and Event Scope--------------------------------------------------
