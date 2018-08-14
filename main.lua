--Untitled tactics RPG
--LOVE 2D + Aseprite

--(c)2018 Ben Ferguson, all rights reserved

--Debug mode
debug = true
--LOVE shortcuts
lg = love.graphics
lw = love.window
lk = love.keyboard
lf = love.filesystem
--Canvas scale
pixelScale = 3
tileSize = 24
--Draw canvases
mapuicanvas = nil
bgcanvas = nil
mapdata = nil
maptiles = nil
--Rich presence
presenceString = "currently WIP"
--Character data
joan = {
    animation = nil,
    direction = 2, --frame #2 is facing right
    x = 100,
    y = 100
}
--Default configuration
function love.conf(t)
    t.window.width = 320 * pixelScale
    t.window.height = 240 * pixelScale
end
--LOVE standard functions
function love.load(arg)
    lw.setTitle("Jeanne Dark - " .. presenceString)
    lg.setDefaultFilter('nearest','nearest',0)
    lg.setBackgroundColor(0.2,0.2,0.2)
    
    joan.animation = initializeSprites(lg.newImage('joan-1.png'), 16, 24, 1)
    maptiles = newMapTileQuads(lg.newImage('jeannetiles.png'), tileSize, tileSize)
    mapdata = love.filesystem.read('map1.txt')
    bgcanvas = lg.newCanvas(100*tileSize*pixelScale,tileSize*100*pixelScale)
    mapuicanvas = lg.newCanvas(100*tileSize*pixelScale,100*tileSize*pixelScale)

    LoadMap()
    DrawGrid()
end

function love.update(dt)
    --joan.animation.currentTime = joan.animation.currentTime + dt
    --if joan.animation.currentTime >= joan.animation.duration then
    --    joan.animation.currentTime = joan.animation.currentTime - joan.animation.duration
    --end
    if lk.isDown('right') then
        joan.x = joan.x + 1 * pixelScale
        joan.direction = 2
    elseif lk.isDown('left') then
        joan.x = joan.x - 1 * pixelScale
        joan.direction = 1
    elseif lk.isDown('up') then
        joan.y = joan.y - (1 * pixelScale)
        --joan.direction
    elseif lk.isDown('down') then
        joan.y = joan.y + (1 * pixelScale)
        --joan.direction
    end
end

function love.draw(dt)    
    local frameNum = math.floor(joan.animation.currentTime / joan.animation.duration * #joan.animation.quads) + 1
    
    lg.draw(bgcanvas,0,0)
    lg.draw(mapuicanvas,0,0)
    lg.print("Hello World",100,100,0,pixelScale,pixelScale)
    
    lg.draw(joan.animation.spriteSheet, joan.animation.quads[joan.direction], joan.x, joan.y, 0, pixelScale, pixelScale)
end

function DrawGrid()
    lg.setCanvas(mapuicanvas)
    lg.setColor(0.5,0.5,0.5,0.5)
    --lg.line(10*pixelScale,10*pixelScale,200*pixelScale,200*pixelScale)
    for j=0,10 do
        for k=0,10 do
            lg.line(j*tileSize*pixelScale, k*tileSize*pixelScale, j*tileSize*pixelScale, 20*tileSize*pixelScale)
            lg.line(j*tileSize*pixelScale, k*tileSize*pixelScale, 20*tileSize*pixelScale, k*tileSize*pixelScale)
        end
    end
    lg.setColor(1,1,1,1)
    lg.setCanvas()
end

function LoadMap()
    lg.setCanvas(bgcanvas)
    local iter_x, iter_y = 0,0
    for tileno in mapdata:gmatch("(%d),") do
        lg.draw(maptiles.sheet, maptiles.quads[tonumber(tileno)], iter_x*tileSize*pixelScale, iter_y*tileSize*pixelScale, 0, pixelScale, pixelScale)
        iter_x = iter_x + 1
        if iter_x > 99 then 
            iter_x = 0
            iter_y = iter_y + 1
        end
    end
    lg.setCanvas()
end

--thanks to OSM Studios
function initializeSprites(image, width, height, duration)
    --Creates an array of quads out of a provided image file for animation
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {}

    for y = 0, image:getHeight() - height, height do --iterate by y 
        for x = 0, image:getWidth() - width, width do --iterate by x
            table.insert(animation.quads, lg.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    return animation;
end

function newMapTileQuads(image, width, height)
    local tiles = {}
    tiles.sheet = image;
    tiles.quads = {};

    for y = 0, image:getHeight() - height, height do 
        for x = 0, image:getWidth() - width, width do
            table.insert(tiles.quads, lg.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    return tiles;
end
