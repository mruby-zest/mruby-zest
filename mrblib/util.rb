def border(scale, pos)
    pos[0] += scale;
    pos[1] += scale;
    pos[2] -= 2*scale;
    pos[3] -= 2*scale;
end

def pad(scale, bb)
    cx = bb[0] + bb[2]/2.0;
    cy = bb[1] + bb[3]/2.0;
    w  = bb[2]*scale;
    h  = bb[3]*scale;
    bb[0] = cx - w/2.0;
    bb[1] = cy - h/2.0;
    bb[2] = w;
    bb[3] = h;
end

class EditRegion
    def initialize(vg, string, width, height)
        @vg     = vg
        @string = string
        @width  = width
        @row_h  = height

        #Info on input
        @widths = []
        @chrcls = []

        #Intermediates
        @word_buffer = ""
        @word_buf_w  = []
        @active_line = 0
        @lastw       = 0
        @activew     = 0

        #Output
        @lines       = [""]
        @line_widths = []


        #cursor
        @cursor_row = 0
        @cursor_col = 0

        string_to_stats
        string_to_lines

        #cursor
        @cursor_row = @lines.length-1
        @cursor_col = @lines[-1].length
        calc_cursor_x
    end

    def lines
        @lines
    end
    def line_widths
        @line_widths
    end

    def flush_word_buffer
        if(@activew < @width)
            @lines[@active_line] += @word_buffer
            @lastw = @activew
        else
            @line_widths[@active_line] = @lastw
            @active_line += 1
            @lines[@active_line] = ""
            @activew = 0
            @lastw   = 0
            n = @word_buffer.length
            (0...n).each do |i|
                push_char(@word_buffer[i], @word_buf_w[i])
            end
        end
        @word_buffer = ""
        @word_buf_w  = []
    end

    def push_char(chr, width)
        if(@lastw + width < @width)
            @lines[@active_line] += chr
            @lastw   += width
            @activew += width
        else
            @line_widths[@active_line] = @lastw
            @active_line += 1
            @lines[@active_line] = chr
            @lastw = @activew = width
        end
    end

    def string_to_stats
        @vg.font_face("bold")
        @vg.font_size @row_h
        @string.each_char do |c|
            @widths << @vg.text_bounds(0, 0, c)
            if(c == " " || c == "\t")
                @chrcls << :space
            elsif(c == "\n" || c == "\r")
                @chrcls << :line
            else
                @chrcls << :chr
            end
        end
    end

    def string_to_lines
        n = @widths.length
        (0...n).each do |i|
            if(@chrcls[i] == :chr)
                @word_buffer += @string[i]
                @word_buf_w  << @widths[i]
                @activew      += @widths[i]
            elsif(@chrcls[i] == :space)
                flush_word_buffer()

                push_char(@string[i], @widths[i])
            elsif(@chrcls[i] == :line)
                flush_word_buffer()

                @line_widths[@active_line] = @lastw
                @lastw = @activew = 0
                @active_line += 1
                @lines[@active_line] = ""
            end
        end

        flush_word_buffer

        @line_widths[@active_line] = @lastw
    end

    def left()
        @cursor_col -= 1 if @cursor_col > 0
        calc_cursor_x
    end

    def right()
        n = @lines[@cursor_row].length
        @cursor_col += 1 if @cursor_col < n
        calc_cursor_x
    end

    def up()
        @cursor_row -= 1 if @cursor_row > 0
        n = @lines[@cursor_row].length
        @cursor_col = n if @cursor_col > n

        old_x = @cursor_x
        best = 0
        best_diff = 1.0/0.0
        (0...n).each do |i|
            @cursor_col = i
            calc_cursor_x
            new_diff = abs(old_x-@cursor_x)
            if(best_diff > new_diff)
                best_diff = new_diff
                best = i
            end
        end

        @cursor_col = best
        calc_cursor_x
    end

    def down()
        @cursor_row += 1 if @cursor_row < @lines.length-1
        n = @lines[@cursor_row].length
        @cursor_col = n if @cursor_col > n

        old_x = @cursor_x
        best = 0
        best_diff = 1.0/0.0
        (0...n).each do |i|
            @cursor_col = i
            calc_cursor_x
            new_diff = abs(old_x-@cursor_x)
            if(best_diff > new_diff)
                best_diff = new_diff
                best = i
            end
        end

        @cursor_col = best
        calc_cursor_x
    end

    def abs(x)
        if(x > 0)
            x
        else
            -x
        end
    end

    def calc_cursor_x
        @vg.font_face("bold")
        @vg.font_size @row_h
        str = @lines[@cursor_row][0,@cursor_col]
        #puts "row = #{@cursor_row}"
        #puts "col = #{@cursor_col}"
        @cursor_x = @vg.text_bounds(0, 0, str)
    end

    def each_string(&block)
        x  = 0
        y  = @row_h/2
        @lines.each do |str|
            cursor = false
            block.call(x,y,str,cursor)
            y += @row_h
        end
        block.call(@cursor_x, @row_h/2 + @cursor_row*@row_h, "|", true)
    end

    def pos()
        pos = @cursor_col
        (0...@cursor_row).each do |i|
            pos += @lines[i].length
        end
        pos
    end

    def pos=(x)
        x = 0 if(x < 0)
        p = x
        (0...@lines.length).each do |i|
            if(@lines[i].length > p)
                @cursor_col = p
                @cursor_row = i
                calc_cursor_x
                return
            else
                p -= @lines[i].length
            end
        end
    end
end
