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
    def initialize(vg, string, width)
        @vg     = vg
        @string = string
        @width  = width

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


        string_to_stats
        string_to_lines
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
end
