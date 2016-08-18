Widget {
    id: bank

    property Symbol mode: :read

    function doSearch()
    {
        search_  = bank_name.selected_val
        search_ += " " + bank_type.selected
        search_ += " " + bank_tag.selected
        search_ += " " + search.label
        $remote.action("/bank/search", search_)
    }
    
    function doBank()
    {
        doSearch if self.mode == :read
        setBank  if self.mode == :write
    }

    function setBank()
    {
        $remote.action("/bank/blist", bank_name.selected_val)
    }

    function doType()
    {
        doSearch if self.mode == :read
        setType  if self.mode == :write
    }

    function setType()
    {
        part = root.get_view_pos(:part)
        sel = bank_type.selected_id
        $remote.action("/part#{part}/info.Ptype", sel)
    }

    function doLoad()
    {
        ins = ins_sel.selected_val
        part = root.get_view_pos(:part)
        return if part.class != Fixnum
        puts "loading #{ins}"
        $remote.action("/load_xiz", part, ins) if !ins.empty?
        $remote.damage("/part#{part}/");
    }

    function doSave()
    {
        return if ins_sel.selected_val.nil?
        puts "Save to slot #{ins_sel.selected_val}"
        part = root.get_view_pos(:part)
        $remote.action("/bank/save_to_slot", part, ins_sel.selected_val.to_i)
    }

    function doInsSelect()
    {
        doLoad if self.mode == :read
        doSave if self.mode == :write
    }

    Widget {
        id: lhs
        SearchBox {
            id: search
            whenValue: lambda { bank.doSearch}
        }
        Widget {
            SelColumn {
                id: bank_name
                label:  "bank"
                skip:   true
                extern: "/bank/bank_list"
                whenValue: lambda { bank.doBank }
            }
            SelColumn {
                id: bank_type
                label: "type"
                extern: "/bank/types"
                whenValue: lambda { bank.doType }
            }
            SelColumn {
                id: bank_tag
                label: "tag"
                extern: "/bank/tags"
                whenValue: lambda { bank.doSearch }
            }
            function layout(l)
            {
                selfBox = l.genBox :widget, self

                rhs_box = children[0].layout l
                mid_box = children[1].layout l
                lhs_box = children[2].layout l

                l.contains(selfBox, rhs_box)
                l.contains(selfBox, mid_box)
                l.contains(selfBox, lhs_box)

                l.rightOf(rhs_box, mid_box)
                l.rightOf(mid_box, lhs_box)
                l.sheq([rhs_box.w, selfBox.w], [1.0, -0.3], 0)
                l.sheq([mid_box.w, selfBox.w], [1.0, -0.3], 0)

                selfBox
            }
        }

        function layout(l)
        {
            selfBox = l.genBox :widget, self

            search  = children[0].layout l
            content = children[1].layout l

            l.fixed(search,  selfBox, 0, 0.00, 1, 0.05)
            l.fixed(content, selfBox, 0, 0.05, 1, 0.95)

            selfBox
        }
    }
    Widget {
        id: rhs
        Widget {
            id: rwbox
            TabButton {
                label: "read"
                value: true
                whenClick: lambda { rwbox.setrw(0) }
            }
            TabButton {
                label: "write"
                whenClick: lambda { rwbox.setrw(1) }
            }
            TriggerButton {
                label: "save"
            }
            function setrw(x)
            {
                if(x == 0)
                    bank.mode = :read
                    children[0].value = true
                    children[1].value = false
                else
                    bank.mode = :write
                    children[0].value = false
                    children[1].value = true
                end
                bank_type.clear
                children[0].damage_self
                children[1].damage_self
            }

            function layout(l)
            {
                Draw::Layout::hpack(l, self_box(l), chBoxes(l))
            }
        }
        Widget {
            SelColumn {
                id: ins_sel
                extern: "/bank/search_results"
                label: "preset"
                number: false
                skip:   true
                whenValue: lambda {bank.doInsSelect}
            }
            Widget {
                id: info_box
                Group {
                    copyable: false
                    label: "name"
                    topSize: 0.3
                    TextLine { extern: "/part0/Pname" }
                }
                Group {
                    topSize: 0.2
                    copyable: false
                    label: "author"
                    TextEdit { extern: "/part0/info.Pauthor" }
                }
                Group {
                    copyable: false
                    label: "comments"
                    TextEdit { extern: "/part0/info.Pcomments" }
                }

                function layout(l)
                {
                    selfBox = l.genBox :widget, self

                    name    = children[0].layout l
                    author  = children[1].layout l
                    comment = children[2].layout l

                    l.fixed(name,    selfBox, 0, 0.00, 1, 0.10)
                    l.fixed(author,  selfBox, 0, 0.10, 1, 0.25)
                    l.fixed(comment, selfBox, 0, 0.35, 1, 0.65)

                    selfBox
                }
            }

            function layout(l)
            {
                selfBox = l.genBox :widget, self

                rhs_box = children[0].layout l
                lhs_box = children[1].layout l
                l.contains(selfBox, rhs_box)
                l.contains(selfBox, lhs_box)

                l.rightOf(rhs_box, lhs_box)
                l.sheq([rhs_box.w, selfBox.w], [1.0, -0.5], 0)

                selfBox
            }
        }
        function layout(l)
        {
            selfBox = l.genBox :widget, self

            t_box = children[0].layout l
            b_box = children[1].layout l
            l.contains(selfBox, t_box)
            l.contains(selfBox, b_box)

            l.topOf(t_box, b_box)
            l.sheq([t_box.h, selfBox.h], [1.0, -0.05], 0)

            selfBox
        }
    }
    function layout(l)
    {
        selfBox = l.genBox :bank, self
        rhs_box = rhs.layout l
        lhs_box = lhs.layout l
        l.contains(selfBox, rhs_box)
        l.contains(selfBox, lhs_box)

        l.rightOf(lhs_box, rhs_box)
        l.sheq([rhs_box.w, selfBox.w], [1.0, -0.5], 0)

        selfBox
    }

    function setup(old=nil)
    {
    }

}
