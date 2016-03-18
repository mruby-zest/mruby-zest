class MacroState
    attr_reader :qid, :id, :data
    def initialize(id,qid)
        @qid  = id
        @id   = qid
        @data = []
    end
end
