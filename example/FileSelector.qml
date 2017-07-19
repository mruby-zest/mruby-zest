Widget {
    id: file
    layer: 2
    property Object valueRef: nil
    property Function whenValue: nil

    property String ext:       nil
    property String pat:       nil

    SelColumn {
        id: folders
        layer: 2
        layoutOpts: [:no_constraint]
        extern: "/file_list_dirs"
        style: :overlay
        label: "Folder"
        doupcase: false
        nrows: 20
        clear_on_extern: true
        whenValue: lambda {
            return if folders.selected.empty?
            file.browser.change_dir_rel(folders.selected)
            file.check
        }
    }
    SelColumn {
        id: files
        layer: 2
        layoutOpts: [:no_constraint]
        extern: "/file_list_files"
        style: :overlay
        label: "Files"
        nrows: 20
        doupcase: false
        clear_on_extern: true
        pattern: Regexp.new(file.pat) if file.pat
        whenValue: lambda {
            return if files.selected.empty?
            file.browser.change_file(files.selected)
            file.check
        }
    }
    TextField {
        id: line
        style: :overlay
        layoutOpts: [:no_constraint]
        layer: 2;
    }
    TriggerButton {
        id:    ebutton
        layoutOpts: [:no_constraint]
        layer: 2;
        label: "Enter"
        whenValue: lambda {file.whenEnter}
        function draw(vg) {
            parent.draw_button(vg, w, h, self.pad)
            parent.draw_text(vg, w, h, self.label, self.textScale)
        }
    }

    Menu {
        id: favs
        options: []
        layer: 2
        layoutOpts: [:no_constraint]
        label: "favorites"
        whenValue: lambda {
            file.browser.change_dir_abs(favs.options[favs.selected]) if favs.selected
            file.check
        }
    }

    TriggerButton {
        id: add
        label: "add favorite"
        layer: 2
        whenValue: lambda { file.addFav }
        layoutOpts: [:no_constraint]

        function draw(vg) {
            parent.draw_button(vg, w, h, self.pad)
            parent.draw_text(vg, w, h, self.label, self.textScale)
        }
    }

    function draw_text(vg, w, h, text, textScale=0.8)
    {
        vg.font_face("bold")
        vg.font_size h*textScale
        vg.fill_color color("56c0a5")
        if(layoutOpts.include? :left_text)
            vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
            vg.text(8,h/2,text.upcase)
        else
            vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
            vg.text(w/2,h/2,text.upcase)
        end
    }

    function draw_button(vg, w, h, pad)
    {
        vg.path do |v|
            v.rect(w*pad, h*pad, w*(1-2*pad), h*(1-2*pad))
            v.stroke_color color("56c0a5")
            v.stroke_width 1
            v.stroke
        end
    }


    //Measurements from mockup
    //1181x659 mockup
    //left side 280px pad
    //right side 900px of 1180 = 280px pad
    //580px-600px inner trough
    //30px-64px top
    //813px-834px top tough
    //85-573px selector y
    //594-628px add y
    function layout(l, selfBox) {
        mockx   = 1181
        mocky   = 659
        xpad    = 280/mockx
        xskip   = 20/mockx

        top_y  = 30/mocky
        top_h  = 34/mocky
        top_w  = (813-280)/mockx
        top_x  = xpad
        top_x2 = top_x+top_w+xskip
        top_w2 = 1-xpad-top_x2

        ff_y    = 85/mocky
        ff_h    = (573-85)/mocky
        ff_w    = 0.5-xskip/2-xpad
        ff_x    = xpad
        ff_x2   = 0.5+0.5*xskip

        fv_y  = 594/mocky
        fv_h  = (628-594)/mocky
        fv_x  = xpad
        fv_x2 = 2*xpad
        fv_w  = 0.1
        fv_w2 = 0.1

        sel_folder = children[0]
        sel_column = children[1]
        line       = children[2]
        select     = children[3]
        favs       = children[4]
        add_favs   = children[5]
        sel_folder.fixed(l, selfBox, ff_x,   ff_y,  ff_w,   ff_h)
        sel_column.fixed(l, selfBox, ff_x2,  ff_y,  ff_w,   ff_h)
        line.fixed(l,       selfBox, top_x,  top_y, top_w,  top_h)
        select.fixed(l,     selfBox, top_x2, top_y, top_w2, top_h)
        favs.fixed(l,       selfBox, fv_x,   fv_y,  fv_w,   fv_h)
        add_favs.fixed(l,   selfBox, fv_x2,  fv_y,  fv_w2,  fv_h)
        selfBox
    }

    function browser() { @browser }

    function onSetup(v=nil) {
        @browser = FileBrowser.new

        #Get files when home dir (or any subsequent dir) is setup
        dirs  = OSC::RemoteParam.new($remote, "/file_list_dirs")
        dirs.callback   = lambda { |x|
            file.browser.set_dirs(x)
            file.check
        }
        files = OSC::RemoteParam.new($remote, "/file_list_files")
        files.callback = lambda { |x|
            file.browser.set_files(x)
            file.check
        }


        #Get the starting path i.e. the HOME dir
        home = nil
        if($current_dir.nil?)
            home  = OSC::RemoteParam.new($remote, "/file_home_dir")
            home.callback = lambda { |x|
                file.browser.set_home_dir(x)
                file.check
            }
        else
            @browser.set_home_dir($current_dir)
        end

        fav   = OSC::RemoteParam.new($remote, "/config/favorites")
        fav.callback  = lambda { |x| set_favs(x) }

        self.valueRef = [dirs, files, home]
    }

    function set_favs(x)
    {
        return if x.nil? || x.empty?

        favs.options =  x  if x.class == Array
        favs.options = [x] if x.class != Array
        favs.damage_self
    }

    function addFav()
    {
        #TODO
        $remote.action("/config/add-favorite", line.label)
        $remote.action("/config/favorites")
    }

    function onKey(k, mode)
    {
        return if mode != "press"
        if(k.ord == 27) #esc
            whenCancel
            return
        elsif(k.ord == 9) #tab
            if(ebutton.value != true)
                ebutton.value = true
            else
                ebutton.value = 0.0
            end
            ebutton.damage_self
            line.label = line.label[0...-1]
            return
        elsif(k.ord == 13) #enter
            line.label = line.label[0...-1]
            whenEnter
            return
        elsif(k.ord == 8)
            @browser.del_char
        else
            @browser.add_char k
        end

        check
    }

    function check()
    {
        return if !@browser.needs_refresh
        @browser.clear_flags

        path = @browser.path
        if self.ext && !path.end_with?(self.ext)
            line.label = [@browser.path, self.ext]
        else
            line.label = @browser.path
        end
        line.damage_self

        search = @browser.search_path

        $remote.action("/file_list_dirs",  search)
        $remote.action("/file_list_files", search)
    }

    function draw(vg) {
        background color("000000", 145)
    }

    function whenEnter() {
        ll = @browser.path
        ll = ll + self.ext if self.ext && !ll.end_with?(self.ext)
        whenValue.call(ll) if whenValue
        root.ego_death self
    }

    function whenCancel() {
        whenValue.call(:cancel) if whenValue
        root.ego_death self
    }

    function onMousePress(m)
    {
        whenCancel
    }
}
