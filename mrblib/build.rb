#load '../../mruby-qml-parse/mrblib/main.rb'
#load "database.rb"
TotalObjs = 0
class ProgBuildVM
    #SC = "/start_context"
    #CC = "/create_class"
    #EI = "/extend_instance"
    #AA = "/add_attr"
    #CA = "/connect_attr"
    #SA = "/set_attr"
    #SP = "/set_parent"
    #AM = "/add_method"
    #CI = "/commit_instance"
    #EC = "/end_context"
    attr_accessor :instance
    def ensure_properties(value)
        if(!value.respond_to?(:properties))
            value.instance_eval{@properties = Hash.new}
            value.instance_eval{def properties;@properties;end}
        end
    end

    def ensure_database(value, database)
        #puts "Ensuring database = '#{database}'"
        if(!value)
            raise "Cannot ensure_database on nil"
        end
        if(!value.respond_to?(:db))
            value.instance_eval{def db;@db;end}
            value.instance_eval{def db=(db);@db=db;end}
            value.db = database
        else
            #puts "value.methods = #{value.methods.sort}"
            #puts "value.db = '#{value.db}'"
        end
        if(!value.respond_to?(:ui_path))
            value.instance_eval{def ui_path;@ui_path;end}
            value.instance_eval{def ui_path=(ui_path);@ui_path=ui_path;end}
            value.ui_path = "/ui/"
        end
    end

    def add_func(value, name, args, code, file, line)
        #puts "Adding Function '#{name}'..."
        eval("value.instance_eval{def #{name}(#{args});#{code};end}", nil, file, line)
    end

    def add_attr(value, name, type, file, line)
        #Add Fastpath for layout terms
        if(["x","y","w","h"].include?(name) && false)
            value.instance_eval("def #{name};@#{name};end", file, line)
            value.instance_eval("def #{name}=(val);@#{name}=val;end", file, line)
        else
            #puts "adding #{name}"
            ensure_properties(value)
            prop = Property.new(name)
            #puts "value.properties = '#{value.properties.class}'<#{value.properties.nil?}>"
            value.properties[name] = prop
            value.db.add_property prop
            value.instance_eval("def #{name};
                                prop = @properties[\"#{name}\"]
                                @db.load_property(prop); end", file, line)
            value.instance_eval("def #{name}=(val);
                                prop = @properties[\"#{name}\"]
                                @db.write_property(prop,val);
                                prop.onWrite.each do |cb|
                                    cb.call
                                    end; end", file, line)
        end
    end

    def update_ui_path(value, npath)
        #puts "update_ui_path(#{value}, #{npath})"
        value.ui_path = npath
        value.properties.each do |key,p|
            p.ppath = npath
        end
        idx = 1
        value.children.each do |c|
            update_ui_path(c, "#{npath}#{idx}/")
        end
    end

    def update_path_recursive(base, npath)
        children = base.children
        if(!children.empty?)
            #TODO this only works one level deep...
            children.each_with_index do |x,i|
                update_ui_path(children[i], "#{npath}#{i}/")
                update_path_recursive(children[i], "#{npath}#{i}/")
            end
        end
    end

    def consume_instruction(inst)
        #puts "consuming #{inst}"
        case inst[0]
        when SC
            #puts "Ignoring..."
            inst
        when CC
            #pp inst
            TotalObjs += 1
            t1 = Time.new
            id = inst[2]
            @alloc_id << id
            obj = nil
            if(@global_ir.include? inst[1])
                #puts "Building Subobject '#{inst[1]}'"
                obj = ProgBuildVM.new(@global_ir[inst[1]], @global_ir, @db, @depth+1).instance
                ensure_database(obj, @db)
            else
                obj = Kernel.const_get(inst[1]).new
                ensure_database(obj, @db)
            end
            if(inst.length == 4 && inst[3] != "anonymous")
                @context[inst[3]] = obj
            end
            if(@objs.length+1 < id)
                raise "invalid id recorded"
            elsif(@objs.length < id)
                @objs << obj
            else
                if(@objs[id])
                    puts "Overwriting Object Slot, Be Prepared For Weirdness"
                    puts "id=#{id}"
                    puts @alloc_id
                    puts @objs[id]
                end
                @objs[id] = obj
            end
            puts " "*@depth+"Creating #{inst[1]} (#{TotalObjs}) <#{1000*(Time.new-t1)}ms>"
        when AA
            (id,name,type) = inst[1..3]
            #puts "Adding attribute..."
            add_attr(@objs[id], name, type, inst.file, inst.line)
        when AM
            #puts "Adding Function..."
            (obj,name, args, value) = inst[1..4]
            add_func(@objs[obj], name, args, value, inst.file, inst.line)
        when SP
            (child, parent) = inst[1..2]
            #puts "Setting parent..."
            #puts "child=#{child},parent=#{parent}"
            #puts "parent = #{@objs[parent]}"
            #puts "child  = #{@objs[child]}"
            #puts "parent-path = #{@objs[parent].ui_path}"
            children = @objs[parent].children
            children << @objs[child]
            @objs[parent].children = children
            npath = "#{@objs[parent].ui_path}#{children.length}/"
            update_ui_path(@objs[child],npath)
            #puts "think of the children #{@objs[child].children}"
            update_path_recursive(@objs[child], npath)
        when CA
            #puts "Connecting field..."
            (obj, field, value) = inst[1..3]
            if(!field.match(/^on/))
                if((["x","y","w","h"].include?(field)) && false)
                    @objs[obj].send(field+"=",eval(value))
                else
                    if(!@objs[obj].properties.include?(field))
                        puts "cannot connect field #{field}..."
                    else
                        @db.connect_property(@objs[obj].properties[field], value, @context)
                    end
                end
                #instance[obj].send(field+"=",value)
            else
                field    = field[2..-1]
                field[0] = field[0].downcase
                @db.connect_watcher(@objs[obj].properties[field], value, @context)
            end
        when CI
            obj = inst[1]
            #puts "Ignoring..."
        when EC
            #puts "Ignoring..."
        else
            puts "Unknown Opcode..."
            puts inst
        end
    end

    def obj_ids(ir)
        ids = []
        ir.each do |inst|
            op = inst[0]
            ids << inst[2] if(op == CC)
        end
        ids
    end

    def correct_ir(chunk, old_valid, total)
        rewrite = []
        seen    = []
        (0...@used_id.max).each do |i|
            if(!old_valid.include? i)
                seen << i
                rewrite[i] = i
            end
        end

        next_ctr = @used_id.max + 1
        
        chunk.map do |inst|
            case inst[0]
            when SC
                #puts "Ignoring..."
            when CC
                #pp inst
                #puts "Creating #{inst[1]}"
                id = inst[2]
                if(seen.include? id)
                    seen << next_ctr
                    rewrite[id] = next_ctr
                    next_ctr += 1
                else
                    seen << id
                    rewrite[id] = id
                end
                [CC, inst[1],rewrite[id], inst[3]]
            when AA
                (id,name,type) = inst[1..3]
                [AA,rewrite[id], name, type]
            when AM
                #puts "Adding Function..."
                (obj, name, args, value) = inst[1..4]
                [AM, rewrite[obj], name, args, value]
            when SP
                #puts "Setting parent..."
                (child, parent) = inst[1..2]
                [SP, rewrite[child], rewrite[parent]]
            when CA
                #puts "Connecting field..."
                (obj, field, value) = inst[1..3]
                [CA, rewrite[obj], field, value]
            when CI
                obj = inst[1]
                [CI, rewrite[obj]]
                #puts "Ignoring..."
            when EC
                #puts "Ignoring..."
                inst
            else
                puts "Unknown Opcode Rewrite..."
                puts inst
                inst
            end
        end
    end


    def total_objs(ir)
        total = 0
        ir.each do |inst|
            op = inst[0]
            total += 1 if(op == CC)
        end
        total
    end

    def initialize(ir, total_ir, db, depth=0)
        if(!ir)
            throw :invalid_ir
        end
        @ir        = ir
        @global_ir = total_ir
        @db        = db
        @depth     = depth
        @instance  = nil
        @context   = Hash.new
        @alloc_id  = [-1]
        @used_id   = obj_ids(ir)
        @objs = []
        objs = total_objs(ir)
        objs.times do
            @objs << nil
        end

        #ir.each do |i|
        #    puts i
        #end

        ir.each do |inst|
            #puts inst
            consume_instruction inst
        end

        #TODO elevate context to function eval...
        @context.each do |cls, ref|
            @objs.each do |inst|
                if(inst)
                    inst.instance_eval("def #{cls};@#{cls}_ref;end")
                    inst.instance_eval("def #{cls}=(val);@#{cls}_ref=val;end")
                    inst.send(cls+"=", ref)
                end
            end
        end
        @instance = @objs[0]
        #puts instance
        #puts "done..."
    end
end

GlobalIRCache = Hash.new
QmlIRCache    = nil

def createInstanceOld(name, parent, pdb)
    qml_ir = QmlIRCache
    ir     = qml_ir[name]
    pbvm   = ProgBuildVM.new(ir, qml_ir, pdb)
    child  = pbvm.instance

    #TODO fix hackyness here with UI paths
    children = parent.children
    children << child
    parent.children = children
    npath = "#{parent.ui_path}#{children.length}/"
    child.ui_path = npath
    child.properties.each do |key,p|
        p.ppath = npath
    end

    child
end

def runBuildTest
    l = Parser.new
    qml_data = [Dir.glob("../mruby-zest/mrblib/*.qml"), Dir.glob("../mruby-zest/qml/*.qml"), Dir.glob("../mruby-zest/test/*.qml"), Dir.glob("../mruby-zest/example/*.qml")].flatten
    qml_ir   = Hash.new
    different_file = false
    qml_data.each do |q|
        cname = q.gsub(".qml","").gsub(/.*\//, "")
        hash = File::Stat.new(q).ctime.to_s
        #hash  = `md5sum #{q}`
        q_ir = nil
        if(GlobalIRCache.include?(cname+hash))
            q_ir = GlobalIRCache[cname+hash];
        else
            puts "Process '#{q}'..."
            #puts "Process '#{q.gsub(".qml","")}'"
            prog = l.load_qml_from_file(q)
            #puts prog
            root_node = nil
            prog.each do |x|
                if(x.is_a? TInst)
                    root_node = x
                end
            end
            q_ir = ProgIR.new(root_node).IR
            GlobalIRCache[cname+hash] = q_ir
            different_file = true
        end
        qml_ir[cname] = q_ir
    end

    if(!different_file)
        return nil
    end
    QmlIRCache = qml_ir

    pdb = PropertyDatabase.new

    start = Time.now
    #ir = qml_ir["slider-01-empty"]
    #ir = qml_ir["window-02-basic"]
    #ir = qml_ir["Knob"]
    #ir = qml_ir["module-01-layout"]
    #ir = qml_ir["module-02-pair"]
    ir = qml_ir["MainWindow"]
    #ir = qml_ir["MainMenu"]
    #ir = qml_ir["macro-02-grid"]
    #ir  = qml_ir["ZynLFO"]
    #ir  = qml_ir["Module"]
    #puts "IR FORM: "
    #ir.each do |x|
    #    puts x
    #end
    pbvm = ProgBuildVM.new(ir, qml_ir, pdb)


    finish = Time.now
    #puts "working on the db..."
    #puts pbvm.instance
    #pdb.update_values
    #puts "Database (Old?)..."
    #puts pdb
    #puts "Database..."
    pdb.force_update
    #puts pdb
    #puts "Instance..."
    #puts pbvm.instance.to_s
    #pp pbvm.instance.children
    #pp pbvm.instance.properties["children"].callback.call
    puts "Builder Execution took #{finish-start} second(s)"
    #pc  = ProgVM.new(pir.IR)
    #puts "Resulting Instance"
    #puts "------------------"
    #pp pc.instance
    pbvm.instance
end

#runTest
