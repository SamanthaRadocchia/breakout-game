# Breakout!!!
# Breakout is a classic arcade game developed by Atari in 1976
# It was conceptualized by Nolan Bushnell, Steve Bristow, and Steve Wozniak
# Steve Jobs obvi got his hand in this pot too...
# Breakout is arguably one of the most influential games in the history of computing
# And now, thanks to Ruby, I've managed to build it (sort of)! 

require 'rubygems'
require 'Gosu'

#### BALL ####
class Ball
	attr_reader :x, :y, :w, :h

	def initialize(window)
		@x = 200
		@y = 400
		@vx = -5
		@vy = 5
		@w = 20
		@h = 20 
		@image = Gosu::Image.new(window,"ball.png", false)
	end 

	def move
		@x = @x + @vx
		@y = @y + @vy
		if @x < 0
			@vx = 5
		end
		if @x > 780
			@vx = -5
		end
		if @y < 0
			@vy = 5
		end
		if @y > 580
			@vy = -5
		end
	end 

	def draw
		@image.draw(@x, @y, 1)
	end

	def reverse_y # makes the ball move in reverse
		@vy = -1 * @vy
	end 

end

#### PADDLE ####

class Paddle
	attr_reader :x, :y, :w, :h

	def initialize(window)
		@x = 200
		@y = 550
		@w = 50
		@h = 15
		@image = Gosu::Image.new(window, "paddle.png", false)
	end

	def move_left
		if @x >0
			@x = @x -7
		end
	end

	def move_right
		if @x < 720
			@x = @x +7
		end
	end 

	def draw 
		@image.draw(@x, @y, 1)
	end

end

### BRICK ####
class Brick
	attr_reader :x, :y, :w, :h

	def initialize(window, x, y)
		@x = x
		@y = y
		@w = 50
		@h = 22
		@image = Gosu::Image.new(window, "brick.png", false)
	end

	def draw
		@image.draw(@x, @y, 1)
	end 

end 

### GameWindow ###
class GameWindow < Gosu::Window

	def initialize 
		super 800, 600, false # call the initialize method of your superclass of Gosu::Window 
		self.caption = "BreakOut"
		@ball = Ball.new(self)
		@paddle = Paddle.new(self)
		@bricks = []
		(1..5).each do |rows|
			(1..10).each do |col|
				@bricks.push Brick.new(self, col * 70, rows * 30)
			end
		end 
	end

	def are_touching?(obj1, obj2) # to determine if ball and bricks are touching - generic collision method for two rectangles
		obj1.x > obj2.x - obj1.w and obj1.x < obj2.x + obj2.w and obj1.y > obj2.y - obj1.h and obj1.y < obj2.y + obj2.h # able to write the .x and .y because of the attr_readers
		# if obj1.x > obj2.x - obj1.w and obj1.x < obj2.x + obj2.w and obj1.y > obj2.y - obj1.h and obj1.y < obj2.y + obj2.h # able to write the .x and .y because of the attr_readers
		# 	return true
		# else
		# 	return false 
		# end 
	end 

	def update
		if button_down?(Gosu::KbLeft) # part of the Gosu gem 
			@paddle.move_left
		end
		if button_down?(Gosu::KbRight)
			@paddle.move_right
		end 
		@ball.move
		if are_touching?(@ball, @paddle)
			@ball.reverse_y
		end
		@bricks.each do |brick|
			if are_touching?(@ball, brick)
				@ball.reverse_y
				@bricks.delete brick 
			end 
		end
	end

	def draw
		@ball.draw
		@paddle.draw
		@bricks.each do |brick|
			brick.draw
		end 
	end 

end


window = GameWindow.new
window.show 

# things this game needs 
# scoring
# lives
# it should tell you when you win and when you lose
