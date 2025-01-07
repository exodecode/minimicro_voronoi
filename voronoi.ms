globals.WIDTH = 960
globals.HEIGHT = 640
globals.cellResolution = 4
globals.textureResolution = 64

voronoi = function(cellResolution, textureResolution)
	rndColor = function
		r = rnd * 255
		g = rnd * 255
		b = rnd * 255
		return rgb(r, g, b)
	end function
	rndCellOffset = function(cellSize, halfCellSize)
		return (rnd * cellSize) - halfCellSize
	end function
	distance = function(x1, y1, x2, y2)
		return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
	end function

	cellSize = floor(HEIGHT / cellResolution)
	halfCellSize = floor(cellSize / 2)
	colors = []
	coordXs = []
	coordYs = []
	cellResolutionEnd = cellResolution - 1

	for y in range(0, cellResolutionEnd)
		colors.push []
		coordXs.push []
		coordYs.push []
		for x in range(0, cellResolutionEnd)
			colors[y].push rndColor
			coordXs[y].push x * cellSize + rndCellOffset(cellSize, halfCellSize)
			coordYs[y].push y * cellSize + rndCellOffset(cellSize, halfCellSize)
		end for
	end for

	pixels = []
	pixelSize = floor(HEIGHT / textureResolution)

	textureResolutionEnd = textureResolution - 1

	for y in range(0, textureResolutionEnd)
		pixels.push []
		y1 = y * pixelSize
		for x in range(0, textureResolutionEnd)
			minDist = -1
			minIndexJ = -1
			minIndexI = -1
			x1 = x * pixelSize
			for j in range(0, cellResolutionEnd)
				for i in range(0, cellResolutionEnd)
					x2 = coordXs[j][i]
					y2 = coordYs[j][i]
					dist = distance(
						x1,
						y1,
						x2,
						y2)
					if minIndexJ == -1 or dist < minDist then
						minDist = dist
						minIndexJ = j
						minIndexI = i
					end if
				end for
			end for
			col = colors[minIndexJ][minIndexI]
			pixels[y].push col
		end for
	end for
	return pixels
end function

main = function(cellResolution, textureResolution)
	clear
	disp = display(4)
	gfx.clear color.clear
	pixels = voronoi(cellResolution, textureResolution)

	textureResolutionEnd = textureResolution - 1
	pixelSize = floor(HEIGHT / textureResolution)

	xOffset = floor((WIDTH - (pixelSize * textureResolution)) / 2)

	for y in range(0, textureResolutionEnd)
		for x in range(0, textureResolutionEnd)
			x1 = x * pixelSize + xOffset
			y1 = y * pixelSize
			col = pixels[y][x]
			gfx.fillRect(
				x1,
				y1,
				pixelSize,
				pixelSize,
				col)
		end for
	end for
end function

main cellResolution, textureResolution
