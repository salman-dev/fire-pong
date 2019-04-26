require 'gosu' 
include Gosu 

$game_over = false

puts "     WELCOME TO \n\ 🔥🔥🔥 FIRE PONG🔥🔥🔥"
puts "player 1, please enter your name"
@@player1 = gets.chomp
puts "player 2, please enter your name"
@@player2 = gets.chomp
class Pong < Window

    def initialize
        super 2560, 1440, false
        @song = Song.new('load/song.ogg')
        @song_2 = Song.new('load/song_2.ogg')
        @bar_1 = Image.new('load/bar_1.png')
        @bar_2 = Image.new('load/bar_2.png')
        @ball = Image.new('load/ball.png')
        @background = Image.new("load/background.png")

        @hit_smp = Sample.new('load/song.ogg')
        @miss_smp = Sample.new('load/song.ogg')
        @game_start_smp = Sample.new('load/song.ogg')

        @x1 = 20
        @x2 = self.width - @bar_2.width - 20
        @y1 = self.height / 2 - @bar_1.height / 2
        @y2 = self.height / 2 - @bar_2.height / 2
        @ball_x = self.width / 2 - @ball.width
        @ball_y = self.height / 2 - @ball.height

        @ball_speed = rand(6..11)
        @ball_speed_y = rand(5..7)
        @bar_speed = rand(7..11)

        @left_score = 0
        @right_score = 0

        @score_font = Font.new(28)
        @game_over_font = Font.new(36)
        @try_again_font = Font.new(24)
        @credits_font = Font.new(12)
    end

    def update
        self.caption = "🔥Fire Pong🔥   ||   #{fps}   ||   #{@@player1} #{@left_score}::#{@right_score} #{@@player2}"
        if $game_over == false
            @song_2.play(volume = 1)
            @ball_x += @ball_speed
            @ball_y += @ball_speed_y

            if @ball_y <= 0 or @ball_y >= self.height
                @ball_speed_y *= -1
            end

            if @ball_x <= @x1 + @bar_1.width * 1 and @ball_y >= @y1 and @ball_y <= @y1 + @bar_1.height
                @ball_speed *= -1.2
                @ball_speed_y *= 1.1
                @bar_speed *= 1.05
                @hit_smp.play(volume = 2)
            end

            if @ball_x >= @x2 - @bar_2.width * 1 and @ball_y >= @y2 and @ball_y <= @y2 + @bar_2.height
                @ball_speed *= -1.3
                @ball_speed_y *= 1.2
                @bar_speed *= 1.05
                @hit_smp.play(volume = 2)
            end

            if @ball_speed == 0 and @ball_speed <= rand(4..6)
                @ball_speed += 1
            end

            if @ball_x < @x1 - @bar_1.width
                @miss_smp.play(volume = 2)
                @right_score += 1

                @ball_speed = rand(3..9)
                @ball_speed_y = rand(3..5)
                @bar_speed = rand(7..11)
                @ball_x = self.width / 2 - @ball.width
                @ball_y = self.height / 2 - @ball.height
                @y1 = self.height / 2 - @bar_1.height / 2
                @y2 = self.height / 2 - @bar_2.height / 2
            end

            if @ball_x > @x2 + @bar_2.width
                @miss_smp.play(volume = 2)
                @left_score += 1

                @ball_speed = rand(-9..-3)
                @ball_speed_y = rand(3..5)
                @bar_speed = rand(7..11)
                @ball_x = self.width / 2 - @ball.width
                @ball_y = self.height / 2 - @ball.height   
                @y1 = self.height / 2 - @bar_1.height / 2
                @y2 = self.height / 2 - @bar_2.height / 2 
            end
        else
            @song.play
            if button_down? KbSpace
                @game_start_smp.play(volume = 1)
                $game_over = false
            end
        end

        @y2 -= @bar_speed if button_down? KbUp and @y2 >= -@bar_2.height / 2
        @y2 += @bar_speed if button_down? KbDown and @y2 <= self.height - @bar_2.height / 2
        @y1 -= @bar_speed if button_down? KbW and @y1 >= -@bar_1.height / 2
        @y1 += @bar_speed if button_down? KbS and @y1 <= self.height - @bar_1.height / 2
        
       
        if @left_score == 7 || @right_score == 7
            $game_over = true
            if button_down? KbSpace
                @x1 = 20
                @x2 = self.width - @bar_2.width - 20
                @y1 = self.height / 2 - @bar_1.height / 2
                @y2 = self.height / 2 - @bar_2.height / 2
                @ball_x = self.width / 2 - @ball.width
                @ball_y = self.height / 2 - @ball.height

                @ball_speed = rand(4..9)
                @ball_speed_y = rand(3..5)
                @bar_speed = rand(7..11)

                @left_score = 0
                @right_score = 0
                $game_over = false
            end
        end
    end

    def draw
    if $game_over == false
        @score_font.draw("#{@left_score}||#{@right_score}", self.width / 2 - 20, 35, 5)        
        @ball.draw(@ball_x, @ball_y, 1)
        @bar_1.draw(@x1, @y1, 1)
        @bar_2.draw(@x2, @y2, 1)
    else
        @game_over_font.draw("GAME OVER!", 1200, 350, 5)    
        @score_font.draw("#{@@player1} Wins!", 1250, 500, 5) if @left_score > @right_score
        @score_font.draw("#{@@player2} Wins!", 1250, 500, 5) if @right_score > @left_score
        # @score_font.draw("It's a tie!", 260, 80, 5) if @left_score == @right_score

        @try_again_font.draw("Press SPACEBAR to play once more!", 1150, 450, 1)
    end
    @credits_font.draw("Code: Salman Allam, Ahmad Antar; Pictures: Google", 320, self.height - 18, 1, 1, 1, Color::GRAY)
    @background.draw(0, 0, -3)
end
end

Pong.new.show