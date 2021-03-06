--libs
local Scene  = require("lib.scene")
local Player = require("../player")

local Bat  = require("../bat")
--
local Thorn  = require("../thorn")

local Apple  = require("../apple")
local Apple1 = require("../apple1")

local Fish   = require("../fish")
local Bunny  = require("../bunny")
local Bar    = require("lib.ui.bar")
local U      = require("lib.utils")
local Vector2 = require("lib.vector2")

local health = require("../global")

require("lib.camera")
--Scene
local T      = Scene:derive("level_7")
local Map_test
local Sonder
local s_pos
--local fox_sprite

level_7_c = false

--health = 20

function T:new(scene_mngr)
    camera:setBounds(0,0,1920,540)
    self.super.new(self,scene_mngr)
    self.p = Player()
    self.em:add(self.p)

    self.bar = Bar("health",125,35,200, 20,"")
    self.em:add(self.bar)
    self.bar_changed = function(bar, value)
    self:on_bar_changed(bar, value) end
    
    self.bar_run = Bar("run",125,35,200, 20,"")
    self.em:add(self.bar_run)
    self.bar_changed_ = function(bar_run, value)
    self:on_bar_changed(bar_run, value) end
    self.bar_run.percentage = 100
    self.bar_run:set(self.bar_run.percentage)
    self.bar_run.pos.y = 65
    self.bar_run.fill_color = U.color(0.6,0.8,1,1)

    Map_test  = love.graphics.newImage("Map/myforest.png")
    Map_test2 = love.graphics.newImage("Map/myforest2.png")
    Sonder   = love.graphics.newImage("Map/sonder1.png")

    snd1 = love.audio.newSource("Sound/Snowfall.ogg","stream")
    snd1:setLooping(true)
end

local entered = false

function T:enter()
    T.super.enter(self)
    _G.events:hook("onBarChanged", self.bar_changed)
end

function T:exit()
    T.super.exit(self)
    _G.events:unhook("onBarChanged", self.bar_changed)
end

function T:on_bar_changed(bar,value)
    bar.text = tostring(value .. "%")
    if value < 20 then
        bar.fill_color = U.color(1,0,0,1)
    elseif value > 19 and value < 50 then
        bar.fill_color = U.color(1,1,0,1)
    elseif value > 49 then
        bar.fill_color = U.color(0,1,0,1)
    end
end

local it = false

function T:update(dt)    
    if pause == false then
        self.super.update(self,dt)
        camera:setPosition( self.p.fox_sprite.pos.x - (love.graphics.getWidth()/3.5), self.p.fox_sprite.pos.y - (love.graphics.getHeight()))
        love.audio.play(snd1)
        self.bar.pos.x = 180 + camera.x
        self.bar_run.pos.x = 180 + camera.x
        s_pos = 5 + camera.x
        --
        if (it == false) then
            self.bar:set(100)--health.get())
            self.bar.text = "100%"--health.get().."%"
            it = true
        end
        --eat
        --Run Bar
        if self.p.fox_sprite.current_anim == "run" or self.p.fox_sprite.current_anim == "jump" then
            self.bar_run:set(self.bar_run.percentage - 0.3)
            if self.bar_run.percentage <= 20 then
                self.p.enable = false
                self.bar_run.fill_color = U.color(1,0,0,1)
            else
                self.p.enable = true
                self.bar_run.fill_color = U.color(0.6,0.8,1,1)
            end
        else
            self.bar_run:set(self.bar_run.percentage + 0.7)
        end
        if(self.bar_run.percentage == 100) then
            self.bar_run.fill_color = U.color(0.6,0.8,1,1)
        end
        self.bar_run.text= ""
        --

        if self.p.fox_sprite.current_anim == "bite" then
            
        end
        
        if (self.p.fox_sprite.pos.x >= 2720) then
            health.val(self.bar.percentage)
            self.p.fox_sprite.pos.x = 80
            self.p.fox_sprite.pos.y = 450
            if self.bn.remove ~= nil then
                self.em:add(self.bn)
                self.bn.remove = nil
            end
            self.bn.spr.pos.x = 400
            self.bn.spr.pos.y = 470
            self.e.spr.pos.x = 500
            self.e.spr.pos.y = 450
            self.e.vx = 1
            self.e1.vx = 1
            self.e2.vx = 1
            self.e1.spr.pos.x = 700
            self.e1.spr.pos.y = 400
            self.e2.spr.pos.x = 650
            self.e2.spr.pos.y = 450
            it = false
            love.audio.stop(snd1)
            level_7_c = true
            
        end
    end
    if pause == true then
        love.audio.pause(snd1)
    end
end

function T:draw()
    camera:set()
    love.graphics.clear(0.34,0.38,1)
    love.graphics.draw(Map_test,0,0)
    love.graphics.draw(Map_test,960,0)
    love.graphics.draw(Map_test2,1920,0)
    love.graphics.draw(Map_test,2880,0)
    self.super.draw(self)   
    
    love.graphics.draw(Sonder,s_pos,15)
    camera:unset()

end


return T